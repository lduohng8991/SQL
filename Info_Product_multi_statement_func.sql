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
	--ElementIndex INT,
    --ElementValue VARCHAR(MAX)
	-- so on... --
)
AS BEGIN
-- indexing the delimiter by assigning row numbers --
    WITH PositionDelimiter AS (
        SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS Position -- assure the NULL value if possibly --
        FROM STRING_SPLIT(@InputColumn, '~') -- split the input column by 'delimiter'
    )
       
    -- sampling the data into the resulted table --
    INSERT INTO @ElementTable (Element_1, Element_2, Element_3, Element_4, Element_5,
                              Element_6, Element_7, Element_8, Element_9, Element_10,
                              Element_11, Element_12, Element_13, Element_14, Element_15
							  --ElementIndex INT,
							  --ElementValue VARCHAR(MAX)
								)
                             
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
 -- CREATE A PROCEDURE contained desired table WITHIN 'ExtractTextBeforeQuotator' INSIDE
SELECT Pur_PurchaseId AS First_PurchaseId, Old_PurchaseId, Pur_Panelistnum, Pur_YPW_on_extract, 
		Ref_Item_Code AS First_Ref_Item_Code,  
		Pur_Category, 
		Pur_Units, Pur_Price, Pur_Shop, QA1, QA2, Promotion, 
		Weekday, PurchaseDate, Pur_Panel,
		Pur_isdeleted
INTO #AC35 FROM AC35
GO

SELECT Pur_PurchaseId AS Second_PurchaseId, 
		Pur_Productname 
INTO #purchase FROM purchase
GO

SELECT Ref_Item_Code AS Second_Ref_Item_Code, 
		Ref_att01, Ref_att02, Ref_att03, Ref_att04, Ref_att05, 
		Ref_att06, Ref_att07, Ref_att08, Ref_att09, Ref_att10, Ref_att11, 
		ATV_Des01, ATV_Des03, ATV_Des04, ATV_Des05, ATV_Des06, ATV_Des07, ATV_Des10
INTO #STF_RefATV FROM STF_RefATV
GO

SELECT Cat_Code, Cat_Description 
INTO #Category FROM Category
GO

SELECT * 
INTO #Localid FROM Localid
GO

SELECT Outlet_name, outlet_code 
INTO #Outlet_K FROM Outlet_K
GO

SELECT * 
INTO #promotion_table FROM promotion_table
GO

SELECT DD_Id, DD_PanelistNum, DD_DiaryType, DD_LoginUser 
INTO #DiaryData FROM DiaryData
GO

-- create a procedure with making sure there is only one desired table 
CREATE PROCEDURE InfoProduct_proc	@Info_id       VARCHAR(50),
									@wantresultset BIT = 0 AS
   IF OBJECT_ID('tempdb..#InfoProduct') IS  NULL 
   BEGIN
      CREATE TABLE #InfoProduct (First_PurchaseId		VARCHAR(50) NOT NULL PRIMARY KEY,
								 Old_PurchaseId			VARCHAR(50) NOT NULL, 
								 Npan					VARCHAR(50), 
								 Region					VARCHAR(50), 
								 Panel					VARCHAR(10), 
								 [Year]					SMALLDATETIME, 
								 [Period]				SMALLINT, 
								 [Week]					SMALLINT, 
								 [yyyy-mm-dd]			DATE, 
								 DayInWeek				VARCHAR(10), 
								 Category				VARCHAR(10), 
								 Cat_Description		VARCHAR(50), 
								 Brand					VARCHAR(50), 
								 Variants				VARCHAR(50), 
								 E04					VARCHAR(50), 
								 E05					VARCHAR(50), 
								 E06					VARCHAR(50), 
								 E07					VARCHAR(50), 
								 Units					VARCHAR(10), 
								 Price					VARCHAR(10), 
								 QA1					VARCHAR(10), 
								 QA2					VARCHAR(10), 
								 Weights_on_Package		VARCHAR(10), 
								 Outlet_Code			VARCHAR(10), 
								 Outlet					VARCHAR(50), 
								 Promotion_Code			VARCHAR(10), 
								 Promotion_Label		VARCHAR(50), 
								 First_Ref_Item_Code	VARCHAR(50), 
								 Pur_Productname		VARCHAR(255), 
								 Pur_isdeleted			VARCHAR(10),
								 E1						VARCHAR(10), 
								 E2						VARCHAR(10), 
								 E3						VARCHAR(10), 
								 E4						VARCHAR(10), 
								 E5						VARCHAR(10), 
								 E6						VARCHAR(10), 
								 VARIANT_CODE			VARCHAR(10), 
								 BRAND_CODE				VARCHAR(10), 
								 Type_Punching			VARCHAR(10), 
								 Latest_Login_User		VARCHAR(30)
													)
   END

   INSERT #InfoProduct (First_PurchaseId,
						Old_PurchaseId, 
						Npan, 
						Region, 
						Panel, 
						[Year], 
						[Period], 
						[Week], 
						[yyyy-mm-dd], 
						DayInWeek, 
						Category, 
						Cat_Description, 
						Brand, 
						Variants, 
						E04, 
						E05, 
						E06, 
						E07, 
						Units, 
						Price, 
						QA1, 
						QA2, 
						Weights_on_Package, 
						Outlet_Code, 
						Outlet, 
						Promotion_Code, 
						Promotion_Label, 
						First_Ref_Item_Code, 
						Pur_Productname, 
						Pur_isdeleted, 
						E1, 
						E2, 
						E3, 
						E4, 
						E5, 
						E6, 
						VARIANT_CODE,		-- add if needed -- 
						BRAND_CODE, 		-- add if needed -- 
						Type_Punching,		-- add if needed -- 
						Latest_Login_User	-- add if needed -- 
								)

		-- your data been proceed --
		SELECT [First_PurchaseId], [Old_PurchaseId], 
				LEFT(Pur_Panelistnum, 7) AS [Npan], [Region], [Pur_Panel], 
				LEFT(Pur_YPW_on_extract, 4) AS [Pur_year], 
				SUBSTRING(Pur_YPW_on_extract, 5, 2) AS [Period], 
				RIGHT(Pur_YPW_on_extract, 1) AS [Week], 
				CONVERT(DATE, CONVERT(VARCHAR, PurchaseDate), 111) AS [yyyy-mm-dd], 
				DATENAME(WEEKDAY, CONVERT(VARCHAR, PurchaseDate)) AS [DayInWeek], 
				Pur_Category AS [Category], [Cat_Description], 
										 
				( SELECT Element_3 
				  FROM #purchase 
				  CROSS APPLY dbo.ExtractTextBeforeQuotator(Pur_ProductName) ) 
				AS [Brand],
				( SELECT Element_4 
				  FROM #purchase 
				  CROSS APPLY dbo.ExtractTextBeforeQuotator(Pur_ProductName) )
				AS [Variants], -- column's name might be changed due to the diversity in the orginal data 

				ATV_Des04 AS [E04], ATV_Des05 AS [E05], ATV_Des06 AS [E06], ATV_Des07 AS [E07],  

				Pur_Units AS [Units], Pur_Price AS [Price], 
				[QA1], QA2/1000 AS [QA2], ( QA1/ (QA2/1000) ) AS [Weights_on_Package],
				
				Pur_Shop AS [Outlet_Code], Outlet_name AS [Outlet],

				Promotion AS [Promotion_Code],
				CASE WHEN Promotion = 1 THEN '.No'
					WHEN Promotion = 2 THEN 'YES'
					WHEN Promotion = 3 THEN 'Price Off (giảm giá)'
					WHEN Promotion = 4 THEN 'Additional Volume (tăng thêm khối lượng)'
					WHEN Promotion = 5 THEN 'Redeemable Coupon (tặng Coupon)'
					WHEN Promotion = 6 THEN 'Loyalty Program (Tích Lũy/ Khách hàng thân thiết)'
					WHEN Promotion = 7 THEN 'Buy 1/Multi  get 1 free (mua 1/nhiều được tặng 1)'
					WHEN Promotion = 8 THEN 'Gift (quà tặng thông thường)'
					WHEN Promotion = 9 THEN 'Contest / Lottery ( Thẻ Cào / Xổ số trúng thưởng)'
					WHEN Promotion = 10 THEN 'Sampling (sản phẩm dùng thử)'
					WHEN Promotion = 11 THEN 'Gifted Purchase (mua 1sp được tặng 1sp khác loại)'
					WHEN Promotion = 12 THEN 'Others (khuyến mãi khác)'
					WHEN Promotion = 13 THEN 'Bundle pack (Sản Phẩm Bán Gộp)'
				ELSE 'NULL'
				END AS [Promotion_Label],

				[First_Ref_Item_Code],
				[Pur_Productname], 

				[Pur_isdeleted],
			   
				CASE WHEN LEN(Ref_att01) IS NULL THEN '00000'
					ELSE Ref_att01 + REPLICATE('0',5-LEN(Ref_att01)) 
				END AS [E1], 
				CASE WHEN LEN(Ref_att02) IS NULL THEN '00000'
					ELSE Ref_att02 + REPLICATE('0',5-LEN(Ref_att02)) 
				END AS [E2], 
				CASE WHEN LEN(Ref_att03) IS NULL THEN '00000'
					ELSE Ref_att03 + REPLICATE('0',5-LEN(Ref_att03)) 
				END AS [E3], 
				CASE WHEN LEN(Ref_att04) IS NULL THEN '00000'
					ELSE Ref_att04 + REPLICATE('0',5-LEN(Ref_att04)) 
				END AS [E4], 
				CASE WHEN LEN(Ref_att05) IS NULL THEN '00000'
					ELSE Ref_att05 + REPLICATE('0',5-LEN(Ref_att05)) 
				END AS [E5], 
				CASE WHEN LEN(Ref_att06) IS NULL THEN '00000'
					ELSE Ref_att06 + REPLICATE('0',5-LEN(Ref_att06)) 
				END AS [E6], 

				( Pur_Category + REPLICATE('0',5-LEN(Pur_Category)) 
				+ Ref_att01 + REPLICATE('0',5-LEN(Ref_att01))
				+ Ref_att03 + REPLICATE('0',5-LEN(Ref_att03)) ) 
				AS [VARIANT_CODE],
				( Pur_Category + REPLICATE('0',5-LEN(Pur_Category)) 
				+ Ref_att01 + REPLICATE('0',5-LEN(Ref_att01)) ) 
				AS [BRAND_CODE],

				DD_DiaryType AS [Type_Punching], DD_LoginUser AS [Latest_Login_User]

	FROM ( 
			SELECT *
			FROM #AC35	JOIN #purchase			ON #AC35.First_PurchaseId = #purchase.Second_PurchaseId
						JOIN #STF_RefATV		ON #AC35.First_Ref_Item_Code = #STF_RefATV.Second_Ref_Item_Code
						JOIN #Category			ON #AC35.Pur_Category = #Category.Cat_Code
						JOIN #Localid			ON #AC35.Pur_Panelistnum = #Localid.IndividualId
						JOIN #Outlet_K			ON #AC35.Pur_Shop = #Outlet_K.outlet_code
						JOIN #promotion_table	ON #AC35.Promotion = #promotion_table.Promotion_Code
						JOIN #DiaryData			ON #AC35.Pur_Panelistnum = #DiaryData.DD_PanelistNum 
		) AS Joins
	-- Alternatively, columns could be specified to be more facilitated & confusion-avoided --
	-- SELECT #AC35.First_PurchaseId,
	--		#AC35.Old_PurchaseId,
	--		#AC35.Pur_Panelistnum, 
	--			...
	--	FROM #AC35 JOIN #purchase				ON ...
	--			...																			
	-- ) AS Joins

	IF @wantresultset = 1
      SELECT * 
	  FROM #InfoProduct
GO
-- convoluted temp table into a new procedure with the existing procedure been created
CREATE PROCEDURE InfoProduct @Info_id VARCHAR(30) AS
   EXEC InfoProduct_proc @Info_id, 1
GO

-- delete after use
DROP PROCEDURE InfoProduct_proc
DROP PROCEDURE InfoProduct
-- in any case DROP TABLE #InfoProduct --
;


