CREATE TABLE [dbo].[FactSalesQuota] (
    [SalesQuotaKey]    INT      IDENTITY (1, 1) NOT NULL,
    [EmployeeKey]      INT      NOT NULL,
    [DateKey]          INT      NOT NULL,
    [CalendarYear]     SMALLINT NOT NULL,
    [CalendarQuarter]  TINYINT  NOT NULL,
    [SalesAmountQuota] MONEY    NOT NULL,
    [Date]             DATETIME NULL,
)
WITH (DISTRIBUTION=HASH([EmployeeKey]), CLUSTERED COLUMNSTORE INDEX);