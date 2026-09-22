/* ============================================================
   01 - DATA EXPLORATION
   Purpose: High level exploration of ClassicModels database 
            to understand baseline records, orders, and customer scale.
   ============================================================ */

-- Customer Base
-- Total count of registered customers in the system
SELECT COUNT(customerNumber) AS totalCustomers FROM dbo.customers;

-- Orders Overview
-- Sample of top 5 recent orders to observe status and dates
SELECT TOP 5 
    orderNumber, 
    orderDate, 
    status, 
    customerNumber 
FROM dbo.orders 
ORDER BY orderDate DESC;

-- Product Catalog
-- 1. Total product count in inventory catalog
SELECT COUNT(productName) AS total_products 
FROM dbo.products;

-- 2. Distinct product categories offered
SELECT DISTINCT productLine 
FROM dbo.products;

-- Order Status Overview
-- Breakdown of total orders grouped by fulfillment status
SELECT 
    status, 
    COUNT(status) AS total_orders 
FROM dbo.orders 
GROUP BY status;