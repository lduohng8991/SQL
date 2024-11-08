SELECT Pur_PurchaseId AS First_PurchaseId, Old_PurchaseId, Pur_Panelistnum, Pur_YPW_on_extract, 
		Ref_Item_Code AS First_Ref_Item_Code,  
		Pur_Category, 
		Pur_Units, Pur_Price, Pur_Shop, QA1, QA2, Promotion, 
		Weekday, PurchaseDate, Pur_Panel,
		Pur_isdeleted
INTO #AC35 FROM AC35
--WHERE LEFT(Pur_YPW_on_extract, 4) = 2023 -- might consider running in one year --
GO

SELECT Pur_PurchaseId, Pur_Productname 
INTO #purchase FROM purchase
GO

SELECT Ref_Item_Code, 
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

SELECT * 
INTO #Outlet_K FROM Outlet_K
GO

SELECT * 
INTO #promotion_table FROM promotion_table
GO

-- create a procedure with making sure there is only one desired table 
CREATE PROCEDURE InfoProduct_proc	@Trans_id       VARCHAR(50),
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
								 E1						VARCHAR(10), 
								 E2						VARCHAR(10), 
								 E3						VARCHAR(10), 
								 E4						VARCHAR(10), 
								 E5						VARCHAR(10), 
								 E6						VARCHAR(10), 
								 VARIANT_CODE			VARCHAR(10), 
								 BRAND_CODE				VARCHAR(10)
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
						E1, 
						E2, 
						E3, 
						E4, 
						E5, 
						E6 
						-- VARIANT_CODE,	-- add if needed
						-- BRAND_CODE		-- add if needed	
								)

		-- your data --
		SELECT [First_PurchaseId], [Old_PurchaseId], 
				LEFT(Pur_Panelistnum, 7) AS [Npan], [Region], [Pur_Panel], 
				LEFT(Pur_YPW_on_extract, 4) AS [Pur_year], 
				SUBSTRING(Pur_YPW_on_extract, 5, 2) AS [Period], 
				RIGHT(Pur_YPW_on_extract, 1) AS [Week], 
				CONVERT(DATE, CONVERT(VARCHAR,PurchaseDate), 111) AS [yyyy-mm-dd], 
				DATENAME(WEEKDAY, CONVERT(VARCHAR,PurchaseDate)) AS [DayInWeek], 
				Pur_Category AS [Category], [Cat_Description], 
										 
				SUBSTRING( Pur_ProductName, 
						CHARINDEX('~', Pur_ProductName, CHARINDEX('~', Pur_ProductName)+1 ), 
						-- dấu '~ đầu tiên' + 1 dể lấy chuỗi bắt đầu dấu từ '~ thứ hai'	--																
						( CHARINDEX('~', Pur_ProductName, CHARINDEX('~', Pur_ProductName, CHARINDEX('~', Pur_ProductName)+1) +1)  -
						CHARINDEX('~', Pur_ProductName, CHARINDEX('~', Pur_ProductName, CHARINDEX('~', Pur_ProductName)+1) -1) )
						--ký tự cần cắt cho brand (lenghth of '~ thứ hai' đổ về hết - 
						--						   lenghth of '~ thứ hai')--								
												)	AS [Brand],

				ATV_Des03							AS [Variants], -- might be extracted string further
				ATV_Des04 AS [E04], ATV_Des05 AS [E05], ATV_Des06 AS [E06], ATV_Des07 AS [E07],  
				Pur_Units AS [Units], Pur_Price AS [Price], 
				[QA1], QA2/1000 AS [QA2], ( QA1/ (QA2/1000) ) AS [Weights_on_Package],
				Pur_Shop AS [Outlet_Code], Outlet_name AS [Outlet],
				Promotion AS [Promotion_Code],
				[First_Ref_Item_Code],
				[Pur_Productname], 
				[Pur_isdeleted],
			   
				CASE WHEN LEN(Ref_att01) = 1 THEN '0000' + CAST(Ref_att01 AS VARCHAR) 
					WHEN LEN(Ref_att01) = 3 THEN '00' + CAST(Ref_att01 AS VARCHAR) 
					WHEN LEN(Ref_att01) = 4 THEN '0' + CAST(Ref_att01 AS VARCHAR) 
				END AS [E1], 
				CASE WHEN LEN(Ref_att02) = 1 THEN '0000' + CAST(Ref_att02 AS VARCHAR) 
					WHEN LEN(Ref_att02) = 2 THEN '000' + CAST(Ref_att02 AS VARCHAR) 
					WHEN LEN(Ref_att02) = 3 THEN '00' + CAST(Ref_att02 AS VARCHAR) 
					WHEN LEN(Ref_att02) = 4 THEN '0' + CAST(Ref_att02 AS VARCHAR) 
				END AS [E2], 
				CASE WHEN LEN(Ref_att03) = 1 THEN '0000' + CAST(Ref_att03 AS VARCHAR) 
					WHEN LEN(Ref_att03) = 2 THEN '000' + CAST(Ref_att03 AS VARCHAR) 
					WHEN LEN(Ref_att03) = 3 THEN '00' + CAST(Ref_att03 AS VARCHAR) 
					WHEN LEN(Ref_att03) IS NULL  THEN '00000'
				END AS [E3], 
				CASE WHEN LEN(Ref_att04) = 1 THEN '0000' + CAST(Ref_att04 AS VARCHAR) 
					WHEN LEN(Ref_att04) = 2 THEN '000' + CAST(Ref_att04 AS VARCHAR) 
					WHEN LEN(Ref_att04) IS NULL  THEN '00000' 
				END AS [E4], 
				CASE WHEN LEN(Ref_att05) = 1 THEN '0000' + CAST(Ref_att05 AS VARCHAR) 
					WHEN LEN(Ref_att05) = 2 THEN '000' + CAST(Ref_att05 AS VARCHAR) 
					WHEN LEN(Ref_att05) IS NULL  THEN '00000' 
				END AS [E5], 
				CASE WHEN LEN(Ref_att06) = 1 THEN '0000' + CAST(Ref_att06 AS VARCHAR) 
					WHEN LEN(Ref_att06) = 2 THEN '000' + CAST(Ref_att06 AS VARCHAR) 
					WHEN LEN(Ref_att06) IS NULL  THEN '00000' 
					END AS [E6]

FROM ( SELECT * FROM #AC35 JOIN #purchase			ON #AC35.First_PurchaseId = #purchase.Pur_PurchaseId
							JOIN #STF_RefATV		ON #AC35.First_Ref_Item_Code = #STF_RefATV.Ref_Item_Code
							JOIN #Category			ON #AC35.Pur_Category = #Category.Cat_Code
							JOIN #Localid			ON #AC35.Pur_Panelistnum = #Localid.IndividualId
							JOIN #Outlet_K			ON #AC35.Pur_Shop = #Outlet_K.outlet_code
							JOIN #promotion_table	ON #AC35.Promotion = #promotion_table.Promotion_Code) AS jjj

	IF @wantresultset = 1
      SELECT * 
	  FROM #InfoProduct
GO
-- convoluted temp table into a new procedure with the existing procedure been created
CREATE PROCEDURE InfoProduct @Trans_id VARCHAR(30) AS
   EXEC InfoProduct_proc @Trans_id, 1
GO

-- delete after use
DROP PROCEDURE InfoProduct_proc
DROP PROCEDURE InfoProduct
-- DROP TABLE #InfoProduct -- in any cases
;


