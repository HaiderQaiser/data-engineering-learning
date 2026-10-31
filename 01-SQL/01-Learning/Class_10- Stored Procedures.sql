-- STORED PROCEDURES -- PATH: Databases > BikeStores > Programmibility > Stored Procedures
-- CREATING STORED PROCEDURE
CREATE PROCEDURE procedure_name 
AS
BEGIN 
	-- FIRST SQL STATEMENT
	SELECT
		product_id,
		list_price
	FROM production.products;
	-- SECOND SQL STATEMENT 
	SELECT 
		product_id,
		quantity
	FROM production.stocks;
	-- AND SO ON
END;

-- TO EXECUTE (can be used multiple times)
EXEC procedure_name;

-- TO UPDATE AN STORED PROCEDURE
ALTER PROCEDURE procedure_name2 
AS
BEGIN 
	-- FIRST SQL STATEMENT
	SELECT
		product_id,
		list_price
	FROM production.products;
	-- SECOND SQL STATEMENT 
	SELECT 
		product_id,
		quantity
	FROM production.stocks;
	-- AND SO ON
END; -- !WRONG HAI YE! 
-- YOU CAN ONLY USE ALTER AGTER ONCE CREATING PROCEDURE

-- INPUT PARAMETERS
CREATE PROCEDURE production.uspFindProducts
    @min_price DECIMAL(10, 2), -- known as parameters
    @max_price DECIMAL(10, 2)
AS
BEGIN
    SELECT
        product_name,
        list_price
    FROM production.products
    WHERE list_price BETWEEN @min_price AND @max_price
    ORDER BY list_price;
END;
-- EXECUTING 
-- Positional arguments
EXEC production.uspFindProducts 100, 500;-- (100, 500 are positional arguments)
-- named arguments
EXEC production.uspFindProducts @min_price = 100, @max_price = 500;

/* we can also set a default value of our parameters
	example: 
			@min_price DECIMAL(10, 2)
*/

-- Practice Ques
CREATE PROCEDURE procedure_01
	@state_value VARCHAR(25)
AS
BEGIN
	SELECT 
		*
	FROM sales.stores
	WHERE state = @state_value
END;

EXEC procedure_01 'NY'; -- positional argument
EXEC procedure_01 @state_value = 'CA'; -- named argument
EXEC procedure_01 'TX';
/*========================================================================================================================
			 VARIABLES 
			 (scope specific hota hai)
========================================================================================================================*/

CREATE PROCEDURE production.uspGetProductList
    @model_year SMALLINT
AS
BEGIN
    DECLARE @product_list VARCHAR(MAX); -- sirf define hua hai (empty box hai)
    SET @product_list = ''; -- ab isme value put ki hai

    SELECT
        @product_list = @product_list + product_name + CHAR(10)
    FROM production.products
    WHERE model_year = @model_year
    ORDER BY product_name;

    PRINT 'product list' + @product_list;
END;
-- EXECUTING 
EXEC production.uspGetProductList @model_year = 2018;

-- OUTPUT PARAMETERS
CREATE PROCEDURE production.uspFindProductsCount
    @min_price    DECIMAL(10, 2) = 0,
    @max_price    DECIMAL(10, 2) = 999999,
    @product_count INT OUTPUT
AS
BEGIN
    SELECT
        product_name,
        list_price
    FROM production.products
    WHERE list_price BETWEEN @min_price AND @max_price
    ORDER BY list_price;

    SELECT @product_count = @@ROWCOUNT; -- @@ROWCOUNT is a default func, (similar to row_number())
	-- OR we can also use
	-- SET @product_count = @@ROWCOUNT;
END;

DECLARE @count INT;

EXEC production.uspFindProductsCount
    @min_price    = 100,
    @max_price    = 500,
    @product_count = @count OUTPUT; -- just like return in python

SELECT @count AS products_found;

/*========================================================================================================================
							ERROR HANDLING
========================================================================================================================*/
CREATE PROCEDURE proced_error
AS 
BEGIN
	BEGIN TRY
		-- SQL STATEMENTS
	END TRY

	BEGIN CATCH
		-- ERROR HANDLING HERE
	END CATCH

