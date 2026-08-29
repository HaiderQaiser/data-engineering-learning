bikestores USE;

SELECT * FROM sales.customers;
SELECT * FROM sales.stores;
SELECT * FROM sales.order_items;

--select specific columns and all rows
SELECT customer_id,  First_name, email FROM sales.customers;

-- select specific columns (all mn included hongy)
SELECT email, * FROM sales.customers;

-- select top entries from the selected table
SELECT TOP 10 * FROM sales.customers;

-- specific selection
SELECT * FROM sales.customers WHERE state = 'TX';

-- OR CONDITION
SELECT * FROM sales.customers WHERE state = 'TX' or state = 'NY';

-- AND CONDITION
SELECT * FROM sales.customers WHERE first_name = 'jaquline' and state = 'NY'; 

-- select all columns and rows where phone no isnt provided
SELECT * FROM sales.customers WHERE phone IS NULL;

-- select all columns and rows where phone no is provided
SELECT * FROM sales.customers WHERE phone IS NOT NULL;

-- BETWEEN KEYWORD
SELECT * FROM sales.customers WHERE customer_id BETWEEN 10 AND 40;

-- ALIAS (temporary hoga)
SELECT
	first_name + ' ' + last_name AS full_name
FROM sales.customers;

--limiting rows
--using offset-fetch


