-- LoF Revenue

SELECT 
    DISTINCT ef.EventID,  
    ef.TicketsSoldPND AS Value, 
    dd.DateValue AS EventStart,
    ed.EventYear,
    'Ticket Revenue' AS Category
FROM EventFact ef
JOIN EventDim ed ON ef.EventID = ed.EventID
JOIN datedim dd ON ed.EventStartDateID = dd.DateID


UNION ALL

SELECT 
    EventID, Value,  EventStart, EventYear, Category
FROM (
    SELECT DISTINCT  
        ef.EventID, 
        ef.MerchandiseID,  -- Preserved to differentiate multiple merch entries
        ef.MerchandiseSold AS Value, 
		dd.DateValue AS EventStart,
		ed.EventYear,
        'Merchandise Revenue' AS Category
    FROM EventFact ef
    JOIN EventDim ed ON ef.EventID = ed.EventID
    JOIN datedim dd ON ed.EventStartDateID = dd.DateID
) AS MerchSub

UNION ALL

SELECT 
    EventID, Value, EventStart, EventYear, Category
FROM (
    SELECT DISTINCT  
        ef.EventID, 
        ef.PromotionID,  -- Preserved to differentiate multiple promo entries
        ef.PromotionRevenue AS Value, 
		dd.DateValue AS EventStart,
		ed.EventYear,
        'Promotion Revenue' AS Category
    FROM EventFact ef
    JOIN EventDim ed ON ef.EventID = ed.EventID
    JOIN datedim dd ON ed.EventStartDateID = dd.DateID
) AS PromoSub;


-- LoF Prize Pool

SELECT ad.AwardEventID, dd.DateValue, ed.EventName, ed.EventYear, ad.AwardValueInPND
FROM AwardDim ad
JOIN EventDim ed ON
ad.AwardEventID = ed.EventID
JOIN DateDim dd ON
ed.EventEndDateID = dd.DateID 
ORDER BY dd.DateValue ;