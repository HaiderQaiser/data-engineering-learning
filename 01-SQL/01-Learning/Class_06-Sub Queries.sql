-- SUB QUERY
SELECT 
	p.product_id,
	p.product_name,
	p.list_price
FROM production.products p
WHERE p.list_price > (
	SELECT AVG(list_price) FROM production.products
	)
/* There are three types of Sub Queries
	
	1. Non-Correlated (inner query independent hoti hai outer query se) */
-- Products in Mountain Bikes or Road Bikes categories
SELECT
    product_id,
    product_name
FROM production.products
WHERE category_id IN (
    SELECT category_id
    FROM production.categories
    WHERE category_name IN ('Mountain Bikes', 'Road Bikes')
); 
Select * from production.categories
SELECT 
	p.product_id,
	p.product_name,
	c.category_id,
FROM production.products p
INNER JOIN production.categories c
ON p.
-- 
SELECT
	staff_id,
	first_name,
	last_name
FROM sales.staffs
WHERE manager_id IS NOT NULL;

-- Gemini code
-- Average no of orders per staff member
SELECT AVG(dt.total_orders) AS avg_orders_per_staff
FROM (
    SELECT staff_id, COUNT(order_id) AS total_orders
    FROM sales.orders
    GROUP BY staff_id
) AS dt;

-- products with the highest price in their category
SELECT 
	product_name,
	product_id,
	list_price
 
 -- customers who placed at least one order in 2017
 SELECT
	customer_id,
	first_name,
	last_name,
	city
FROM sales.customers c
WHERE EXISTS (
	SELECT 1
	FROM sales.orders o
	WHERE o.customer_id = c.customer_id
	AND YEAR(o.order_date) = 2017);