CREATE TABLE [g10].[LINEITEM] (
    [L_ORDERKEY]      INT             NOT NULL,
    [L_PARTKEY]       INT             NOT NULL,
    [L_SUPPKEY]       INT             NOT NULL,
    [L_LINENUMBER]    INT             NOT NULL,
    [L_QUANTITY]      DECIMAL (15, 2) NOT NULL,
    [L_EXTENDEDPRICE] DECIMAL (15, 2) NOT NULL,
    [L_DISCOUNT]      DECIMAL (15, 2) NOT NULL,
    [L_TAX]           DECIMAL (15, 2) NOT NULL,
    [L_RETURNFLAG]    CHAR (1)        NOT NULL,
    [L_LINESTATUS]    CHAR (1)        NOT NULL,
    [L_SHIPDATE]      DATE            NOT NULL,
    [L_COMMITDATE]    DATE            NOT NULL,
    [L_RECEIPTDATE]   DATE            NOT NULL,
    [L_SHIPINSTRUCT]  CHAR (25)       NOT NULL,
    [L_SHIPMODE]      CHAR (10)       NOT NULL,
    [L_COMMENT]       VARCHAR (44)    NOT NULL,
);


GO
CREATE CLUSTERED INDEX [IX_LINEITEM_SHIPDATE_g10]
    ON [g10].[LINEITEM]([L_SHIPDATE] ASC);

