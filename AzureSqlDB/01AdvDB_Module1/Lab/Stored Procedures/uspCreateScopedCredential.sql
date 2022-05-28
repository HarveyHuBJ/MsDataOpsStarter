-- =========================
-- Author		: Harvey Hu
-- Created on	: 2022-5-25
-- Description	: 创建外部数据源的凭据， 例如使用SAS访问blob
-- =========================
CREATE PROCEDURE [lab].[uspCreateScopedCredential]
	@cred_name VARCHAR(100),  -- CREDENTIAL name
	@secret VARCHAR(100), -- the SECRET, 如果是SAS， 则如'sv=2020-08-04&ss=b&....3D'
	@identity VARCHAR(100) = 'SHARED ACCESS SIGNATURE'  -- the IDENTITY
AS
BEGIN
SET  nocount  ON;

-- 是否需要创建DMK(Database Master Key)， 并且将password 保存
if not exists (select top 1 * from sys.symmetric_keys)
begin
	DECLARE @command_create_dmk varchar(MAX);
	DECLARE @newkey char(16) =  substring('!p1'+ replace( newid(),'-',''),1,16)
	
	if object_id('dbo.sys_masterkey') is not null
		DROP TABLE dbo.sys_masterkey

	select  @newkey		as MasterKey, 
			getdate()	as CreatedTime
	into dbo.sys_masterkey

	SET @command_create_dmk = CONCAT(
		'CREATE MASTER KEY ENCRYPTION BY PASSWORD = ''' , @newkey, ''''
		);
	EXECUTE (@command_create_dmk);
end

DECLARE @command_create_cred varchar(MAX);
SET @command_create_cred = CONCAT(
'CREATE DATABASE SCOPED CREDENTIAL ', @cred_name ,' WITH ',
	'IDENTITY = '''+ @identity + ''',' ,
	'SECRET = '''+ @secret+ ''''
	)

EXECUTE (@command_create_cred);
PRINT  'Scoped Credential Created.';
END
