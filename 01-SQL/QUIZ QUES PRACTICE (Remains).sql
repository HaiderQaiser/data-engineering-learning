/* 
8. List the customers who have placed more orders than the average number of orders per customer. */
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders
FROM sales.customers c
JOIN sales.orders o 
    ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, 
    c.first_name, 
    c.last_name
HAVING COUNT(o.order_id) > (
    SELECT COUNT(order_id) * 1.0 / COUNT(DISTINCT customer_id) 
    FROM sales.orders
)
ORDER BY 
    total_orders DESC;

-- Using a CTE, calculate each customer's total spend, then return the top 10 customers
-- with their spend and rank. Add a second CTE that labels each customer as "High" 
-- (above the overall average spend) or "Regular".

-- each customer's total spend
WITH total_spent AS(
    SELECT 
        o.customer_id  AS customer_id,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent_per_customer
       -- DENSE_RANK() OVER(
          --  ORDER BY o.customer_id DESC) AS rank_no
    FROM sales.orders o
    INNER JOIN sales.order_items oi
        ON o.order_id = oi.order_id 
    GROUP BY o.customer_id
),
customer_tier AS (
    SELECT 
        customer_id,
        DENSE_RANK() OVER(
            ORDER BY total_spent_per_customer DESC) AS rank_no,
        CASE 
            WHEN total_spent_per_customer > (SELECT AVG(total_spent_per_customer) FROM total_spent) THEN 'High'
            ELSE 'Regular'
        END AS label
    FROM total_spent
)
SELECT 
    ts.customer_id,
    ts.total_spent_per_customer,
    ct.rank_no,
    ct.label
FROM total_spent ts
INNER JOIN customer_tier ct
    ON ts.customer_id = ct.customer_id
ORDER BY ct.rank_no 
OFFSET 0 ROWS
FETCH NEXT 10 ROWS ONLY;

/* 
Using CTEs, find the best-selling product (by quantity) in each category,
and show how much of that product's stock is currently available across all stores.
    Hint: Use ROW_NUMBER() or RANK() partitioned by category, then join to production.stocks  */
WITH RankingCategoriesbyQuantitySold AS(
    SELECT
        p.product_id,
        p.product_name,
        c.category_id,
        SUM(oi.quantity) quantity_sold,
         ROW_NUMBER() OVER(
            PARTITION BY c.category_id ORDER BY SUM(oi.quantity) DESC) AS rnk
    FROM production.categories c
    INNER JOIN production.products p
        ON c.category_id = p.category_id
    INNER JOIN sales.order_items oi
        ON p.product_id = oi.product_id
    GROUP BY c.category_id, p.product_id, p.product_name
)
SELECT 
    rcqs.product_id,
    rcqs.product_name,
    rcqs.category_id,
    rcqs.rnk,
    SUM(s.quantity) AS stock_available
FROM RankingCategoriesbyQuantitySold rcqs
INNER JOIN production.stocks s
    ON rcqs.product_id = s.product_id
WHERE rcqs.rnk = 1
GROUP BY rcqs.product_id, rcqs.product_name, rcqs.category_id, rcqs.rnk;

/*
Business Scenario:

Management yeh analyze karna chahti hai ke har saal (Year-wise) kitne naye customers bane 
(jinne apna pehla order diya) aur un First-time Orders ki total revenue kitni thi, vs. Repeat Orders 
(jo 2nd ya baad ke orders thay) ki total revenue kitni thi. */
/*
-- MENE QUERY KO PARTS MN DIVIDE KR DIA, THEN MN UN SAB PARTS KO COMBINE KR K OVERALL QUERY BANA LUNGA
-- 1: PEHLE TO YE DHUNDNA HOGA KI PEHLA ORDER WALE CUSTOMERS KONSE HAIN.
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ' ,c.last_name) AS customer_name,
    ROW_NUMBER() OVER(
        PARTITION BY c.customer_id ORDER BY DATENAME(DAY,o.order_date), YEAR(o.order_date)) AS rnk
FROM sales.customers c
INNER JOIN sales.orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, CONCAT(c.first_name, ' ' ,c.last_name) --😭😭😭 ye bhi nhi hopaya yar mujhse.

-- 2: phir mere hisab se sab customers k orders nikalengy 
-- 3: phir nikale hue orders mn se pehla order ko minus krengy to bad k customers mil jaengy.
-- bro sach bataon to mera dimagh itna capable hi nhi ki mushkil task kr ske🥲😔.mere bass ki nhi data engineering.
-- mujhe lagta hai ki mn sawal ko tecke hi ghlt trike se kr rha hu aur krta hun.
*/
WITH RankingOrders AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        ROW_NUMBER() OVER(
            PARTITION BY customer_id ORDER BY order_date) AS order_rnk
    FROM sales.orders
),
RetrievingFirstOrderRevenue AS (
    SELECT
        YEAR(ro.order_date) AS order_year, -- 1. Customer level ke bajaye Year level lagaya
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS first_order_revenue
    FROM RankingOrders ro
    INNER JOIN sales.order_items oi
        ON ro.order_id = oi.order_id
    WHERE ro.order_rnk = 1
    GROUP BY YEAR(ro.order_date) -- 1. Year se group kiya
),
RetrievingOtherOrdersRevenue AS (
    SELECT
        YEAR(ro.order_date) AS order_year, -- 1. Customer level ke bajaye Year level lagaya
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS other_orders_revenue
    FROM RankingOrders ro
    INNER JOIN sales.order_items oi
        ON ro.order_id = oi.order_id
    WHERE ro.order_rnk <> 1
    GROUP BY YEAR(ro.order_date) -- 1. Year se group kiya
)
SELECT 
    f.order_year,
    f.first_order_revenue,
    ISNULL(o.other_orders_revenue, 0) AS repeat_order_revenue -- Null handle karne ke liye
FROM RetrievingFirstOrderRevenue f
LEFT JOIN RetrievingOtherOrdersRevenue o -- 2. INNER JOIN ki jagah LEFT JOIN
    ON f.order_year = o.order_year;
-- BETTER AND EASIER WAY!
WITH RankingOrders AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        ROW_NUMBER() OVER(
            PARTITION BY customer_id ORDER BY order_date) AS order_rnk
    FROM sales.orders
)
SELECT 
    YEAR(ro.order_date) AS order_year,
    
    -- Agar rank 1 hai toh first_time_revenue waale dhabbe mein daalo
    SUM(CASE WHEN ro.order_rnk = 1 THEN oi.quantity * oi.list_price * (1 - oi.discount) ELSE 0 END) AS first_time_customer_revenue,
    
    -- Agar rank > 1 hai toh repeat_revenue waale dhabbe mein daalo
    SUM(CASE WHEN ro.order_rnk > 1 THEN oi.quantity * oi.list_price * (1 - oi.discount) ELSE 0 END) AS repeat_customer_revenue

FROM RankingOrders ro
INNER JOIN sales.order_items oi
    ON ro.order_id = oi.order_id
GROUP BY YEAR(ro.order_date)
ORDER BY order_year;