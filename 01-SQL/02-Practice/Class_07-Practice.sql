-- Using a CTE (WITH clause), write a query to find all employees whose salary is greater than 
-- the average salary of their department.
WITH avg_sal AS (
	SELECT dept, AVG(salary) AS avg_salary FROM dept GROUP BY dept
)
	SELECT 
		emp_id,
		emp_name,
		dept,
		salary,
		avg_salary
	FROM employee e
	INNER JOIN avg_sal a
	WHERE e.salary >  a.avg_salary ;
 
/* CTE ka use karke un products ki list nikalo jinki list_price unki apni category_id ki average price
se zyada ho. */ 
WITH avg_price AS (
SELECT category_id, AVG(list_price) AS cat_avg_price FROM production.products GROUP BY category_id)
SELECT 
	p.product_id,
	p.product_name,
	p.list_price,
	cat_avg_price
FROM production.products p
INNER JOIN avg_price a
	ON p.category_id = a.category_id
WHERE p.list_price > a.cat_avg_price;
/* CTE ka use karke un Stores ki list nikalo jinki Total Sales (Total Revenue) poori company ki 
Average Store Sales se ziada ho.*/
WITH store_sales AS (
	SELECT 
		store_id, 
		SUM(quantity * list_price * (1 - discount)) AS total_store_sales 
	FROM sales.stores st
	INNER JOIN sales.orders o
		ON st.store_id = o.store_id
	GROUP BY store_id 
)
SELECT 
	st.store_id,
	st.store_name,
	s.total_store_sales,
	AVG(total_store_sales) AS avg_store_sales
FROM sales.stores st
INNER JOIN store_sales s
	ON st.store_id = s.store_id
	WHERE  avg_store_sales > s.total_store_sales;
-----
WITH store_sales AS (
	SELECT
		o.store_id,
		--oi.order_id,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales
	FROM sales.order_items oi
	INNER JOIN sales.orders o
		ON oi.order_id = o.order_id
	GROUP BY o.store_id
)
average AS (
	SELECT 
		store_id,
		AVG(total_sales) AS avg_sales
		FROM store_sales )
SELECT 
	st.store_id,
    st.store_name,
    ss.total_sales,
    ca.avg_sales
FROM sales.stores st
INNER JOIN store_sales a
	ON st.store_id = a.store_id
WHERE st.total_sales > a.avg_sales;
		




select * from sales.stores