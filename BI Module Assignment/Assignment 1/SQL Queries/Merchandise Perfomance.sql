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
