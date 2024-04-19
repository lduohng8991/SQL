
SELECT Pur_panel, LEFT(Pur_YPW_on_extract, 4) AS [Year],
	   SUM(CASE WHEN [Period] = 01 THEN 1 ELSE 0 END) AS [Period 01], 
	   SUM(CASE WHEN [Period] = 02 THEN 1 ELSE 0 END) AS [Period 02], 
	   SUM(CASE WHEN [Period] = 03 THEN 1 ELSE 0 END) AS [Period 03], 
	   SUM(CASE WHEN [Period] = 04 THEN 1 ELSE 0 END) AS [Period 04], 
	   SUM(CASE WHEN [Period] = 05 THEN 1 ELSE 0 END) AS [Period 05], 
	   SUM(CASE WHEN [Period] = 06 THEN 1 ELSE 0 END) AS [Period 06], 
	   SUM(CASE WHEN [Period] = 07 THEN 1 ELSE 0 END) AS [Period 07], 
	   SUM(CASE WHEN [Period] = 08 THEN 1 ELSE 0 END) AS [Period 08], 
	   SUM(CASE WHEN [Period] = 09 THEN 1 ELSE 0 END) AS [Period 09], 
	   SUM(CASE WHEN [Period] = 10 THEN 1 ELSE 0 END) AS [Period 10], 
	   SUM(CASE WHEN [Period] = 11 THEN 1 ELSE 0 END) AS [Period 11], 
	   SUM(CASE WHEN [Period] = 12 THEN 1 ELSE 0 END) AS [Period 12], 
	   SUM(CASE WHEN [Period] = 13 THEN 1 ELSE 0 END) AS [Period 13],
	   --SUM(CASE WHEN [Period] NOT IN (01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13) THEN 1 ELSE 0 END) AS [WHAT_IS_THIS],
	   --COUNT([Period_NULL]) AS [Period_NULL],
	   COUNT(*) AS [Total]

FROM (
		SELECT Pur_PurchaseId, 
				Pur_panel, pur_Panelistnum, 
				Pur_YPW_on_extract, 
				
				Pur_DateOfEntry, -- which date employee inputs a record --
				SUBSTRING(Pur_YPW_on_extract, 5, 2) AS [Period],
				SUBSTRING(Pur_YPW_on_extract, 7, 1) AS [Week],
				(SELECT Pur_YPW_on_extract FROM purchase WHERE Pur_YPW_on_extract = NULL) AS [Period_NULL],

				Pur_ProductName,
				Pur_Status
		FROM purchase
		WHERE Pur_Delete_Flag = 0
			AND Pur_Category != 88
			AND Pur_UserLogin = 'LaH' -- username --

			AND LEFT(Pur_YPW_on_extract, 4) < 2028 -- in 5 years (from 2022) --
						) AS LCR -- LaH user Counting Records --
GROUP BY Pur_panel, LEFT(Pur_YPW_on_extract, 4); 

	