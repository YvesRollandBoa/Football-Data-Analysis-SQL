/*
   05_analysis_from_views.sql
   Analyses finales basées sur les vues analytiques

   Vues utilisées :
     ✅ league_season_summary
     ✅ team_match_stats
     ✅ home_vs_away_summary
     ✅ league_performance_ranking
*/


/*
   1️⃣ Classement des meilleures équipes (par victoires)
*/

SELECT
    team_name,
    matches_played,
    wins,
    draws,
    losses,
    goals_scored,
    goals_conceded,
    ROUND((wins * 100.0) / matches_played, 2) AS win_rate,
    (goals_scored - goals_conceded) AS goal_difference
FROM team_match_stats
ORDER BY win_rate DESC, goal_difference DESC
LIMIT 10;


/*
   2️⃣ Top 10 meilleures attaques (buts marqués)
*/

SELECT
    team_name,
    goals_scored,
    matches_played,
    ROUND(goals_scored * 1.0 / matches_played, 2) AS avg_goals_scored
FROM team_match_stats
ORDER BY goals_scored DESC
LIMIT 10;


/*
   3️⃣ Top 10 meilleures défenses (buts encaissés)
*/

SELECT
    team_name,
    goals_conceded,
    matches_played,
    ROUND(goals_conceded * 1.0 / matches_played, 2) AS avg_goals_conceded
FROM team_match_stats
ORDER BY goals_conceded ASC
LIMIT 10;


/*
   4️⃣ Classement des ligues les plus offensives
   (buts par match)
*/

SELECT
    league_name,
    avg_goals_per_match,
    total_matches
FROM league_performance_ranking
ORDER BY avg_goals_per_match DESC;


/*
   5️⃣ Évolution du nombre de buts par saison
*/

SELECT
    season,
    ROUND(AVG(avg_goals_per_match), 2) AS avg_goals_across_leagues
FROM league_season_summary
GROUP BY season
ORDER BY season;


/*
   6️⃣ Avantage domicile vs extérieur
*/

SELECT *
FROM home_vs_away_summary;
