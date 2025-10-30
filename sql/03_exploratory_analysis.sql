/* 
   1️⃣  Vérification de base
   Objectif : s'assurer que les données sont bien importées et cohérentes
 */

-- Aperçu des données matches
SELECT * FROM matches LIMIT 10;

--  Nombre total de matchs
SELECT COUNT(*) AS total_matches
FROM matches;


--  Nombre total d’équipes, de ligues et de joueurs
SELECT 
    (SELECT COUNT(*) FROM teams) AS total_teams,
    (SELECT COUNT(*) FROM leagues) AS total_leagues,
    (SELECT COUNT(*) FROM players) AS total_players;


--  Plage temporelle des matchs (du plus ancien au plus récent)
SELECT MIN(date) AS first_match, MAX(date) AS last_match
FROM matches;
-- Nous pouvons voir que la base contient environ 25 000 matchs, ce qui correspond à la période 2008–2016.


/* 
   2️⃣  Analyses descriptives globales
   Objectif : comprendre la répartition des matchs et le volume de données
*/

-- 🔹 Nombre de matchs par ligue
SELECT 
    l.name AS league_name, 
    COUNT(*) AS total_matches
FROM matches m
JOIN leagues l ON m.league_id = l.id
GROUP BY l.name
ORDER BY total_matches DESC;
-- Nous observons que certaines ligues comme la Premier League, la Liga et la Serie A comptent le plus grand nombre de matchs enregistrés, 

-- 🔹 Nombre de matchs par saison
SELECT 
    season, 
    COUNT(*) AS matches_per_season
FROM matches
GROUP BY season
ORDER BY season;
-- Le nombre de matchs reste relativement stable d’une saison à l’autre, ce qui confirme la régularité des compétitions au fil des années.


-- 🔹 Moyenne de buts par match (tous matchs confondus)
SELECT 
    ROUND(AVG(home_team_goal + away_team_goal), 2) AS avg_goals_per_match
FROM matches;
-- Nous pouvons voir que la moyenne de buts par match se situe autour de 2,5. Cela reflète un équilibre classique entre attaque et défense dans le football européen.


/* 
   3️⃣  Performances domicile / extérieur
   Objectif : comprendre l’avantage du terrain
  */

-- Pourcentage de victoires à domicile
SELECT 
  ROUND(100.0 * SUM(CASE WHEN home_team_goal > away_team_goal THEN 1 ELSE 0 END) / COUNT(*), 2) 
  AS home_win_rate
FROM matches;
-- Nous observons qu’environ 45 à 50 % des matchs se soldent par une victoire à domicile, ce qui confirme l’avantage du terrain pour la majorité des équipes.




-- Pourcentage de victoires à l’extérieur
SELECT 
  ROUND(100.0 * SUM(CASE WHEN away_team_goal > home_team_goal THEN 1 ELSE 0 END) / COUNT(*), 2) 
  AS away_win_rate
FROM matches;
-- Les victoires à l’extérieur représentent environ 25 à 30 % des matchs, ce qui illustre la difficulté pour les équipes visiteuses.


-- Pourcentage de matchs nuls
SELECT 
  ROUND(100.0 * SUM(CASE WHEN home_team_goal = away_team_goal THEN 1 ELSE 0 END) / COUNT(*), 2) 
  AS draw_rate
FROM matches;


/* 
   4️⃣  Moyenne de buts par ligue et par saison
   Objectif : identifier les ligues les plus offensives
*/

-- ⚽️ Moyenne de buts par match et par ligue
SELECT 
  l.name AS league_name,
  ROUND(AVG(m.home_team_goal + m.away_team_goal), 2) AS avg_goals
FROM matches m
JOIN leagues l ON m.league_id = l.id
GROUP BY l.name
ORDER BY avg_goals DESC;
-- Nous observons que certaines ligues, comme la Bundesliga, l'Eredivisie, présentent des moyennes de buts plus élevées, traduisant un style de jeu plus offensif.




-- 🗓 Moyenne de buts par saison
SELECT 
  season,
  ROUND(AVG(home_team_goal + away_team_goal), 2) AS avg_goals
FROM matches
GROUP BY season
ORDER BY season;
-- Nous pouvons constater une légère évolution du nombre moyen de buts par saison. Cela peut indiquer une tendance à l’offensive ou une évolution tactique au fil des années.


/*
   5️⃣  Classements et performances par équipe
   Objectif : déterminer les meilleures attaques et défenses
    */

--  Total de buts marqués et encaissés par équipe
SELECT 
  t.team_long_name AS team_name,
  SUM(CASE WHEN m.home_team_api_id = t.team_api_id THEN m.home_team_goal ELSE m.away_team_goal END) AS goals_scored,
  SUM(CASE WHEN m.home_team_api_id = t.team_api_id THEN m.away_team_goal ELSE m.home_team_goal END) AS goals_conceded
FROM matches m
JOIN teams t ON t.team_api_id IN (m.home_team_api_id, m.away_team_api_id)
GROUP BY t.team_long_name
ORDER BY goals_scored DESC
LIMIT 10;
-- Nous pouvons voir que les équipes comme le FC Barcelone ou le Real Madrid figurent parmi les meilleures attaques, confirmant leur domination offensive sur la période étudiée.


-- 🏅 Pourcentage de victoires par équipe (minimum 30 matchs)
SELECT 
  t.team_long_name AS team_name,
  ROUND(100.0 * SUM(
      CASE 
        WHEN (m.home_team_api_id = t.team_api_id AND m.home_team_goal > m.away_team_goal)
          OR (m.away_team_api_id = t.team_api_id AND m.away_team_goal > m.home_team_goal)
        THEN 1 ELSE 0 END
  ) / COUNT(*), 2) AS win_rate
FROM matches m
JOIN teams t ON t.team_api_id IN (m.home_team_api_id, m.away_team_api_id)
GROUP BY t.team_long_name
HAVING COUNT(*) > 30
ORDER BY win_rate DESC
LIMIT 10;
-- Nous constatons que les équipes avec les meilleurs taux de victoire sont souvent celles issues des grands championnats européens, traduisant une forte régularité de performance.

-- Nombre de matchs par équipe
SELECT 
  t.team_long_name,
  COUNT(*) AS match_count
FROM matches m
JOIN teams t ON t.team_api_id IN (m.home_team_api_id, m.away_team_api_id)
GROUP BY t.team_long_name
ORDER BY match_count DESC;


