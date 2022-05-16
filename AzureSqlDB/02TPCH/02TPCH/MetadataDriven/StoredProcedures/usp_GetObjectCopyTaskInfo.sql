/*
 * AUTHOR      : HARVEY HU
 * CREATED ON  : 2022-5-10
 * DESCRIPITION: 根据对象名称， 获取COPY DATA的任务参数， 包括mapping信息
*/

CREATE PROCEDURE [dbo].[usp_GetObjectCopyTaskInfo]
	@schemaName varchar(200) ,
	@objectName varchar(200) 
AS
	
 select 
    a.[src_blob_folder] as [folder],
	a.[src_blob_path] as [file],
	translator = JSON_MODIFY (
		(select 
			src_type as 'source.type',
			src_ordinal as 'source.ordinal',
			sink_name as 'sink.name',
			sink_type as 'sink.type',
			sink_physical_type as 'sink.physicalType'
		 from mddr.CopyDataMappings m
		 where m.copy_data_id = a.copy_data_id
		 for json path, root('mappings')),
		 '$.type', 'TabularTranslator')

 from mddr.copydata a
 where a.[tgt_db_table] = @objectName
 and a.[tgt_db_schema] = @schemaName
  
RETURN 0
