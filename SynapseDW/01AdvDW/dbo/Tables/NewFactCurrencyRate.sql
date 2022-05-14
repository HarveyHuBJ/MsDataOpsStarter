CREATE TABLE [dbo].[NewFactCurrencyRate] (
    [AverageRate]  REAL         NULL,
    [CurrencyID]   NVARCHAR (3) NULL,
    [CurrencyDate] DATE         NULL,
    [EndOfDayRate] REAL         NULL,
    [CurrencyKey]  INT          NULL,
    [DateKey]      INT          NULL
)
WITH (DISTRIBUTION=HASH([CurrencyID]), CLUSTERED COLUMNSTORE INDEX);

