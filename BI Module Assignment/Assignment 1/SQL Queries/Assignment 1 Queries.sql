-- q1a
 SELECT 
 		CONCAT(UPPER(ed.EventName), '-', ed.EventYear) AS [Event Name],
		pd.PromotionType,
		md.MarketeerName,
		ROUND(SUM(COALESCE(ef.PromotionRevenue, 0) - COALESCE(ef.PromotionCost, 0)), 0) AS [Total Promotion Profit], 
--     Ranks by TPP within each grouping set
    RANK() OVER (
        PARTITION BY 
            CASE 
					WHEN ed.EventName IS NOT NULL AND ed.EventYear IS NOT NULL AND pd.PromotionType IS NULL AND md.MarketeerName IS NULL THEN 'Event'
					WHEN pd.PromotionType IS NOT NULL AND ed.EventName IS NULL AND md.MarketeerName IS NULL THEN 'PromotionType'
					WHEN md.MarketeerName IS NOT NULL AND ed.EventName IS NULL AND pd.PromotionType IS NULL THEN 'Marketeer'
					WHEN ed.EventName IS NOT NULL AND ed.EventYear IS NOT NULL AND pd.PromotionType IS NOT NULL AND md.MarketeerName IS NULL 
					THEN 'Event + Promotion'
					WHEN ed.EventName IS NOT NULL AND ed.EventYear IS NOT NULL AND md.MarketeerName IS NOT NULL AND pd.PromotionType IS NULL 
					THEN 'Event + Marketeer'
					WHEN pd.PromotionType IS NOT NULL AND md.MarketeerName IS NOT NULL AND ed.EventName IS NULL THEN 'PromotionType + Marketeer'
					WHEN ed.EventName IS NOT NULL AND ed.EventYear IS NOT NULL AND pd.PromotionType IS NOT NULL AND md.MarketeerName IS NOT NULL 
					THEN 'Event + Promotion + Marketeer'
			END
		ORDER BY SUM(COALESCE(ef.PromotionRevenue, 0) - COALESCE(ef.PromotionCost, 0)) DESC
    			) AS [TPP RankWithinGroup],
    	ROUND(AVG(COALESCE(ef.PromotionRevenue, 0) - COALESCE(ef.PromotionCost, 0)), 0) AS [AVG Promotion Profit],
-- Ranks by APP within each grouping set
    RANK() OVER (
        PARTITION BY 
            CASE 
					WHEN ed.EventName IS NOT NULL AND ed.EventYear IS NOT NULL AND pd.PromotionType IS NULL AND md.MarketeerName IS NULL THEN 'Event'
					WHEN pd.PromotionType IS NOT NULL AND ed.EventName IS NULL AND md.MarketeerName IS NULL THEN 'PromotionType'
					WHEN md.MarketeerName IS NOT NULL AND ed.EventName IS NULL AND pd.PromotionType IS NULL THEN 'Marketeer'
					WHEN ed.EventName IS NOT NULL AND ed.EventYear IS NOT NULL AND pd.PromotionType IS NOT NULL AND md.MarketeerName IS NULL 
					THEN 'Event + Promotion'
					WHEN ed.EventName IS NOT NULL AND ed.EventYear IS NOT NULL AND md.MarketeerName IS NOT NULL AND pd.PromotionType IS NULL 
					THEN 'Event + Marketeer'
					WHEN pd.PromotionType IS NOT NULL AND md.MarketeerName IS NOT NULL AND ed.EventName IS NULL THEN 'PromotionType + Marketeer'
					WHEN ed.EventName IS NOT NULL AND ed.EventYear IS NOT NULL AND pd.PromotionType IS NOT NULL AND md.MarketeerName IS NOT NULL 
					THEN 'Event + Promotion + Marketeer'
			END
		ORDER BY AVG(COALESCE(ef.PromotionRevenue, 0) - COALESCE(ef.PromotionCost, 0)) DESC
   	 		   ) AS [APP RankWithinGroup]
FROM 
	EventDim ed 
	JOIN EventFact ef ON ed.EventID = ef.EventID
	JOIN PromotionDim pd ON ef.PromotionID = pd.PromotionID
	JOIN MarketeerDim md ON pd.MarketeerID = md.MarketeerID
-- Grouping sets for flexible grouping
GROUP BY GROUPING SETS (
					    (ed.EventName, ed.EventYear),
					    (pd.PromotionType),
					    (md.MarketeerName),
					    (ed.EventName, ed.EventYear, pd.PromotionType),
					    (ed.EventName, ed.EventYear, md.MarketeerName),
					    (pd.PromotionType, md.MarketeerName),
					    (ed.EventName, ed.EventYear, pd.PromotionType, md.MarketeerName)
						)
-- Enforcing custom grouping order for clarity
-- 						
ORDER BY 
    CASE 
        WHEN ed.EventName IS NOT NULL AND ed.EventYear IS NOT NULL AND pd.PromotionType IS NULL AND md.MarketeerName IS NULL THEN 1 -- Event Name
		WHEN pd.PromotionType IS NOT NULL AND ed.EventName IS NULL AND md.MarketeerName IS NULL THEN 2 -- PromotionType
		WHEN md.MarketeerName IS NOT NULL AND ed.EventName IS NULL AND pd.PromotionType IS NULL THEN 3 -- Marketeer
		WHEN ed.EventName IS NOT NULL AND ed.EventYear IS NOT NULL AND pd.PromotionType IS NOT NULL AND md.MarketeerName IS NULL THEN 4 -- Event + Promotion
		WHEN ed.EventName IS NOT NULL AND ed.EventYear IS NOT NULL AND md.MarketeerName IS NOT NULL AND pd.PromotionType IS NULL THEN 5 -- Event + Marketeer
		WHEN pd.PromotionType IS NOT NULL AND md.MarketeerName IS NOT NULL AND ed.EventName IS NULL THEN 6 -- PromotionType + Marketeer
		WHEN ed.EventName IS NOT NULL AND ed.EventYear IS NOT NULL AND pd.PromotionType IS NOT NULL AND md.MarketeerName IS NOT NULL 
		THEN 7 -- Event + Promotion + Marketeer
	END, [TPP RankWithinGroup]
;
