SELECT CONCAT(ed.EventName, '-', ed.EventYear) AS [Event Name], dd.DateValue AS [Event Start Date], dd_end.DateValue AS [Event End Date], DATEDIFF(DAY, dd.DateValue, dd_end.DateValue) AS [Event Duration (Days)], COALESCE(ef.PromotionRevenue, 0) - COALESCE(ef.PromotionCost, 0) AS [Promotion Profit], pd.PromotionType, md.MarketeerName, ef.PromotionDuration
--    RANK() OVER (ORDER BY COALESCE(ef.PromotionRevenue, 0) - COALESCE(ef.PromotionCost, 0) DESC) AS [Profit Rank]
FROM EventDim ed
JOIN DateDim dd ON
ed.EventStartDateID = dd.DateID
JOIN DateDim dd_end ON
ed.EventEndDateID = dd_end.DateID
JOIN EventFact ef ON
ed.EventID = ef.EventID
JOIN PromotionDim pd ON
ef.PromotionID = pd.PromotionID
JOIN MarketeerDim md ON
pd.MarketeerID = md.MarketeerID
ORDER BY [Promotion Profit] DESC;


SELECT 
	CONCAT(ed.EventName,'-', ed.EventYear ) AS [Event Name], 
	pd.PromotionType, 
	md.MarketeerName, 
	ef.PromotionRevenue - ef.PromotionCost AS [Promotion Profit]
FROM EventDim ed
JOIN DateDim dd ON	
ed.EventStartDateID = dd.DateID
JOIN EventFact ef ON
ed.EventID = ef.EventID
JOIN PromotionDim pd ON
ef.PromotionID = pd.promotionID
JOIN MarketeerDim md ON
pd.MarketeerID = md.MarketeerID
ORDER BY [Event Name];

SELECT 
	CONCAT(ed.EventName,'-', ed.EventYear ) AS [Event Name], 
	pd.PromotionType, 
	md.MarketeerName, 
	AVG(ef.PromotionRevenue - ef.PromotionCost) AS [ AVG Promotion Profit]
FROM EventDim ed
JOIN DateDim dd ON	
ed.EventStartDateID = dd.DateID
JOIN EventFact ef ON
ed.EventID = ef.EventID
JOIN PromotionDim pd ON
ef.PromotionID = pd.promotionID
JOIN MarketeerDim md ON
pd.MarketeerID = md.MarketeerID
GROUP BY CUBE(
		CONCAT(ed.EventName,'-', ed.EventYear ),
		pd.PromotionType, 
		md.MarketeerName);

SELECT 
	CONCAT(ed.EventName,'-', ed.EventYear ) AS [Event Name], 
	pd.PromotionType, 
	md.MarketeerName, 
	ROUND(AVG(ef.PromotionRevenue - ef.PromotionCost),0) AS [ AVG Promotion Profit]
FROM EventDim ed
JOIN DateDim dd ON	
ed.EventStartDateID = dd.DateID
JOIN EventFact ef ON
ed.EventID = ef.EventID
JOIN PromotionDim pd ON
ef.PromotionID = pd.promotionID
JOIN MarketeerDim md ON
pd.MarketeerID = md.MarketeerID
GROUP BY GROUPING SETS
		(
		CONCAT(ed.EventName,'-', ed.EventYear ),
		pd.PromotionType, 
		md.MarketeerName,
		(CONCAT(ed.EventName,'-', ed.EventYear ),pd.PromotionType),
		(CONCAT(ed.EventName,'-', ed.EventYear ),md.MarketeerName),
		(pd.PromotionType,md.MarketeerName),
		(CONCAT(ed.EventName,'-', ed.EventYear ),pd.PromotionType, 	md.MarketeerName)
		)
ORDER BY [ AVG Promotion Profit] DESC;


WITH AvgPromotionProfit AS (
    SELECT 
        CONCAT(ed.EventName, '-', ed.EventYear) AS [Event Name], 
        pd.PromotionType,
        md.MarketeerName, 
        ROUND(AVG(ef.PromotionRevenue - ef.PromotionCost), 0) AS [AVG Promotion Profit]
    FROM 
        EventDim ed
    JOIN 
        DateDim dd ON ed.EventStartDateID = dd.DateID
    JOIN 
        EventFact ef ON ed.EventID = ef.EventID
    JOIN 
        PromotionDim pd ON ef.PromotionID = pd.PromotionID
    JOIN 
        MarketeerDim md ON pd.MarketeerID = md.MarketeerID
    GROUP BY 
        GROUPING SETS (
            (CONCAT(ed.EventName, '-', ed.EventYear)),  -- 1st
            (pd.PromotionType),                          -- 2nd
            (md.MarketeerName),                         -- 3rd
            (CONCAT(ed.EventName, '-', ed.EventYear), pd.PromotionType), -- 4th
            (CONCAT(ed.EventName, '-', ed.EventYear), md.MarketeerName),  -- 5th
            (pd.PromotionType, md.MarketeerName),       -- 6th
            (CONCAT(ed.EventName, '-', ed.EventYear), pd.PromotionType, md.MarketeerName)  -- 7th
        )
)

SELECT * 
FROM AvgPromotionProfit
ORDER BY 
    [AVG Promotion Profit] DESC, 
    [Event Name],                   -- To keep groups defined
    pd.PromotionType,               -- Adjust1
    md.MarketeerName;               -- Adjust2

    
    
 WITH AggregatedData AS (
    SELECT 
        ed.EventName, 
        ed.EventYear, 
        pd.PromotionType, 
        md.MarketeerName, 
        ROUND(AVG(COALESCE(ef.PromotionRevenue, 0) - COALESCE(ef.PromotionCost, 0)), 0) AS [AVG Promotion Profit]
    FROM EventDim ed
    JOIN DateDim dd ON ed.EventStartDateID = dd.DateID
    JOIN EventFact ef ON ed.EventID = ef.EventID
    JOIN PromotionDim pd ON ef.PromotionID = pd.PromotionID
    JOIN MarketeerDim md ON pd.MarketeerID = md.MarketeerID
    GROUP BY GROUPING SETS (
        (ed.EventName, ed.EventYear),
        (pd.PromotionType), 
        (md.MarketeerName),
        (ed.EventName, ed.EventYear, pd.PromotionType),
        (ed.EventName, ed.EventYear, md.MarketeerName),
        (pd.PromotionType, md.MarketeerName),
        (ed.EventName, ed.EventYear, pd.PromotionType, md.MarketeerName)
    )
)
SELECT 
    CONCAT(EventName, '-', EventYear) AS [Event Name], 
    PromotionType, 
    MarketeerName, 
    [AVG Promotion Profit],
    RANK() OVER (PARTITION BY 
                    CASE 
                        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NULL AND MarketeerName IS NULL THEN 'Event'
                        WHEN PromotionType IS NOT NULL AND EventName IS NULL AND MarketeerName IS NULL THEN 'PromotionType'
                        WHEN MarketeerName IS NOT NULL AND EventName IS NULL AND PromotionType IS NULL THEN 'Marketeer'
                        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NOT NULL AND MarketeerName IS NULL THEN 'Event + Promotion'
                        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND MarketeerName IS NOT NULL AND PromotionType IS NULL THEN 'Event + Marketeer'
                        WHEN PromotionType IS NOT NULL AND MarketeerName IS NOT NULL AND EventName IS NULL THEN 'PromotionType + Marketeer'
                        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NOT NULL AND MarketeerName IS NOT NULL THEN 'Event + Promotion + Marketeer'
                    END
                ORDER BY [AVG Promotion Profit] DESC) AS RankWithinGroup
FROM AggregatedData
ORDER BY 
    CASE 
        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NULL AND MarketeerName IS NULL THEN 1
        WHEN PromotionType IS NOT NULL AND EventName IS NULL AND MarketeerName IS NULL THEN 2
        WHEN MarketeerName IS NOT NULL AND EventName IS NULL AND PromotionType IS NULL THEN 3
        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NOT NULL AND MarketeerName IS NULL THEN 4
        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND MarketeerName IS NOT NULL AND PromotionType IS NULL THEN 5
        WHEN PromotionType IS NOT NULL AND MarketeerName IS NOT NULL AND EventName IS NULL THEN 6
        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NOT NULL AND MarketeerName IS NOT NULL THEN 7
    END, 
    RankWithinGroup;

 

    
 WITH AggregatedData AS (
    SELECT 
        ed.EventName, 
        ed.EventYear, 
        pd.PromotionType, 
        md.MarketeerName, 
        ROUND(AVG(COALESCE(ef.PromotionRevenue, 0) - COALESCE(ef.PromotionCost, 0)), 0) AS [AVG Promotion Profit]
    FROM EventDim ed
    JOIN DateDim dd ON ed.EventStartDateID = dd.DateID
    JOIN EventFact ef ON ed.EventID = ef.EventID
    JOIN PromotionDim pd ON ef.PromotionID = pd.PromotionID
    JOIN MarketeerDim md ON pd.MarketeerID = md.MarketeerID
    GROUP BY GROUPING SETS (
        (ed.EventName, ed.EventYear),
        (pd.PromotionType), 
        (md.MarketeerName),
        (ed.EventName, ed.EventYear, pd.PromotionType),
        (ed.EventName, ed.EventYear, md.MarketeerName),
        (pd.PromotionType, md.MarketeerName),
        (ed.EventName, ed.EventYear, pd.PromotionType, md.MarketeerName)
    )
)
SELECT 
    CONCAT(EventName, '-', EventYear) AS [Event Name], 
    PromotionType, 
    MarketeerName, 
    [AVG Promotion Profit]
--    RANK() OVER (PARTITION BY 
--                    CASE 
--                        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NULL AND MarketeerName IS NULL THEN 'Event'
--                        WHEN PromotionType IS NOT NULL AND EventName IS NULL AND MarketeerName IS NULL THEN 'PromotionType'
--                        WHEN MarketeerName IS NOT NULL AND EventName IS NULL AND PromotionType IS NULL THEN 'Marketeer'
--                        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NOT NULL AND MarketeerName IS NULL THEN 'Event + Promotion'
--                        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND MarketeerName IS NOT NULL AND PromotionType IS NULL THEN 'Event + Marketeer'
--                        WHEN PromotionType IS NOT NULL AND MarketeerName IS NOT NULL AND EventName IS NULL THEN 'PromotionType + Marketeer'
--                        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NOT NULL AND MarketeerName IS NOT NULL THEN 'Event + Promotion + Marketeer'
--                    END
--                ORDER BY [AVG Promotion Profit] DESC) AS RankWithinGroup
FROM AggregatedData
ORDER BY 
    CASE 
        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NULL AND MarketeerName IS NULL THEN 1
        WHEN PromotionType IS NOT NULL AND EventName IS NULL AND MarketeerName IS NULL THEN 2
        WHEN MarketeerName IS NOT NULL AND EventName IS NULL AND PromotionType IS NULL THEN 3
        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NOT NULL AND MarketeerName IS NULL THEN 4
        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND MarketeerName IS NOT NULL AND PromotionType IS NULL THEN 5
        WHEN PromotionType IS NOT NULL AND MarketeerName IS NOT NULL AND EventName IS NULL THEN 6
        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NOT NULL AND MarketeerName IS NOT NULL THEN 7
    END;


 
SELECT 
    CONCAT(ed.EventName, '-', ed.EventYear) AS [Event Name], 
    pd.PromotionType, 
    md.MarketeerName, 
    ROUND(SUM(ef.PromotionRevenue - ef.PromotionCost), 0) AS [Total Promotion Profit],
    ROUND(AVG(ef.PromotionRevenue - ef.PromotionCost), 0) AS [Avg Promotion Profit],
    GROUPING(CONCAT(ed.EventName, '-', ed.EventYear)) AS EventGroup,
    GROUPING(pd.PromotionType) AS PromotionGroup,
    GROUPING(md.MarketeerName) AS MarketeerGroup
FROM EventDim ed
JOIN DateDim dd ON ed.EventStartDateID = dd.DateID
JOIN EventFact ef ON ed.EventID = ef.EventID
JOIN PromotionDim pd ON ef.PromotionID = pd.PromotionID
JOIN MarketeerDim md ON pd.MarketeerID = md.MarketeerID
GROUP BY GROUPING SETS
    (
        (CONCAT(ed.EventName, '-', ed.EventYear)),  -- 1️⃣ By Event (Most General)
        (pd.PromotionType),  -- 2️⃣ By Promotion Type
        (md.MarketeerName),  -- 3️⃣ By Marketeer
        (CONCAT(ed.EventName, '-', ed.EventYear), pd.PromotionType),  -- 4️⃣ By Event + Promotion Type
        (CONCAT(ed.EventName, '-', ed.EventYear), md.MarketeerName),  -- 5️⃣ By Event + Marketeer
        (pd.PromotionType, md.MarketeerName),  -- 6️⃣ By Promotion Type + Marketeer
        (CONCAT(ed.EventName, '-', ed.EventYear), pd.PromotionType, md.MarketeerName)  -- 7️⃣ By Event + Promotion Type + Marketeer (Most Specific)
    )
ORDER BY 
    EventGroup DESC,  -- Events first
    PromotionGroup DESC,  -- Then Promotion Types
    MarketeerGroup DESC,  -- Then Marketeers
    [Total Promotion Profit] DESC;  -- Finally, order each category by Total Profit


SELECT 
    CONCAT(ed.EventName, '-', ed.EventYear) AS [Event Name], 
    pd.PromotionType, 
    md.MarketeerName, 
    ROUND(SUM(ef.PromotionRevenue - ef.PromotionCost), 0) AS [Total Promotion Profit],
    ROUND(AVG(ef.PromotionRevenue - ef.PromotionCost), 0) AS [Avg Promotion Profit]
FROM EventDim ed
JOIN DateDim dd ON ed.EventStartDateID = dd.DateID
JOIN EventFact ef ON ed.EventID = ef.EventID
JOIN PromotionDim pd ON ef.PromotionID = pd.PromotionID
JOIN MarketeerDim md ON pd.MarketeerID = md.MarketeerID
GROUP BY GROUPING SETS
    (
        (CONCAT(ed.EventName, '-', ed.EventYear)),  -- By Event
        (pd.PromotionType),  -- By Promotion Type
        (md.MarketeerName),  -- By Marketeer
        (CONCAT(ed.EventName, '-', ed.EventYear), pd.PromotionType),  -- By Event + Promotion Type
        (CONCAT(ed.EventName, '-', ed.EventYear), md.MarketeerName),  -- By Event + Marketeer
        (pd.PromotionType, md.MarketeerName),  -- By Promotion Type + Marketeer
        (CONCAT(ed.EventName, '-', ed.EventYear), pd.PromotionType, md.MarketeerName)  -- By Event + Promotion Type + Marketeer
    )
ORDER BY 
	[Total Promotion Profit] DESC,
    [Avg Promotion Profit] DESC  -- Rank by Average Profit First
    ;  -- If average is the same, rank by Total Profit


    
       
 WITH AggregatedData AS (
    SELECT 
        ed.EventName, 
        ed.EventYear, 
        pd.PromotionType, 
        md.MarketeerName, 
        ROUND(AVG(COALESCE(ef.PromotionRevenue, 0) - COALESCE(ef.PromotionCost, 0)), 0) AS [AVG Promotion Profit],
        ROUND(SUM(COALESCE(ef.PromotionRevenue, 0) - COALESCE(ef.PromotionCost, 0)), 0) AS [Total Promotion Profit]
    FROM EventDim ed
    JOIN DateDim dd ON ed.EventStartDateID = dd.DateID
    JOIN EventFact ef ON ed.EventID = ef.EventID
    JOIN PromotionDim pd ON ef.PromotionID = pd.PromotionID
    JOIN MarketeerDim md ON pd.MarketeerID = md.MarketeerID
    GROUP BY GROUPING SETS (
        (ed.EventName, ed.EventYear),
        (pd.PromotionType), 
        (md.MarketeerName),
        (ed.EventName, ed.EventYear, pd.PromotionType),
        (ed.EventName, ed.EventYear, md.MarketeerName),
        (pd.PromotionType, md.MarketeerName),
        (ed.EventName, ed.EventYear, pd.PromotionType, md.MarketeerName)
    )
)
SELECT 
    CONCAT(UPPER(EventName), '-', EventYear) AS [Event Name], 
    PromotionType, 
    MarketeerName, 
    [Total Promotion Profit],
       RANK() OVER (PARTITION BY 
                    CASE 
                        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NULL AND MarketeerName IS NULL THEN 'Event'
                        WHEN PromotionType IS NOT NULL AND EventName IS NULL AND MarketeerName IS NULL THEN 'PromotionType'
                        WHEN MarketeerName IS NOT NULL AND EventName IS NULL AND PromotionType IS NULL THEN 'Marketeer'
                        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NOT NULL AND MarketeerName IS NULL THEN 'Event + Promotion'
                        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND MarketeerName IS NOT NULL AND PromotionType IS NULL THEN 'Event + Marketeer'
                        WHEN PromotionType IS NOT NULL AND MarketeerName IS NOT NULL AND EventName IS NULL THEN 'PromotionType + Marketeer'
                        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NOT NULL AND MarketeerName IS NOT NULL THEN 'Event + Promotion + Marketeer'
                    END
                ORDER BY [Total Promotion Profit] DESC) AS [TPP RankWithinGroup],
    [AVG Promotion Profit],
    RANK() OVER (PARTITION BY 
                    CASE 
                        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NULL AND MarketeerName IS NULL THEN 'Event'
                        WHEN PromotionType IS NOT NULL AND EventName IS NULL AND MarketeerName IS NULL THEN 'PromotionType'
                        WHEN MarketeerName IS NOT NULL AND EventName IS NULL AND PromotionType IS NULL THEN 'Marketeer'
                        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NOT NULL AND MarketeerName IS NULL THEN 'Event + Promotion'
                        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND MarketeerName IS NOT NULL AND PromotionType IS NULL THEN 'Event + Marketeer'
                        WHEN PromotionType IS NOT NULL AND MarketeerName IS NOT NULL AND EventName IS NULL THEN 'PromotionType + Marketeer'
                        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NOT NULL AND MarketeerName IS NOT NULL THEN 'Event + Promotion + Marketeer'
                    END
                ORDER BY [AVG Promotion Profit] DESC) AS [APP RankWithinGroup]
FROM AggregatedData
ORDER BY 
    CASE 
        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NULL AND MarketeerName IS NULL THEN 1
        WHEN PromotionType IS NOT NULL AND EventName IS NULL AND MarketeerName IS NULL THEN 2
        WHEN MarketeerName IS NOT NULL AND EventName IS NULL AND PromotionType IS NULL THEN 3
        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NOT NULL AND MarketeerName IS NULL THEN 4
        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND MarketeerName IS NOT NULL AND PromotionType IS NULL THEN 5
        WHEN PromotionType IS NOT NULL AND MarketeerName IS NOT NULL AND EventName IS NULL THEN 6
        WHEN EventName IS NOT NULL AND EventYear IS NOT NULL AND PromotionType IS NOT NULL AND MarketeerName IS NOT NULL THEN 7
    END, 
    [TPP RankWithinGroup];
 
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
				WHEN ed.EventName IS NOT NULL AND ed.EventYear IS NOT NULL AND pd.PromotionType IS NOT NULL AND md.MarketeerName IS NULL THEN 'Event + Promotion'
				WHEN ed.EventName IS NOT NULL AND ed.EventYear IS NOT NULL AND md.MarketeerName IS NOT NULL AND pd.PromotionType IS NULL THEN 'Event + Marketeer'
				WHEN pd.PromotionType IS NOT NULL AND md.MarketeerName IS NOT NULL AND ed.EventName IS NULL THEN 'PromotionType + Marketeer'
				WHEN ed.EventName IS NOT NULL AND ed.EventYear IS NOT NULL AND pd.PromotionType IS NOT NULL AND md.MarketeerName IS NOT NULL THEN 'Event + Promotion + Marketeer'
			END
		ORDER BY SUM(COALESCE(ef.PromotionRevenue, 0) - COALESCE(ef.PromotionCost, 0)) DESC
    ) AS [TPP RankWithinGroup],
    	ROUND(AVG(COALESCE(ef.PromotionRevenue, 0) - COALESCE(ef.PromotionCost, 0)), 0) AS [AVG Promotion Profit],
-- Ranks by APP within each grouping set
    RANK() OVER (
        PARTITION BY 
            CASE 
                WHEN ed.EventName IS NOT NULL
AND ed.EventYear IS NOT NULL
AND pd.PromotionType IS NULL
AND md.MarketeerName IS NULL THEN 'Event'
WHEN pd.PromotionType IS NOT NULL
AND ed.EventName IS NULL
AND md.MarketeerName IS NULL THEN 'PromotionType'
WHEN md.MarketeerName IS NOT NULL
AND ed.EventName IS NULL
AND pd.PromotionType IS NULL THEN 'Marketeer'
WHEN ed.EventName IS NOT NULL
AND ed.EventYear IS NOT NULL
AND pd.PromotionType IS NOT NULL
AND md.MarketeerName IS NULL THEN 'Event + Promotion'
WHEN ed.EventName IS NOT NULL
AND ed.EventYear IS NOT NULL
AND md.MarketeerName IS NOT NULL
AND pd.PromotionType IS NULL THEN 'Event + Marketeer'
WHEN pd.PromotionType IS NOT NULL
AND md.MarketeerName IS NOT NULL
AND ed.EventName IS NULL THEN 'PromotionType + Marketeer'
WHEN ed.EventName IS NOT NULL
AND ed.EventYear IS NOT NULL
AND pd.PromotionType IS NOT NULL
AND md.MarketeerName IS NOT NULL THEN 'Event + Promotion + Marketeer'
END
ORDER BY AVG(COALESCE(ef.PromotionRevenue, 0) - COALESCE(ef.PromotionCost, 0)) DESC
    ) AS [APP RankWithinGroup]
FROM EventDim ed
JOIN DateDim dd ON
ed.EventStartDateID = dd.DateID
JOIN EventFact ef ON
ed.EventID = ef.EventID
JOIN PromotionDim pd ON
ef.PromotionID = pd.PromotionID
JOIN MarketeerDim md ON
pd.MarketeerID = md.MarketeerID
-- Grouping sets for flexible grouping
GROUP BY GROUPING SETS (
    (ed.EventName, ed.EventYear),
-- 1️⃣ By Event
    (pd.PromotionType),
-- 2️⃣ By PromotionType
    (md.MarketeerName),
-- 3️⃣ By Marketeer
    (ed.EventName, ed.EventYear, pd.PromotionType),
-- 4️⃣ By Event + PromotionType
    (ed.EventName, ed.EventYear, md.MarketeerName),
-- 5️⃣ By Event + Marketeer
    (pd.PromotionType, md.MarketeerName),
-- 6️⃣ By PromotionType + Marketeer
    (ed.EventName, ed.EventYear, pd.PromotionType, md.MarketeerName)
-- 7️⃣ By Event + Promotion + Marketeer
)
-- Enforcing custom grouping order
ORDER BY 
    CASE 
        WHEN ed.EventName IS NOT NULL
AND ed.EventYear IS NOT NULL
AND pd.PromotionType IS NULL
AND md.MarketeerName IS NULL THEN 1
-- Event Name
WHEN pd.PromotionType IS NOT NULL
AND ed.EventName IS NULL
AND md.MarketeerName IS NULL THEN 2
-- PromotionType
WHEN md.MarketeerName IS NOT NULL
AND ed.EventName IS NULL
AND pd.PromotionType IS NULL THEN 3
-- Marketeer
WHEN ed.EventName IS NOT NULL
AND ed.EventYear IS NOT NULL
AND pd.PromotionType IS NOT NULL
AND md.MarketeerName IS NULL THEN 4
-- Event + Promotion
WHEN ed.EventName IS NOT NULL
AND ed.EventYear IS NOT NULL
AND md.MarketeerName IS NOT NULL
AND pd.PromotionType IS NULL THEN 5
-- Event + Marketeer
WHEN pd.PromotionType IS NOT NULL
AND md.MarketeerName IS NOT NULL
AND ed.EventName IS NULL THEN 6
-- PromotionType + Marketeer
WHEN ed.EventName IS NOT NULL
AND ed.EventYear IS NOT NULL
AND pd.PromotionType IS NOT NULL
AND md.MarketeerName IS NOT NULL THEN 7
-- Event + Promotion + Marketeer
END, [TPP RankWithinGroup];
