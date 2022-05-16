﻿CREATE TABLE [g100].[NATION] (
    [N_NATIONKEY] INT           NOT NULL,
    [N_NAME]      CHAR (25)     NOT NULL,
    [N_REGIONKEY] INT           NOT NULL,
    [N_COMMENT]   VARCHAR (152) NULL,
    PRIMARY KEY CLUSTERED ([N_NATIONKEY] ASC),
    CONSTRAINT [NATION_FK1] FOREIGN KEY ([N_REGIONKEY]) REFERENCES [dbo].[REGION] ([R_REGIONKEY])
);

