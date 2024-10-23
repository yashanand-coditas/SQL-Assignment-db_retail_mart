-- Database: db_retail_mart

-- DROP DATABASE IF EXISTS db_retail_mart;

CREATE DATABASE db_retail_mart
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_India.1252'
    LC_CTYPE = 'English_India.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
DROP TABLE tbl_campaign CASCADE;
DROP TABLE tbl_customers CASCADE;
DROP TABLE tbl_inventory CASCADE;
DROP TABLE tbl_orders CASCADE;
DROP TABLE tbl_products CASCADE;



SELECT * FROM tbl_inventory;
SELECT * FROM tbl_campaign;

DROP TABLE tbl_campaign CASCADE;
DROP TABLE tbl_customers CASCADE;
DROP TABLE tbl_inventory CASCADE;
DROP TABLE tbl_orders CASCADE;
DROP TABLE tbl_products CASCADE;
DROP TABLE tbl_order_items CASCADE;


DROP TABLE tbl_campaign CASCADE;
DROP TABLE tbl_customers CASCADE;
DROP TABLE tbl_inventory CASCADE;
DROP TABLE tbl_orders CASCADE;
DROP TABLE tbl_products CASCADE;
DROP TABLE tbl_order_items CASCADE;


CREATE TABLE tbl_campaign(
    campaign_id SERIAL PRIMARY KEY,
	campaign_name VARCHAR NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	budget DECIMAL NOT NULL,
	region VARCHAR NOT NULL
);

CREATE TABLE tbl_customers (
     customer_id SERIAL PRIMARY KEY,
	 name VARCHAR NOT NULL,
	 email VARCHAR NOT NULL UNIQUE,
	 join_date DATE NOT NULL,
	 total_spent DECIMAL NOT NULL
);


CREATE TABLE tbl_orders(
     order_id SERIAL PRIMARY KEY,
	 customer_id INT REFERENCES tbl_customers(customer_id),
	 order_date DATE NOT NULL,
	 campaign_id INT REFERENCES tbl_campaign(campaign_id),
	 total_amount DECIMAL NOT NULL
);

CREATE TABLE tbl_order_items(
     order_item_id SERIAL PRIMARY KEY,
	 order_id INT REFERENCES tbl_orders(order_id),
	 product_id INT REFERENCES tbl_products(product_id),
	 quantity INT NOT NULL,
	 price DECIMAL NOT NULL
);

CREATE TABLE tbl_products(
      product_id SERIAL PRIMARY KEY,
	  product_name VARCHAR NOT NULL,
	  category VARCHAR NOT NULL,
	  price DECIMAL NOT NULL
);

CREATE TABLE tbl_inventory(
      inventory_id SERIAL PRIMARY KEY,
	  product_id INT REFERENCES tbl_products(product_id),
	  stock_quantity INT NOT NULL
);

DROP TABLE tbl_campaign CASCADE;
DROP TABLE tbl_customers CASCADE;
DROP TABLE tbl_inventory CASCADE;
DROP TABLE tbl_orders CASCADE;
DROP TABLE tbl_products CASCADE;
DROP TABLE tbl_order_items CASCADE;

CREATE TABLE tbl_campaign (
    campaign_id INT PRIMARY KEY,
    campaign_name VARCHAR(255),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(10, 2),
    region VARCHAR(255)
);

CREATE TABLE tbl_customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    join_date DATE,
    total_spent DECIMAL(10, 2)
);

CREATE TABLE tbl_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    campaign_id INT,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES tbl_customers(customer_id),
    FOREIGN KEY (campaign_id) REFERENCES tbl_campaign(campaign_id)
);

CREATE TABLE tbl_order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES tbl_orders(order_id)
);

CREATE TABLE tbl_products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(255),
    price DECIMAL(10, 2)
);

CREATE TABLE tbl_inventory (
    inventory_id INT PRIMARY KEY,
    product_id INT,
    stock_quantity INT,
    FOREIGN KEY (product_id) REFERENCES tbl_products(product_id)
);

--Basic SQL Assignment

--1.Select all campaigns that are currently active.
SELECT
	* 
FROM 
	tbl_campaign WHERE start_date <= CURRENT_DATE AND end_date >= CURRENT_DATE;

--2.Select all customers who joined after January 1, 2023.
SELECT
	* 
FROM 
	tbl_customers WHERE join_date > '2023-01-01';

--3.Select the total amount spent by each customer, ordered by amount in descending order.
SELECT 
	name,total_spent
FROM 
	tbl_customers 
ORDER BY 
	total_spent DESC;

--4.Select the products with a price greater than $50.
SELECT 
	* 
FROM 
	tbl_products 
WHERE 
	price>50;

--5.Select the number of orders placed in the last 30 days.
SELECT 
	COUNT(*) 
FROM 
	tbl_orders WHERE order_date >= CURRENT_DATE-INTERVAL'30 days';

--6.Order the products by price in ascending order and limit the results to the top 5 most affordable products.
SELECT 
	* 
FROM 
	tbl_products
ORDER BY 
	price ASC LIMIT 5;

--7.Select the campaign names and their budgets.
SELECT 
	campaign_name, budget 
FROM 
	tbl_campaign;

--8.Select the total quantity sold for each product, ordered by quantity sold in descending order.
SELECT 
    p.product_id, 
    p.product_name, 
    SUM(oi.quantity) AS total_sold
FROM 
    tbl_order_items oi
JOIN 
    tbl_products p ON oi.product_id = p.product_id
GROUP BY 
    p.product_id, p.product_name
ORDER BY 
    total_sold DESC;


--9.Select the details of orders that have a total amount greater than $100.
SELECT 
	* 
FROM 
	tbl_orders WHERE total_amount >100;

--10.Find the total number of customers who have made at least one purchase.
SELECT
	COUNT(DISTINCT customer_id) 
FROM 
	tbl_orders;

--11.Select the top 3 campaigns with the highest budgets.
SELECT 
	campaign_name, budget 
FROM 
	tbl_campaign 
ORDER BY 
	budget DESC LIMIT 3;

--12.Select the top 5 customers with the highest total amount spent.
SELECT 
	customer_id, total_spent 
FROM 
	tbl_customers 
ORDER BY 
	total_spent DESC LIMIT 5;

---------------------------------------------------------------------------------------

--Analysis Inference from RetailMart's Campaign

--1.Active Campaigns: By identifying currently active campaigns, we can determine which marketing strategies are currently engaging customers and generating sales.
--2.New Customers: Analyzing customers who joined after January 1, 2023, helps us understand the effectiveness of recent marketing efforts in attracting new clients.
--3.Customer Spending: By examining the total amount spent by each customer, we can identify key customers who contribute significantly to revenue. This can inform loyalty programs or targeted marketing strategies aimed at high-value customers.
--4.Product Pricing: Identifying products priced above $50 helps in understanding the high-end offerings in the inventory. This can aid in determining which products might require promotional strategies to boost sales.
--5.Recent Orders: The number of orders placed in the last 30 days provides insights into recent customer engagement and sales trends. A spike in orders could indicate a successful campaign or seasonal trends, while a drop may signal issues that need addressing.
--6.Affordable Products: Listing the top 5 most affordable products helps identify entry-level items that might attract budget-conscious customers.
--7.Campaign Budgets: Understanding the budget allocated to each campaign allows us to evaluate whether higher spending correlates with increased sales and customer engagement.
--8.Total Quantity Sold: By ordering products by total quantity sold, we can identify bestsellers and trends in consumer preferences. This insight is essential for inventory management and future product development.
--9.High-Value Orders: Analyzing orders with amounts greater than $100 can help in identifying high-ticket sales and the effectiveness of upselling strategies.
--10.Active Customers: The total number of customers who have made at least one purchase reveals the breadth of our customer base and can inform customer retention strategies.
--11.Active Customers: The total number of customers who have made at least one purchase reveals the breadth of our customer base and can inform customer retention strategies.
--12.High-Spending Customers: Understanding which customers have the highest total spending can inform loyalty and retention efforts. Strategies can be developed to reward these customers and encourage repeat purchases.









