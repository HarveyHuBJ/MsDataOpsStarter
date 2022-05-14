CREATE TABLE [dbo].[FactFinance] (
    [FinanceKey]         INT        IDENTITY (1, 1) NOT NULL,
    [DateKey]            INT        NOT NULL,
    [OrganizationKey]    INT        NOT NULL,
    [DepartmentGroupKey] INT        NOT NULL,
    [ScenarioKey]        INT        NOT NULL,
    [AccountKey]         INT        NOT NULL,
    [Amount]             FLOAT (53) NOT NULL,
    [Date]               DATETIME   NULL,
)
WITH (DISTRIBUTION=HASH([AccountKey]), CLUSTERED COLUMNSTORE INDEX);