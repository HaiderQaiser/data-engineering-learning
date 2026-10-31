/*========================================================================================================================
Ek aisa simple Stored Procedure banao jiska naam sales.sp_GetCaliforniaCustomers ho.
========================================================================================================================*/
CREATE OR ALTER PROCEDURE sales.sp_GetCaliforniaCustomers
AS
BEGIN 
	SELECT
		first_name,
		last_name,
		city
	FROM sales.customers
	WHERE state = 'CA'
END;
-- execution
EXEC sales.sp_GetCaliforniaCustomers;
/*========================================================================================================================
Ek aisa Stored Procedure banao jiska naam sales.sp_GetCustomersByState ho. (Dynamically)
========================================================================================================================*/

CREATE OR ALTER PROCEDURE sales.sp_GetCustomersByState
	@statename VARCHAR(2) 
AS 
BEGIN
	SELECT
		first_name,
		last_name,
		city,
		state
	FROM sales.customers
	WHERE state = @statename
END;
-- execution
EXEC sales.sp_GetCustomersByState 'CA'; -- WE CAN PUT ANY STATE NAME HERE

-- Ek aisa Stored Procedure banao jiska naam sales.sp_GetTotalOrdersByCustomer ho.
CREATE OR ALTER PROCEDURE sales.sp_GetTotalOrdersByCustomer
	@Customer_id INT, -- input parameter
	@TotalOrders INT OUTPUT -- output parameter
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Orders_count INT -- declared our variable name

	SELECT
		@TotalOrders = COUNT(DISTINCT order_id)
	FROM sales.orders
	WHERE customer_id = @Customer_id
END;
-- variable
DECLARE @Result INT;
-- execution
EXEC sales.sp_GetTotalOrdersByCustomer 
	@Customer_id = 1,
	@TotalOrders = @Result OUTPUT;
-- Actually printing the result (value of our variable)
SELECT @Result AS TotalOrdersForCustomer;

/*========================================================================================================================
Ek Stored Procedure banao jiska naam sales.sp_CheckCustomerCategory ho. (using if...else, input/ output parameters
========================================================================================================================*/
CREATE OR ALTER PROCEDURE sales.sp_CheckCustomerCategory 
	-- Input Parameter
	@CustomerId SMALLINT,
	@Category VARCHAR(20) OUTPUT	
AS
BEGIN
	SET NOCOUNT ON;

	-- creating variable
	DECLARE @TotalOrders INT;
	
	SELECT
		@TotalOrders = COUNT(DISTINCT order_id)
	FROM sales.orders
	WHERE customer_id = @CustomerId
	IF @TotalOrders >= 5
		BEGIN
			SET @Category =  'VIP Customer'
		END
	ELSE
		BEGIN
			SET @Category = 'Regular Customer'
		END	 
END;
-- Variable banaya
DECLARE @Result VARCHAR(20);
-- Execute kia
EXEC sales.sp_CheckCustomerCategory
	@CustomerId = 1,
	@Category = @Result OUTPUT;
-- Actually seeing the result
SELECT @Result AS Customer_Category;

/*========================================================================================================================

========================================================================================================================*/
-- kisi cust ki total spending calculate
CREATE OR ALTER PROCEDURE sales.sp_GetCustomerSpendingSummary
	@CustomerId SMALLINT,
	@TotalSpending DECIMAL(10,2) OUTPUT, -- agr FLOAT kr deta to?
	@TotalOrders INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	-- Query for TotalSpending
	SELECT
		@TotalSpending = ISNULL(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 0.0)
	FROM sales.orders o
	INNER JOIN sales.order_items oi
		ON o.order_id = oi.order_id
	WHERE o.customer_id = @CustomerId;

	-- Query for TotalOrders
	SELECT
		@TotalOrders = COUNT(*)
	FROM sales.orders
	WHERE customer_id = @CustomerId;
END;

-- creating variables to get the output
DECLARE 
	@TotalSpendingSummary DECIMAL(10,2), -- agr FLOAT kr deta to?
	@TotalOrdersSummary INT;
-- execution
EXEC sales.sp_GetCustomerSpendingSummary
	@CustomerId = 1,
	@TotalSpending = @TotalSpendingSummary OUTPUT,
	@TotalOrders = @TotalOrdersSummary OUTPUT;
-- seeing the result!
SELECT 
	@TotalSpendingSummary AS TotalSpending,
	@TotalOrdersSummary AS TotalOrders;
-- BRO WESE AB MUJHE DIFFICULTY NHI HORHI (MN STUCK NHI HORHA). AUR DATAENGINEER WALI FEEL ARHI HAI AJ. (Stored procedures waqai kamaal hain).

/*========================================================================================================================
			ERROR HANDLING
========================================================================================================================*/
-- Basic TRY...CATCH ka structure
BEGIN TRY
    -- Yahan hum deliberate error generate kar rahe hain (Math Error: 10 divide by 0)
    SELECT 10 / 0 AS Result;
END TRY
BEGIN CATCH
    -- Agar TRY block mein koi error aaya, toh control yahan aayega
    PRINT 'Oops! Zero se divide nahi kar sakte.';
END CATCH;

BEGIN TRY
	SELECT 10/0 AS RESULT
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS Error_no,
		ERROR_MESSAGE() AS Error_msg
		--ERROR_LINE() AS Error_line_no
END CATCH;