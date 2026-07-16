CREATE SCHEMA staging;
GO


CREATE TABLE staging.internetsales
(
	ProductKey int  NULL,
	OrderDateKey int  NULL,
	CustomerKey int  NULL,
	OrderQuantity int  NULL,
	UnitPrice decimal(18,2)  NULL,
	UnitPriceDiscountPct decimal(8,2)  NULL,
	DiscountAmount decimal(18,2)  NULL,
	TotalProductCost decimal(18,2)  NULL,
	SalesAmount decimal(18,2)  NULL,
	TaxAmt decimal(18,2)  NULL
)
GO
