# Analysis Inference from RetailMart's Campaign

#### 1.Campaign Budget Analysis
- Identifying the campaigns with the highest and lowest budgets reveals the financial allocation strategies and their impact on overall revenue. Campaigns with higher budgets that also generate significant revenue suggest effective resource utilization, while low-budget campaigns that yield high returns indicate potential opportunities for growth.

---
#### 2.Product Pricing Insights
- Analyzing the average price of products across all categories allows RetailMart to understand pricing strategies and identify potential pricing adjustments needed to remain competitive. Ranking products based on total sales helps in determining bestsellers and optimizing inventory.

---
#### 3.Revenue and Order Amounts
- Using a CTE to calculate total revenue and average order amounts per campaign provides a clear picture of each campaign's effectiveness. Understanding which campaigns generate the highest average order values can inform future marketing efforts.

---
#### 4.Handling Inventory
- Addressing missing stock quantities with a default value of zero ensures accurate inventory assessments. This information is crucial for supply chain management and ensures that high-demand products are adequately stocked.

---
#### 5.Customer Spending Analysis
- Analyzing total quantity and revenue generated from each product by customer provides insights into customer preferences and behaviors. Understanding which customers consistently spend more can guide personalized marketing and loyalty initiatives.

---
#### 6.Campaign Performance Evaluation
- Comparing average order amounts of campaigns against the overall average highlights campaigns that are performing exceptionally well or underperforming. This evaluation can direct resources to campaigns that need optimization.

---
#### 7.Sales Trends and Growth Rates
- Calculating the growth rate of sales for each campaign over time and analyzing rolling averages can reveal trends in consumer behavior and the effectiveness of seasonal promotions. This data aids in strategic planning for future campaigns.

---
#### 8.Top Customers Identification
- Using CTEs and window functions to identify the top 5 customers who consistently spend above the 75th percentile allows RetailMart to focus on nurturing relationships with its most valuable clients, enhancing customer loyalty.

---
#### 9.Correlation Between Budgets and Revenue
- Investigating the correlation between campaign budgets and total revenue generated can uncover insights into how effectively financial resources are translating into sales. This analysis is critical for future budget planning.

---
#### 10.Regional Performance Comparison
- Partitioning sales data by region can identify performance discrepancies and anomalies. Understanding these variations can help RetailMart tailor regional strategies to boost sales.

---
#### 11.Impact of Product Categories
- Analyzing the impact of product categories on campaign success can inform marketing strategies and product placements, ensuring that the most effective categories receive the attention they deserve.

---
#### 12.Moving Averages and Trends
- Computing moving averages of sales per region allows RetailMart to detect trends over time, aiding in strategic decision-making and planning for future campaigns.

---
#### 13.Effectiveness of Campaigns
- Evaluating pre-campaign and post-campaign average sales provides insights into campaign effectiveness. This assessment helps in understanding the impact of marketing efforts and refining future strategies.

---
#### 14.Analyze the Impact of Product Categories on Campaign Success
- Examining the impact of product categories on campaign success provides valuable insights into how different categories perform within various marketing efforts. By correlating campaign outcomes with specific product categories, RetailMart can identify which categories drive higher sales and engagement. This analysis helps in understanding consumer preferences and enables more targeted marketing strategies, ensuring that the most successful categories receive focused promotional efforts. 

---
#### 15.Compute the Moving Average of Sales per Region and Analyze Trends 
- Calculating the moving average of sales per region offers RetailMart a clearer picture of sales trends over time, smoothing out fluctuations and highlighting underlying patterns. This analysis helps identify seasonal trends and regional performance differences, allowing RetailMart to make informed decisions regarding inventory distribution and marketing strategies.

