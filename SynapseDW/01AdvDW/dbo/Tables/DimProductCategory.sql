CREATE TABLE [dbo].[DimProductCategory] (
    [ProductCategoryKey]          INT           IDENTITY (1, 1) NOT NULL,
    [ProductCategoryAlternateKey] INT           NULL,
    [EnglishProductCategoryName]  NVARCHAR (50) NOT NULL,
    [SpanishProductCategoryName]  NVARCHAR (50) NOT NULL,
    [FrenchProductCategoryName]   NVARCHAR (50) NOT NULL,
)
WITH (DISTRIBUTION=REPLICATE, CLUSTERED COLUMNSTORE INDEX);