CREATE TABLE [dbo].[DimProductSubcategory] (
    [ProductSubcategoryKey]          INT           IDENTITY (1, 1) NOT NULL,
    [ProductSubcategoryAlternateKey] INT           NULL,
    [EnglishProductSubcategoryName]  NVARCHAR (50) NOT NULL,
    [SpanishProductSubcategoryName]  NVARCHAR (50) NOT NULL,
    [FrenchProductSubcategoryName]   NVARCHAR (50) NOT NULL,
    [ProductCategoryKey]             INT           NULL,
)
WITH (DISTRIBUTION=REPLICATE, CLUSTERED COLUMNSTORE INDEX);