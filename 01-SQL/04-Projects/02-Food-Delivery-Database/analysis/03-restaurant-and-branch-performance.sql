-- =============================================
-- Project: Food Delivery Database
-- File: analysis/03-restaurant-and-branch-performance.sql
-- Area: Restaurant and Branch Performance Analysis
-- Database: Microsoft SQL Server
-- =============================================

USE food_delivery_db;
GO

-- ---------------------------------------------
-- SECTION 1: RESTAURANT & BRANCH REVENUE LEADERBOARD
-- Business Question: Restaurant and Branch Revenue, Completed Orders & AOV Ranking
-- ---------------------------------------------
SELECT
    r.restaurant_id,
    r.restaurant_name,
    b.branch_id,
    b.branch_name,
    SUM(CASE WHEN o.order_status = 'Delivered' THEN (oi.quantity * oi.price) - oi.discount ELSE 0 END) AS net_revenue,
    COUNT(DISTINCT CASE WHEN o.order_status = 'Delivered' THEN o.order_id END) AS completed_orders,
    CAST(
        SUM(CASE WHEN o.order_status = 'Delivered' THEN (oi.quantity * oi.price) - oi.discount ELSE 0 END) * 1.0 /
        NULLIF(COUNT(DISTINCT CASE WHEN o.order_status = 'Delivered' THEN o.order_id END), 0)
        AS DECIMAL(10,2)
    ) AS avg_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN branches b
    ON o.branch_id = b.branch_id
JOIN restaurants r
    ON b.restaurant_id = r.restaurant_id
GROUP BY 
    r.restaurant_id,
    r.restaurant_name,
    b.branch_id,
    b.branch_name
ORDER BY 
    net_revenue DESC;
-- ---------------------------------------------
-- SECTION 2: BRANCH CANCELLATIONS & PERFORMANCE IMPACT
-- Business Question: Branch Cancellation Volume, Cancellation Rate (%) and Revenue
-- ---------------------------------------------
SELECT 
    r.restaurant_id,
    r.restaurant_name,
    b.branch_id,
    b.branch_name,
    
    -- 1. Cancelled Orders Count
    COUNT(DISTINCT CASE WHEN o.order_status = 'Cancelled' THEN o.order_id END) AS cancelled_orders,
    
    -- 2. Cancellation Rate Percentage
    CONCAT(
        CAST(
            COUNT(DISTINCT CASE WHEN o.order_status = 'Cancelled' THEN o.order_id END) * 100.0 / 
            NULLIF(COUNT(DISTINCT o.order_id), 0)
            AS DECIMAL(5,2)
        ),
        '%'
    ) AS cancellation_rate,
    
    -- 3. Net Revenue with COALESCE (Default 0 if NULL)
    COALESCE(
        SUM(
            CASE 
                WHEN o.order_status = 'Delivered' THEN (oi.quantity * oi.price) - oi.discount 
                ELSE 0 
            END
        ), 
        0
    ) AS net_delivered_revenue

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN branches b
    ON o.branch_id = b.branch_id
JOIN restaurants r
    ON b.restaurant_id = r.restaurant_id
GROUP BY 
    r.restaurant_id,
    r.restaurant_name,
    b.branch_id,
    b.branch_name
ORDER BY 
    cancelled_orders DESC;