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
