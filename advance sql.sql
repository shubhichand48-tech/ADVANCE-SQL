drop table product;

create table product(
productID INT primary key,
Productname Varchar (100),
category varchar(50),
price Decimal (10,2)
);
 
 insert into product values 
 (1,'keyboard','electronics',1200),
 (2,'mouse','electronics',800),
 (3,'chair', 'furniture',2500),
 (4,'Desk','furniture',5500);
 
 create table sales(
 saleID INT primary KEY,
 productID INT,
 Quantity INT,
 saledate DATE,
 Foreign key (productID) references products (productID)
 );
 
 insert into sales values
 (1,1,4,'2024-01-05'),
 (2,2,10,'2024-01-06'),
 (3,3,2,'2024-01-10'),
 (4,4,1,'2024-01-11');
 
WITH ProductRevenue AS (
    SELECT 
        p.ProductID,
        p.ProductName,
        SUM(p.Price * s.Quantity) AS TotalRevenue
    FROM Products p
    JOIN Sales s
        ON p.ProductID = s.ProductID
    GROUP BY p.ProductID, p.ProductName
)
SELECT *
FROM ProductRevenue
WHERE TotalRevenue > 3000;

-- question7
CREATE VIEW CategorySummary AS
SELECT 
    Category,
    COUNT(ProductID) AS TotalProducts,
    AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category;

-- question8
CREATE VIEW ProductPriceView AS
SELECT ProductID, ProductName, Price
FROM Products;

UPDATE ProductPriceView
SET Price = 1500
WHERE ProductID = 1;

-- question9
CREATE PROCEDURE GetProductsByCategory
    @CategoryName VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Products
    WHERE Category = @CategoryName;
END;

-- question10
CREATE TABLE ProductArchive (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    DeletedAt DATETIME
);

CREATE TRIGGER trg_AfterDelete_Product
On Products
AFTER DELETE
AS
BEGIN
    INSERT INTO ProductArchive (ProductID, ProductName, Category, Price, DeletedAt)
    SELECT 
        ProductID,
        ProductName,
        Category,
        Price,
        GETDATE()
    FROM deleted;
END;