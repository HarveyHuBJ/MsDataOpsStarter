CREATE TABLE [dbo].[FactCurrencyRate] (
    [CurrencyKey]  INT        NOT NULL,
    [DateKey]      INT        NOT NULL,
    [AverageRate]  FLOAT (53) NOT NULL,
    [EndOfDayRate] FLOAT (53) NOT NULL,
    [Date]         DATETIME   NULL,
)
WITH (DISTRIBUTION=HASH([CurrencyKey]), CLUSTERED COLUMNSTORE INDEX);
