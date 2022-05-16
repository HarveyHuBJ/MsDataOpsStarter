
if exists (select name from sysobjects where name = 'oldorders')
    drop table oldorders

if exists (select name from sysobjects where name = 'temporders')
    drop table temporders

if exists (select name from sysobjects where name = 'neworders')
    drop table neworders

if exists (select name from sysobjects where name = 'newlineitem')
    drop table newlineitem


go



create table oldorders           (o_orderkey      int             not null)

create table temporders           (o_orderkey_1     int      not null,
                                   o_string_1       varchar(4)  not null, 
                                   o_orderkey_2       int       not null,
                                   o_string         varchar(4)  not null    )
 

create table neworders
				 (o_orderkey      int                  not null,
				  o_custkey       int                  not null,
				  o_orderstatus   char(1)              not null,
				  o_totalprice    float                not null,
				  o_orderdate     datetime             not null,
				  o_orderpriority char(15)             not null,
				  o_clerk         char(15)             not null,
				  o_shippriority  int                  not null,
				  o_comment       varchar(79)          not null)

create table newlineitem
				(l_orderkey               int          not null,
				 l_partkey                int          not null,
				 l_suppkey                int          not null,
				 l_linenumber             int          not null,
				 l_quantity               float        not null,
				 l_extendedprice          float        not null,
				 l_discount               float        not null,
				 l_tax                    float        not null,
				 l_returnflag             char(1)      not null,
				 l_linestatus             char(1)      not null,
				 l_shipdate               datetime     not null,
				 l_commitdate             datetime     not null,
				 l_receiptdate            datetime     not null,
				 l_shipinstruct           char(25)     not null,
				 l_shipmode               char(10)     not null,
				 l_comment                varchar(44)  not null)



go


 --eof

