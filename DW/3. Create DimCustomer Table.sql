--CREATE SCHEMA dw;
--GO

CREATE TABLE dw.DimCustomer
(
	CustomerKey int NOT NULL,
	CustomerName nvarchar(200) NOT NULL,
	MaritalStatus nvarchar(1)  NULL,
	Gender nvarchar(1) NULL,
	City nvarchar(30) NULL,
	Province nvarchar(50) NULL,
	Country nvarchar(50) NULL
)
GO
