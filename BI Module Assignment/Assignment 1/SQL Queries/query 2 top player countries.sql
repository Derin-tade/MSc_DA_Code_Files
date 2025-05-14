SELECT ed.EventID,
	CONCAT (
		UPPER(ed.EventName),
		'-',
		ed.EventYear
		) AS [Event Name],
	sd.StadiumName AS [Stadium Name],
	sdld.LocationCity AS [Stadium City],
	sdld.Country AS [Stadium Country],
	-- Number of clubs from the same city as the stadium
	COUNT(DISTINCT CASE WHEN cdld.LocationCity = sdld.LocationCity THEN cd.ClubID ELSE NULL	END) AS [Clubs from Stadium City],
	-- Number of clubs from the same country as the stadium
	COUNT(DISTINCT CASE WHEN cdld.Country = sdld.Country THEN cd.ClubID	ELSE NULL END) AS [Clubs from Stadium Country],
	-- Number of players from the same city as the stadium
	COUNT(DISTINCT CASE WHEN pld.LocationCity = sdld.LocationCity THEN pd.PlayerID ELSE NULL END) AS [Players from Stadium City],
	-- Number of players from the same country as the stadium
	COUNT(DISTINCT CASE WHEN pld.Country = sdld.Country THEN pd.PlayerID ELSE NULL END) AS [Players from Stadium Country],
	-- City with the maximum number of clubs in attendance
	(
		SELECT TOP 1 cdld.LocationCity
		FROM PlayerInGameDim pigd
		JOIN ClubDim cd ON pigd.ClubID = cd.ClubID
		JOIN LocationDim cdld ON cd.ClubLocation = cdld.LocationID
		JOIN GameFact gf2 ON pigd.GameID = gf2.GameID
		WHERE gf2.EventID = ed.EventID
		GROUP BY cdld.LocationCity
		ORDER BY COUNT(DISTINCT cd.ClubID) DESC
	) AS [Max Clubs City],
	-- Country with the maximum number of clubs in attendance
	(
		SELECT TOP 1 cdld.Country
		FROM PlayerInGameDim pigd
		JOIN ClubDim cd ON pigd.ClubID = cd.ClubID
		JOIN LocationDim cdld ON cd.ClubLocation = cdld.LocationID
		JOIN GameFact gf2 ON pigd.GameID = gf2.GameID
		WHERE gf2.EventID = ed.EventID
		GROUP BY cdld.Country
		ORDER BY COUNT(DISTINCT cd.ClubID) DESC
	) AS [Max Clubs Country],
	-- City with the maximum number of players in attendance
	(
		SELECT TOP 1 pld.LocationCity
		FROM PlayerInGameDim pigd
		JOIN PlayerDim pd ON pigd.PlayerID = pd.PlayerID
		JOIN LocationDim pld ON pd.PlayerOriginID = pld.LocationID
		JOIN GameFact gf2 ON pigd.GameID = gf2.GameID
		WHERE gf2.EventID = ed.EventID
		GROUP BY pld.LocationCity
		ORDER BY COUNT(DISTINCT pd.PlayerID) DESC
		) AS [Max Players City],
	-- Country with the maximum number of players in attendance
	(
		SELECT TOP 1 pld.Country
		FROM PlayerInGameDim pigd
		JOIN PlayerDim pd ON pigd.PlayerID = pd.PlayerID
		JOIN LocationDim pld ON pd.PlayerOriginID = pld.LocationID
		JOIN GameFact gf2 ON pigd.GameID = gf2.GameID
		WHERE gf2.EventID = ed.EventID
		GROUP BY pld.Country
		ORDER BY COUNT(DISTINCT pd.PlayerID) DESC
		) AS [Max Players Country]
FROM EventDim ed
JOIN GameFact gf ON ed.EventID = gf.EventID
JOIN GameDim gd ON gf.GameID = gd.GameID
JOIN StadiumDim sd ON gf.StadiumID = sd.StadiumID
JOIN LocationDim sdld ON sd.StadiumLocationID = sdld.LocationID
JOIN PlayerInGameDim pigd ON gd.GameID = pigd.GameID
JOIN ClubDim cd ON pigd.ClubID = cd.ClubID
JOIN LocationDim cdld ON cd.ClubLocation = cdld.LocationID
JOIN PlayerDim pd ON pigd.PlayerID = pd.PlayerID
JOIN LocationDim pld ON pd.PlayerOriginID = pld.LocationID
GROUP BY ed.EventID, ed.EventName, ed.EventYear, sd.StadiumName, sdld.LocationCity, sdld.Country
ORDER BY [Event Name],	[Stadium Name];


select * from LocationDim ld where Country = 'United States' order by LocationCity
