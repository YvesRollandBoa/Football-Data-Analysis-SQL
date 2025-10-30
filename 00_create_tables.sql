-- Drop tables

DROP TABLE IF EXISTS leagues CASCADE;
DROP TABLE IF EXISTS teams CASCADE;
DROP TABLE IF EXISTS players CASCADE;
DROP TABLE IF EXISTS matches CASCADE;


-- create tables

CREATE TABLE leagues (
    id SERIAL PRIMARY KEY,
    country_id INT,
    name VARCHAR(100)
);

CREATE TABLE teams (
    id SERIAL PRIMARY KEY,
    team_api_id INT,
    team_fifa_api_id INT,
    team_long_name VARCHAR(100),
    team_short_name VARCHAR(50)
);

CREATE TABLE players (
    id SERIAL PRIMARY KEY,
    player_api_id INT,
    player_name VARCHAR(100),
    player_fifa_api_id INT,
    birthday DATE,
    height FLOAT,
    weight FLOAT
);

CREATE TABLE matches (
    id SERIAL PRIMARY KEY,
    country_id INT,
    league_id INT,
    season VARCHAR(20),
    stage INT,
    date DATE,
    match_api_id INT,
    home_team_api_id INT,
    away_team_api_id INT,
    home_team_goal INT,
    away_team_goal INT
);

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

-- Add constraints

ALTER TABLE teams
ADD CONSTRAINT unique_team_api_id UNIQUE (team_api_id);

ALTER TABLE matches
ADD CONSTRAINT fk_home_team FOREIGN KEY (home_team_api_id) REFERENCES teams (team_api_id);

ALTER TABLE matches
ADD CONSTRAINT fk_away_team FOREIGN KEY (away_team_api_id) REFERENCES teams (team_api_id);

ALTER TABLE matches
ADD CONSTRAINT fk_league FOREIGN KEY (league_id) REFERENCES leagues (id);








