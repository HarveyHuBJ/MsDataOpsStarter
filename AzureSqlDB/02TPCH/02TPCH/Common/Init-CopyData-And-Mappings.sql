 
truncate table mddr.CopyData
truncate table mddr.CopyDataMappings

-- 1，2，4，5 存在mapping缺失，待调查
--select * from mddr.CopyDataMappings

if object_id('#metadata_config_table') is not null
    drop table #metadata_config_table;
go
create table #metadata_config_table (id int , name varchar(100) , mappings varchar(max));

go
insert into   #metadata_config_table
values
  (1, 'CUSTOMER', '[{"source":{"type":"String","ordinal":1},"sink":{"name":"C_CUSTKEY","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":2},"sink":{"name":"C_NAME","type":"String","physicalType":"varchar"}},{"source":{"type":"String","ordinal":3},"sink":{"name":"C_ADDRESS","type":"String","physicalType":"varchar"}},{"source":{"type":"String","ordinal":4},"sink":{"name":"C_NATIONKEY","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":5},"sink":{"name":"C_PHONE","type":"String","physicalType":"char"}},{"source":{"type":"String","ordinal":6},"sink":{"name":"C_ACCTBAL","type":"Decimal","physicalType":"decimal","scale":2,"precision":15}},{"source":{"type":"String","ordinal":7},"sink":{"name":"C_MKTSEGMENT","type":"String","physicalType":"char"}},{"sink":{"name":"C_COMMENT","type":"String","physicalType":"varchar"}}]')
, (2, 'LINEITEM', '[{"source":{"type":"String","ordinal":1},"sink":{"name":"L_ORDERKEY","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":2},"sink":{"name":"L_PARTKEY","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":3},"sink":{"name":"L_SUPPKEY","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":4},"sink":{"name":"L_LINENUMBER","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":5},"sink":{"name":"L_QUANTITY","type":"Decimal","physicalType":"decimal","scale":2,"precision":15}},{"source":{"type":"String","ordinal":6},"sink":{"name":"L_EXTENDEDPRICE","type":"Decimal","physicalType":"decimal","scale":2,"precision":15}},{"source":{"type":"String","ordinal":7},"sink":{"name":"L_DISCOUNT","type":"Decimal","physicalType":"decimal","scale":2,"precision":15}},{"sink":{"name":"L_TAX","type":"Decimal","physicalType":"decimal","scale":2,"precision":15}},{"sink":{"name":"L_RETURNFLAG","type":"String","physicalType":"char"}},{"sink":{"name":"L_LINESTATUS","type":"String","physicalType":"char"}},{"sink":{"name":"L_SHIPDATE","type":"DateTime","physicalType":"date"}},{"sink":{"name":"L_COMMITDATE","type":"DateTime","physicalType":"date"}},{"sink":{"name":"L_RECEIPTDATE","type":"DateTime","physicalType":"date"}},{"sink":{"name":"L_SHIPINSTRUCT","type":"String","physicalType":"char"}},{"sink":{"name":"L_SHIPMODE","type":"String","physicalType":"char"}},{"sink":{"name":"L_COMMENT","type":"String","physicalType":"varchar"}}]')
, (3, 'NATION', '[{"source":{"type":"String","ordinal":1},"sink":{"name":"N_NATIONKEY","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":2},"sink":{"name":"N_NAME","type":"String","physicalType":"char"}},{"source":{"type":"String","ordinal":3},"sink":{"name":"N_REGIONKEY","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":4},"sink":{"name":"N_COMMENT","type":"String","physicalType":"varchar"}}]')
, (4, 'ORDERS', '[{"source":{"type":"String","ordinal":1},"sink":{"name":"O_ORDERKEY","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":2},"sink":{"name":"O_CUSTKEY","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":3},"sink":{"name":"O_ORDERSTATUS","type":"String","physicalType":"char"}},{"source":{"type":"String","ordinal":4},"sink":{"name":"O_TOTALPRICE","type":"Decimal","physicalType":"decimal","scale":2,"precision":15}},{"source":{"type":"String","ordinal":5},"sink":{"name":"O_ORDERDATE","type":"DateTime","physicalType":"date"}},{"source":{"type":"String","ordinal":6},"sink":{"name":"O_ORDERPRIORITY","type":"String","physicalType":"char"}},{"source":{"type":"String","ordinal":7},"sink":{"name":"O_CLERK","type":"String","physicalType":"char"}},{"sink":{"name":"O_SHIPPRIORITY","type":"Int32","physicalType":"int"}},{"sink":{"name":"O_COMMENT","type":"String","physicalType":"varchar"}}]')
, (5, 'PART', '[{"source":{"type":"String","ordinal":1},"sink":{"name":"P_PARTKEY","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":2},"sink":{"name":"P_NAME","type":"String","physicalType":"varchar"}},{"source":{"type":"String","ordinal":3},"sink":{"name":"P_MFGR","type":"String","physicalType":"char"}},{"source":{"type":"String","ordinal":4},"sink":{"name":"P_BRAND","type":"String","physicalType":"char"}},{"source":{"type":"String","ordinal":5},"sink":{"name":"P_TYPE","type":"String","physicalType":"varchar"}},{"source":{"type":"String","ordinal":6},"sink":{"name":"P_SIZE","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":7},"sink":{"name":"P_CONTAINER","type":"String","physicalType":"char"}},{"sink":{"name":"P_RETAILPRICE","type":"Decimal","physicalType":"decimal","scale":2,"precision":15}},{"sink":{"name":"P_COMMENT","type":"String","physicalType":"varchar"}}]')
, (6, 'PARTSUPP', '[{"source":{"type":"String","ordinal":1},"sink":{"name":"PS_PARTKEY","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":2},"sink":{"name":"PS_SUPPKEY","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":3},"sink":{"name":"PS_AVAILQTY","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":4},"sink":{"name":"PS_SUPPLYCOST","type":"Decimal","physicalType":"decimal","scale":2,"precision":15}},{"source":{"type":"String","ordinal":5},"sink":{"name":"PS_COMMENT","type":"String","physicalType":"varchar"}}]')
, (7, 'REGION', '[{"source":{"type":"String","ordinal":1},"sink":{"name":"R_REGIONKEY","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":2},"sink":{"name":"R_NAME","type":"String","physicalType":"char"}},{"source":{"type":"String","ordinal":3},"sink":{"name":"R_COMMENT","type":"String","physicalType":"varchar"}}]')
, (8, 'SUPPLIER', '[{"source":{"type":"String","ordinal":1},"sink":{"name":"S_SUPPKEY","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":2},"sink":{"name":"S_NAME","type":"String","physicalType":"char"}},{"source":{"type":"String","ordinal":3},"sink":{"name":"S_ADDRESS","type":"String","physicalType":"varchar"}},{"source":{"type":"String","ordinal":4},"sink":{"name":"S_NATIONKEY","type":"Int32","physicalType":"int"}},{"source":{"type":"String","ordinal":5},"sink":{"name":"S_PHONE","type":"String","physicalType":"char"}},{"source":{"type":"String","ordinal":6},"sink":{"name":"S_ACCTBAL","type":"Decimal","physicalType":"decimal","scale":2,"precision":15}},{"source":{"type":"String","ordinal":7},"sink":{"name":"S_COMMENT","type":"String","physicalType":"varchar"}}]')

/* VALIDATE JSON */
select *
from #metadata_config_table
where isjson(mappings) = 0

/* ready to init metadata configs*/
go
Declare @id int;
Declare @max int;
Declare @i int =1;

Declare @folder varchar(200) = '1g/data'
Declare @file varchar(200)
Declare @sch varchar(20)  = 'g1'
Declare @tbl varchar(200)   
Declare @mps varchar(2000)   

select @max = count(1) from #metadata_config_table;

WHILE @i<= @max
BEGIN
     print @i;

    select @file = LOWER(a.name) + '.tbl', 
           @tbl = a.name,
           @mps = a.mappings
    from #metadata_config_table a
    where id=@i

    INSERT INTO mddr.CopyData ([src_blob_folder], [src_blob_path], [tgt_db_schema], [tgt_db_table])
    Values (@folder , @file, @sch, @tbl )

    set @id = @@identity
	
    /* 还原成结构化的数据， 方便修改*/
    INSERT INTO mddr.CopyDataMappings
    SELECT @id,src_type,src_ordinal,sink_name,sink_type,sink_physical_type
    FROM OPENJSON(@mps)
    WITH
      (
        src_type varchar(10) '$.source.type',
        src_ordinal varchar(10) '$.source.ordinal',
        sink_name varchar(50) '$.sink.name',
        sink_type varchar(20) '$.sink.type',
        sink_physical_type varchar(20) '$.sink.physicalType'
      )
 
    SET @i += 1
END

  