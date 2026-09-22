  -- kis customer ne kia order kia us order main kia product usne buy kie hain?
SELECT 
	c.customer_id,
	c.first_name,
	c.last_name,
	o.order_date,
	p.product_name,
	p.list_price
FROM sales.customers AS c
INNER JOIN sales.orders AS o
ON c.customer_id = o.customer_id
INNER JOIN sales.order_items AS oi
ON o.order_id = oi.order_id
INNER JOIN production.products AS p
ON oi.product_id = p.product_id;

--												◆◆◆ VIEWS ◆◆◆
CREATE VIEW  vw_customer_order 
AS
SELECT 
	c.customer_id,
	c.first_name,
	c.last_name,
	o.order_date,
	p.product_name,
	p.list_price
FROM sales.customers AS c
INNER JOIN sales.orders AS o
ON c.customer_id = o.customer_id
INNER JOIN sales.order_items AS oi
ON o.order_id = oi.order_id
INNER JOIN production.products AS p
ON oi.product_id = p.product_id;
-- check
SELECT * FROM [dbo].[vw_customer_order]

-- modify view
CREATE OR ALTER VIEW view_name_here;
-- OR
ALTER VIEW vw_customer_order 
AS
SELECT 
	c.customer_id,
	c.first_name,
	c.last_name,
	o.order_date,
	p.product_name,
	p.list_price,
	c.phone
FROM sales.customers AS c
INNER JOIN sales.orders AS o
ON c.customer_id = o.customer_id
INNER JOIN sales.order_items AS oi
ON o.order_id = oi.order_id
INNER JOIN production.products AS p
ON oi.product_id = p.product_id;

-- check
SELECT * FROM vw_customer_order;

-- rename view
-- simple ui se kr skte hain view pe right click kr k

-- CURRENT-DATE (is function se current date la skte hain)
-- 3.1 PRACTICE QUES
CREATE VIEW production.vw_product_catalog
AS
SELECT 
	p.product_name,
	b.brand_name,
	c.category_name,
	p.list_price
FROM production.products AS p
INNER JOIN production.categories AS c
ON p.category_id = c.category_id
INNER JOIN production.brands AS b
ON p.brand_id = b.brand_id;

SELECT * FROM [production].[vw_product_catalog]

-- Using the view from 3.1, write a query that returns only products under $500,
-- sorted by price ascending.
SELECT * FROM [production].[vw_product_catalog]
WHERE list_price < 500
ORDER BY list_price ASC;

-- 3.3
CREATE VIEW vw_customer_contact
AS 
SELECT customer_id, first_name, last_name, city
FROM sales.customers; 

SELECT * FROM vw_customer_contact;

-- H.W remaining questions
-- AGGREGATION
SELECT
	count(*) AS total_products, -- sirf wohi values ginta hai jo NOT NULL hon
	avg(list_price) AS average_price
FROM production.products;
-- 
SELECT 
	COUNT(*) AS total_orders,
	COUNT(shipped_date) AS shipped_orders,
	COUNT(*) - COUNT(shipped_date) AS remaining_orders
FROM sales.orders;

-- GROUP BY (ALWAYS USE AN AGGREGATION FUNCTION WITH GROUP BY)
SELECT 
	state,
	COUNT(*) AS customer_by_state
FROM sales.customers
GROUP BY state;

-- Ques: i need product count by category, also product by brand_id
-- and product by brand_id and category_id
-- ORDER OF EXECUTION -------
SELECT 
	product_name,
	COUNT(*) AS product_by_categories
FROM production.products
GROUP BY product_name
ORDER BY product_by_categories;

SELECT 
	c.first_name + ' '  + c.last_name AS customer_name,
	((oi.list_price * oi.quantity) * (1 - oi.discount)) AS discounted_order_price
FROM sales.customers AS c
INNER JOIN sales.orders AS o
	ON c.customer_id = o.customer_id
INNER JOIN sales.order_items AS oi
	ON o.order_id = oi.order_id
ORDER BY discounted_order_price
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

-- Ques: Top 5 product categories by total revenue, only including categories with at least 50 completed orders.
