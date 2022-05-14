CREATE TABLE [dbo].[FactProductInventory] (
    [ProductKey]   INT   NOT NULL,
    [DateKey]      INT   NOT NULL,
    [MovementDate] DATE  NOT NULL,
    [UnitCost]     MONEY NOT NULL,
    [UnitsIn]      INT   NOT NULL,
    [UnitsOut]     INT   NOT NULL,
    [UnitsBalance] INT   NOT NULL,
)
WITH (DISTRIBUTION=HASH([ProductKey]), CLUSTERED COLUMNSTORE INDEX);