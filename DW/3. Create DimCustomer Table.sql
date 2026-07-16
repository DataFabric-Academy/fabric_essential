--CREATE SCHEMA dw;
--GO

CREATE TABLE dw.DimCustomer
(
	CustomerKey int NOT NULL,
	CustomerName varchar(200) NOT NULL,
	MaritalStatus varchar(1)  NULL,
	Gender varchar(1) NULL,
	City varchar(30) NULL,
	Province varchar(50) NULL,
	Country varchar(50) NULL
)
GO
