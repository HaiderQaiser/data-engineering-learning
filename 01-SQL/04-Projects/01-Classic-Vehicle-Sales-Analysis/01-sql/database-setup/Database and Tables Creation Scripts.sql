/* SSMS /SQL Server Compatible Script - ClassicModels */

-- Database create aur switch karna
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'classicmodels')
BEGIN
    CREATE DATABASE classicmodels;
END;
GO

USE classicmodels;
GO

-- Safe Drop existing tables (Foreign key dependencies ki wajah se sahi order me drop karna zaroori hai)
DROP TABLE IF EXISTS orderdetails;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS offices;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS productlines;
GO

-- 1. Create productlines
CREATE TABLE productlines (
    productLine VARCHAR(50) NOT NULL,
    textDescription VARCHAR(4000) DEFAULT NULL,
    htmlDescription VARCHAR(MAX) DEFAULT NULL,
    image VARBINARY(MAX) DEFAULT NULL,
    PRIMARY KEY (productLine)
);

-- 2. Create products
CREATE TABLE products (
    productCode VARCHAR(15) NOT NULL,
    productName VARCHAR(70) NOT NULL,
    productLine VARCHAR(50) NOT NULL,
    productScale VARCHAR(10) NOT NULL,
    productVendor VARCHAR(50) NOT NULL,
    productDescription VARCHAR(MAX) NOT NULL,
    quantityInStock SMALLINT NOT NULL,
    buyPrice DECIMAL(10,2) NOT NULL,
    MSRP DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (productCode),
    FOREIGN KEY (productLine) REFERENCES productlines (productLine)
);

-- 3. Create offices
CREATE TABLE offices (
    officeCode VARCHAR(10) NOT NULL,
    city VARCHAR(50) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    addressLine1 VARCHAR(50) NOT NULL,
    addressLine2 VARCHAR(50) DEFAULT NULL,
    state VARCHAR(50) DEFAULT NULL,
    country VARCHAR(50) NOT NULL,
    postalCode VARCHAR(15) NOT NULL,
    territory VARCHAR(10) NOT NULL,
    PRIMARY KEY (officeCode)
);

-- 4. Create employees
CREATE TABLE employees (
    employeeNumber INT NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    firstName VARCHAR(50) NOT NULL,
    extension VARCHAR(10) NOT NULL,
    email VARCHAR(100) NOT NULL,
    officeCode VARCHAR(10) NOT NULL,
    reportsTo INT DEFAULT NULL,
    jobTitle VARCHAR(50) NOT NULL,
    PRIMARY KEY (employeeNumber),
    FOREIGN KEY (reportsTo) REFERENCES employees (employeeNumber),
    FOREIGN KEY (officeCode) REFERENCES offices (officeCode)
);

-- 5. Create customers
CREATE TABLE customers (
    customerNumber INT NOT NULL,
    customerName VARCHAR(50) NOT NULL,
    contactLastName VARCHAR(50) NOT NULL,
    contactFirstName VARCHAR(50) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    addressLine1 VARCHAR(50) NOT NULL,
    addressLine2 VARCHAR(50) DEFAULT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) DEFAULT NULL,
    postalCode VARCHAR(15) DEFAULT NULL,
    country VARCHAR(50) NOT NULL,
    salesRepEmployeeNumber INT DEFAULT NULL,
    creditLimit DECIMAL(10,2) DEFAULT NULL,
    PRIMARY KEY (customerNumber),
    FOREIGN KEY (salesRepEmployeeNumber) REFERENCES employees (employeeNumber)
);

-- 6. Create payments
CREATE TABLE payments (
    customerNumber INT NOT NULL,
    checkNumber VARCHAR(50) NOT NULL,
    paymentDate DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (customerNumber, checkNumber),
    FOREIGN KEY (customerNumber) REFERENCES customers (customerNumber)
);

-- 7. Create orders
CREATE TABLE orders (
    orderNumber INT NOT NULL,
    orderDate DATE NOT NULL,
    requiredDate DATE NOT NULL,
    shippedDate DATE DEFAULT NULL,
    status VARCHAR(15) NOT NULL,
    comments VARCHAR(MAX) DEFAULT NULL,
    customerNumber INT NOT NULL,
    PRIMARY KEY (orderNumber),
    FOREIGN KEY (customerNumber) REFERENCES customers (customerNumber)
);

-- 8. Create orderdetails
CREATE TABLE orderdetails (
    orderNumber INT NOT NULL,
    productCode VARCHAR(15) NOT NULL,
    quantityOrdered INT NOT NULL,
    priceEach DECIMAL(10,2) NOT NULL,
    orderLineNumber SMALLINT NOT NULL,
    PRIMARY KEY (orderNumber, productCode),
    FOREIGN KEY (orderNumber) REFERENCES orders (orderNumber),
    FOREIGN KEY (productCode) REFERENCES products (productCode)
);
GO
