
DECLARE @CustomerId INT = 1, @TotalSpent DECIMAL(10,2);
SELECT @TotalSpent = SUM(oi.quantity * (oi.list_price - oi.discount))
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.customer_id = @CustomerId;
IF @TotalSpent > 5000
    PRINT 'Customer ' + CAST(@CustomerId AS VARCHAR) + ' is a VIP. Total Spent: $' + CAST(@TotalSpent AS VARCHAR);
ELSE
    PRINT 'Customer ' + CAST(@CustomerId AS VARCHAR) + ' is Regular. Total Spent: $' + CAST(@TotalSpent AS VARCHAR);


DECLARE @Threshold DECIMAL(10,2) = 1500, @Count INT;
SELECT @Count = COUNT(*) FROM production.products WHERE list_price > @Threshold;
PRINT 'Threshold: $' + CAST(@Threshold AS VARCHAR) + ', Products Above Threshold: ' + CAST(@Count AS VARCHAR);


DECLARE @StaffId INT = 2, @Year INT = 2017, @SalesTotal DECIMAL(10,2);
SELECT @SalesTotal = SUM(oi.quantity * (oi.list_price - oi.discount))
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.staff_id = @StaffId AND YEAR(o.order_date) = @Year;
PRINT 'Staff ID: ' + CAST(@StaffId AS VARCHAR) + ', Year: ' + CAST(@Year AS VARCHAR) + ', Total Sales: $' + CAST(@SalesTotal AS VARCHAR);


SELECT @@SERVERNAME AS ServerName, @@VERSION AS Version, @@ROWCOUNT AS LastRowCount;


DECLARE @Qty INT;
SELECT @Qty = quantity FROM production.stocks WHERE product_id = 1 AND store_id = 1;
IF @Qty > 20
    PRINT 'Well stocked';
ELSE IF @Qty BETWEEN 10 AND 20
    PRINT 'Moderate stock';
ELSE
    PRINT 'Low stock - reorder needed';


DECLARE @Batch INT = 0;
WHILE EXISTS (SELECT TOP 1 1 FROM production.stocks WHERE quantity < 5)
BEGIN
    UPDATE TOP (3) production.stocks SET quantity = quantity + 10 WHERE quantity < 5;
    SET @Batch += 1;
    PRINT 'Batch ' + CAST(@Batch AS VARCHAR) + ' processed.';
END


SELECT product_name, list_price,
CASE 
    WHEN list_price < 300 THEN 'Budget'
    WHEN list_price BETWEEN 300 AND 800 THEN 'Mid-Range'
    WHEN list_price BETWEEN 801 AND 2000 THEN 'Premium'
    ELSE 'Luxury'
END AS PriceCategory
FROM production.products;


IF EXISTS (SELECT 1 FROM sales.customers WHERE customer_id = 5)
    SELECT COUNT(*) AS OrderCount FROM sales.orders WHERE customer_id = 5;
ELSE
    PRINT 'Customer ID 5 not found.';

CREATE FUNCTION CalculateShippin(@total DECIMAL(10,2)) RETURNS DECIMAL(5,2)
AS
BEGIN
    RETURN (
        CASE
            WHEN @total > 100 THEN 0
            WHEN @total BETWEEN 50 AND 99.99 THEN 5.99
            ELSE 12.99
        END
    )
END;


CREATE FUNCTION GetProductsByPriceRange(@min DECIMAL(10,2), @max DECIMAL(10,2))
RETURNS TABLE
AS
RETURN
    SELECT p.product_name, p.list_price, b.brand_name, c.category_name
    FROM production.products p
    JOIN production.brands b ON p.brand_id = b.brand_id
    JOIN production.categories c ON p.category_id = c.category_id
    WHERE p.list_price BETWEEN @min AND @max;


CREATE FUNCTION GetCustomerYealySummary(@customer_id INT)
RETURNS @summary TABLE (
    Year INT,
    TotalOrders INT,
    TotalSpent DECIMAL(10,2),
    AvgOrderValue DECIMAL(10,2)
)
AS
BEGIN
    INSERT INTO @summary
    SELECT YEAR(o.order_date), COUNT(*), SUM(oi.quantity * (oi.list_price - oi.discount)), 
           AVG(oi.quantity * (oi.list_price - oi.discount))
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id = @customer_id
    GROUP BY YEAR(o.order_date);
    RETURN;
END;


CREATE FUNCTION CalculateBulkDiscount(@qty INT) RETURNS DECIMAL(4,2)
AS
BEGIN
    RETURN (
        CASE 
            WHEN @qty BETWEEN 1 AND 2 THEN 0.00
            WHEN @qty BETWEEN 3 AND 5 THEN 0.05
            WHEN @qty BETWEEN 6 AND 9 THEN 0.10
            ELSE 0.15
        END
    )
END;


CREATE PROCEDURE sp_GetCustomerOrderHistory
    @customer_id INT,
    @startDate DATE = NULL,
    @endDate DATE = NULL
AS
BEGIN
    SELECT o.order_id, o.order_date, SUM(oi.quantity * (oi.list_price - oi.discount)) AS OrderTotal
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id = @customer_id
        AND (@startDate IS NULL OR o.order_date >= @startDate)
        AND (@endDate IS NULL OR o.order_date <= @endDate)
    GROUP BY o.order_id, o.order_date;
END;


CREATE PROCEDURE sp_RestockProduct
    @store_id INT,
    @product_id INT,
    @quantity INT,
    @old_qty INT OUTPUT,
    @new_qty INT OUTPUT,
    @status VARCHAR(50) OUTPUT
AS
BEGIN
    SELECT @old_qty = quantity FROM production.stocks WHERE store_id = @store_id AND product_id = @product_id;
    UPDATE production.stocks SET quantity = quantity + @quantity WHERE store_id = @store_id AND product_id = @product_id;
    SELECT @new_qty = quantity FROM production.stocks WHERE store_id = @store_id AND product_id = @product_id;
    SET @status = 'Restocked successfully';
END;


CREATE PROCEDURE sp_ProcessNewOrder
    @customer_id INT,
    @product_id INT,
    @quantity INT,
    @store_id INT
AS
BEGIN
    DECLARE @order_id INT, @staff_id INT;
    BEGIN TRY
        BEGIN TRAN;
        SELECT TOP 1 @staff_id = staff_id FROM sales.staffs WHERE store_id = @store_id;
        INSERT INTO sales.orders (customer_id, order_status, order_date, required_date, store_id, staff_id)
        VALUES (@customer_id, 1, GETDATE(), GETDATE() + 5, @store_id, @staff_id);
        SET @order_id = SCOPE_IDENTITY();
        DECLARE @price DECIMAL(10,2), @discount DECIMAL(4,2);
        SELECT @price = list_price FROM production.products WHERE product_id = @product_id;
        SET @discount = dbo.CalculateBulkDiscount(@quantity);
        INSERT INTO sales.order_items (order_id, item_id, product_id, quantity, list_price, discount)
        VALUES (@order_id, 1, @product_id, @quantity, @price, @discount);
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT ERROR_MESSAGE();
    END CATCH
END;


CREATE PROCEDURE sp_SearchProducts
    @name NVARCHAR(255) = NULL,
    @category_id INT = NULL,
    @minPrice DECIMAL(10,2) = NULL,
    @maxPrice DECIMAL(10,2) = NULL,
    @sortColumn NVARCHAR(255) = 'list_price'
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX) = 'SELECT * FROM production.products WHERE 1=1';
    IF @name IS NOT NULL SET @sql += ' AND product_name LIKE ''%' + @name + '%''';
    IF @category_id IS NOT NULL SET @sql += ' AND category_id = ' + CAST(@category_id AS VARCHAR);
    IF @minPrice IS NOT NULL SET @sql += ' AND list_price >= ' + CAST(@minPrice AS VARCHAR);
    IF @maxPrice IS NOT NULL SET @sql += ' AND list_price <= ' + CAST(@maxPrice AS VARCHAR);
    SET @sql += ' ORDER BY ' + @sortColumn;
    EXEC sp_executesql @sql;
END;


DECLARE @QStart DATE = '2017-01-01', @QEnd DATE = '2017-03-31';
SELECT s.staff_id, s.first_name, s.last_name,
    SUM(oi.quantity * (oi.list_price - oi.discount)) AS TotalSales,
    CASE 
        WHEN SUM(oi.quantity * (oi.list_price - oi.discount)) > 10000 THEN '10% Bonus'
        WHEN SUM(oi.quantity * (oi.list_price - oi.discount)) BETWEEN 5000 AND 9999 THEN '5% Bonus'
        ELSE '2% Bonus'
    END AS BonusTier
FROM sales.staffs s
JOIN sales.orders o ON s.staff_id = o.staff_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE o.order_date BETWEEN @QStart AND @QEnd
GROUP BY s.staff_id, s.first_name, s.last_name;


SELECT store_id, product_id, quantity,
    CASE
        WHEN quantity < 5 THEN 'Restock: Add 20'
        WHEN quantity BETWEEN 5 AND 15 THEN 'Restock: Add 10'
        WHEN quantity > 15 THEN 'Stock sufficient'
    END AS Action
FROM production.stocks;



SELECT c.customer_id, c.first_name, c.last_name,
    ISNULL(SUM(oi.quantity * (oi.list_price - oi.discount)), 0) AS TotalSpent,
    CASE 
        WHEN SUM(oi.quantity * (oi.list_price - oi.discount)) IS NULL THEN 'No Orders'
        WHEN SUM(oi.quantity * (oi.list_price - oi.discount)) > 5000 THEN 'Gold'
        WHEN SUM(oi.quantity * (oi.list_price - oi.discount)) BETWEEN 2000 AND 4999 THEN 'Silver'
        ELSE 'Bronze'
    END AS LoyaltyTier
FROM sales.customers c
LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
LEFT JOIN sales.order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name;


CREATE PROCEDURE sp_DiscontinueProduct
    @product_id INT,
    @replacement_id INT = NULL
AS
BEGIN
    IF EXISTS (SELECT 1 FROM sales.order_items oi JOIN sales.orders o ON oi.order_id = o.order_id
               WHERE oi.product_id = @product_id AND o.order_status IN (1,2))
    BEGIN
        IF @replacement_id IS NOT NULL
            UPDATE sales.order_items SET product_id = @replacement_id WHERE product_id = @product_id;
        ELSE
            RAISERROR('Product has pending orders. Replacement required.', 16, 1);
    END
    DELETE FROM production.stocks WHERE product_id = @product_id;
    DELETE FROM production.products WHERE product_id = @product_id;
    PRINT 'Product discontinued successfully.';
END;


SELECT YEAR(o.order_date) AS Year, MONTH(o.order_date) AS Month, 
       COUNT(DISTINCT o.order_id) AS TotalOrders,
       SUM(oi.quantity * (oi.list_price - oi.discount)) AS TotalSales,
       s.first_name + ' ' + s.last_name AS Staff,
       c.category_name
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN sales.staffs s ON o.staff_id = s.staff_id
JOIN production.products p ON oi.product_id = p.product_id
JOIN production.categories c ON p.category_id = c.category_id
GROUP BY YEAR(o.order_date), MONTH(o.order_date), s.first_name, s.last_name, c.category_name;


CREATE PROCEDURE sp_InsertOrderWithValidation
    @customer_id INT, @product_id INT, @quantity INT, @store_id INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sales.customers WHERE customer_id = @customer_id)
        RETURN;
    IF NOT EXISTS (SELECT 1 FROM production.stocks WHERE store_id = @store_id AND product_id = @product_id AND quantity >= @quantity)
        RETURN;
    EXEC sp_ProcessNewOrder @customer_id, @product_id, @quantity, @store_id;
END;