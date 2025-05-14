----------------------------- 
-- Factors Influencing EVENTS and Spectators

-- Overview game dim
SELECT *
FROM GameDim gd ;

-- Overview game fact
SELECT *
FROM GameFact gf
ORDER BY
	EventID
	, GameID;

-- Overview event fact
SELECT *
FROM EventFact ef ;

-- Overview event dim
SELECT *
FROM EventDim ed ;

-- Overview promotion dim
SELECT *
FROM PromotionDim pd;

-- Overview marketeer dim
SELECT *
FROM MarketeerDim md ;


-- Overview ticket dim
SELECT *
FROM TicketDim td
--ORDER BY td.TicketType, td.TicketEvent
 ;


-- Find out number of promotions each marketer has done
SELECT pd.MarketeerID ,md.MarketeerName , count(pd.MarketeerID) AS [Number of Promotions]
FROM PromotionDim pd JOIN MarketeerDim md ON pd.MarketeerID = md.MarketeerID
GROUP BY pd.MarketeerID, md.MarketeerName
ORDER BY count(pd.MarketeerID) DESC;


-- Find out number of 
SELECT DISTINCT pd.MarketeerID,md.MarketeerName, pd.PromotionType 
FROM PromotionDim pd
JOIN MarketeerDim md ON
pd.MarketeerID = md.MarketeerID
order by pd.MarketeerID, pd.PromotionType
;

SELECT DISTINCT 
	ed.EventID, 
	dd.DateValue , 
	CONCAT(ed.EventName, 
	ed.EventYear ) AS [Event Name], 
	ed.EventEndDateID - ed.EventStartDateID AS [Event Duration], 
	ef.PromotionRevenue - ef.PromotionCost AS [Promotion Profit], 
	pd.PromotionType, 
	md.MarketeerName , 
	ef.PromotionDuration
FROM EventDim ed
JOIN DateDim dd ON	
ed.EventStartDateID = dd.DateID
JOIN EventFact ef ON
ed.EventID = ef.EventID
JOIN PromotionDim pd ON
ef.PromotionID = pd.promotionID
JOIN MarketeerDim md ON
pd.MarketeerID = md.MarketeerID
ORDER BY [Promotion Profit] ;

-- cg variant
SELECT
    CONCAT(ed.EventName, '-', ed.EventYear) AS [Event Name], 
    dd.DateValue AS [Event Start Date], 
    dd_end.DateValue AS [Event End Date], 
    DATEDIFF(DAY, dd.DateValue, dd_end.DateValue) AS [Event Duration (Days)], 
    COALESCE(ef.PromotionRevenue, 0) - COALESCE(ef.PromotionCost, 0) AS [Promotion Profit], 
    pd.PromotionType, 
    md.MarketeerName, 
    ef.PromotionDuration,
    RANK() OVER (ORDER BY COALESCE(ef.PromotionRevenue, 0) - COALESCE(ef.PromotionCost, 0) DESC) AS [Profit Rank]
FROM EventDim ed
JOIN DateDim dd ON ed.EventStartDateID = dd.DateID
JOIN DateDim dd_end ON ed.EventEndDateID = dd_end.DateID  -- Added JOIN for event end date
JOIN EventFact ef ON ed.EventID = ef.EventID
JOIN PromotionDim pd ON ef.PromotionID = pd.PromotionID
JOIN MarketeerDim md ON pd.MarketeerID = md.MarketeerID
ORDER BY [Promotion Profit] DESC;


