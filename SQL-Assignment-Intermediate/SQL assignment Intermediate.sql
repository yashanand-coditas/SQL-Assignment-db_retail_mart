-- Intermediate SQL Assignment

--1.Number of orders per campaign, ordered by number of orders descending.
SELECT campaign_id, COUNT(*) AS order_count
FROM tbl_orders
GROUP BY campaign_id
ORDER BY order_count DESC;

--2.Average order amount for each campaign.
SELECT campaign_id, AVG(total_amount)AS average_order_amount
from tbl_orders
group by campaign_id;

--3.Products ordered more than 100 times in total.
SELECT product_id, SUM(quantity) as total_ordered
FROM tbl_order_items
GROUP BY product_id
HAVING SUM(quantity)>100;

--4.Total sales for each region, ordered by sales descending.
SELECT region, SUM(total_amount) AS total_sales
FROM tbl_orders
JOIN tbl_campaign ON tbl_orders.campaign_id = tbl_campaign.campaign_id
GROUP BY region
ORDER BY total_sales DESC;

--5.Average amount spent per customer, ordered by average descending.
SELECT customer_id, AVG(total_spent) AS average_spent
FROM tbl_customers
GROUP BY customer_id
ORDER BY average_spent DESC;

--6.Most popular product in each category.
SELECT p.category, p.product_id, SUM(quantity) AS total_sold
FROM tbl_order_items oi
JOIN tbl_products p ON oi.product_id = p.product_id
GROUP BY p.category, p.product_id
ORDER BY total_sold DESC;

--7.Total budget of all campaigns that have ended.
SELECT SUM(budget) AS total_ended_budget
FROM tbl_campaign
WHERE end_date < CURRENT_DATE;

--8.Order details along with campaign names.
SELECT o.*, c.campaign_name
FROM tbl_orders o
JOIN tbl_campaign c ON o.campaign_id = c.campaign_id;

--9.Product details for each order item.
SELECT oi.*, p.product_name
FROM tbl_order_items oi
JOIN tbl_products p ON oi.product_id = p.product_id;

--10.Total revenue per campaign.
SELECT campaign_id, SUM(total_amount) AS total_revenue
FROM tbl_orders
GROUP BY campaign_id;

--11.Total number of orders placed per region.
SELECT region, COUNT(*) AS order_count
FROM tbl_orders o
JOIN tbl_campaign c ON o.campaign_id = c.campaign_id
GROUP BY region;

--12.Total amount spent by each customer on each campaign.
SELECT customer_id, campaign_id, SUM(total_amount) AS total_spent
FROM tbl_orders
GROUP BY customer_id, campaign_id;

--13.Average budget of all campaigns, grouped by region.
SELECT region, AVG(budget) AS average_budget
FROM tbl_campaign
GROUP BY region;

--14.Filter campaigns with total spending greater than their budget using a sub-query.
SELECT *
FROM tbl_campaign c
WHERE (SELECT SUM(total_amount) FROM tbl_orders o WHERE o.campaign_id = c.campaign_id) > c.budget;

--15.Total quantity sold and average price per product.
SELECT p.product_id, SUM(oi.quantity) AS total_quantity_sold, AVG(oi.price) AS average_price
FROM tbl_order_items oi
JOIN tbl_products p ON p.product_id = oi.product_id
GROUP BY p.product_id;

--16.Total quantity sold per product.
SELECT product_id, SUM(quantity) AS total_quantity_sold
FROM tbl_order_items
GROUP BY product_id;

--17.Campaigns with average order amount greater than $200.
SELECT campaign_id, AVG(total_amount) AS average_order_amount
FROM tbl_orders
GROUP BY campaign_id
HAVING AVG(total_amount) > 200;

--18.Top 10 products with highest total sales amount, ordered by sales descending.
SELECT p.product_id, SUM(oi.quantity * oi.price) AS total_sales
FROM tbl_order_items oi
JOIN tbl_products p ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_sales DESC
LIMIT 10;

--19.Products with less than 20 units in stock, ordered by stock quantity.
SELECT p.product_id, p.product_name, i.stock_quantity
FROM tbl_products p
JOIN tbl_inventory i ON p.product_id = i.product_id
WHERE i.stock_quantity < 20
ORDER BY i.stock_quantity;

--20.Customers who spent more than the average amount spent per customer in the last 6 months.
SELECT DISTINCT customer_id
FROM tbl_customers
WHERE total_spent > (SELECT AVG(total_spent) FROM tbl_customers WHERE join_date >= CURRENT_DATE - INTERVAL '6 months');

------------------------------------------------------------------------------------------------------------------------
------------Analysis Inference from RetailMart's Campaign--------------------------------

--1.Number of Orders per Campaign: By analyzing the number of orders associated with each campaign, we can identify which campaigns successfully drove customer engagement. Campaigns with a high number of orders suggest effective marketing strategies, while those with fewer orders may require reassessment or optimization.
--2Average Order Amount per Campaign: Evaluating the average order amount for each campaign provides insights into customer spending behavior. Campaigns with higher average order values may indicate successful upselling techniques or the effectiveness of premium product placements.
--3.High-Volume Products: Identifying products that have been ordered more than 100 times helps in understanding customer preferences. These insights can inform inventory management, ensuring that popular products are always in stock, and can guide promotional strategies to further boost sales.
--4.Total Sales by Region: Analyzing total sales across different regions highlights areas of strong performance and those that may require more attention. This information is crucial for tailoring regional marketing efforts and resource allocation to maximize sales potential.
--5.Average Spending per Customer: Calculating the average amount spent per customer reveals valuable insights into customer segments. Higher average spending indicates loyal customers or successful marketing efforts, guiding strategies for personalized promotions or loyalty programs.
--6.Most Popular Product in Each Category: Identifying the most popular products within each category aids in inventory planning and targeted marketing. These products can be highlighted in campaigns to attract more customers and drive sales.
--7.Total Budget of Ended Campaigns: Analyzing the total budget of campaigns that have ended helps in understanding the financial allocations versus actual sales performance. This can inform future budgetary decisions and campaign planning.
--8.Order Details with Campaign Names: Obtaining order details along with their associated campaign names facilitates a deeper analysis of campaign effectiveness. It enables tracking which campaigns generated specific sales and helps refine marketing strategies.
--9.Total Revenue per Campaign: Aggregating total revenue generated by each campaign provides clear insights into the financial impact of marketing efforts. This data is essential for evaluating the return on investment (ROI) of each campaign.
--10.Total Number of Orders by Region: Analyzing the total number of orders placed per region helps identify geographical strengths and weaknesses. This can inform targeted promotions and resource distribution.
--11.Customer Spending by Campaign: Assessing the total amount spent by each customer on each campaign offers insights into customer loyalty and engagement levels. This information can guide personalized marketing efforts and rewards programs.
--12.Average Budget by Region: Using aggregate functions to find the average budget of all campaigns grouped by region provides insights into regional spending patterns. This can inform future budgeting strategies and regional campaign planning.
--13.Campaigns Exceeding Budget: Filtering campaigns with total spending exceeding their budget highlights potential inefficiencies or overspending issues. Addressing these campaigns can prevent financial losses and improve future campaign planning.
--14.Total Quantity Sold and Average Price per Product: Calculating the total quantity sold alongside the average price per product helps assess pricing strategies and product demand. This data is crucial for effective inventory management.
--15.Total Quantity Sold per Product: Aggregating total quantities sold per product provides insights into bestsellers and underperformers, aiding in inventory and marketing decisions.
--16.High-Value Campaigns: Identifying campaigns with an average order amount greater than $200 helps spotlight successful high-value sales strategies. This information can inform future campaign designs targeting premium customers.
--17.Top Products by Total Sales: Finding the top 10 products with the highest total sales amounts helps prioritize marketing and inventory efforts. These products should be featured prominently in campaigns to maximize sales potential.
--18.Low-Stock Products: Identifying products with fewer than 20 units in stock helps prevent stockouts and lost sales opportunities. This is essential for maintaining optimal inventory levels and ensuring customer satisfaction.
--19.High-Spending Customers in Recent Months: Analyzing customers who spent more than the average in the last six months helps identify high-value customers. Targeting these customers with personalized marketing strategies can enhance customer loyalty and retention.
--20.Customer Spending Patterns:By identifying customers who have spent more than the average amount in the last six months, we gain insights into spending patterns and customer behavior. This analysis helps us recognize which customers are more engaged and likely to contribute significantly to overall sales.