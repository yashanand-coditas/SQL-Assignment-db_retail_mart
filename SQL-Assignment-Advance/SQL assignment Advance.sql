--Advance SQL Assignment

--Indexes
1.
CREATE INDEX idx_campaign_budget ON tbl_campaign(budget);
--Reason:This index will speed up queries that involve filtering or sorting campaigns based on their budget, such as selecting campaigns with the highest and lowest budgets.
2.
CREATE INDEX idx_products_category ON tbl_products(category);
--Reason:This index will enhance performance when calculating the average price of products across categories and ranking products based on total sales within each category.
3.
CREATE INDEX idx_orders_campaign ON tbl_orders(campaign_id);
--Reason:This index will help in efficiently retrieving orders associated with each campaign, which is useful for calculating total revenue and average order amounts per campaign.
4.
CREATE INDEX idx_inventory_product ON tbl_inventory(product_id);
--Reason:This index will facilitate quick lookups of stock quantities for products, especially when handling missing stock quantities and providing default values.
5.
CREATE INDEX idx_order_items_order ON tbl_order_items(order_id);
--Reason:This index allows for quick access to order items associated with each order, which is important for analyzing total quantity and revenue generated from each product by customer.
6.
CREATE INDEX idx_orders_date_customer ON tbl_orders(order_date, customer_id);
--Reason:This composite index will help optimize queries that analyze sales trends over time, such as evaluating growth rates of sales for each campaign.
7.
CREATE INDEX idx_customers_total_spent ON tbl_customers(total_spent);
--Reason:This index supports the query to find the top  customers who consistently spend.
8.
CREATE INDEX idx_campaign_region ON tbl_campaign(region);
--Reason:This index can help with partitioning the sales data to compare the performance of different regions.

--1.Select the campaigns with the highest and lowest budgets.
--Approach 1
(SELECT campaign_name, budget 
 FROM 
 	tbl_campaign
 ORDER BY 	
 		budget DESC LIMIT 1)
UNION
(SELECT campaign_name, budget
 FROM 
 	tbl_campaign
 ORDER BY 
 	budget ASC LIMIT 1);
--Approach 2
SELECT 
    (SELECT campaign_name 
     FROM 
	 	tbl_campaign 
     WHERE budget = (SELECT MAX(budget) FROM tbl_campaign)) AS highest_budget_campaign,
    (SELECT MAX(budget) FROM tbl_campaign) AS highest_budget,
    (SELECT campaign_name 
     FROM 
	 	tbl_campaign 
     WHERE budget = (SELECT MIN(budget) FROM tbl_campaign)) AS lowest_budget_campaign,
    (SELECT MIN(budget) FROM tbl_campaign) AS lowest_budget;

--approach 3-using rank

WITH ranked_campaigns AS (
    SELECT 
        campaign_name,
        budget,
        DENSE_RANK() OVER (ORDER BY budget DESC) AS rank_highest,  
        DENSE_RANK() OVER (ORDER BY budget ASC) AS rank_lowest     
    FROM 
        tbl_campaign
)
SELECT 
    campaign_name,
    budget
FROM 
    ranked_campaigns
WHERE 
    rank_highest = 1 OR rank_lowest = 1;  

--2.Find the average price of products across all categories.
SELECT 
	category, AVG(price) AS average_price
FROM 
	tbl_products
GROUP BY 
	category;

--3.Rank products based on their total sales within each category.
SELECT 
	p.product_name, p.category, 
       DENSE_RANK() OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity * oi.price) DESC) AS sales_rank
FROM 
	tbl_products p
JOIN 
	tbl_order_items oi ON p.product_id = oi.product_id
GROUP BY 
	p.product_name, p.category;

--4.Create a CTE to calculate the total revenue and average order amount for each campaign.
WITH campaign_revenue AS (
    SELECT 
		c.campaign_id, c.campaign_name,
           SUM(o.total_amount) AS total_revenue,
           AVG(o.total_amount) AS average_order_amount
    FROM 
		tbl_campaign c
    LEFT JOIN 
		tbl_orders o ON c.campaign_id = o.campaign_id
    GROUP BY 
		c.campaign_id, c.campaign_name
)
SELECT *
FROM campaign_revenue;

--5.Handle any missing stock quantities and provide a default value of 0 for products with no recorded inventory.
SELECT 
	p.product_name, COALESCE(i.stock_quantity, 0) AS stock_quantity
FROM 
	tbl_products p
LEFT JOIN 
	tbl_inventory i ON p.product_id = i.product_id
ORDER BY 	
	stock_quantity ASC;

SELECT p.product_name,
       COALESCE(SUM(i.stock_quantity), 0) AS total_stock
FROM 
	tbl_products p
LEFT JOIN 
	tbl_inventory i ON p.product_id = i.product_id
GROUP BY 
	p.product_name;


--6.Analyse the total quantity and revenue generated from each product by customer.
SELECT c.name AS customer_name, p.product_name,
       SUM(oi.quantity) AS total_quantity,
       SUM(oi.quantity * oi.price) AS total_revenue
FROM 
	tbl_customers c
JOIN 
	tbl_orders o ON c.customer_id = o.customer_id
JOIN 
	tbl_order_items oi ON o.order_id = oi.order_id
JOIN 
	tbl_products p ON oi.product_id = p.product_id
GROUP BY 
	c.name, p.product_name;

--7.Find campaigns that have a higher average order amount than the overall average.
WITH avg_order AS (
    SELECT AVG(total_amount) AS overall_avg_order
    FROM tbl_orders
)
SELECT 
	c.campaign_name, AVG(o.total_amount) AS campaign_avg_order
FROM 
	tbl_campaign c
JOIN 
	tbl_orders o ON c.campaign_id = o.campaign_id
GROUP BY 
	c.campaign_name
HAVING 
	AVG(o.total_amount) > (SELECT overall_avg_order FROM avg_order);

--8.Analyse the rolling average of sales per campaign over the last 3 months.
--month wise
WITH monthly_sales AS (
    SELECT campaign_id,
           DATE_TRUNC('month', order_date) AS sales_month,
           SUM(total_amount) AS total_sales
    FROM
		tbl_orders
    WHERE 
		order_date >= CURRENT_DATE - INTERVAL '3 months'
    GROUP BY 
		campaign_id, sales_month
),
rolling_avg_sales AS (
    SELECT campaign_id,
           sales_month,
           AVG(total_sales) OVER (PARTITION BY campaign_id ORDER BY sales_month 
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_average_sales
    FROM 
		monthly_sales
)
SELECT campaign_id,
       sales_month,
       rolling_average_sales,
       TO_CHAR(sales_month, 'Month') AS month_name
FROM 
	rolling_avg_sales
ORDER BY 
	campaign_id, sales_month;


--9.Calculate the growth rate of sales for each campaign over time and rank them accordingly.
--Monthly
WITH monthly_sales AS (
    SELECT 
        c.campaign_name,
        DATE_TRUNC('month', o.order_date) AS sales_month,
        SUM(o.total_amount) AS total_sales
    FROM 
        tbl_campaign c
    INNER JOIN 
        tbl_orders o ON c.campaign_id = o.campaign_id
    GROUP BY 
        c.campaign_name, DATE_TRUNC('month', o.order_date)
),
growth_rate_calculation AS (
    SELECT 
        campaign_name,
        sales_month,
        total_sales,
        LAG(total_sales) OVER (PARTITION BY campaign_name ORDER BY sales_month) AS previous_sales,
        ((total_sales - LAG(total_sales) OVER (PARTITION BY campaign_name ORDER BY sales_month)) /
         NULLIF(LAG(total_sales) OVER (PARTITION BY campaign_name ORDER BY sales_month), 0) * 100) AS growth_rate
    FROM 
        monthly_sales
)
SELECT 
    campaign_name,
    TO_CHAR(sales_month, 'Month') AS month_name,  
    total_sales,
    COALESCE(growth_rate, 0) AS growth_rate, 
    DENSE_RANK() OVER (PARTITION BY campaign_name ORDER BY growth_rate DESC) AS growth_rank
FROM 
    growth_rate_calculation
WHERE 
    EXTRACT(MONTH FROM sales_month) <> 1  
ORDER BY 
    campaign_name, growth_rank;

--weekly
WITH weekly_sales AS (
    SELECT 
        c.campaign_name,
        DATE_TRUNC('week', o.order_date) AS sales_week, 
        SUM(o.total_amount) AS total_sales
    FROM 
        tbl_campaign c
    INNER JOIN 
        tbl_orders o ON c.campaign_id = o.campaign_id
    GROUP BY 
        c.campaign_name, DATE_TRUNC('week', o.order_date)
),
growth_rate_calculation AS (
    SELECT 
        campaign_name,
        sales_week,
        total_sales,
        LAG(total_sales) OVER (PARTITION BY campaign_name ORDER BY sales_week) AS previous_sales,
        ((total_sales - LAG(total_sales) OVER (PARTITION BY campaign_name ORDER BY sales_week)) /
         NULLIF(LAG(total_sales) OVER (PARTITION BY campaign_name ORDER BY sales_week), 0) * 100) AS growth_rate
    FROM 
        weekly_sales
)
SELECT 
    campaign_name,
    TO_CHAR(sales_week, 'IW') AS week_number, 
    total_sales,
    COALESCE(growth_rate, 0) AS growth_rate,  
    DENSE_RANK() OVER (PARTITION BY campaign_name ORDER BY growth_rate DESC) AS growth_rank
FROM 
    growth_rate_calculation
WHERE 
    NOT (EXTRACT(MONTH FROM sales_week) = 1 AND EXTRACT(WEEK FROM sales_week) = 1)  
ORDER BY 
    campaign_name, growth_rank;


--10.Use CTEs and Window Functions to find the top 5 customers who have consistently spent above the 75th percentile of customer spending.
WITH percentile_data AS (
    SELECT 
		PERCENTILE_CONT(0.01) WITHIN GROUP (ORDER BY total_spent) AS percentile_75
    FROM 
		tbl_customers
),
top_customers AS (
    SELECT 
		customer_id, total_spent
    FROM 
		tbl_customers
    WHERE 
		total_spent < (SELECT percentile_75 FROM percentile_data)
)
SELECT 
	customer_id, total_spent
FROM 
	top_customers
ORDER BY 
	total_spent DESC
LIMIT 5;  

--11.Use Advanced Sub-Queries to find the correlation between campaign budgets and total revenue generated.
WITH campaign_revenue AS (
    SELECT 
        c.campaign_id,
        c.campaign_name,
        c.budget,
        COALESCE(SUM(o.total_amount), 0) AS total_revenue
    FROM 
        tbl_campaign c
    LEFT JOIN 
        tbl_orders o ON c.campaign_id = o.campaign_id
    GROUP BY 
        c.campaign_id, c.campaign_name, c.budget
),
budget_ranges AS (
    SELECT 
        campaign_id,
        campaign_name,
        budget,
        total_revenue,
        CASE 
            WHEN budget BETWEEN 10000 AND 20000 THEN '10000-20000'
            WHEN budget BETWEEN 20001 AND 30000 THEN '20001-30000'
            WHEN budget BETWEEN 30001 AND 40000 THEN '30001-40000'
            WHEN budget BETWEEN 40001 AND 50000 THEN '40001-50000'
            ELSE '50001+'
        END AS budget_range
    FROM 
        campaign_revenue
)
SELECT 
    budget_range,
    json_agg(
        json_build_object(
            'campaign_name', campaign_name, 
            'revenue', total_revenue
        )
    ) AS campaigns_in_range
FROM 
    budget_ranges
GROUP BY 
    budget_range
ORDER BY 
    budget_range;
                                                        
--12.Partition the sales data to compare the performance of different regions and identify any anomalies.
SELECT region, AVG(total_amount) AS avg_sales,
      RANK() OVER (ORDER BY AVG(total_amount) DESC) AS sales_rank
FROM 
	tbl_campaign c
JOIN 
	tbl_orders o ON c.campaign_id = o.campaign_id
GROUP BY 
	region;

--13.Analyse the impact of product categories on campaign success.
SELECT p.category, SUM(o.total_amount) AS total_revenue,
       COUNT(o.order_id) AS total_orders
FROM 
	tbl_products p
JOIN 
	tbl_order_items oi ON p.product_id = oi.product_id
JOIN 
	tbl_orders o ON oi.order_id = o.order_id
JOIN 
	tbl_campaign c ON o.campaign_id = c.campaign_id
GROUP BY 
	p.category;

--14.Compute the moving average of sales per region and analyze trends.
WITH sales_per_day AS (
    SELECT 
        c.region,
        o.order_date,
        SUM(o.total_amount) AS daily_sales
    FROM 
        tbl_campaign c
    JOIN 
        tbl_orders o ON c.campaign_id = o.campaign_id
    GROUP BY 
        c.region, o.order_date
),
moving_avg_sales AS (
    SELECT 
        region,
        order_date,
        daily_sales,
        AVG(daily_sales) OVER (PARTITION BY region ORDER BY order_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_sales
    FROM 
        sales_per_day
)
SELECT 
    region,
    order_date,
    daily_sales,
    moving_avg_sales
FROM 
    moving_avg_sales
ORDER BY 
    region, order_date;

--15.Evaluate the effectiveness of campaigns by comparing the pre-campaign and post-campaign average sales.
WITH sales_data AS (
    SELECT 
        c.campaign_id,
        c.campaign_name,
        CASE 
            WHEN o.order_date < c.start_date THEN 'Pre Campaign'
            WHEN o.order_date > c.end_date THEN 'Post Campaign'
        END AS duration,
        o.total_amount
    FROM 
        tbl_campaign c
    INNER JOIN 
        tbl_orders o ON c.campaign_id = o.campaign_id
    WHERE 
        o.order_date < c.start_date OR o.order_date > c.end_date
),
average_sales AS (
    SELECT 
        campaign_id,
        campaign_name,
        AVG(CASE WHEN duration = 'Pre Campaign' THEN total_amount END) AS avg_pre_sales,
        AVG(CASE WHEN duration = 'Post Campaign' THEN total_amount END) AS avg_post_sales
    FROM 
        sales_data
    GROUP BY 
        campaign_id, campaign_name
)
SELECT 
    campaign_id,
    campaign_name,
    COALESCE(avg_pre_sales, 0) AS avg_pre_sales,  -
    COALESCE(avg_post_sales, 0) AS avg_post_sales,  
    (COALESCE(avg_post_sales, 0) - COALESCE(avg_pre_sales, 0)) AS sales_difference,
    CASE 
        WHEN COALESCE(avg_pre_sales, 0) = 0 THEN NULL  
        ELSE (COALESCE(avg_post_sales, 0) - COALESCE(avg_pre_sales, 0)) / COALESCE(avg_pre_sales, 0) * 100 
    END AS effectiveness_percentage
FROM 
    average_sales;



-----------------------------------------------------------------------------------------------------------------------------------------

-------------------------Analysis Inference from RetailMart's Campaign------------------------------------------------

--1.Campaign Budget Analysis:Identifying the campaigns with the highest and lowest budgets reveals the financial allocation strategies and their impact on overall revenue. Campaigns with higher budgets that also generate significant revenue suggest effective resource utilization, while low-budget campaigns that yield high returns indicate potential opportunities for growth.
--2.Product Pricing Insights:Analyzing the average price of products across all categories allows RetailMart to understand pricing strategies and identify potential pricing adjustments needed to remain competitive. Ranking products based on total sales helps in determining bestsellers and optimizing inventory.
--3.Revenue and Order Amounts:Using a CTE to calculate total revenue and average order amounts per campaign provides a clear picture of each campaign's effectiveness. Understanding which campaigns generate the highest average order values can inform future marketing efforts.
--4.Handling Inventory:Addressing missing stock quantities with a default value of zero ensures accurate inventory assessments. This information is crucial for supply chain management and ensures that high-demand products are adequately stocked.
--5.Customer Spending Analysis:Analyzing total quantity and revenue generated from each product by customer provides insights into customer preferences and behaviors. Understanding which customers consistently spend more can guide personalized marketing and loyalty initiatives.
--6.Campaign Performance Evaluation:Comparing average order amounts of campaigns against the overall average highlights campaigns that are performing exceptionally well or underperforming. This evaluation can direct resources to campaigns that need optimization.
--7.Sales Trends and Growth Rates:Calculating the growth rate of sales for each campaign over time and analyzing rolling averages can reveal trends in consumer behavior and the effectiveness of seasonal promotions. This data aids in strategic planning for future campaigns.
--8.Top Customers Identification:Using CTEs and window functions to identify the top 5 customers who consistently spend above the 75th percentile allows RetailMart to focus on nurturing relationships with its most valuable clients, enhancing customer loyalty.
--9.Correlation Between Budgets and Revenue:Investigating the correlation between campaign budgets and total revenue generated can uncover insights into how effectively financial resources are translating into sales. This analysis is critical for future budget planning.
--10.Regional Performance Comparison:Partitioning sales data by region can identify performance discrepancies and anomalies. Understanding these variations can help RetailMart tailor regional strategies to boost sales.
--11.Impact of Product Categories:Analyzing the impact of product categories on campaign success can inform marketing strategies and product placements, ensuring that the most effective categories receive the attention they deserve.
--12.Moving Averages and Trends:Computing moving averages of sales per region allows RetailMart to detect trends over time, aiding in strategic decision-making and planning for future campaigns.
--13.Effectiveness of Campaigns:Evaluating pre-campaign and post-campaign average sales provides insights into campaign effectiveness. This assessment helps in understanding the impact of marketing efforts and refining future strategies.
--14.Analyze the Impact of Product Categories on Campaign Success: Examining the impact of product categories on campaign success provides valuable insights into how different categories perform within various marketing efforts. By correlating campaign outcomes with specific product categories, RetailMart can identify which categories drive higher sales and engagement. This analysis helps in understanding consumer preferences and enables more targeted marketing strategies, ensuring that the most successful categories receive focused promotional efforts. 
--15.Compute the Moving Average of Sales per Region and Analyze Trends: Calculating the moving average of sales per region offers RetailMart a clearer picture of sales trends over time, smoothing out fluctuations and highlighting underlying patterns. This analysis helps identify seasonal trends and regional performance differences, allowing RetailMart to make informed decisions regarding inventory distribution and marketing strategies.