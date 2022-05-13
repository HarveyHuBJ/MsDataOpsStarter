CREATE   PROCEDURE [dbo].[sp_UpdateTableSpaceInfo]
AS
BEGIN
    IF NOT EXISTS (SELECT *
                   FROM   sysobjects
                   WHERE  id = OBJECT_ID(N'temp_tableSpaceInfo')
                          AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
        BEGIN
            CREATE TABLE temp_tableSpaceInfo (
                name       NVARCHAR (128),
                rows       CHAR (11)     ,
                reserved   VARCHAR (18)  ,
                data       VARCHAR (18)  ,
                index_size VARCHAR (18)  ,
                unused     VARCHAR (18)  
            );
        END
    DELETE temp_tableSpaceInfo;
    DECLARE @tablename AS VARCHAR (255);
    DECLARE table_list_cursor CURSOR
        FOR SELECT   name
            FROM     sysobjects
            WHERE    OBJECTPROPERTY(id, N'IsTable') = 1
                     AND name NOT LIKE N'#%%'
            ORDER BY name;
    OPEN table_list_cursor;
    FETCH NEXT FROM table_list_cursor INTO @tablename;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            IF EXISTS (SELECT *
                       FROM   sysobjects
                       WHERE  id = OBJECT_ID(@tablename)
                              AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
                BEGIN
                    EXECUTE sp_executesql N'INSERT INTO temp_tableSpaceInfo EXEC sp_spaceused @tbname', N'@tbname varchar(255)', @tbname = @tablename;
                END
            FETCH NEXT FROM table_list_cursor INTO @tablename;
        END
    CLOSE table_list_cursor;
    DEALLOCATE table_list_cursor;
    SELECT *
    FROM   temp_tableSpaceInfo;
    DROP TABLE temp_tableSpaceInfo;
END

