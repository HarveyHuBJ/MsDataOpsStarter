# CICD 说明
## 1. Data In Git

这里主要指的是在代码中管理的数据，通常包括但不限于：

* 测试数据
* 配置数据



需要将这些数据发布到Azure Blob ， 或者再进一步初始化到SQL Server中。

![data-movement](.\readme-imgs\dataingit.png)

### 参考命令

~~~bash
azcopy -s \00Data\ -d blob 
~~~

~~~sql
-- step1, MASTER KEY
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'YourStrongPassword1';
GO


-- step2, DATABASE SCOPED CREDENTIAL
CREATE DATABASE SCOPED CREDENTIAL MyAzureBlobStorageCredential
 WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
 SECRET = 'sv=2020-08-04&ss=b&srt=sco&sp=rlx&se=2022-11-16T10:52:56Z&st=2022-05-16T02:52:56Z&spr=https&sig=1KOzQoEnbfowWNqSER9YzO%2F9NEdkP%2BYgRpNp%2FKVkCV8%3D';

 -- NOTE: Make sure that you don't have a leading ? in SAS token
GO


-- step3, EXTERNAL DATA SOURCE
CREATE EXTERNAL DATA SOURCE MyAzureBlobStorage
WITH ( TYPE = BLOB_STORAGE,
          LOCATION = 'https://{your storage account}.blob.core.windows.net/{root_folder}'
          , CREDENTIAL= MyAzureBlobStorageCredential --> CREDENTIAL is not required if a blob is configured for public (anonymous) access!
);

-- step 1-3 execute only once at the first time!


-- step4, truncate and bulk insert
TRUNCATE TABLE g1.lineitem ;
BULK INSERT g1.lineitem FROM '1g\data\lineitem.tbl' 
WITH ( 
    DATA_SOURCE = 'MyAzureBlobStorage' , 
    FIELDTERMINATOR ='|' , 
    ROWTERMINATOR ='|\n' 
); 


~~~



### 参考文档

1. azcopy
2. bulk insert from blob

