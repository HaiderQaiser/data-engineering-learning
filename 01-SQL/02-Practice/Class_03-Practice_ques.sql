--													✦✦✦ QUESTION 1 ✦✦✦
-- 5.1. Write a query that lists every product with its brand name, 
-- using production.products and production.brands.
SELECT
	p.product_name,
	b.brand_name
FROM production.products as p
INNER JOIN production.brands as b
ON p.brand_id = b.brand_id;

--													✦✦✦ QUESTION 2 ✦✦✦
-- 5.2. Using a LEFT JOIN, write a query that finds every store
-- with zero staff currently assigned to it.
SELECT 
	st.store_name 
FROM sales.stores as st
LEFT JOIN sales.staffs as s
ON s.store_id = st.store_id
WHERE s.staff_id IS NULL;

--												✦✦✦ PRACTICE QUESTIONS ✦✦✦
-- Task: Humari database me aise Customers dhoondo jinhone aaj tak
-- ek bhi Order nahi diya.
SELECT
	c.first_name + ' ' + last_name AS full_name,
	c.state,
	o.customer_id,
	o.order_id
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Task: Un Categories ka naam pata karo jinka ek bhi product 
-- hamare database me registered nahi hai
SELECT 
	c.category_id,
	c.category_name
FROM	production.categories AS c
LEFT JOIN production.products AS p
ON c.category_id = p.category_id
WHERE p.product_id IS NULL;

--													✦✦✦ QUESTION 3 ✦✦✦
/*
5.3. Explain, in your own words, why the following query returns
every product regardless of stock level, and rewrite it so that it 
only returns products with fewer than 5 units in stock at store 1:
*/
SELECT 
	p.product_name,
	s.quantity
FROM production.products AS p
LEFT JOIN production.stocks AS s
    ON p.product_id = s.product_id AND s.quantity < 5 AND s.store_id = 1;


SELECT 
	p.product_name,
	s.quantity
FROM production.products AS p
LEFT JOIN production.stocks AS s
    ON p.product_id = s.product_id
	WHERE s.quantity < 5 AND s.store_id = 1;
-- MY ANSWER: 
--		ON Clause mn filter lagane se NULL records drop nhi hotay!
--		Proper filtering k lie conditions ko Where clause mn daalna zruri hai.

--													✦✦✦ QUESTION 4 ✦✦✦
-- 5.4. Write a self join on sales.staffs that lists every manager along with
-- a count placeholder column showing 1 for each employee they manage 
-- (you will replace this with a real COUNT in Chapter 6); for now, just
-- produce one row per employee-manager pair.
SELECT 
	emp.first_name AS employee_name,
	mgr.first_name AS manager_name,
	1 AS staff_count
FROM sales.staffs AS emp
LEFT JOIN sales.staffs AS mgr
ON emp.manager_id = mgr.staff_id;



--													✦✦✦ QUESTION 5 ✦✦✦
-- 5.5. Write a three-table join across sales.orders, sales.order_items,
-- and production.products that lists every item in order #1, including product name and quantity.
SELECT 
	p.product_name,
	oi.quantity
FROM production.products as p
INNER JOIN sales.order_items as oi
	ON  p.product_id = oi.product_id
INNER JOIN sales.orders as o
	ON oi.order_id = o.order_id
WHERE oi.order_id = 1;

-- OR
SELECT 
    p.product_name,
    oi.quantity
FROM sales.orders AS o
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN production.products AS p
    ON oi.product_id = p.product_id
WHERE o.order_id = 1;

--													✦✦✦ QUESTION 6 ✦✦✦

-- 5.6. A colleague joins orders to order_items and reports "we received 4,658 orders last year." 
-- Explain what actually went wrong with that number and how you would find the true order count instead.
SELECT COUNT(order_id) FROM sales.orders;
-- Jb us colleague ne dono table ko join kia to us join ki wajah se order ids k sath sath order items
-- bhi agye (jo count hogye). jiski wajah se calculation exact nhi hoski

--													✦✦✦ QUESTION 7 ✦✦✦
/*
5.7. Think About It: CROSS JOIN is often considered dangerous because it can accidentally produce 
millions of rows from two innocent-looking tables. Under what real circumstances would you deliberately
want a CROSS JOIN, and how would you guard against using one by accident, for example, by forgetting an 
ON clause that was meant to be there? 
*/
-- ANSWER
/*
CROSS JOIN hum tab jaan bujh kar lagate hain jab hume do cheezon ke saare combinations chahiye hon.
Jaise T-Shirts ke Colors (Red, Blue) aur Sizes (S, M, L). CROSS JOIN chalayenge to har color ka har
size ke sath pair ban jayega (Red-S, Red-M, Red-L, wagera).
*/