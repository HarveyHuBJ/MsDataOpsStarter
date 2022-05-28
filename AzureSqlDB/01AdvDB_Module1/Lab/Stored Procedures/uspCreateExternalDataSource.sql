-- =========================
-- Author		: Harvey Hu
-- Created on	: 2022-5-25
-- Description	: 从外部数据源中，重新加载数据
-- =========================
CREATE PROCEDURE [lab].[uspCreateExternalDataSource]
	@ds_name nvarchar(50) ,
	@cred_name nvarchar(100) ,
	@ds_location  nvarchar(1000)  -- eg. 'https://myaccnt.blob.core.windows.net/mycontainer'
AS
SET  nocount  ON;

DECLARE @command_create_ds varchar(MAX);
SET @command_create_ds = CONCAT(
'CREATE EXTERNAL DATA SOURCE ', @ds_name,
'WITH ( TYPE = BLOB_STORAGE ,',
'          LOCATION = ''',@ds_location,''',' ,
'          CREDENTIAL= ', @cred_name  
);

EXECUTE (@command_create_ds);
PRINT  'EXTERNAL DATA SOURCE Created.';
RETURN 0
