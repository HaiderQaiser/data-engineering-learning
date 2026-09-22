USE BikeStores;
SELECT * FROM production.products;

-- 1. Pehle dekho products table mein kya hai
SELECT * FROM production.products;

-- 2. Phir dekho categories table mein kya hai
SELECT * FROM production.categories;
-- JOINS

-- INNER JOIN
SELECT 
	p.product_name,
	c.category_name,
	p.list_price
FROM production.products AS p
INNER JOIN production.categories AS c
	ON p.category_id = c.category_id;

SELECT 
products.product_name,
products.model_year,
categories.category_name
FROM production.products
INNER JOIN production.categories
ON productions.category_id = categories.category_id;


SELECT 
	s.first_name,
	s.last_name,
	o.order_id,
	o.order_date

FROM sales.staff  AS s
LEFT JOIN sales.orders AS o
ON s.store_id = o.store_id;

-- LEFT JOIN

SELECT 
	p.product_id,
	p.product_name,
	s.quantity
FROM production.stocks AS s
LEFT JOIN production.products AS p
ON p.product_id = s.product_id;



-- PRACTICE QUESTIONS

-- 5.1. Write a query that lists every product with its brand name, using production.products and production.brands.
SELECT 
	p.product_id,
	b.brand_name,
	p.product_name
FROM production.products AS p
INNER JOIN production.brands AS b
ON p.brand_id = b.brand_id;

-- 5.2. Using a LEFT JOIN, write a query that finds every store with zero staff currently assigned to it.
SELECT *
FROM production.store AS s
LEFT JOIN production.stores AS st
ON s.store_id = st.store_id;







