-- Import Data

COPY leagues
FROM '/Users/Shared/football_project/leagues.csv'
DELIMITER ','
CSV HEADER;

COPY teams
FROM '/Users/Shared/football_project/teams.csv'
DELIMITER ','
CSV HEADER;

COPY players
FROM '/Users/Shared/football_project/players.csv'
DELIMITER ','
CSV HEADER;

COPY matches
FROM '/Users/Shared/football_project/matches_clean.csv'
DELIMITER ','
CSV HEADER;
