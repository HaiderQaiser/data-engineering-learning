USE BikeStores;

--==============================================CLASS TEACHER's CODE===================================================
USE bikestores;

-- QUERYING
-----------

-- select all columsn and rows
SELECT * FROM sales.customers;

-- select specific columns and all rows
SELECT customer_id, first_name, last_name FROM sales.customers;

-- select specific column first and then all coumns and rows
SELECT phone, * FROM sales.customers;

-- QUERYING & FILTERING
-----------------------

-- select all columsn and rows where states is NY
SELECT * FROM sales.customers WHERE state = 'NY';

-- select all columsn and rows where states is NY or TX
SELECT * FROM sales.customers WHERE state = 'NY' or state = 'TX';

-- select all columsn and rows where states is NY and first_name is Garry
SELECT * FROM sales.customers WHERE first_name = 'Garry' and state = 'TX';

-- select all columsn and rows where states is NOT CA
SELECT * FROM sales.customers WHERE state != 'CA';

-- select all columsn and rows where phne number isnt been provided
SELECT * FROM sales.customers WHERE phone IS NULL;

-- select all columsn and rows where customer have provided phone number
SELECT * FROM sales.customers WHERE phone IS NOT NULL;

-- all customers  betwee id 5 to 56
SELECT * FROM sales.customers WHERE customer_id BETWEEN 5 AND 56;

-- OTHERS
---------

-- ALIAS
SELECT
	first_name + ' ' + last_name AS full_name
FROM sales.customers;

SELECT
	last_name AS full_name
FROM sales.customers;

-- LIMITING ROWS
SELECT top 15 * FROM sales.customers;

-- ORDER BY
SELECT *
FROM sales.customers
ORDER BY first_name;

SELECT *
FROM sales.customers
ORDER BY first_name DESC;

SELECT *
FROM sales.customers
ORDER BY state ASC, first_name DESC;

SELECT *
FROM sales.customers
ORDER BY first_name DESC, state ASC;

-- qasim --> CA
-- qasim --> NY

SELECT *
FROM sales.customers
ORDER BY state ASC, first_name DESC;

SELECT *
FROM sales.customers
ORDER BY first_name ASC, last_name DESC;

SELECT *
FROM sales.customers
ORDER BY 8, 2;

-- how to apply limitng on order by using ?
SELECT TOP 10 * FROM sales.customers
ORDER BY first_name;

-- ==============================================MY CODE===================================================

-- ORDER BY
SELECT * 
FROM sales.customers
ORDER BY first_name DESC;

-- ORDER BY MORE THAN ONE COLUMN
SELECT * 
FROM sales.customers
ORDER BY first_name ASC, state  DESC;

 -- ORDER BY ON BEHALF OF COLUMN NUMBER (using numeric numbers)
SELECT * 
FROM sales.customers
ORDER BY 8,2;


-- APPLY LIMIT
SELECT * 
FROM sales.customers
ORDER BY first_name
OFFSET 7 ROWS FETCH  NEXT 4 ROWS ONLY;

SELECT first_name, last_name, city
FROM sales.customers
ORDER BY city
OFFSET 10 ROWS
FETCH NEXT 5 ROWS ONLY;

-- ==============================================OPERATORS==============================================
-- COMPARISON OPERATORS
-- >, >=, <, <=, =, != (<>)

--LOGICAL OPERATORS
-- AND, OR, NOT

-- QUERY MULTIPLE VALUES 
	-- OPTION 1
SELECT * FROM sales.customers
WHERE state = 'NY' OR state = 'TX';
	-- OPTION 2
SELECT * FROM sales.customers
WHERE state IN ('NY', 'TX');

SELECT * FROM sales.customers
WHERE customer_id IN (
	SELECT customer_id FROM sales.orders
)ORDER BY customer_id;
