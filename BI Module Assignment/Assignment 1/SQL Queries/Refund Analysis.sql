-- Tickets Section
SELECT CONCAT(UPPER(ed.EventName), '-', ed.EventYear) AS [Event Name], CONCAT(td.TicketEvent, ' ', td.TicketType) AS ItemName,
-- Sales and Refund Metrics
SUM(ef.TicketsSold) AS TotalSold, COALESCE(SUM(rf.TicketsRefunded), 0) AS TotalRefunded, COALESCE(SUM(rf.TicketsRefundedPND), 0) AS TotalRefundedPND,
-- ticker Refund Rates
    CASE 
        WHEN SUM(ef.TicketsSold) = 0 THEN 0
ELSE (COALESCE(SUM(rf.TicketsRefunded), 0) * 1.0 / SUM(ef.TicketsSold)) * 100
END AS RefundRatePercentage, CASE 
        WHEN SUM(ef.TicketsSoldPND) = 0 THEN 0
ELSE (COALESCE(SUM(rf.TicketsRefundedPND), 0) * 1.0 / SUM(ef.TicketsSoldPND)) * 100
END AS RefundRatePercentagePND,
-- Net Sales after refunds
SUM(ef.TicketsSold) - COALESCE(SUM(rf.TicketsRefunded), 0) AS NetSales, SUM(ef.TicketsSoldPND) - COALESCE(SUM(rf.TicketsRefundedPND), 0) AS NetSalesPND, 'Ticket' AS ItemType
FROM EventFact ef
LEFT JOIN TicketDim td ON
ef.TicketID = td.TicketID
LEFT JOIN RefundFact rf ON
ef.TicketID = rf.TicketID
LEFT JOIN EventDim ed ON
ef.EventID = ed.EventID
GROUP BY
    CONCAT(UPPER(ed.EventName), '-', ed.EventYear), td.TicketEvent, td.TicketType
UNION ALL
-- Merchandise Section
SELECT CONCAT(UPPER(ed.EventName), '-', ed.EventYear) AS [Event Name], md.MerchandiseType AS ItemName,
-- Sales and Refund Metrics
SUM(ef.MerchandiseSold) AS TotalSold, COALESCE(SUM(rf.MerchandiseRefunded), 0) AS TotalRefunded, COALESCE(SUM(rf.MerchandiseRefundedPND), 0) AS TotalRefundedPND,
-- merch Refund Rates
    CASE 
        WHEN SUM(ef.MerchandiseSold) = 0 THEN 0
ELSE (COALESCE(SUM(rf.MerchandiseRefunded), 0) * 1.0 / SUM(ef.MerchandiseSold)) * 100
END AS RefundRatePercentage, CASE 
        WHEN SUM(ef.MerchandiseSoldPND) = 0 THEN 0
ELSE (COALESCE(SUM(rf.MerchandiseRefundedPND), 0) * 1.0 / SUM(ef.MerchandiseSoldPND)) * 100
END AS RefundRatePercentagePND,
-- Net Sales after refunds
SUM(ef.MerchandiseSold) - COALESCE(SUM(rf.MerchandiseRefunded), 0) AS NetSales, SUM(ef.MerchandiseSoldPND) - COALESCE(SUM(rf.MerchandiseRefundedPND), 0) AS NetSalesPND, 'Merchandise' AS ItemType
FROM EventFact ef
LEFT JOIN MerchandiseDim md ON
ef.MerchandiseID = md.MerchandiseID
LEFT JOIN RefundFact rf ON
ef.MerchandiseID = rf.MerchandiseID
LEFT JOIN EventDim ed ON
ef.EventID = ed.EventID
GROUP BY 
    CONCAT(UPPER(ed.EventName), '-', ed.EventYear), md.MerchandiseType
ORDER BY 
    [Event Name], ItemType, RefundRatePercentage DESC, NetSales DESC, ItemName;
