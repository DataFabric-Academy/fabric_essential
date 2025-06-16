CREATE SCHEMA staging;
GO


CREATE TABLE staging.internetsales
(
	ProductKey bigint  NULL,
	OrderDateKey bigint  NULL,
	CustomerKey bigint  NULL,
	OrderQuantity bigint  NULL,
	UnitPrice float  NULL,
	UnitPriceDiscountPct bigint  NULL,
	DiscountAmount bigint  NULL,
	TotalProductCost float  NULL,
	SalesAmount float  NULL,
	TaxAmt float  NULL
)
GO
