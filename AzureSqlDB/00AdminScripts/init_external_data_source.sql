-- step1, MASTER KEY
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '$(dmk_password)';
GO


-- step2, DATABASE SCOPED CREDENTIAL
CREATE DATABASE SCOPED CREDENTIAL MyAzureBlobStorageCredential
 WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
 SECRET = '$(sas)';

GO

-- step3, EXTERNAL DATA SOURCE
CREATE EXTERNAL DATA SOURCE MyAzureBlobStorage
WITH ( TYPE = BLOB_STORAGE,
          LOCATION = '$(blob_location)'
          , CREDENTIAL= MyAzureBlobStorageCredential --> CREDENTIAL is not required if a blob is configured for public (anonymous) access!
);


-- drop External DATA SOURCE MyAzureBlobStorage
-- drop DATABASE SCOPED CREDENTIAL MyAzureBlobStorageCredential
-- drop MASTER KEY