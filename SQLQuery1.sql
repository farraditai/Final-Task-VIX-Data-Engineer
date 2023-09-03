CREATE DATABASE dwh_project

CREATE TABLE DimCustomer (
	CustomerID int NOT NULL,
	CustomerName varchar(50) NOT NULL,
	Age int NOT NULL,
	Gender varchar(50) NOT NULL,
	City varchar(50) NOT NULL,
	NoHP varchar(50) NOT NULL
	CONSTRAINT PK_DimCustomer PRIMARY KEY (CustomerID)
)

CREATE TABLE DimProduct (
	ProductID int NOT NULL,
	ProductName varchar(50) NOT NULL,
	ProductCategory varchar(50) NOT NULL,
	ProductUnitPrice int NULL,
	CONSTRAINT PK_DimProduct PRIMARY KEY (ProductID)
)

CREATE TABLE FactSalesOrder (
	OrderID int NOT NULL,
	CustomerID int NOT NULL,
	ProductID int NOT NULL,
	Quantity int NOT NULL,
	Amount int NOT NULL,
	StatusID int NOT NULL,
	OrderDate date NOT NULL,
	CONSTRAINT PK_FactSalesOrder PRIMARY KEY (OrderID),
	CONSTRAINT FK_SalesCustomer FOREIGN KEY (CustomerID) REFERENCES DimCustomer (CustomerID),
	CONSTRAINT FK_SalesProduct FOREIGN KEY (ProductID) REFERENCES DimProduct (ProductID),
	CONSTRAINT FK_SalesStatus FOREIGN KEY (StatusID) REFERENCES DimStatusOrder (StatusID)
)
CREATE TABLE DimStatusOrder (
	StatusID int NOT NULL,
	StatusOrder varchar(50) NOT NULL,
	StatusOrderDesc varchar(50) NOT NULL,
	CONSTRAINT PK_DimStatusOrder PRIMARY KEY (StatusID)
)
SELECT * FROM DimCustomer
SELECT * FROM DimProduct
SELECT * FROM FactSalesOrder
SELECT * FROM DimStatusOrder

CREATE OR ALTER PROCEDURE summary_order_status
(@StatusID int) AS
BEGIN
	SELECT
		a.OrderID,
		b.CustomerName,
		c.ProductName,
		a.Quantity,
		d.StatusOrder
	FROM FactSalesOrder a
	INNER JOIN DimCustomer b ON a.CustomerID = b.CustomerID
	INNER JOIN DimProduct c ON a.ProductID = c.ProductID
	INNER JOIN DimStatusOrder d ON a.StatusID = d.StatusID
	WHERE d.StatusID = @StatusID
END

EXEC summary_order_status @StatusID = 2
