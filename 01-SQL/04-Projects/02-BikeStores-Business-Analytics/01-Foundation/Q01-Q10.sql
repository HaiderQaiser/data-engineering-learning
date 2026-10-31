/*=======================================================================================================================
				LEVEL 1 — SQL Foundation & Business Reporting
========================================================================================================================*/

/*========================================================================================================================
 1. Sales & Order Fundamentals
========================================================================================================================*/
/*
Q1 — Total Orders by Status

Finance team ko har order status (Pending, Completed, etc.) ke hisaab se orders ki total
count aur percentage chahiye. */
SELECT
	CASE 
		WHEN order_status = 1 THEN 'Pending'
		WHEN order_status = 2 THEN 'Resolved'
		WHEN order_status = 3 THEN 'Cancelled'
		WHEN order_status = 4 THEN 'Shipped'
	END AS status_name,
	COUNT(*) AS order_count,
	CONCAT(CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)), '%') AS percentage
FROM sales.orders
GROUP BY order_status
/*
4 = Shipped
3 = Cancelled
2 = Resolved
1 = Pending
*/

/*
Q2 — Top Customers by Spending

Marketing team ko top 10 customers identify karne hain, based on their total 
net spending. Customer ka full name aur total spending show karo. 
*/
SELECT
	c.customer_id,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spending
FROM sales.customers c
INNER JOIN sales.orders o
	ON c.customer_id = o.customer_id
INNER JOIN sales.order_items oi
	ON o.order_id = oi.order_id
GROUP BY c.customer_id, CONCAT(c.first_name, ' ', c.last_name)
ORDER BY total_spending DESC
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY;

/*
Q3 — Best-Selling Products

Product team ko quantity sold ke hisaab se top 10 products chahiye. Product 
name, total quantity sold aur total revenue show karo.
*/
SELECT
	p.product_id,
	p.product_name,
	SUM(oi.quantity) AS quantity_sold,
	SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS total_revenue
FROM production.products p
INNER JOIN sales.order_items oi
	ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY quantity_sold DESC
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY;

/*
Q4 — Store Performance

Management ko har store ke total orders, total units sold aur net revenue ka report chahiye.
*/
SELECT
	st.store_id,
	st.store_name,
	COUNT(DISTINCT o.order_id) AS total_orders,
	SUM(oi.quantity) AS items_sold,
	CONCAT(SUM(oi.list_price * oi.quantity * (1 - oi.discount)), '$') AS net_revenue
FROM sales.stores st
INNER JOIN sales.orders o
	ON st.store_id = o.store_id
INNER JOIN sales.order_items oi
	ON o.order_id = oi.order_id
GROUP BY st.store_id, st.store_name
ORDER BY SUM(oi.list_price * oi.quantity * (1 - oi.discount)) DESC

/*
Q5 — Brand Revenue Report

Management ko har brand ki total revenue aur units sold compare karne hain. Brands ko revenue
ke descending order mein show karo.
*/
SELECT
	b.brand_id,
	b.brand_name,
	SUM(oi.quantity) AS units_sold,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM production.brands b
INNER JOIN production.products p
	ON b.brand_id = p.brand_id
INNER JOIN sales.order_items oi
	ON p.product_id = oi.product_id
GROUP BY b.brand_id, b.brand_name
ORDER BY total_revenue DESC
/*========================================================================================================================
 2. Customer & Product Analysis
========================================================================================================================*/
/*
Marketing team un customers ki list chahti hai jinhon ne abhi tak koi order place
nahi kiya.
*/
SELECT
	c.customer_id,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM sales.customers c
LEFT JOIN sales.orders o
	ON c.customer_id = o.customer_id 
WHERE o.customer_id IS NULL

/*
Q7 — Products Never Sold

Inventory team ko un products ki list chahiye jo kisi bhi order item mein kabhi sell
nahi huay.
*/
SELECT
	p.product_id,
	p.product_name
FROM production.products p
LEFT JOIN sales.order_items oi
	ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

/*
Q8 — Category Performance

Har product category ki total revenue, quantity sold aur distinct orders calculate karo.
*/
SELECT
	c.category_id,
	c.category_name,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
	SUM(oi.quantity) AS quantity_sold,
	COUNT(DISTINCT oi.order_id) AS total_orders
FROM production.categories c
INNER JOIN  production.products p
	ON c.category_id = p.category_id
INNER JOIN sales.order_items oi
	ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name

/*
Q9 — Staff Sales Report

Har staff member ke handled orders aur un orders ki total revenue show karo. Staff ka naam aur store bhi include karo.
*/
SELECT
	st.staff_id,
	st.first_name + ' ' + st.last_name AS staff_name,
	-- store_name here,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.staffs st
INNER JOIN sales.orders o
	ON st.staff_id = o.staff_id
INNER JOIN sales.order_items oi
	ON o.order_id = oi.order_id
GROUP BY st.staff_id, st.first_name + ' ' + st.last_name

/*
Q10 — Average Order Value

Finance team ko overall average order value chahiye. Har order ki net revenue calculate karke phir average nikalo.
*/
SELECT
	SUM(quantity * list_price * (1 - discount)) /
	COUNT(DISTINCT order_id)AS AOV
FROM sales.order_items  