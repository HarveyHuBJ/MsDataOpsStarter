CREATE TABLE [dbo].[DimOrganization] (
    [OrganizationKey]       INT           IDENTITY (1, 1) NOT NULL,
    [ParentOrganizationKey] INT           NULL,
    [PercentageOfOwnership] NVARCHAR (16) NULL,
    [OrganizationName]      NVARCHAR (50) NULL,
    [CurrencyKey]           INT           NULL,
)
WITH (DISTRIBUTION=REPLICATE, CLUSTERED COLUMNSTORE INDEX);
