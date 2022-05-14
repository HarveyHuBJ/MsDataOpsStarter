CREATE TABLE [dbo].[FactInternetSalesReason] (
    [SalesOrderNumber]     NVARCHAR (20) NOT NULL,
    [SalesOrderLineNumber] TINYINT       NOT NULL,
    [SalesReasonKey]       INT           NOT NULL,
)
WITH (DISTRIBUTION=HASH([SalesOrderNumber]), CLUSTERED COLUMNSTORE INDEX);

