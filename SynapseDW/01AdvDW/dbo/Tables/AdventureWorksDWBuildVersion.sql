﻿CREATE TABLE [dbo].[AdventureWorksDWBuildVersion] (
    [DBVersion]   NVARCHAR (50) NULL,
    [VersionDate] DATETIME      NULL
)
WITH (DISTRIBUTION=REPLICATE, CLUSTERED COLUMNSTORE INDEX);
