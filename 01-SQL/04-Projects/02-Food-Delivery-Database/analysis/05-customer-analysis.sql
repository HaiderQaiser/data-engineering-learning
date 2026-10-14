-- ---------------------------------------------
-- SECTION 1: TOP 5 SPENDING CUSTOMERS
-- Business Question: Top 5 Highest-Spending Customers and Completed Order Counts
-- ---------------------------------------------
SELECT TOP 5
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    SUM((oi.quantity * oi.price) - oi.discount) AS total_spending,
    COUNT(DISTINCT o.order_id) AS completed_orders_placed
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE 
    o.order_status = 'Delivered'
GROUP BY 
    c.customer_id, 
    c.first_name, 
    c.last_name
ORDER BY 
    total_spending DESC;

-- ---------------------------------------------
-- SECTION 2: REPEAT CUSTOMER ANALYSIS & RETENTION RATE
-- Business Question: Total Unique Customers, Repeat Customers (Orders > 1), and Repeat Customer Rate (%)
-- ---------------------------------------------
WITH CustomerOrders AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Delivered'
    GROUP BY c.customer_id
)
SELECT
    COUNT(customer_id) AS total_unique_customers,
    COUNT(CASE WHEN total_orders > 1 THEN customer_id END) AS total_repeat_customers,
    CAST(
        COUNT(CASE WHEN total_orders > 1 THEN customer_id END) * 100.0 / 
        NULLIF(COUNT(customer_id), 0)
        AS DECIMAL(5,2)
    ) AS repeat_customer_rate_percentage
FROM CustomerOrders;