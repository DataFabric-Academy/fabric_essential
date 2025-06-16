CREATE PROCEDURE dw.LoadDimProduct 
AS
BEGIN
    DROP TABLE IF EXISTS dw.DimProduct;

    SELECT * 
    INTO dw.DimProduct
    FROM staging.product;
END
