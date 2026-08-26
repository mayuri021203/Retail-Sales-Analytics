/*
=========================================================
RETAIL SALES ANALYTICS PROJECT
Complete SQL Server Portfolio Script
=========================================================

Workflow:
1. Create database
2. Create tables
3. Validate imported data
4. Basic data-quality checks
5. Business analysis
6. Customer analysis
7. Product/category analysis
8. Regional analysis
9. Monthly analysis
10. Inventory analysis

NOTE:
The data was cleaned in Python/Pandas before being imported into SQL Server.
The INSERT/BULK INSERT section is intentionally left as a template because
the local CSV folder path is different on every computer.
=========================================================
*/


/* =====================================================
   1. CREATE DATABASE
   ===================================================== */

IF DB_ID('RetailSalesAnalytics') IS NULL
BEGIN
    CREATE DATABASE RetailSalesAnalytics;
END;
GO

USE RetailSalesAnalytics;
GO


/* =====================================================
   2. CREATE TABLES
   ===================================================== */

/*
Customers table
*/
IF OBJECT_ID('dbo.Customers', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Customers
    (
        Customer_ID   VARCHAR(50)  NOT NULL PRIMARY KEY,
        Customer_Name VARCHAR(150),
        City          VARCHAR(100),
        Region        VARCHAR(100)
    );
END;
GO


/*
Products table
*/
IF OBJECT_ID('dbo.Products', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Products
    (
        Product_ID   VARCHAR(50)  NOT NULL PRIMARY KEY,
        Product_Name VARCHAR(150),
        Category     VARCHAR(100)
    );
END;
GO


/*
Sales table

Order_Date is the date column confirmed in the project.
*/
IF OBJECT_ID('dbo.Sales', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Sales
    (
        Order_ID    VARCHAR(50) NOT NULL,
        Order_Date  DATE,
        Customer_ID VARCHAR(50),
        Product_ID  VARCHAR(50),
        Quantity    INT,
        Sales       DECIMAL(18,2),
        Cost        DECIMAL(18,2),
        Profit      DECIMAL(18,2),
        Region      VARCHAR(100)
    );
END;
GO


/*
Inventory table
*/
IF OBJECT_ID('dbo.Inventory', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Inventory
    (
        Product_ID     VARCHAR(50),
        Region         VARCHAR(100),
        Stock_Quantity INT,
        Reorder_Level  INT
    );
END;
GO


/* =====================================================
   3. VERIFY TABLES
   ===================================================== */

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_NAME IN ('Customers','Products','Sales','Inventory')
ORDER BY TABLE_NAME;
GO


/* =====================================================
   4. CHECK TABLE COLUMNS
   ===================================================== */

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('Customers','Products','Sales','Inventory')
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO


/* =====================================================
   5. DATA IMPORT TEMPLATE
   ===================================================== */

/*
Use SSMS Import Flat File / Import Data Wizard to load the
cleaned CSV files.

If you use BULK INSERT, replace the file paths with your
own local paths.

Example:

BULK INSERT dbo.Customers
FROM 'C:\YourPath\cleaned_customers.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

Repeat for Products, Sales and Inventory.

Do NOT paste your personal/local file paths into GitHub.
*/


/* =====================================================
   6. BASIC ROW COUNT VALIDATION
   ===================================================== */

SELECT 'Customers' AS Table_Name, COUNT(*) AS Row_Count
FROM dbo.Customers

UNION ALL

SELECT 'Products', COUNT(*)
FROM dbo.Products

UNION ALL

SELECT 'Sales', COUNT(*)
FROM dbo.Sales

UNION ALL

SELECT 'Inventory', COUNT(*)
FROM dbo.Inventory;
GO


/* =====================================================
   7. PREVIEW DATA
   ===================================================== */

SELECT TOP 10 *
FROM dbo.Customers;

SELECT TOP 10 *
FROM dbo.Products;

SELECT TOP 10 *
FROM dbo.Sales;

SELECT TOP 10 *
FROM dbo.Inventory;
GO


/* =====================================================
   8. CHECK NULL VALUES
   ===================================================== */

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Null_Customer_ID,
    SUM(CASE WHEN Customer_Name IS NULL THEN 1 ELSE 0 END) AS Null_Customer_Name,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS Null_City,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS Null_Region
FROM dbo.Customers;
GO

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS Null_Product_ID,
    SUM(CASE WHEN Product_Name IS NULL THEN 1 ELSE 0 END) AS Null_Product_Name,
    SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS Null_Category
FROM dbo.Products;
GO

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) AS Null_Order_ID,
    SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS Null_Order_Date,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Null_Customer_ID,
    SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS Null_Product_ID,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS Null_Sales,
    SUM(CASE WHEN Cost IS NULL THEN 1 ELSE 0 END) AS Null_Cost,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS Null_Profit
FROM dbo.Sales;
GO


/* =====================================================
   9. CHECK DUPLICATES
   ===================================================== */

SELECT
    Customer_ID,
    COUNT(*) AS Duplicate_Count
FROM dbo.Customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;
GO

SELECT
    Product_ID,
    COUNT(*) AS Duplicate_Count
FROM dbo.Products
GROUP BY Product_ID
HAVING COUNT(*) > 1;
GO

SELECT
    Order_ID,
    COUNT(*) AS Duplicate_Count
FROM dbo.Sales
GROUP BY Order_ID
HAVING COUNT(*) > 1;
GO


/* =====================================================
   10. BASIC SALES DATA VALIDATION
   ===================================================== */

SELECT
    COUNT(*) AS Invalid_Quantity_Rows
FROM dbo.Sales
WHERE Quantity <= 0;
GO

SELECT
    COUNT(*) AS Negative_Sales_Rows
FROM dbo.Sales
WHERE Sales < 0;
GO

SELECT
    COUNT(*) AS Negative_Cost_Rows
FROM dbo.Sales
WHERE Cost < 0;
GO


/* =====================================================
   11. OVERALL SALES PERFORMANCE
   ===================================================== */

SELECT
    SUM(Sales) AS Total_Sales,
    SUM(Cost) AS Total_Cost,
    SUM(Profit) AS Total_Profit
FROM dbo.Sales;
GO


/* =====================================================
   12. OVERALL PROFIT MARGIN
   ===================================================== */

SELECT
    SUM(Sales) AS Total_Sales,
    SUM(Cost) AS Total_Cost,
    SUM(Profit) AS Total_Profit,
    ROUND(
        SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0),
        2
    ) AS Profit_Margin_Percent
FROM dbo.Sales;
GO


/* =====================================================
   13. SALES BY REGION
   ===================================================== */

SELECT
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM dbo.Sales
GROUP BY Region
ORDER BY Total_Sales DESC;
GO


/* =====================================================
   14. SALES AND PROFIT BY CATEGORY
   ===================================================== */

SELECT
    Products.Category,
    SUM(Sales.Sales) AS Total_Sales,
    SUM(Sales.Profit) AS Total_Profit
FROM dbo.Sales
JOIN dbo.Products
    ON Sales.Product_ID = Products.Product_ID
GROUP BY Products.Category
ORDER BY Total_Sales DESC;
GO


/* =====================================================
   15. TOP 10 PRODUCTS BY SALES
   ===================================================== */

SELECT TOP 10
    Products.Product_ID,
    Products.Product_Name,
    Products.Category,
    SUM(Sales.Sales) AS Total_Sales,
    SUM(Sales.Profit) AS Total_Profit
FROM dbo.Sales
JOIN dbo.Products
    ON Sales.Product_ID = Products.Product_ID
GROUP BY
    Products.Product_ID,
    Products.Product_Name,
    Products.Category
ORDER BY Total_Sales DESC;
GO


/* =====================================================
   16. TOP 10 PRODUCTS BY PROFIT
   ===================================================== */

SELECT TOP 10
    Products.Product_ID,
    Products.Product_Name,
    Products.Category,
    SUM(Sales.Profit) AS Total_Profit
FROM dbo.Sales
JOIN dbo.Products
    ON Sales.Product_ID = Products.Product_ID
GROUP BY
    Products.Product_ID,
    Products.Product_Name,
    Products.Category
ORDER BY Total_Profit DESC;
GO


/* =====================================================
   17. TOP 10 CUSTOMERS BY SALES
   ===================================================== */

SELECT TOP 10
    Customers.Customer_ID,
    Customers.Customer_Name,
    Customers.City,
    Customers.Region,
    SUM(Sales.Sales) AS Total_Sales,
    SUM(Sales.Profit) AS Total_Profit
FROM dbo.Sales
JOIN dbo.Customers
    ON Sales.Customer_ID = Customers.Customer_ID
GROUP BY
    Customers.Customer_ID,
    Customers.Customer_Name,
    Customers.City,
    Customers.Region
ORDER BY Total_Sales DESC;
GO


/* =====================================================
   18. TOP 10 CUSTOMERS BY ORDER COUNT
   ===================================================== */

SELECT TOP 10
    Customers.Customer_ID,
    Customers.Customer_Name,
    Customers.City,
    COUNT(Sales.Order_ID) AS Order_Count,
    SUM(Sales.Sales) AS Total_Sales,
    SUM(Sales.Profit) AS Total_Profit
FROM dbo.Sales
JOIN dbo.Customers
    ON Sales.Customer_ID = Customers.Customer_ID
GROUP BY
    Customers.Customer_ID,
    Customers.Customer_Name,
    Customers.City
ORDER BY Order_Count DESC;
GO


/* =====================================================
   19. CUSTOMER COUNT AND SALES BY REGION
   ===================================================== */

SELECT
    Customers.Region,
    COUNT(DISTINCT Customers.Customer_ID) AS Customer_Count,
    SUM(Sales.Sales) AS Total_Sales,
    SUM(Sales.Profit) AS Total_Profit
FROM dbo.Sales
JOIN dbo.Customers
    ON Sales.Customer_ID = Customers.Customer_ID
GROUP BY Customers.Region
ORDER BY Total_Sales DESC;
GO


/* =====================================================
   20. TOP 10 CITIES BY SALES
   ===================================================== */

SELECT TOP 10
    Customers.City,
    SUM(Sales.Sales) AS Total_Sales,
    SUM(Sales.Profit) AS Total_Profit
FROM dbo.Sales
JOIN dbo.Customers
    ON Sales.Customer_ID = Customers.Customer_ID
GROUP BY Customers.City
ORDER BY Total_Sales DESC;
GO


/* =====================================================
   21. MONTHLY SALES AND PROFIT
   ===================================================== */

SELECT
    YEAR(Order_Date) AS Sales_Year,
    MONTH(Order_Date) AS Sales_Month,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM dbo.Sales
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY
    Sales_Year,
    Sales_Month;
GO


/* =====================================================
   22. LOW STOCK PRODUCTS
   ===================================================== */

SELECT
    Inventory.Product_ID,
    Products.Product_Name,
    Products.Category,
    Inventory.Region,
    Inventory.Stock_Quantity,
    Inventory.Reorder_Level
FROM dbo.Inventory
JOIN dbo.Products
    ON Inventory.Product_ID = Products.Product_ID
WHERE Inventory.Stock_Quantity <= Inventory.Reorder_Level
ORDER BY Inventory.Stock_Quantity ASC;
GO


/* =====================================================
   23. INVENTORY STOCK STATUS
   ===================================================== */

SELECT
    CASE
        WHEN Stock_Quantity <= Reorder_Level
        THEN 'Low Stock'
        ELSE 'Healthy Stock'
    END AS Stock_Status,
    COUNT(*) AS Product_Count
FROM dbo.Inventory
GROUP BY
    CASE
        WHEN Stock_Quantity <= Reorder_Level
        THEN 'Low Stock'
        ELSE 'Healthy Stock'
    END;
GO


/* =====================================================
   24. INVENTORY STATUS FOR EVERY PRODUCT
   ===================================================== */

SELECT
    Inventory.Product_ID,
    Products.Product_Name,
    Products.Category,
    Inventory.Region,
    Inventory.Stock_Quantity,
    Inventory.Reorder_Level,
    CASE
        WHEN Inventory.Stock_Quantity <= Inventory.Reorder_Level
        THEN 'Low Stock'
        ELSE 'Healthy Stock'
    END AS Stock_Status
FROM dbo.Inventory
JOIN dbo.Products
    ON Inventory.Product_ID = Products.Product_ID
ORDER BY Inventory.Stock_Quantity ASC;
GO


/* =====================================================
   25. STOCK QUANTITY BY REGION
   ===================================================== */

SELECT
    Region,
    SUM(Stock_Quantity) AS Total_Stock
FROM dbo.Inventory
GROUP BY Region
ORDER BY Total_Stock DESC;
GO


/* =====================================================
   26. PROFIT MARGIN BY CATEGORY
   ===================================================== */

SELECT
    Products.Category,
    SUM(Sales.Sales) AS Total_Sales,
    SUM(Sales.Profit) AS Total_Profit,
    ROUND(
        SUM(Sales.Profit) * 100.0 /
        NULLIF(SUM(Sales.Sales), 0),
        2
    ) AS Profit_Margin_Percent
FROM dbo.Sales
JOIN dbo.Products
    ON Sales.Product_ID = Products.Product_ID
GROUP BY Products.Category
ORDER BY Profit_Margin_Percent DESC;
GO


/* =====================================================
   27. FINAL BUSINESS SUMMARY
   ===================================================== */

SELECT
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    SUM(Sales) AS Total_Sales,
    SUM(Cost) AS Total_Cost,
    SUM(Profit) AS Total_Profit,
    ROUND(
        SUM(Profit) * 100.0 /
        NULLIF(SUM(Sales), 0),
        2
    ) AS Profit_Margin_Percent
FROM dbo.Sales;
GO


/*
=========================================================
END OF RETAIL SALES ANALYTICS SQL PROJECT
=========================================================
*/
