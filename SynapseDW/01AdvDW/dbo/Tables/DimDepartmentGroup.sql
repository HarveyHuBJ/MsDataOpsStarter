CREATE TABLE [dbo].[DimDepartmentGroup] (
    [DepartmentGroupKey]       INT           IDENTITY (1, 1) NOT NULL,
    [ParentDepartmentGroupKey] INT           NULL,
    [DepartmentGroupName]      NVARCHAR (50) NULL,
)
WITH (DISTRIBUTION=REPLICATE, CLUSTERED COLUMNSTORE INDEX);