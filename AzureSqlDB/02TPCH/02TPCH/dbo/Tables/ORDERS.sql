CREATE TABLE [dbo].[ORDERS] (
    [O_ORDERKEY]      INT             NOT NULL,
    [O_CUSTKEY]       INT             NOT NULL,
    [O_ORDERSTATUS]   CHAR (1)        NOT NULL,
    [O_TOTALPRICE]    DECIMAL (15, 2) NOT NULL,
    [O_ORDERDATE]     DATE            NOT NULL,
    [O_ORDERPRIORITY] CHAR (15)       NOT NULL,
    [O_CLERK]         CHAR (15)       NOT NULL,
    [O_SHIPPRIORITY]  INT             NOT NULL,
    [O_COMMENT]       VARCHAR (79)    NOT NULL,
    PRIMARY KEY CLUSTERED ([O_ORDERKEY] ASC),
);

