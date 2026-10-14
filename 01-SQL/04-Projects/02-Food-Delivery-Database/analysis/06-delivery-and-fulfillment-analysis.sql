-- =============================================
-- Project: Food Delivery Database
-- File: analysis/06-delivery-and-fulfillment-analysis.sql
-- Area: Delivery Operations and Fulfillment Analysis
-- Database: Microsoft SQL Server
-- =============================================

USE food_delivery_db;
GO

-- ---------------------------------------------
-- SECTION 1: TOP 3 FASTEST RIDERS
-- Business Question: Average delivery duration (pickup to delivery) and top 3 fastest riders
-- ---------------------------------------------
WITH DeliveryDuration AS (
    SELECT
        r.rider_id,
        r.first_name + ' ' + r.last_name AS rider_name,
        DATEDIFF(MINUTE, d.picked_up_at, d.delivered_at) AS delivery_duration
    FROM riders r
    JOIN deliveries d
        ON r.rider_id = d.rider_id
    WHERE 
        d.delivery_status = 'Delivered'
)
SELECT TOP 3
    rider_id,
    rider_name,
    CAST(AVG(delivery_duration * 1.0) AS DECIMAL(10,2)) AS avg_delivery_duration_minutes
FROM DeliveryDuration
GROUP BY 
    rider_id, 
    rider_name
ORDER BY 
    avg_delivery_duration_minutes ASC;
-- ---------------------------------------------
-- SECTION 2: LATE DELIVERY RATE ANALYSIS
-- Business Question: Total Late Delivered Orders and Platform Late Delivery Rate (%)
-- ---------------------------------------------
WITH LateDeliveredOrders AS (
    SELECT
        COUNT(DISTINCT CASE WHEN d.delivered_at > o.required_date THEN o.order_id END) AS total_late_delivered_orders,
        COUNT(DISTINCT CASE WHEN o.order_status = 'Delivered' THEN o.order_id END) AS total_orders
    FROM orders o
    JOIN deliveries d
        ON o.order_id = d.order_id
)
SELECT 
    total_late_delivered_orders,
    total_orders,
    CONCAT(
        CAST(
            (total_late_delivered_orders * 100.0 / NULLIF(total_orders, 0))
            AS DECIMAL(5,2)
        ),
        '%'
    ) AS overall_late_delivery_rate
FROM LateDeliveredOrders;