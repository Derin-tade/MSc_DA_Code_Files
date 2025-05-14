-- How do players clubs and champions affect the number of spectators, popupularity


-- 
-- IS there a link between the Champion and Pla
SELECT *
FROM PlayerInGameDim pigd
--WHERE pigd.PlayerID = 162
ORDER BY championID;


SELECT * FROM PlayerDim pd 
--WHERE pd.PlayerGameName = 'Abathur'
ORDER BY PlayerGameName ;

SELECT *
FROM ChampionDim cd;

SELECT pigd.PlayerID , pigd.championID
FROM ChampionDim cd
FULL JOIN PlayerInGameDim pigd ON
cd.ChampionID = pigd.ChampionID;
SELECT * FROM ClubDim cd
ORDER BY cd.ClubName ;

-------------------------------------------------
SELECT pigd.PlayerID
	, dd.DateYear
	, COUNT(pigd.GameID) AS [Games Played]
	, COUNT(DISTINCT CASE WHEN pigd.ChampionID IS NOT NULL THEN pigd.ChampionID END) AS [Number OF Championships Won]
FROM PlayerInGameDim pigd
JOIN 
    GameFact gf ON
	pigd.GameID = gf.GameID
JOIN 
    DateDim dd ON
	gf.DateID = dd.DateID
LEFT JOIN 
    ChampionDim cd ON
	pigd.ChampionID = cd.ChampionID
WHERE pigd.PlayerID = 162
GROUP BY
	pigd.PlayerID
	, dd.DateYear
ORDER BY
	dd.DateYear
	, [Games Played] DESC;



--investigate events

SELECT
	*
FROM
	EventFact ef
--ORDER BY
--	ef.MerchandiseID 
;
SELECT
	*
FROM
	EventDim ed ;


--JOIN event AND date

SELECT
	ed.EventID
	, ed.EventName
	, ed.EventStartDateID
	, ddstd.DateID AS [dateID from DateDim] 
	, ed.EventEndDateID
	, ddend.DateID AS [dateID from DateDim]
FROM
	EventDim ed
JOIN DateDim ddstd ON
	ddstd.DateID = ed.EventStartDateID
JOIN DateDim ddend ON
	ddend.DateID = ed.EventEndDateID;

--select top 1 * from DateDim dd order by DateID desc;
--select top 1 * from DateDim dd order by DateID asc;

	*
FROM
	EventFact ef
JOIN EventDim ed ON
	ed.EventID = ef.EventID
ORDER BY ed.EventID ;