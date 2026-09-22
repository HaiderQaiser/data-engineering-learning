/* ============================================================
   02 - SALES ANALYTICS
   Purpose: Deep dive into revenue streams, order financial breakdown, 
            and product performance metrics.
   ============================================================ */

-- Total Revenue Calculation
-- Cumulative revenue generated across all line items in completed orders
SELECT 
    SUM(quantityOrdered * priceEach) AS total_revenue
FROM dbo.orderdetails;

-- Top Revenue Generating Products
-- Top 5 products that generated the highest cumulative revenue for the business.
SELECT
    productCode,
    SUM(quantityOrdered * priceEach) AS total_revenue
    FROM dbo.orderdetails
    GROUP BY productCode
    ORDER BY total_revenue DESC
    OFFSET 0 ROWS
    FETCH NEXT 5 ROWS ONLY;

-- Average Order Value (AOV)
-- Calculating average revenue generated per unique customer order
WITH OrderTotals AS (
    SELECT 
        orderNumber,
        SUM(quantityOrdered * priceEach) AS totalOrderValue
    FROM dbo.orderdetails 
    GROUP BY orderNumber
)
SELECT 
    AVG(totalOrderValue) AS average_order_value
FROM OrderTotals;

-- High-Volume vs Low-Volume Order Status Breakdown
-- Identifying order status categories containing more than 5 total orders
SELECT
    status,
    COUNT(orderNumber) AS order_volume
FROM dbo.orders 
GROUP BY status
HAVING COUNT(orderNumber) > 5;

-- Product Line Sales & Revenue Breakdown
-- Total quantity sold and total revenue generated for each product line
SELECT
    p.productLine,
    SUM(od.quantityOrdered) AS total_units_sold,
    SUM(od.quantityOrdered * od.priceEach) AS total_revenue
FROM dbo.products p
INNER JOIN dbo.orderdetails od
    ON p.productCode = od.productCode
GROUP BY p.productLine
ORDER BY total_revenue DESC;