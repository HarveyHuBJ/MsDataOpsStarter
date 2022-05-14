CREATE TABLE [dbo].[FactSurveyResponse] (
    [SurveyResponseKey]             INT           IDENTITY (1, 1) NOT NULL,
    [DateKey]                       INT           NOT NULL,
    [CustomerKey]                   INT           NOT NULL,
    [ProductCategoryKey]            INT           NOT NULL,
    [EnglishProductCategoryName]    NVARCHAR (50) NOT NULL,
    [ProductSubcategoryKey]         INT           NOT NULL,
    [EnglishProductSubcategoryName] NVARCHAR (50) NOT NULL,
    [Date]                          DATETIME      NULL,
)
WITH (DISTRIBUTION=HASH([ProductCategoryKey]), CLUSTERED COLUMNSTORE INDEX);