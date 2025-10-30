-- Add constraints

ALTER TABLE teams
ADD CONSTRAINT unique_team_api_id UNIQUE (team_api_id);

ALTER TABLE matches
ADD CONSTRAINT fk_home_team FOREIGN KEY (home_team_api_id) REFERENCES teams (team_api_id);

ALTER TABLE matches
ADD CONSTRAINT fk_away_team FOREIGN KEY (away_team_api_id) REFERENCES teams (team_api_id);

ALTER TABLE matches
ADD CONSTRAINT fk_league FOREIGN KEY (league_id) REFERENCES leagues (id);








