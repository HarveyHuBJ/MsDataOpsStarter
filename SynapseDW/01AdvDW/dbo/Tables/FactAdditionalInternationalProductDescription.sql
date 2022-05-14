CREATE TABLE [dbo].[FactAdditionalInternationalProductDescription] (
    [ProductKey]         INT            NOT NULL,
    [CultureName]        NVARCHAR (50)  NOT NULL,
    [ProductDescription] NVARCHAR (4000) NOT NULL,
)
WITH (DISTRIBUTION=HASH([ProductKey]), CLUSTERED COLUMNSTORE INDEX);