USE [DataEntry]
GO

/****** Object:  View [dbo].[code_translate_template]    Script Date: 30-Nov-23 4:22:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER         VIEW [dbo].[code_translate_template] AS 

SELECT B.Pur_PurchaseId, 
	   B.Old_PurchaseId, 
	   B.Npan, B.Region, 
	   B.Pur_Panel AS [Panel],	
	   B.Pur_year AS [Year], B.Period, B.Week, B.[yyyy-mm-dd] AS [yyyy-mm-dd],	B.DayInWeek, 
	   B.Category, B.Cat_Description, B.Brand, 
	   
	   CASE WHEN B.Variants IS NULL THEN 'N/A' ELSE B.Variants END AS [Variants], 

	   CASE WHEN B.E04 IS NULL THEN 'N/A' ELSE B.E04 END AS [E04], 
	   CASE WHEN B.E05 IS NULL THEN 'N/A' ELSE B.E05 END AS [E05], 
	   CASE WHEN B.E06 IS NULL THEN 'N/A' ELSE B.E06 END AS [E06], 
	   CASE WHEN B.E07 IS NULL THEN 'N/A' ELSE B.E07 END AS [E07], 
	   
	   B.Units AS [Units], B.Price AS [Price], B.QA1 AS [QA1], B.QA2 AS [QA2], B.Weights_on_Package AS [Weights_on_Package], 
	   B.Outlet_Code AS [Outlet_Code], B.Outlet AS [Outlet], B.Promotion_Code AS [Promotion_Code], A.Promotion_Label AS [Promotion_Label], 
	   B.Ref_Item_Code AS [Ref_Item_Code], 
	   B.Pur_Productname AS [Pur_Productname], 
	   B.E1 AS [E1], B.E2 AS [E2], B.E3 AS [E3], B.E4 AS [E4], B.E5 AS [E5], B.E6 AS [E6],
	   CONCAT(B.Category, B.E1, B.E3) AS [VARIANT_CODE],  

	   CONCAT(B.Category, B.E1) AS [BRAND_CODE]

FROM promotion_table AS A JOIN (
								SELECT  [Pur_PurchaseId], [Old_PurchaseId], 
										LEFT(Pur_Panelistnum, 7) AS [Npan], [Region], 
										[Pur_Panel], 
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
																	) AS [Brand],

										ATV_Des03 AS [Variants], -- SỬA LẠI Ở ĐÂY
										ATV_Des04 AS [E04], ATV_Des05 AS [E05], ATV_Des06 AS [E06], ATV_Des07 AS [E07],  
										Pur_Units AS [Units], Pur_Price AS [Price], 
										[QA1], QA2/1000 AS [QA2], ( QA1/ (QA2/1000) ) AS [Weights_on_Package],
										Pur_Shop AS [Outlet_Code], Outlet_name AS [Outlet],
										Promotion AS [Promotion_Code],
										[Ref_Item_Code],
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

								FROM (
										( SELECT Ref_Item_Code, 
												Ref_att01, Ref_att02, Ref_att03, Ref_att04, Ref_att05, Ref_att06, Ref_att07, Ref_att08, Ref_att09, Ref_att10, Ref_att11, 
												ATV_Des01, ATV_Des03, ATV_Des04, ATV_Des05, ATV_Des06, ATV_Des07, ATV_Des10,
												Pur_PurchaseId, Old_PurchaseId, Pur_Panelistnum, Pur_YPW_on_extract,  
												Pur_Category, Pur_Units, Pur_Price, Pur_Shop, QA1, QA2, Promotion, Weekday, PurchaseDate, Pur_Panel,
												Pur_isdeleted,
												Pur_Productname, 
												Cat_Description 
										  FROM Category AS C JOIN ( SELECT B.Ref_Item_Code, 
																			Ref_att01, Ref_att02, Ref_att03, Ref_att04, Ref_att05, Ref_att06, Ref_att07, Ref_att08, Ref_att09, Ref_att10, Ref_att11, 
																			ATV_Des01, ATV_Des03, ATV_Des04, ATV_Des05, ATV_Des06, ATV_Des07, ATV_Des10,
																			A.Pur_PurchaseId, Old_PurchaseId, A.Pur_Panelistnum, A.Pur_YPW_on_extract,  
																			A.Pur_Category, A.Pur_Units, A.Pur_Price, A.Pur_Shop, QA1, QA2, Promotion, A.Weekday, A.PurchaseDate, A.Pur_Panel,
																			Pur_isdeleted,
																			Pur_Productname
																	FROM STF_RefATV AS B JOIN ( SELECT A.Pur_PurchaseId, Old_PurchaseId, A.Pur_Panelistnum, A.Pur_YPW_on_extract, Ref_Item_Code,  
																										A.Pur_Category, A.Pur_Units, A.Pur_Price, A.Pur_Shop, QA1, QA2, Promotion, A.Weekday, A.PurchaseDate, A.Pur_Panel,
																										Pur_Productname,
																										Pur_isdeleted
																								FROM AC35 AS A JOIN purchase AS P 
																												ON A.Old_PurchaseId = P.Pur_PurchaseId ) AS A

															  ON B.Ref_Item_Code = A.Ref_Item_Code ) AS AB

						   ON C.Cat_Code = AB.Pur_Category ) AS ABC JOIN Outlet_K AS K
																	 ON K.outlet_code = ABC.Pur_Shop 
																	JOIN Localid ON ABC.Pur_Panelistnum = Localid.IndividualId ) 
																	
																					) AS B 
						ON B.promotion_code= A.Promotion_Code



WHERE B.Pur_isdeleted = 0 
			AND B.Pur_year > YEAR(GETDATE()) - 3 ;


						 



GO


