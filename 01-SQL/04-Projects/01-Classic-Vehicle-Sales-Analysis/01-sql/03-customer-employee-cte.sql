/* ============================================================
   03 - CUSTOMER & EMPLOYEE ANALYTICS
   Purpose: Analyzing relationship mappings between customers 
            and sales representatives, and evaluating top customer 
            revenue contributions using CTEs and Joins.
   ============================================================ */

-- Sales Representatives & Assigned Customers
-- List of employees and their mapped customers (including employees without customers)
SELECT
    e.employeeNumber,
    CONCAT(e.firstName, ' ', e.lastName) AS sales_rep_name,
    c.customerName
FROM dbo.employees e
LEFT JOIN dbo.customers c
    ON e.employeeNumber = c.salesRepEmployeeNumber;


-- Top Revenue Contributing Customers (CTE Approach)
-- Identifying the top 3 customers generating the highest cumulative payment revenue
WITH CustomerPayments AS (
    SELECT
        c.customerNumber,
        c.customerName,
        SUM(p.amount) AS total_revenue
    FROM dbo.customers c
    INNER JOIN dbo.payments p
        ON c.customerNumber = p.customerNumber
    GROUP BY c.customerNumber, c.customerName
)
SELECT TOP 3 
    customerNumber,
    customerName,
    total_revenue
FROM CustomerPayments
ORDER BY total_revenue DESC;

-- Highest Revenue Generating Sales Representatives
-- Identifying sales representatives generating the highest total payment revenue through assigned customers
WITH SalesRepRevenue AS (
    SELECT
        e.employeeNumber,
        CONCAT(e.firstName, ' ', e.lastName) AS employeeName,
        SUM(p.amount) AS total_revenue
    FROM dbo.employees e
    INNER JOIN dbo.customers c
        ON e.employeeNumber = c.salesRepEmployeeNumber
    INNER JOIN dbo.payments p
        ON c.customerNumber = p.customerNumber
    GROUP BY e.employeeNumber, CONCAT(e.firstName, ' ', e.lastName)
)
SELECT 
    employeeNumber,
    employeeName,
    total_revenue
FROM SalesRepRevenue
ORDER BY total_revenue DESC;

-- Top Customer Ranking per Sales Representative
-- Single highest spending customer per sales representative using Window Functions and CTEs
WITH CustomerRanking AS (
    SELECT
        DENSE_RANK() OVER(
            PARTITION BY e.employeeNumber
            ORDER BY SUM(p.amount) DESC
        ) AS rank,
        e.employeeNumber,
        c.customerNumber,
        c.customerName,
        SUM(p.amount) AS total_spent
    FROM dbo.employees e
    INNER JOIN dbo.customers c
        ON e.employeeNumber = c.salesRepEmployeeNumber
    INNER JOIN dbo.payments p
        ON c.customerNumber = p.customerNumber
    GROUP BY c.customerNumber, c.customerName, e.employeeNumber
)
SELECT
    rank,
    employeeNumber,
    customerNumber,
    customerName,
    total_spent
FROM CustomerRanking
WHERE rank = 1
ORDER BY total_spent DESC;