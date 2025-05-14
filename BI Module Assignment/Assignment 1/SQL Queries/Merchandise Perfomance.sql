select * from OnlineSalesFact osf;
select count(DISTINCT dateID) FROM OnlineSalesFact osf;
select * from MerchandiseDim md;
select * from EventFact ef;
select * from  ProviderDim pd ;
select * from DateDim dd ;
SELECT * FROM GameFact gf JOIN DateDim dd ON gf.DateID = dd.DateID WHERE dd.DateValue = '2016-05-24';
SELECT
	ed.*
	, ddsd.datevalue
	, dded.datevalue
FROM
	EventDim ed
JOIN DateDim ddsd ON
	ed.EventStartDateID = ddsd.DateID
JOIN DateDim dded ON
	ed.EventEndDateID = dded.DateID; 
 
SELECT * FROM PlayerInGameDim pigd ORDER BY playerID;

SELECT count (DISTINCT pigd.PlayerInGameID ), count(pigd.PlayerID) FROM PlayerInGameDim pigd JOIN PlayerDim pd ON pigd.PlayerID = pd.PlayerID


SELECT DISTINCT MerchandiseType FROM (select
	CONVERT(VARCHAR	, dd.DateValue, 107) as [Sales Date]
	, DATENAME(WeekDay, dd.DateValue)[Sales Day]
	, DateName( month , dd.DateValue)[Sales Month]
	, DateName( Year , dd.DateValue)[Sales Year]
	, COUNT(  DISTINCT CASE WHEN osf.DateID = gf.DateID THEN gf.GameID END) AS [No. Of GamesPlayed]
	, COUNT(  DISTINCT CASE WHEN osf.DateID = gf.DateID THEN pigd.PlayerInGameID END) AS [No. Players]
	, md.MerchandiseType
	, pd.ProviderName
	, ld.Country
	,osf.MerchandiseSold 
	, osf.MerchandiseSoldPND
from OnlineSalesFact osf
LEFT join DateDim dd on
	osf.DateID = dd.DateID
left join GameFact gf on
	dd.DateID = gf.DateID
	LEFT JOIN GameDim gd ON gf.GameID = gd.GameID LEFT JOIN PlayerInGameDim pigd ON gd.GameID = pigd.GameID 
left join MerchandiseDim md on
	osf.MerchandiseID = md.MerchandiseID
left join ProviderDim pd on
	md.MerchandiseProviderID = pd.ProviderID
join LocationDim ld on
	pd.ProviderLocation = ld.LocationID
GROUP BY dd.DateValue,  md.MerchandiseType , pd.ProviderName, ld.Country ,osf.MerchandiseSold , osf.MerchandiseSoldPND
--HAVING dd.DateValue  = '2018-10-28'
--ORDER BY [No. Of GamesPlayed] DESC
) a;















-- ds variant


SELECT
    CASE 
        WHEN dd.DateID  BETWEEN ed.EventStartDateID AND ed.EventEndDateID 
        THEN CONCAT(ed.EventName, ' ', YEAR(ed.EventYear)) 
        ELSE 'No Event' 
    END AS EventName,
    CONVERT(VARCHAR, dd.DateValue, 107) AS [Sales Date],
    DATENAME(WeekDay, dd.DateValue) AS [Sales Day],
    DateName(Month, dd.DateValue) AS [Sales Month],
    DateName(Year, dd.DateValue) AS [Sales Year],
    COUNT(DISTINCT CASE WHEN osf.DateID = gf.DateID THEN gf.GameID END) AS [No. Of GamesPlayed],
    COUNT(DISTINCT CASE WHEN osf.DateID = gf.DateID THEN pigd.PlayerInGameID END) AS [No. Players],
    md.MerchandiseType, pd.ProviderName, ld.Country, sum(osf.MerchandiseSold) [MerchSold], sum(osf.MerchandiseSoldPND) [MerchSold(PND)]
FROM OnlineSalesFact osf
LEFT JOIN DateDim dd ON osf.DateID = dd.DateID
LEFT JOIN GameFact gf ON dd.DateID = gf.DateID
LEFT JOIN GameDim gd ON gf.GameID = gd.GameID 
LEFT JOIN PlayerInGameDim pigd ON gd.GameID = pigd.GameID 
LEFT JOIN MerchandiseDim md ON osf.MerchandiseID = md.MerchandiseID
LEFT JOIN ProviderDim pd ON md.MerchandiseProviderID = pd.ProviderID
LEFT JOIN LocationDim ld ON pd.ProviderLocation = ld.LocationID
LEFT JOIN EventDim ed ON dd.DateID  BETWEEN ed.EventStartDateID  AND ed.EventEndDateID 
GROUP BY 
	dd.dateID, ed.EventYear, dd.DateValue, md.MerchandiseType, pd.ProviderName, ld.Country, ed.EventName, ed.EventStartDateID, ed.EventEndDateID
ORDER BY dd.DateValue ; 













WITH SalesData AS (
    SELECT
--    	CASE 
--        	WHEN dd.DateID  BETWEEN ed.EventStartDateID AND ed.EventEndDateID THEN CONCAT(ed.EventName, ' ', YEAR(ed.EventYear)) ELSE 'No Event' 
--    	END AS EventName,
--        CONVERT(VARCHAR, dd.DateValue, 107) AS [Sales Date],
--        DATENAME(WeekDay, dd.DateValue) AS [Sales Day],
--        DateName(Month, dd.DateValue) AS [Sales Month],
--        DateName(Year, dd.DateValue) AS [Sales Year],
--        COUNT(DISTINCT CASE WHEN osf.DateID = gf.DateID THEN gf.GameID END) AS [No. Of GamesPlayed],
--        COUNT(DISTINCT CASE WHEN osf.DateID = gf.DateID THEN pigd.PlayerInGameID END) AS [No. Players],
        md.MerchandiseType,
        pd.ProviderName,
--        ld.Country,
        SUM(osf.MerchandiseSoldPND) AS MerchandiseSoldPND -- Use SUM for aggregation
    FROM OnlineSalesFact osf
    LEFT JOIN DateDim dd ON osf.DateID = dd.DateID
    LEFT JOIN GameFact gf ON dd.DateID = gf.DateID
    LEFT JOIN GameDim gd ON gf.GameID = gd.GameID 
    LEFT JOIN PlayerInGameDim pigd ON gd.GameID = pigd.GameID 
    LEFT JOIN MerchandiseDim md ON osf.MerchandiseID = md.MerchandiseID
    LEFT JOIN ProviderDim pd ON md.MerchandiseProviderID = pd.ProviderID
    LEFT JOIN LocationDim ld ON pd.ProviderLocation = ld.LocationID
    LEFT JOIN EventDim ed ON dd.DateID BETWEEN ed.EventStartDateID AND ed.EventEndDateID 
    GROUP BY 
--    dd.DateValue, 
    md.MerchandiseType, pd.ProviderName 
--    ld.Country, ed.EventName, ed.EventStartDateID, ed.EventEndDateID, dd.dateID, ed.EventYear
)
SELECT 
    [ProviderName],
    COALESCE([Accessories], 0) AS [Accessories],
    COALESCE([Art and Book], 0) AS [Art and Book],
    COALESCE([Board Games], 0) AS [Board Games],
    COALESCE([Clothing], 0) AS [Clothing],
    COALESCE([Figures], 0) AS [Figures],
    COALESCE([Pins], 0) AS [Pins],
    COALESCE([Plush], 0) AS [Plush],
    COALESCE([Statues], 0) AS [Statues]
FROM SalesData
PIVOT (
    SUM(MerchandiseSoldPND)
    FOR MerchandiseType IN ([Accessories], 
                            [Art and Book], 
                            [Board Games], 
                            [Clothing], 
                            [Figures], 
                            [Pins], 
                            [Plush], 
                            [Statues])
) AS PivotTable
ORDER BY [ProviderName];