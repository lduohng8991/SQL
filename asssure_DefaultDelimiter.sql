-- Method 1 --
CREATE FUNCTION dbo.AssureDefaultDelimiter(@buffer VARCHAR(MAX), @pattern VARCHAR(255)) 
RETURNS VARCHAR(MAX) AS
BEGIN
    DECLARE @pos INT = PATINDEX(@pattern, @buffer)
    WHILE @pos > 0 BEGIN
        SET @buffer = STUFF(@buffer, @pos, 1, '_') -- 'deletes' a part of a string then 'inserts' delimiter '_' into the string --
        SET @pos = PATINDEX(@pattern, @buffer)
    END
    RETURN @buffer
END

GO
-- // In use //--
-- SELECT your_column, 
--		CAST( dbo.AssureDefaultDelimiter('your_column', '%[ -()]%') AS VARCHAR ) AS column_has_been_changed
-- FROM your_table (optional)

-------------------------------------------------------------------------------------------------------------------------------------

-- Method 2 --
DECLARE @string VARCHAR(100) = 'your_text';
DECLARE @new_delimiter VARCHAR(10) = '_'; -- default delimiter

SELECT STRING_AGG(value, @new_delimiter) AS replaced_string
FROM STRING_SPLIT(@string, '%[ -()#.,=<>]/\|%');
