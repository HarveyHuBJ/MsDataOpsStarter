﻿/*
AUTHOR      : HARVEY HU
CREATED ON  : 2022-5-10
DESCRIPITION: 以blob的tbl文件作为数据源，初始化表数据
  Args :  @stg  int  表示不同的数据阶段 分别为 1/10/100/其他(dbo), 对应的schema分别是 g1/g10/g100/dbo
*/
CREATE PROCEDURE [common].[usp_InitTables]
	@stg int = 0
AS
BEGIN

	IF @stg = 1
	BEGIN
		TRUNCATE TABLE g1.customer ;
		TRUNCATE TABLE g1.nation   ;
		TRUNCATE TABLE g1.part     ;
		TRUNCATE TABLE g1.partsupp ;
		TRUNCATE TABLE g1.region   ;
		TRUNCATE TABLE g1.supplier ;
		TRUNCATE TABLE g1.[order]  ;
		TRUNCATE TABLE g1.lineitem ;

		BULK INSERT g1.customer FROM '1g\data\customer.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g1.nation   FROM '1g\data\nation.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g1.part     FROM '1g\data\part.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g1.partsupp FROM '1g\data\partsupp.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g1.region   FROM '1g\data\region.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g1.supplier FROM '1g\data\supplier.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g1.[order]  FROM '1g\data\order.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g1.lineitem FROM '1g\data\lineitem.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
	END
	ELSE IF @stg = 10
	BEGIN
		TRUNCATE TABLE g10.customer ;
		TRUNCATE TABLE g10.nation   ;
		TRUNCATE TABLE g10.part     ;
		TRUNCATE TABLE g10.partsupp ;
		TRUNCATE TABLE g10.region   ;
		TRUNCATE TABLE g10.supplier ;
		TRUNCATE TABLE g10.[order]  ;
		TRUNCATE TABLE g10.lineitem ;

		BULK INSERT g10.customer FROM '10g\data\customer.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g10.nation   FROM '10g\data\nation.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g10.part     FROM '10g\data\part.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g10.partsupp FROM '10g\data\partsupp.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g10.region   FROM '10g\data\region.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g10.supplier FROM '10g\data\supplier.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g10.[order]  FROM '10g\data\order.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g10.lineitem FROM '10g\data\lineitem.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
	END

	ELSE IF @stg = 100
	BEGIN
	    TRUNCATE TABLE g100.customer ;
		TRUNCATE TABLE g100.nation   ;
		TRUNCATE TABLE g100.part     ;
		TRUNCATE TABLE g100.partsupp ;
		TRUNCATE TABLE g100.region   ;
		TRUNCATE TABLE g100.supplier ;
		TRUNCATE TABLE g100.[order]  ;
		TRUNCATE TABLE g100.lineitem ;

		BULK INSERT g100.customer FROM '100g\data\customer.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g100.nation   FROM '100g\data\nation.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g100.part     FROM '100g\data\part.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g100.partsupp FROM '100g\data\partsupp.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g100.region   FROM '100g\data\region.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g100.supplier FROM '100g\data\supplier.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g100.[order]  FROM '100g\data\order.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT g100.lineitem FROM '100g\data\lineitem.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
	END

	ELSE  
	BEGIN
		TRUNCATE TABLE dbo.customer ;
		TRUNCATE TABLE dbo.nation   ;
		TRUNCATE TABLE dbo.part     ;
		TRUNCATE TABLE dbo.partsupp ;
		TRUNCATE TABLE dbo.region   ;
		TRUNCATE TABLE dbo.supplier ;
		TRUNCATE TABLE dbo.[order]  ;
		TRUNCATE TABLE dbo.lineitem ;

		BULK INSERT dbo.customer FROM '0d1g\data\customer.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT dbo.nation   FROM '0d1g\data\nation.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT dbo.part     FROM '0d1g\data\part.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT dbo.partsupp FROM '0d1g\data\partsupp.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT dbo.region   FROM '0d1g\data\region.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT dbo.supplier FROM '0d1g\data\supplier.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT dbo.[order]  FROM '0d1g\data\order.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
		BULK INSERT dbo.lineitem FROM '0d1g\data\lineitem.tbl' WITH ( DATA_SOURCE = 'MyAzureBlobStorage' , FIELDTERMINATOR ='|' , ROWTERMINATOR ='|\n' ); 
	END

RETURN 0
END
