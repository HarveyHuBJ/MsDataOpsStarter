

-- category mappings
-- #1 , telecom_churn.csv
-- #2 , weights_heights.csv

SET NOCOUNT ON;

IF CHARINDEX('#1', '$(files)')>0 or '$(files)'='all'
BEGIN
    PRINT 'Reloading [Lab].[telecom_churn] data.'
    TRUNCATE TABLE Lab.telecom_churn;
    BULK INSERT Lab.telecom_churn FROM '$(root)/telecom_churn.csv' WITH ( DATA_SOURCE = '$(name)BlobStorage' , FORMAT = 'CSV',		FIELDTERMINATOR =',' ,	 firstrow=2 ,	ROWTERMINATOR ='0x0a' ); 
END
GO

  
IF CHARINDEX('#2', '$(files)')>0 or '$(files)'='all'
BEGIN
    PRINT 'Reloading [Lab].[weights_heights] data.'
    TRUNCATE TABLE Lab.weights_heights;
    BULK INSERT Lab.weights_heights FROM '$(root)/weights_heights.csv' WITH ( DATA_SOURCE = '$(name)BlobStorage' , FORMAT = 'CSV',		FIELDTERMINATOR =',' ,	 firstrow=2 ,	ROWTERMINATOR ='0x0a'); 
END

PRINT 'Reloading completed.'

