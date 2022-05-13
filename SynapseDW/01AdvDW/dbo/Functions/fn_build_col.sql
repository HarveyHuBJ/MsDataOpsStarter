CREATE FUNCTION dbo.fn_build_col
(@colName VARCHAR (200), @colType VARCHAR (200))
RETURNS VARCHAR (MAX)
AS
BEGIN
    RETURN concat(@colName, ' ', CASE WHEN @colType = 'string' THEN 'nvarchar(2000)' WHEN @colType = 'datetime' THEN 'datetime' WHEN @colType = 'double' THEN 'decimal(20,6)' WHEN @colType = 'int32' THEN 'int' WHEN @colType = 'boolean' THEN 'bit' ELSE 'nvarchar(2000)' END);
END

