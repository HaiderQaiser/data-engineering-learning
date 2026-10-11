-- =============================================
-- Project: Food Delivery Database
-- File: analysis/02-order-and-revenue-analysis.sql
-- Area: Order and Revenue Analysis
-- Database: Microsoft SQL Server
-- =============================================

USE food_delivery_db;
GO

-- ---------------------------------------------
-- SECTION 1: PLATFORM REVENUE SUMMARY
-- Business Question: Platform Overall Revenue Breakdown (Delivered Orders Only)
-- ---------------------------------------------
SELECT
    SUM(oi.quantity * oi.price) AS gross_revenue,
    SUM(oi.discount) AS total_discount_given,
    SUM((oi.quantity * oi.price) - oi.discount) AS net_revenue
FROM order_items oi
JOIN orders o 
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered';

-- ---------------------------------------------
-- SECTION 2: AVERAGE ORDER VALUE (AOV)
-- Business Question: Average Order Value (Delivered Orders)
-- ---------------------------------------------
SELECT
    CAST(
        SUM((oi.quantity * oi.price) - oi.discount) * 1.0 / COUNT(DISTINCT o.order_id) 
        AS DECIMAL(10,2)
    ) AS avg_order_value
FROM order_items oi
INNER JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered';

-- ---------------------------------------------
-- SECTION 3: MONTHLY ORDER & REVENUE METRICS
-- Business Question: Monthly Order Volume, Delivery Rate, Cancellation Rate & Net Revenue
-- ---------------------------------------------
SELECT 
    YEAR(o.order_date) AS order_year,
    MONTH(o.order_date) AS order_month,
    
    -- 1. Total Placed Orders
    COUNT(DISTINCT o.order_id) AS total_orders,
    
    -- 2. Delivered Orders
    COUNT(DISTINCT CASE WHEN o.order_status = 'Delivered' THEN o.order_id END) AS delivered_orders,
    
    -- 3. Cancelled Orders
    COUNT(DISTINCT CASE WHEN o.order_status = 'Cancelled' THEN o.order_id END) AS cancelled_orders,
    
    -- 4. Cancellation Rate (%)
    CONCAT(
        CAST(
            COUNT(DISTINCT CASE WHEN o.order_status = 'Cancelled' THEN o.order_id END) * 100.0 / 
            NULLIF(COUNT(DISTINCT o.order_id), 0) 
            AS DECIMAL(5,2)
        ),
        '%'
    ) AS cancellation_rate,
    
    -- 5. Net Delivered Revenue
    SUM(
        CASE 
            WHEN o.order_status = 'Delivered' THEN (oi.quantity * oi.price) - oi.discount 
            ELSE 0 
        END
    ) AS net_delivered_revenue

FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY 
    YEAR(o.order_date), 
    MONTH(o.order_date)
ORDER BY 
    order_year ASC, 
    order_month ASC;