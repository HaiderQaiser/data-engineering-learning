/*========================================================================================================================
									LEVEL 2 — Intermediate Business Analysis
========================================================================================================================*/
/*========================================================================================================================
3. Finance & Sales Trends
========================================================================================================================*/

/*
Q11 — Monthly Revenue Report

Finance team ko har year aur month ka total net revenue, total orders aur average order value chahiye.
*/
WITH MonthlySummary AS(
	SELECT
		MONTH(o.order_date) AS month,
		YEAR(o.order_date) AS year,
		COUNT(DISTINCT oi.order_id) AS total_orders,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_net_revenue
	FROM sales.order_items oi
	INNER JOIN sales.orders o
		ON oi.order_id = o.order_id
	GROUP BY 
			MONTH(o.order_date),
			YEAR(o.order_date) 
			)
SELECT
	year,
	month,
	total_net_revenue,
	total_orders,
	total_net_revenue / total_orders AS avg_order_value
FROM MonthlySummary
ORDER BY year, month;

/*
Q12 — Year-over-Year Revenue Growth

Har saal ki revenue aur previous year ki revenue ke comparison mein absolute difference aur percentage growth calculate karo.
*/
WITH RevPerYear AS(
	SELECT
		YEAR(o.order_date) AS year,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS current_year_revenue
	FROM sales.order_items oi
	INNER JOIN sales.orders o
		ON oi.order_id = o.order_id
	GROUP BY YEAR(o.order_date)
),
PrevYearRev AS(
SELECT
	year,
	current_year_revenue,
	LAG(current_year_revenue, 1) OVER(ORDER BY year ) AS prev_year_rev
FROM RevPerYear
)
SELECT
	year,
	current_year_revenue,
	prev_year_rev,
	current_year_revenue - prev_year_rev AS difference,
	(((current_year_revenue - prev_year_rev) /
	NULLIF(prev_year_rev, 0) ) * 100) AS percentage_growth -- can also be replace by CASE WHEN
FROM PrevYearRev;

/*
Q13 — Year-to-Date Revenue

Har year ke har month ki monthly revenue aur January se us month tak cumulative revenue calculate karo.
*/
WITH MonthlyRevCalc AS (
	SELECT
		YEAR(o.order_date) AS year,
		MONTH(o.order_date) AS month,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS monthly_revenue
	FROM sales.order_items oi
	INNER JOIN sales.orders o
		ON oi.order_id = o.order_id
	GROUP BY YEAR(o.order_date), MONTH(o.order_date)
)
SELECT
	year,
	month,
	monthly_revenue,
	SUM(monthly_revenue) OVER(
	PARTITION BY year
	ORDER BY month) AS cumulative_rev -- OR running_total
FROM MonthlyRevCalc;

/*
Q14 — Month-over-Month Growth

Har month ki revenue ko previous month ki revenue se compare karke revenue difference aur percentage growth/drop show karo.
*/
WITH MonthlyRev AS(
	SELECT
		YEAR(o.order_date) AS year,
		MONTH(o.order_date) AS month,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS current_month_revenue
	FROM sales.order_items oi
	INNER JOIN sales.orders o
		ON oi.order_id = o.order_id
	GROUP BY YEAR(o.order_date), MONTH(o.order_date) 
),
PrevMonthlyRev AS(
SELECT
	year,
	month,
	current_month_revenue,
	LAG(current_month_revenue,1) OVER(
	ORDER BY year, month) AS prev_month_revenue
FROM MonthlyRev
)
SELECT
	year,
	month,
	current_month_revenue,
	prev_month_revenue,
	-- difference
	current_month_revenue - prev_month_revenue AS difference,
	-- percentage growth/ drop
	CASE	
		WHEN prev_month_revenue = 0 OR prev_month_revenue IS NULL THEN NULL
		ELSE CONCAT(
					CAST(
						((current_month_revenue - prev_month_revenue) / prev_month_revenue) * 100 
						AS DECIMAL(10,2)
						)
						
			, '%')
	END AS percentage_growth_OR_drop
FROM PrevMonthlyRev
ORDER BY year, month;

/* 
Q15 — Quarterly Revenue

Har year ke Q1, Q2, Q3 aur Q4 ki revenue calculate karo aur quarter-wise performance compare karo.
*/
WITH QuarterlySummary AS(
	SELECT
		YEAR(o.order_date) AS year_no,
		DATEPART(QUARTER, o.order_date) AS quarter_no,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS current_quarter_revenue
	FROM sales.order_items oi
	INNER JOIN sales.orders o
		ON oi.order_id = o.order_id 
	GROUP BY YEAR(o.order_date), DATEPART(QUARTER, o.order_date)
),
PreppedData  AS ( -- naam dene mn bura hun mn😭
	SELECT
		year_no,
		quarter_no,
		current_quarter_revenue,
		LAG(current_quarter_revenue,1) OVER(ORDER BY year_no, quarter_no) AS prev_quarter_revenue
	FROM QuarterlySummary
)
SELECT
	year_no,
	quarter_no,
	current_quarter_revenue,
	prev_quarter_revenue,
	current_quarter_revenue - prev_quarter_revenue AS difference,
	CASE 
		WHEN prev_quarter_revenue = 0 OR prev_quarter_revenue IS NULL THEN NULL -- APNE PURE DIMAAGH KA USE KRTE HUE FIRST VALUE MN SIRF % KA SIGN ARHA THA USE BHI HATA DIA😝
		ELSE CONCAT(CAST(((current_quarter_revenue - prev_quarter_revenue) / NULLIF(prev_quarter_revenue, 0)) * 100 AS DECIMAL(10,2)), '%')
	END AS percentage_growth
FROM PreppedData
ORDER BY year_no, quarter_no;

/*========================================================================================================================
4. Customer & Product Intelligence
========================================================================================================================*/
/*
Q16 — Repeat Customers

Aise customers identify karo jinhon ne ek se zyada distinct orders place kiye hain. Unke orders aur total spending show karo.
*/
SELECT
	c.customer_id,
	c.first_name + ' ' + c.last_name AS customer_name,
	COUNT(DISTINCT o.order_id) AS order_count,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spending
FROM sales.customers c
INNER JOIN sales.orders o
	ON c.customer_id = o.customer_id
INNER JOIN sales.order_items oi
	ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name + ' ' + c.last_name
HAVING COUNT(DISTINCT o.order_id) > 1;

/*
Q17 — Customer First and Latest Order

Har customer ka first order date, latest order date aur total number of orders calculate karo.
*/
SELECT
	c.customer_id,
	c.first_name + ' ' + c.last_name AS customer_name,
	MIN(o.order_date) AS first_order,
	MAX(o.order_date) AS latest_order,
	COUNT(DISTINCT o.order_id) AS total_orders
FROM sales.customers c
INNER JOIN sales.orders o
	ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name

/*
Q18 — Top Product per Category

Har category ke andar revenue generate karne wale top 3 products identify karo. Ties ko bhi consider karo.
*/
WITH CatwiseProdRevenue AS(
	SELECT 
		c.category_id,
		c.category_name,
		p.product_id,
		p.product_name,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
	FROM production.categories c
	INNER JOIn production.products p
		ON c.category_id = p.category_id
	INNER JOIN sales.order_items oi
		ON p.product_id = oi.product_id
	GROUP BY c.category_id, category_name, p.product_id, p.product_name
),
RankingProducts AS(
	SELECT
		category_id,
		category_name,
		product_id,
		product_name,
		total_revenue,
		DENSE_RANK() OVER(PARTITION BY category_id ORDER BY total_revenue DESC) AS rank_no
	FROM CatwiseProdRevenue
)
SELECT
	category_id,
	category_name,
	product_id,
	product_name,
	total_revenue,
	rank_no
FROM RankingProducts
WHERE rank_no <= 3;

/*
Q19 — Store-wise Category Contribution

Har store mein har category ki revenue calculate karo, aur us category ki store ki total revenue mein percentage contribution nikalo.
*/
--- try
WITH OverAllStoreRev AS( -- I COULD ALSO USED WINDOW FUNC (PARTITION BY st.store_id) and BOOM! WITHOUT THIS CTE
SELECT
	st.store_id,
	st.store_name,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS overall_store_revenue
FROM sales.stores st
INNER JOIN sales.orders o
	ON st.store_id = o.store_id
INNER JOIN sales.order_items oi
	ON o.order_id = oi.order_id
GROUP BY st.store_id, st.store_name
),
StoreCatRev AS(
	SELECT
		st.store_id,
		st.store_name,
		c.category_id,
		c.category_name,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
	FROM production.categories c
	INNER JOIN production.products p
		ON c.category_id = p.category_id
	INNER JOIN sales.order_items oi
		ON p.product_id = oi.product_id
	INNER JOIN sales.orders o
		ON oi.order_id = o.order_id
	INNER JOIN sales.stores st
		ON o.store_id = st.store_id
	GROUP BY st.store_id, st.store_name, c.category_id, c.category_name
)
SELECT
	scr.store_id,
	scr.store_name,
	scr.category_id,
	scr.category_name,
	scr.total_revenue,
	CONCAT(CAST((scr.total_revenue / osr.overall_store_revenue) * 100 AS DECIMAL(10,2)), '%') AS percentage_contribution
FROM StoreCatRev scr
INNER JOIN OverAllStoreRev osr
	ON scr.store_id = osr.store_id;

/*
Q20 — Discount Analysis

Finance team ko discount bands (0%, 0–10%, 10–20%, 20%+) ke hisaab se order-item count, revenue before discount aur revenue after discount chahiye.
*/
WITH DiscountBanding AS(
	SELECT
		order_id,
		item_id,
		quantity,
		list_price,
		discount,
		CASE
			WHEN discount * 100 = 0 THEN '0%'
			WHEN discount * 100 > 0 AND discount * 100 <= 5 THEN '0-5%'
			WHEN discount * 100 > 5 AND discount * 100 <= 10 THEN '5-10%'
			WHEN discount* 100 > 10 AND discount * 100 <= 15 THEN '10-15%'
			WHEN discount* 100 > 15 AND discount * 100 <= 20 THEN '15-20%'
			ELSE '20%'
		END AS discount_band
	FROM sales.order_items
)
SELECT
	COUNT(item_id) AS items_count,
	SUM(quantity * list_price) AS revenue_before_discount,
	SUM(quantity * list_price * (1 - discount)) AS revenue_after_discount,
	discount_band
FROM DiscountBanding
GROUP BY discount_band
ORDER BY 
		CASE discount_band
			WHEN '0%' THEN 1
			WHEN '0-5%' THEN 2
			WHEN '5-10%' THEN 3
			WHEN '10-15%' THEN 4
			WHEN '15-20%' THEN 5
		END;