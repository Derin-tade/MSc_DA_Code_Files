-- Player Demographic Dashboard

WITH PPaDS AS (
    SELECT 
        p.PlayerRealName,
        SUM(pr.PRKills) AS TotalKills,
        SUM(pr.PRAssists) AS TotalAssists,
        SUM(pr.PRDeaths) AS TotalDeaths,
        SUM(gf.GameDuration) - COALESCE(SUM(gf.GameDurationOfPause),0) AS MinutesPlayed,
        DENSE_RANK() OVER (ORDER BY SUM(pr.PRKills) DESC) AS KillsRank,
        DENSE_RANK() OVER (ORDER BY SUM(pr.PRAssists) DESC) AS AssistsRank,
        DENSE_RANK() OVER (ORDER BY SUM(pr.PRDeaths) ) AS DeathsRank,
        DATEDIFF(YEAR,p.PlayerDoB, '2020-12-12') AS Player_Age,
        p.PlayerGender AS Gender,
        count(DISTINCT pig.gameid) AS No_of_Games_Played,
        l.Country,
        CASE 
            WHEN DATEDIFF(YEAR, p.PlayerDoB, '2020-12-12') < 18 THEN 'Under 18'
            WHEN DATEDIFF(YEAR, p.PlayerDoB, '2020-12-12') BETWEEN 18 AND 24 THEN '18-24'
            WHEN DATEDIFF(YEAR, p.PlayerDoB, '2020-12-12') BETWEEN 25 AND 34 THEN '25-34'
            WHEN DATEDIFF(YEAR, p.PlayerDoB, '2020-12-12') BETWEEN 35 AND 44 THEN '35-44'
            ELSE '45+' 
        END AS AgeGroup
    FROM 
        PlayerDim p
    JOIN PlayerInGameDim pig ON p.PlayerID = pig.PlayerID
    JOIN GameDim gd ON pig.GameID  = gd.GameID
    JOIN GameFact gf ON gd.GameID = gf.GameID
    JOIN PersonalRecordDim pr ON pig.PRID = pr.PRID
    JOIN LocationDim l ON p.PlayerOriginID = l.LocationID
    GROUP BY 
        p.PlayerRealName, l.Country, p.PlayerDoB, p.PlayerGender
)
SELECT 
    PlayerRealName, No_of_Games_Played, MinutesPlayed, TotalKills,KillsRank, TotalAssists, AssistsRank, 
    TotalDeaths, DeathsRank, Country, Player_Age , AgeGroup, Gender
FROM 
    PPaDS
ORDER BY 
    KillsRank; 

SELECT count(DISTINCT gameid) FROM PlayerInGameDim pigd ;