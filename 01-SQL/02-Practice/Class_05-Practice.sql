--										✧✧✧ VIEWS PRACTICE ✧✧✧
/* 3.1. Create a view called production.vw_product_catalog that joins products, categories,
and brands to show product_name, category_name, brand_name, and list_price in one result. */ 
CREATE VIEW production.vw_product_catalog
AS 
SELECT 
	p.product_name,
	c.category_name,
	b.brand_name,
	p.list_price
FROM production.products AS p
INNER JOIN production.brands AS b
	ON p.brand_id = b.brand_id
INNER JOIN production.categories AS c
	ON c.category_id = p.category_id;

SELECT * FROM [production].[vw_product_catalog];

/* 3.2. Using the view from 3.1, write a query that returns only products
under $500, sorted by price ascending. */
SELECT * FROM [production].[vw_product_catalog]
WHERE list_price < 500 
ORDER BY list_price ASC;

/* 3.3. Create a view sales.vw_customer_contact that exposes only customer_id,
first_name, last_name, and city from sales.customers, explicitly excluding email and phone.
Explain in one sentence what real-world problem this view solves. */ 
CREATE VIEW sales.vw_customer_contact
AS 
SELECT 
	c.customer_id,
	c.first_name,
	c.last_name,
	c.city
FROM sales.customers AS c;
/* This view enforces data privacy and security (Column-Level Security) by restricting general 
users or external reporting tools from accessing sensitive Personal Identifiable Information (PII) 
like email addresses and phone numbers. */

/* 3.4. Explain why the following view cannot be used in a simple UPDATE statement, and identify 
exactly which part of its definition causes the restriction: */ 

CREATE VIEW sales.vw_order_summary 
AS
SELECT 
	o.order_id,
	c.first_name, 
	c.last_name, 
	o.order_status
FROM sales.orders AS o
INNER JOIN sales.customers AS c 
	ON o.customer_id = c.customer_id; -- Ek sath 2 tables ka data update nhi kia jaskta

--										✧✧✧ VIEWS PRACTICE ✧✧✧
-- 4.1 - Write a query that returns the total number of customers and the number with a non-NULL phone value.
SELECT 
	COUNT(customer_id) AS total_customers,
	COUNT(phone) AS total_phone_nos
FROM sales.customers;

/* 4.2 - Group production.products by brand_id and return the product count and average list_price per brand,
sorted by average price descending */
SELECT 
	brand_id,
	COUNT(product_id) AS total_products,
	AVG(list_price) AS average_price
FROM production.products 
GROUP BY brand_id
ORDER BY average_price DESC;
-- better way
SELECT 
	p.brand_id,
	b.brand_name,
	COUNT(p.product_id) AS total_products,
	AVG(p.list_price) AS average_price
FROM production.products p
INNER JOIN production.brands b
	ON p.brand_id = b.brand_id
GROUP BY p.brand_id, b.brand_name
ORDER BY average_price DESC;

-- 4.3 - Using HAVING, find every brand with an average list_price above $1000.
SELECT  
	brand_id,
	AVG(list_price) AS avg_price
FROM production.products
GROUP BY brand_id
HAVING AVG(list_price) > 1000

-- 4.4 - The following query does not run. Explain the error and fix it:

SELECT c.customer_id, SUM(oi.list_price) AS total
FROM sales.order_items oi
INNER JOIN sales.orders o
	ON oi.order_id = o.order_id
INNER JOIN sales.customers c
	ON c.customer_id =  o.customer_id
GROUP BY c.customer_id
HAVING SUM(oi.list_price) > 5000;

/* 4.5 - Write a query that joins sales.orders, sales.order_items, and production.products,
then returns total quantity sold per product name, sorted from highest to lowest, limited to the top 10.*/ 
SELECT 
	p.product_name,
	SUM(oi.quantity) AS total_qtty
FROM production.products AS p
INNER JOIN sales.order_items AS oi
	On p.product_id = oi.product_id
INNER JOIN sales.orders AS o
	ON oi.order_id = o.order_id
GROUP BY product_name
ORDER BY total_qtty DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

