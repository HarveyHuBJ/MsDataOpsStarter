-- step1, MASTER KEY
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'YourStrongPassword1';
GO


-- step2, DATABASE SCOPED CREDENTIAL
CREATE DATABASE SCOPED CREDENTIAL MyAzureBlobStorageCredential
 WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
 SECRET = 'sv=2020-08-04&ss=b&srt=sco&sp=rlx&se=2022-11-16T10:52:56Z&st=2022-05-16T02:52:56Z&spr=https&sig=1KOzQoEnbfowWNqSER9YzO%2F9NEdkP%2BYgRpNp%2FKVkCV8%3D';

 -- NOTE: Make sure that you don't have a leading ? in SAS token, and
 -- that you have at least read permission on the object that should be loaded srt=o&sp=r, and
 -- that expiration period is valid (all dates are in UTC time)
GO


-- step3, EXTERNAL DATA SOURCE
CREATE EXTERNAL DATA SOURCE MyAzureBlobStorage
WITH ( TYPE = BLOB_STORAGE,
          LOCATION = 'https://adlssalesdemo.blob.core.windows.net/raw-data'
          , CREDENTIAL= MyAzureBlobStorageCredential --> CREDENTIAL is not required if a blob is configured for public (anonymous) access!
);