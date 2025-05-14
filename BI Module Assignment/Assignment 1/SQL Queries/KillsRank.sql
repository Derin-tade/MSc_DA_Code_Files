/*
SELECT * FROM ClubCoachDim ccd;
SELECT * FROM CoachDim cd;
SELECT * FROM AwardDim ad;
SELECT * FROM PlayerInGameDim pigd WHERE championid IS NULL;
SELECT * FROM ClubDim cd;

SELECT cd.CoachName, COUNT(DISTINCT ccd.ClubID) AS NumberOfClubsCoached, MAX(ccd.CoachPosition) AS HighestCoachingPosition,
-- Assuming alphabetical order determines the highest position
COUNT(gd.GameID) AS TotalGamesPlayed, SUM(CASE WHEN gf.GameResult = 'Won' THEN 1 ELSE 0 END) AS TotalGamesWon, COUNT(DISTINCT ad.AwardID) AS TotalAwardsWon, CASE 
        WHEN cd.CoachIsExPlayer = 1 THEN 'Yes'
ELSE 'No'
END AS IsExPlayer
FROM CoachDim cd
LEFT JOIN 
    ClubCoachDim ccd ON
cd.CoachID = ccd.CoachID
LEFT JOIN 
    ClubDim cld ON
ccd.ClubID = cld.ClubID
LEFT JOIN 
    GameFact gf ON
cd.CoachID = gf.RefereeID
-- Adjust based on where CoachID is relevant in GameFact
LEFT JOIN 
    AwardDim ad ON
cd.CoachHigherAwardID = ad.AwardID
LEFT JOIN 
    GameDim gd ON
gf.GameID = gd.GameID
GROUP BY 
    cd.CoachName, cd.CoachIsExPlayer
ORDER BY 
    cd.CoachName;


WITH RankedPlayers AS (
    SELECT 
        p.PlayerRealName,
        SUM(pr.PRKills) AS TotalKills,
        RANK() OVER (ORDER BY SUM(pr.PRKills) DESC) AS KillsRank
    FROM 
        PlayerDim p
    JOIN 
        PlayerInGameDim pig ON p.PlayerID = pig.PlayerID
    JOIN 
        PersonalRecordDim pr ON pig.PRID = pr.PRID
    GROUP BY 
        p.PlayerRealName
)
SELECT * FROM RankedPlayers
ORDER BY KillsRank;

SELECT
TOP 5
    cl.ClubName, SUM(c.CoachYearsOfExperience) AS TotalExperience
FROM ClubDim cl
JOIN 
    ClubCoachDim cc ON
cl.ClubID = cc.ClubID
JOIN 
    CoachDim c ON
cc.CoachID = c.CoachID
GROUP BY 
    cl.ClubName
ORDER BY 
    TotalExperience DESC;




SELECT TOP 10
    ch.ChampionName,
    COUNT(pig.ChampionID ) AS ChampionCount,
    AVG(pr.PRKills) AS AverageKills,
    AVG(pr.PRAssists) AS AverageAssists
FROM 
    ChampionDim ch
JOIN 
    PlayerInGameDim pig ON ch.ChampionID = pig.ChampionID
JOIN 
    PersonalRecordDim pr ON pig.PRID = pr.PRID
JOIN 
    GameFact gf ON pig.GameID = gf.GameID
WHERE 
    gf.EventID IN (SELECT EventID FROM EventDim WHERE EventName = 'World Championship')
GROUP BY 
    ch.ChampionName
ORDER BY 
    PlayerCount DESC;


SELECT count (DISTINCT championID) FROM PlayerInGameDim pigd;



*/







WITH PPaDS AS (
    SELECT 
        p.PlayerRealName,
        SUM(pr.PRKills) AS TotalKills,
        SUM(pr.PRAssists) AS TotalAssists,
        SUM(pr.PRDeaths) AS TotalDeaths,
        DENSE_RANK() OVER (ORDER BY SUM(pr.PRKills) DESC) AS KillsRank,
        DENSE_RANK() OVER (ORDER BY SUM(pr.PRAssists) DESC) AS AssistsRank,
        DENSE_RANK() OVER (ORDER BY SUM(pr.PRDeaths) ) AS DeathsRank,
        l.Country,
        CASE 
            WHEN DATEDIFF(YEAR, p.PlayerDoB, GETDATE()) < 18 THEN 'Under 18'
            WHEN DATEDIFF(YEAR, p.PlayerDoB, GETDATE()) BETWEEN 18 AND 24 THEN '18-24'
            WHEN DATEDIFF(YEAR, p.PlayerDoB, GETDATE()) BETWEEN 25 AND 34 THEN '25-34'
            WHEN DATEDIFF(YEAR, p.PlayerDoB, GETDATE()) BETWEEN 35 AND 44 THEN '35-44'
            ELSE '45+' 
        END AS AgeGroup
    FROM 
        PlayerDim p
    JOIN PlayerInGameDim pig ON p.PlayerID = pig.PlayerID
    JOIN PersonalRecordDim pr ON pig.PRID = pr.PRID
    JOIN LocationDim l ON p.PlayerOriginID = l.LocationID
    GROUP BY 
        p.PlayerRealName, l.Country, p.PlayerDoB
)
SELECT 
    PlayerRealName,TotalKills,KillsRank, TotalAssists, AssistsRank, TotalDeaths, DeathsRank, Country, AgeGroup
FROM 
    PPaDS
ORDER BY 
    KillsRank; 

    
