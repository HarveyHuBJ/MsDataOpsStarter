

-- category mappings
-- #1 , telecom_churn.csv
-- #2 , mlbootcamp5_train.csv
-- #3 , weights_heights.csv

IF CHARINDEX('#1', '$(files)')>0 or '$(files)'='all'
BEGIN
    TRUNCATE TABLE Lab.telecom_churn
    BULK INSERT Lab.telecom_churn FROM '$(root)/telecom_churn.csv' WITH ( DATA_SOURCE = '$(name)BlobStorage' , FORMAT = 'CSV',		FIELDTERMINATOR =',' ,	 firstrow=2 ,	ROWTERMINATOR ='0x0a' ); 
END

BEGIN
IF CHARINDEX('#2', '$(files)')>0 or '$(files)'='all'
    TRUNCATE TABLE Lab.mlbootcamp5_train
    BULK INSERT Lab.mlbootcamp5_train FROM '$(root)/mlbootcamp5_train.csv' WITH ( DATA_SOURCE = '$(name)BlobStorage' ,FORMAT = 'CSV',		FIELDTERMINATOR =',' ,	 firstrow=2 ,	ROWTERMINATOR ='0x0a' ); 
END

BEGIN
IF CHARINDEX('#3', '$(files)')>0 or '$(files)'='all'
    TRUNCATE TABLE Lab.weights_heights
    BULK INSERT Lab.weights_heights FROM '$(root)/weights_heights.csv' WITH ( DATA_SOURCE = '$(name)BlobStorage' , FORMAT = 'CSV',		FIELDTERMINATOR =',' ,	 firstrow=2 ,	ROWTERMINATOR ='0x0a'); 
END