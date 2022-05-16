CREATE TABLE [mddr].[CopyData]
(
	[copy_data_id] INT IDENTITY(1,1) NOT NULL ,
	[src_blob_folder] nvarchar(200) NOT NULL,
	[src_blob_path] nvarchar(200) NOT NULL,
	[tgt_db_schema] varchar(10) NOT NULL,
	[tgt_db_table] varchar(100) NOT NULL, 
    CONSTRAINT [PK_CopyData] PRIMARY KEY ([copy_data_id]),
)
