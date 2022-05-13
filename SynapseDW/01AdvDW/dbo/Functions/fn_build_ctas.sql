CREATE FUNCTION dbo.fn_build_ctas
(@name VARCHAR (200), @structure VARCHAR (MAX))
RETURNS VARCHAR (MAX)
AS
BEGIN
    DECLARE @result AS VARCHAR (MAX);
    SELECT @result = concat('create table dbo.', @name, ' (
	', string_agg(CAST (dbo.fn_build_col(colName, colType) AS VARCHAR (MAX)), ','), '
   )')
    FROM   OPENJSON (@structure) WITH (colName VARCHAR (200) '$.name', colType VARCHAR (200) '$.type');
    RETURN @result;
END

