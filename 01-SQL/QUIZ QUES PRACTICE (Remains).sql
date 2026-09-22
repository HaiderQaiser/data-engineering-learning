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




