CREATE PROCEDURE staging.TransformProduct 
AS
BEGIN
    UPDATE staging.product
    SET Color='N/A'
    WHERE Color='NA';

    UPDATE staging.product
    SET ModelName='Unknown'
    WHERE ModelName IS NULL;

    UPDATE staging.product
    SET EnglishProductCategoryName='Unknown'
    WHERE EnglishProductCategoryName IS NULL;

    UPDATE staging.product
    SET EnglishProductSubcategoryName='Unknown'
    WHERE EnglishProductSubcategoryName IS NULL;
END
