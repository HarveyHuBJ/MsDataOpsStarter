CREATE TABLE [dbo].[PART] (
    [P_PARTKEY]     INT             NOT NULL,
    [P_NAME]        VARCHAR (55)    NOT NULL,
    [P_MFGR]        CHAR (25)       NOT NULL,
    [P_BRAND]       CHAR (10)       NOT NULL,
    [P_TYPE]        VARCHAR (25)    NOT NULL,
    [P_SIZE]        INT             NOT NULL,
    [P_CONTAINER]   CHAR (10)       NOT NULL,
    [P_RETAILPRICE] DECIMAL (15, 2) NOT NULL,
    [P_COMMENT]     VARCHAR (23)    NOT NULL,
    PRIMARY KEY CLUSTERED ([P_PARTKEY] ASC)
);

