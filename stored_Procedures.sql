CREATE PROCEDURE CreateOrder
    @CustomerID INT,
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    BEGIN TRANSACTION;

    DECLARE @Price DECIMAL(10,2);
    DECLARE @Total DECIMAL(10,2);

    SELECT @Price = Price FROM Products WHERE ProductID = @ProductID;

    SET @Total = @Price * @Quantity;

    INSERT INTO Orders (CustomerID, TotalAmount)
    VALUES (@CustomerID, @Total);

    DECLARE @OrderID INT = SCOPE_IDENTITY();

    INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Price)
    VALUES (@OrderID, @ProductID, @Quantity, @Price);

    UPDATE Products
    SET StockQuantity = StockQuantity - @Quantity
    WHERE ProductID = @ProductID;

    COMMIT TRANSACTION;
END;


EXEC CreateOrder 1,1,2;
