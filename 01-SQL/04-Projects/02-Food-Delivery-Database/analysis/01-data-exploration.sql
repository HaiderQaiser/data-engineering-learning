-- =============================================
-- Project: Food Delivery Database
-- File: analysis/01-data-exploration.sql
-- Area: Data Exploration and Quality Assessment
-- Database: Microsoft SQL Server
-- =============================================

USE food_delivery_db;
GO

-- ---------------------------------------------
-- SECTION 1: OVERALL PLATFORM SCALE
-- Business Question: Overall Platform Scale
-- ---------------------------------------------
SELECT 
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM restaurants) AS total_restaurants,
    (SELECT COUNT(*) FROM branches) AS total_branches,
    (SELECT COUNT(*) FROM menu_items) AS total_menu_items,
    (SELECT COUNT(*) FROM orders) AS total_orders;

-- ---------------------------------------------
-- SECTION 2: ORDER STATUS DISTRIBUTION
-- Business Question: Order Status Distribution
-- ---------------------------------------------
SELECT 
    order_status,
    COUNT(order_status) AS total_orders,
    CONCAT(
        CAST(COUNT(order_status) * 100.0 / SUM(COUNT(order_status)) OVER () AS DECIMAL(5,2)), 
        '%'
    ) AS percentage_share
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- ---------------------------------------------
-- SECTION 3: ORDER DATE COVERAGE
-- Business Question: Order Date Coverage and Time Span
-- ---------------------------------------------
SELECT
    MIN(order_date) AS earliest_order_date,
    MAX(order_date) AS latest_order_date,
    DATEDIFF(DAY, MIN(order_date), MAX(order_date)) AS total_days_span
FROM orders;

