--CREATE SCHEMA dw;
--GO

CREATE TABLE dw.DimCustomer
(
	CustomerKey bigint NOT NULL,
	CustomerName varchar(8000) NOT NULL,
	MaritalStatus varchar(8000)  NULL,
	Gender varchar(8000) NULL,
	City varchar(8000) NULL,
	Province varchar(8000) NULL,
	Country varchar(8000) NULL
)
GO
