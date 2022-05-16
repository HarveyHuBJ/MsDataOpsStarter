CREATE TABLE [mddr].[CopyDataMappings]
(
	[copy_data_id] INT NOT NULL, 
    [src_type] VARCHAR(10) NULL, 
    [src_ordinal] INT NULL, 
    [sink_name] VARCHAR(100) NULL ,
    [sink_type] VARCHAR(100) NULL ,
    [sink_physical_type] VARCHAR(100) NULL ,
)
