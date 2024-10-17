# RetailMart SQL Analysis Documentation

## Introduction
This documentation outlines the analysis performed on the RetailMart database, which focuses on evaluating the effectiveness of recent sales campaigns. The aim is to analyze the impact of these campaigns on sales, customer engagement, and inventory management. This analysis is divided into three parts: Basic Assignment, Intermediate Assignment, and Advanced Assignment.

## Database Schema
The first step involved creating a database named `db_retail_mart` and defining the necessary tables according to the provided schema. Each table was designed with primary and foreign keys to ensure data integrity. The following tables were created:

### tbl_campaign
- `campaign_id` (INT, Primary Key)
- `campaign_name` (VARCHAR)
- `start_date` (DATE)
- `end_date` (DATE)
- `budget` (DECIMAL)
- `region` (VARCHAR)

### tbl_customers
- `customer_id` (INT, Primary Key)
- `name` (VARCHAR)
- `email` (VARCHAR)
- `join_date` (DATE)
- `total_spent` (DECIMAL)

### tbl_orders
- `order_id` (INT, Primary Key)
- `customer_id` (INT, Foreign Key)
- `order_date` (DATE)
- `campaign_id` (INT, Foreign Key)
- `total_amount` (DECIMAL)

### tbl_order_items
- `order_item_id` (INT, Primary Key)
- `order_id` (INT, Foreign Key)
- `product_id` (INT, Foreign Key)
- `quantity` (INT)
- `price` (DECIMAL)

### tbl_products
- `product_id` (INT, Primary Key)
- `product_name` (VARCHAR)
- `category` (VARCHAR)
- `price` (DECIMAL)

### tbl_inventory
- `inventory_id` (INT, Primary Key)
- `product_id` (INT, Foreign Key)
- `stock_quantity` (INT)

#### Basic Assignment
The basic assignment aimed to extract fundamental insights from the database. Here are the queries executed and their implications:

- **Active Campaigns**: Selected all campaigns currently active to evaluate ongoing marketing efforts.
- **New Customers**: Selected customers who joined after January 1, 2023, to assess recent customer acquisition.
- **Customer Spending**: Analyzed total spending by each customer to identify high-value clients.
- **Product Pricing**: Retrieved products priced above $50 to target premium customers.
- **Recent Orders**: Counted orders placed in the last 30 days to gauge current sales activity.
- **Affordable Products**: Ordered products by price and limited to the top 5 to highlight budget-friendly options.
- **Campaign Budgets**: Selected campaign names and their budgets for financial assessment.
- **Product Sales**: Analyzed total quantity sold for each product to identify bestsellers.
- **High-Value Orders**: Reviewed orders with amounts greater than $100 to find significant transactions.
- **Customer Purchases**: Counted customers with at least one purchase to evaluate engagement.
- **Top Campaigns**: Identified top 3 campaigns by budget to understand resource allocation.
- **High-Spending Customers**: Selected top 5 customers based on total spending for targeted marketing.

##### Insights from Basic Assignment
- A diverse range of campaigns is active, reflecting ongoing marketing efforts.
- Recent customer acquisition is promising, indicating effective outreach strategies.
- Identifying high-spending customers is crucial for targeted promotions.
- Bestselling products highlight successful inventory and marketing strategies.

#### Intermediate Assignment
The intermediate assignment involved more complex queries aimed at deeper insights:

- **Orders per Campaign**: Counted orders per campaign to measure campaign effectiveness.
- **Average Order Amount**: Analyzed average order amounts for campaigns to assess financial performance.
- **High-Order Products**: Selected products ordered over 100 times to identify popular items.
- **Regional Sales**: Analyzed total sales per region to gauge geographic performance.
- **Average Customer Spending**: Calculated average spending per customer for financial insights.
- **Popular Products by Category**: Identified the most popular product in each category for targeted marketing.
- **Ended Campaign Budgets**: Summarized total budget for completed campaigns for financial closure.
- **Order and Campaign Details**: Retrieved detailed order information alongside campaign names.
- **Revenue per Campaign**: Aggregated revenue to assess campaign profitability.
- **Orders per Region**: Counted total orders placed in each region to evaluate geographic engagement.
- **Customer Spending per Campaign**: Analyzed spending by each customer on campaigns for marketing insights.
- **Average Campaign Budget by Region**: Computed average budget of campaigns grouped by region for regional financial insights.
- **Campaign Spending vs. Budget**: Filtered campaigns where spending exceeded budget for financial scrutiny.
- **Product Sales and Pricing**: Calculated total quantity sold and average price per product for inventory management.
- **Campaigns Over $200**: Identified campaigns with average order amounts exceeding $200 to focus on high-value marketing.
- **Top Products by Sales**: Retrieved top 10 products by sales amount for inventory strategies.
- **Low-Stock Products**: Identified products with low stock for inventory management.
- **High-Spending Customers (Last 6 Months)**: Found customers who spent more than average for retention strategies.

#### Insights from Intermediate Assignment
- Campaign effectiveness varies, with some achieving significant sales while others need improvement.
- Popular products offer insights into customer preferences and inventory needs.
- Regional sales performance indicates potential areas for growth and targeted marketing efforts.

#### Advanced Assignment
The advanced assignment included more complex analyses utilizing indexes and advanced SQL techniques:

- **Highest and Lowest Budgets**: Selected campaigns with the highest and lowest budgets for financial assessment.
- **Average Product Price**: Analyzed average prices of products across categories to inform pricing strategies.
- **Ranked Products by Sales**: Ranked products within categories to identify top performers.
- **CTE for Revenue and Order Amount**: Created a CTE to summarize total revenue and average order amounts for campaigns.
- **Handle Missing Stock**: Provided default values for missing stock quantities to ensure accurate inventory assessment.
- **Customer Product Revenue Analysis**: Analyzed total quantity and revenue generated by products for customer engagement insights.
- **Average Order Amount vs. Overall Average**: Identified campaigns exceeding the average order amount for financial performance evaluation.
- **Rolling Average of Sales**: Analyzed sales trends over the last 3 months for forecasting.
- **Sales Growth Rate**: Calculated sales growth rates for ranking campaigns over time.
- **Top Spending Customers (75th Percentile)**: Used CTEs to find customers consistently spending above the 75th percentile.
- **Campaign Budget Correlation**: Analyzed correlation between campaign budgets and revenue for financial insights.
- **Partitioned Sales Data**: Partitioned data for regional performance comparisons and anomaly detection.
- **Impact of Categories on Campaign Success**: Analyzed how product categories influence campaign success.
- **Moving Average of Regional Sales**: Computed moving averages for trend analysis.
- **Effectiveness of Campaigns**: Compared pre- and post-campaign average sales for effectiveness evaluation.

#### Insights from Advanced Assignment
- Budget allocation correlates with campaign success; strategic adjustments may enhance effectiveness.
- Consistent high-spending customers should be nurtured for increased loyalty and revenue.
- Trends in sales and product performance inform future marketing and inventory strategies.

## Conclusion
The comprehensive analysis conducted for RetailMart has provided valuable insights into the effectiveness of its sales campaigns and customer engagement strategies.

In the Basic Assignment, we established a foundational understanding of the current landscape by identifying active campaigns, analyzing customer spending, and reviewing product pricing. This initial exploration highlighted key areas for potential growth, particularly in understanding customer demographics and spending behavior.

The Intermediate Assignment deepened our analysis by examining the performance of each campaign in terms of order volume, average order amounts, and regional sales. Notably, we identified popular products and assessed total sales across various regions, revealing significant trends that can inform future marketing efforts. This segment emphasized the importance of targeted campaigns and inventory management in driving sales.

In the Advanced Assignment, we employed more complex SQL techniques, including CTEs and window functions, to analyze the correlation between campaign budgets and revenue, as well as to evaluate customer spending patterns. This stage uncovered critical insights into product performance, sales growth rates, and the overall effectiveness of campaigns over time. The use of indexes improved query performance, ensuring efficient data retrieval.

Overall, the analysis has equipped RetailMart with actionable insights to enhance marketing strategies, optimize inventory management, and improve customer engagement. Moving forward, RetailMart should focus on refining its campaigns based on performance metrics, targeting high-value customers, and leveraging data-driven decision-making to boost sales effectiveness and overall business growth
