
/*
   🧩 CREATION DES VUES PERMANENTES
   Objectif : Préparer les données pour les analyses et visualisations
*/


/* 
   1️⃣ Vue : league_season_summary
   Objectif : regrouper les statistiques globales par ligue et saison
*/

CREATE OR REPLACE VIEW league_season_summary AS
SELECT 
    l.name AS league_name,
    m.season,
    COUNT(*) AS total_matches,
    ROUND(AVG(m.home_team_goal + m.away_team_goal), 2) AS avg_goals_per_match,
    ROUND(SUM(CASE WHEN m.home_team_goal > m.away_team_goal THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS home_win_rate,
    ROUND(SUM(CASE WHEN m.away_team_goal > m.home_team_goal THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS away_win_rate,
    ROUND(SUM(CASE WHEN m.home_team_goal = m.away_team_goal THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS draw_rate
FROM matches m
JOIN leagues l ON m.league_id = l.id
GROUP BY l.name, m.season
ORDER BY l.name, m.season;

-- Cette vue permet d’analyser l’évolution du nombre de buts et des tendances de résultats  par ligue et par saison. Elle servira pour des visualisations temporelles.


/* 
   2️⃣ Vue : team_match_stats
   Objectif : centraliser les statistiques des équipes par match
*/

CREATE OR REPLACE VIEW team_match_stats AS
SELECT 
    t.team_long_name AS team_name,
    COUNT(*) AS matches_played,
    SUM(CASE WHEN (m.home_team_api_id = t.team_api_id AND m.home_team_goal > m.away_team_goal)
              OR (m.away_team_api_id = t.team_api_id AND m.away_team_goal > m.home_team_goal)
        THEN 1 ELSE 0 END) AS wins,
    SUM(CASE WHEN (m.home_team_api_id = t.team_api_id AND m.home_team_goal < m.away_team_goal)
              OR (m.away_team_api_id = t.team_api_id AND m.away_team_goal < m.home_team_goal)
        THEN 1 ELSE 0 END) AS losses,
    SUM(CASE WHEN m.home_team_goal = m.away_team_goal THEN 1 ELSE 0 END) AS draws,
    SUM(CASE WHEN m.home_team_api_id = t.team_api_id THEN m.home_team_goal ELSE m.away_team_goal END) AS goals_scored,
    SUM(CASE WHEN m.home_team_api_id = t.team_api_id THEN m.away_team_goal ELSE m.home_team_goal END) AS goals_conceded,
    ROUND(AVG(CASE WHEN m.home_team_api_id = t.team_api_id THEN m.home_team_goal ELSE m.away_team_goal END), 2) AS avg_goals_scored
FROM matches m
JOIN teams t ON t.team_api_id IN (m.home_team_api_id, m.away_team_api_id)
GROUP BY t.team_long_name
ORDER BY wins DESC;
-- Cette vue résume les performances globales des équipes : victoires, défaites, buts marqués et encaissés. Elle est idéale pour créer un classement général des clubs.


/*
   3️⃣ Vue : home_vs_away_summary
   Objectif : mesurer l’avantage du terrain
*/

CREATE OR REPLACE VIEW home_vs_away_summary AS
SELECT 
    ROUND(100.0 * SUM(CASE WHEN home_team_goal > away_team_goal THEN 1 ELSE 0 END) / COUNT(*), 2) AS home_win_rate,
    ROUND(100.0 * SUM(CASE WHEN away_team_goal > home_team_goal THEN 1 ELSE 0 END) / COUNT(*), 2) AS away_win_rate,
    ROUND(100.0 * SUM(CASE WHEN home_team_goal = away_team_goal THEN 1 ELSE 0 END) / COUNT(*), 2) AS draw_rate
FROM matches;

-- Cette vue permet de visualiser la répartition des résultats (victoires domicile / extérieur / nuls) sur l’ensemble du dataset.


/*
   4️⃣ Vue : league_performance_ranking
   Objectif : classer les ligues selon leur moyenne de buts
 */

CREATE OR REPLACE VIEW league_performance_ranking AS
SELECT 
    l.name AS league_name,
    ROUND(AVG(m.home_team_goal + m.away_team_goal), 2) AS avg_goals_per_match,
    COUNT(*) AS total_matches
FROM matches m
JOIN leagues l ON m.league_id = l.id
GROUP BY l.name
ORDER BY avg_goals_per_match DESC;

-- Cette vue fournit un classement direct des ligues les plus offensives. Elle est utile pour comparer la dynamique des compétitions européennes.

