CREATE TABLE [dbo].[DimCurrency] (
    [CurrencyKey]          INT           IDENTITY (1, 1) NOT NULL,
    [CurrencyAlternateKey] NCHAR (3)     NOT NULL,
    [CurrencyName]         NVARCHAR (50) NOT NULL,
);

 
