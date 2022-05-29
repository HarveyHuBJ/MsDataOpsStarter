
-- PRINT 'SAS is [$(sas)]'
-- ATTENTION : $(sas) cann't correctly get as expected, so PLEASE update your DATABASE SCOPED CREDENTIAL mannually!!!
--  eg.
--     ALTER DATABASE SCOPED CREDENTIAL {YOUR-CRED} WITH IDENTITY = 'SHARED ACCESS SIGNATURE',  SECRET = '{YOUR SAS}';

IF not exists (select top 1 1 from sys.external_data_sources a where name ='$(name)BlobStorage')
BEGIN
    -- step1, MASTER KEY
    IF not exists (select top 1 1 from sys.symmetric_keys)
        CREATE MASTER KEY ENCRYPTION BY PASSWORD = '$(dmk_password)';


    -- step2, DATABASE SCOPED CREDENTIAL
    -- issue, it seems SAS cann't input as a parameter for SAS has some special characters, like '=' , '&'
    IF not exists (select top 1 1 from sys.database_scoped_credentials where name ='$(name)Credential')
        CREATE DATABASE SCOPED CREDENTIAL $(name)Credential
        WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
        SECRET = '$(sas)';



    -- step3, EXTERNAL DATA SOURCE
    CREATE EXTERNAL DATA SOURCE $(name)BlobStorage
    WITH ( TYPE = BLOB_STORAGE,
            LOCATION = '$(blob_location)'
            , CREDENTIAL= $(name)Credential --> CREDENTIAL is not required if a blob is configured for public (anonymous) access!
    );

END
-- drop External DATA SOURCE MyAzureBlobStorage
-- drop DATABASE SCOPED CREDENTIAL MyAzureBlobStorageCredential
-- drop MASTER KEY