
CREATE FUNCTION dbo.ExtractTextBeforeQuotator -- table-valued function --
(
 @InputColumn  VARCHAR(MAX)
)
RETURNS @ElementTable TABLE -- using dynamic recursive table method --
(
    Element_1 VARCHAR(MAX), -- might be change the number of parameters due to lack of resources
    Element_2 VARCHAR(MAX),
    Element_3 VARCHAR(MAX),
    Element_4 VARCHAR(MAX),
    Element_5 VARCHAR(MAX),
	Element_6 VARCHAR(MAX),
	Element_7 VARCHAR(MAX),
	Element_8 VARCHAR(MAX),
	Element_9 VARCHAR(MAX),
	Element_10 VARCHAR(MAX),
	Element_11 VARCHAR(MAX),
	Element_12 VARCHAR(MAX),
	Element_13 VARCHAR(MAX),
	Element_14 VARCHAR(MAX),
	Element_15 VARCHAR(MAX)
	-- so on... --
)
AS BEGIN
-- indexing the delimiter by assigning row numbers --
    WITH PositionDelimiter AS (
        SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS Position -- assure th NULL value if possibly --
        FROM STRING_SPLIT(@InputColumn, '~') -- split the input column by the '~' delimiter
    )
       
    -- sampling the data into the resulted table --
    INSERT INTO @ElementTable (Element_1, Element_2, Element_3, Element_4, Element_5,
                              Element_6, Element_7, Element_8, Element_9, Element_10,
                              Element_11, Element_12, Element_13, Element_14, Element_15)
                             
        -- excecute the function by pivoting --
        SELECT
        MAX(CASE WHEN Position = 1 THEN value END) AS Element_1,
        MAX(CASE WHEN Position = 2 THEN value END) AS Element_2,
        MAX(CASE WHEN Position = 3 THEN value END) AS Element_3,
        MAX(CASE WHEN Position = 4 THEN value END) AS Element_4,
        MAX(CASE WHEN Position = 5 THEN value END) AS Element_5,
		MAX(CASE WHEN Position = 6 THEN value END) AS Element_6,
        MAX(CASE WHEN Position = 7 THEN value END) AS Element_7,
        MAX(CASE WHEN Position = 8 THEN value END) AS Element_8,
        MAX(CASE WHEN Position = 9 THEN value END) AS Element_9,
		MAX(CASE WHEN Position = 10 THEN value END) AS Element_10,
		MAX(CASE WHEN Position = 11 THEN value END) AS Element_11,
        MAX(CASE WHEN Position = 12 THEN value END) AS Element_12,
        MAX(CASE WHEN Position = 13 THEN value END) AS Element_13,
        MAX(CASE WHEN Position = 14 THEN value END) AS Element_14,
        MAX(CASE WHEN Position = 15 THEN value END) AS Element_15
    FROM PositionDelimiter;

  -- return the final set of results stored in the 'table-liked' variable --
  RETURN; -- send the results of the function back to the caller
END;
GO

-- apply into your desired column -- ('~' in this case)
SELECT 'your_column' FROM 'your_table'
CROSS APPLY dbo.ExtractTextBeforeQuotator('your_column');
