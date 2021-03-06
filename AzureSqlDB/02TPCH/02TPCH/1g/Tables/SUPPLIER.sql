CREATE TABLE [g1].[SUPPLIER] (
    [S_SUPPKEY]   INT             NOT NULL,
    [S_NAME]      CHAR (25)       NOT NULL,
    [S_ADDRESS]   VARCHAR (40)    NOT NULL,
    [S_NATIONKEY] INT             NOT NULL,
    [S_PHONE]     CHAR (15)       NOT NULL,
    [S_ACCTBAL]   DECIMAL (15, 2) NOT NULL,
    [S_COMMENT]   VARCHAR (101)   NOT NULL,
    PRIMARY KEY CLUSTERED ([S_SUPPKEY] ASC),
);

