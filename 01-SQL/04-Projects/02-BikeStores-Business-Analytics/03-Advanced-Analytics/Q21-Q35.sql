/*========================================================================================================================
									LEVEL 3 — Advanced SQL & Complex Analytics
========================================================================================================================*/
/*========================================================================================================================
5. Advanced Sales Analytics
========================================================================================================================*/
/*
Q21 — Running Revenue by Store

Har store ke orders ko date-wise arrange karke running cumulative revenue calculate karo. Har store ka running total alag reset ho.
*/
WITH RevenueSummary AS(
	SELECT
		YEAR(o.order_date) AS year,
		MONTH(o.order_date) AS month,
		st.store_id,
		st.store_name,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total--OVER(
		--	PARTITION BY st.store_id, st.store_name 
		--	ORDER BY YEAR(o.order_date), MONTH(o.order_date)) AS running_total
	FROM sales.stores st
	INNER JOIN sales.orders o
		ON st.store_id = o.store_id
	INNER JOIN sales.order_items oi
		ON o.order_id = oi.order_id
	GROUP BY YEAR(o.order_date), MONTH(o.order_date),
	st.store_id, st.store_name
)
SELECT
	year,
	month,
	store_id,
	store_name,
	total,
	SUM(total) OVER(
		PARTITION BY store_id, store_name
		ORDER BY year, month)
		AS running_total
FROM RevenueSummary;
/*
Q22 — Three-Month Moving Average

Har month ki revenue aur current month samet previous 2 months ki moving average revenue calculate karo.
*/
WITH RevenueSummary AS(
	SELECT
		YEAR(o.order_date) AS year,
		MONTH(o.order_date) AS month,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
	FROM sales.orders o
	JOIN sales.order_items oi
		ON o.order_id = oi.order_id
	GROUP BY YEAR(o.order_date), MONTH(o.order_date)
	--ORDER BY year, month
)
SELECT
	year,
	month,
	total_revenue,
	AVG(total_revenue) OVER(
		ORDER BY year, month
		ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM RevenueSummary;
/*
Q23 — Best Month for Every Year

Har year ka highest revenue wala month identify karo. Agar multiple months ki revenue equal ho toh sab return karo.
*/
WITH RevenueSummary AS(
	SELECT
		YEAR(o.order_date) AS year,
		MONTH(o.order_date) AS month,
		DATENAME(MONTH, o.order_date) AS month_name,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
	FROM sales.orders o
	JOIN sales.order_items oi
		ON o.order_id = oi.order_id
	GROUP BY YEAR(o.order_date), MONTH(o.order_date), DATENAME(MONTH, o.order_date)
),
Ranking AS(
	SELECT
		year,
		month,
		month_name,
		total_revenue,
		DENSE_RANK() OVER(
			PARTITION BY year -- mere khyal se yahan masla horha hai 
			ORDER BY total_revenue DESC) AS rank_no
	FROM RevenueSummary
)
SELECT
	year,
	month,
	month_name,
	total_revenue,
	rank_no
FROM Ranking
WHERE rank_no = 1;

/*
Q24 — Revenue Contribution Ranking

Har store ki yearly revenue aur us year ki company-wide revenue mein percentage contribution calculate karo. Stores ko yearly revenue ke basis par rank karo.
*/
WITH YearlyRevenue AS(
	SELECT
		YEAR(o.order_date) AS year,
		st.store_id,
		st.store_name,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS yearly_revenue
		--SUM(oi.quantity * oi.list_price * (1 - oi.discount)) OVER() AS company_wide_revenue
	FROM sales.stores st
	INNER JOIN sales.orders o
		ON st.store_id = o.store_id
	INNER JOIN sales.order_items oi
		ON o.order_id = oi.order_id
	GROUP BY YEAR(o.order_date), st.store_id, st.store_name
),
CTE2 AS( -- NAMING MN BURA HUN MN
	SELECT
		year,
		store_id,
		store_name,
		yearly_revenue,
		SUM(yearly_revenue) OVER(PARTITION BY year) AS company_wide_revenue
	FROM YearlyRevenue
)
SELECT
	year,
	store_id,
	store_name,
	yearly_revenue,
	company_wide_revenue,
	(yearly_revenue / SUM(yearly_revenue) OVER(PARTITION BY year) * 100) AS percentage_contribution,
	DENSE_RANK() OVER(
		PARTITION BY year
		ORDER BY yearly_revenue DESC) AS store_rank
FROM CTE2;

/*
Q25 — Revenue Above Monthly Average

Har month ki revenue calculate karke sirf woh months show karo jinki revenue usi year ke average monthly revenue se zyada hai.
*/
WITH RevenueSummary AS(
	SELECT
		YEAR(o.order_date) AS year,
		MONTH(o.order_date) AS month,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS monthly_revenue,
		AVG(SUM(oi.quantity * oi.list_price * (1 - oi.discount))) OVER(
			PARTITION BY YEAR(o.order_date)
			)AS avg_monthly_revenue
	FROM sales.orders o
	INNER JOIN sales.order_items oi
		ON o.order_id = oi.order_id
	GROUP BY YEAR(o.order_date) ,MONTH(o.order_date)
)
SELECT
	year,
	month,
	monthly_revenue,
	avg_monthly_revenue,
	CONCAT(
		CAST(
			((monthly_revenue - avg_monthly_revenue) / avg_monthly_revenue * 100)
			AS DECIMAL(10,2)), '%') AS pct_above_avg
FROM RevenueSummary
WHERE monthly_revenue > avg_monthly_revenue
ORDER BY year, month;

/*========================================================================================================================
6. Customer Segmentation & Retention
========================================================================================================================*/
/*
Q26 — Customer Revenue Ranking

Har customer ki total spending calculate karke unhe overall aur store-wise rank karo.
*/
SELECT
	st.store_id,
	st.store_name,
	c.customer_id,
	c.first_name + ' ' + c.last_name AS customer_name,
	SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spending,
	DENSE_RANK() OVER(
		ORDER BY SUM(oi.quantity * oi.list_price * (1 - oi.discount)) DESC)
		AS customer_rank,
	DENSE_RANK() OVER(
		PARTITION BY st.store_id
		ORDER BY SUM(oi.quantity * oi.list_price * (1 - oi.discount)) DESC)
		AS store_wise_rank
FROM sales.customers c
JOIN sales.orders o
	ON c.customer_id = o.customer_id
JOIN sales.stores st
	ON o.store_id = st.store_id
JOIN sales.order_items oi
	ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name, st.store_id,st.store_name
ORDER BY st.store_name, store_wise_rank;
/*
Q27 — Customer Spending Segments

Customers ko total spending ke basis par Low, Medium aur High spending segments mein classify karo. Segment-wise customer count aur revenue show karo.
*/
WITH CustomerSpending AS(
	SELECT
		c.customer_id,
		c.first_name,
		c.last_name,
		SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spending,
		NTILE(3) OVER(
			ORDER BY SUM(oi.quantity * oi.list_price * (1 - oi.discount)) DESC) AS segment
	FROM sales.customers c
	JOIN sales.orders o
		ON c.customer_id = o.customer_id
	JOIN sales.order_items oi
		ON o.order_id = oi.order_id
	GROUP BY c.customer_id, c.first_name, c.last_name
),
Segmentation AS(
	SELECT
		customer_id,
		total_spending,
		CASE
			WHEN segment = 1 THEN 'High'
			WHEN segment = 2 THEN 'Medium'
			WHEN segment = 3 THEN 'Low'
		END AS segments
	FROM CustomerSpending
)
SELECT
	
	COUNT(*) AS total_customers,
	SUM(total_spending) AS revenue,
	segments
FROM Segmentation
GROUP BY segments
ORDER BY revenue;
/*
Q28 — Monthly Active Customers

Har month mein distinct customers ki count nikalo. Saath hi previous month ke comparison mein active customers ka change calculate karo.
*/
WITH MonthlyCustomers AS(
	SELECT
		YEAR(order_date) AS year,
		MONTH(order_date) AS month,
		COUNT(DISTINCT customer_id) AS current_month_customers
	FROM sales.orders
	GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT
	year,
	month,
	current_month_customers,
	LAG(current_month_customers,1 ) OVER(
		PARTITION BY year
		ORDER BY month) AS previous_month_customers,
	current_month_customers - LAG(current_month_customers,1 ) OVER(
		PARTITION BY year
		ORDER BY month) AS difference
FROM MonthlyCustomers;
/*
Q29 — Customer Purchase Gap

Har customer ke consecutive orders ke darmiyan days ka gap calculate karo. Longest aur average purchase gap identify karo.
*/

