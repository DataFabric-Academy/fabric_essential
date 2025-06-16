CREATE TABLE staging.Product
(
    ProductKey bigint  NOT NULL,
    EnglishProductName varchar(8000)  NOT NULL,
    Color varchar(8000)  NULL,
    ModelName varchar(8000)  NULL,
    EnglishProductSubcategoryName varchar(8000)  NULL,
    EnglishProductCategoryName varchar(8000)  NULL
)
GO
