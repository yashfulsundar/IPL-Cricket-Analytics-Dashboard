CREATE DATABASE ipl_analysis;
USE ipl_analysis;

CREATE TABLE ipl (
    match_id INT,
    season INT,
    start_date DATE,
    venue VARCHAR(100),
    innings INT,
    ball FLOAT,
    batting_team VARCHAR(100),
    bowling_team VARCHAR(100),
    striker VARCHAR(100),
    non_striker VARCHAR(100),
    bowler VARCHAR(100),
    runs_off_bat INT,
    extras INT,
    wides FLOAT,
    noballs FLOAT,
    byes FLOAT,
    legbyes FLOAT,
    penalty FLOAT,
    wicket_type VARCHAR(50),
    player_dismissed VARCHAR(100),
    other_wicket_type VARCHAR(50),
    other_player_dismissed VARCHAR(100)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/IPL_data.csv'
INTO TABLE ipl
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(match_id, season, @start_date, venue, innings, ball, batting_team, bowling_team,
striker, non_striker, bowler, runs_off_bat, extras, @wides, @noballs, @byes,
@legbyes, @penalty, @wicket_type, @player_dismissed, @other_wicket_type, @other_player_dismissed)
SET 
start_date = STR_TO_DATE(@start_date, '%d-%m-%Y'),
wides = NULLIF(@wides, ''),
noballs = NULLIF(@noballs, ''),
byes = NULLIF(@byes, ''),
legbyes = NULLIF(@legbyes, ''),
penalty = NULLIF(@penalty, ''),
wicket_type = NULLIF(@wicket_type, ''),
player_dismissed = NULLIF(@player_dismissed, ''),
other_wicket_type = NULLIF(@other_wicket_type, ''),
other_player_dismissed = NULLIF(@other_player_dismissed, '');

SELECT COUNT(*) FROM ipl;
SELECT * FROM ipl LIMIT 5;

SELECT striker,
SUM(runs_off_bat) AS total_runs
FROM ipl
GROUP BY striker
ORDER BY total_runs DESC
LIMIT 10;

SELECT bowler,
COUNT(wicket_type) AS wickets
FROM ipl
WHERE wicket_type IS NOT NULL
AND wicket_type != 'run out'
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 10;

SELECT batting_team,
SUM(runs_off_bat) AS team_runs
FROM ipl
GROUP BY batting_team
ORDER BY team_runs DESC;

SELECT striker,
COUNT(*) AS sixes
FROM ipl
WHERE runs_off_bat = 6
GROUP BY striker
ORDER BY sixes DESC
LIMIT 10;

SELECT venue,
ROUND(AVG(runs_off_bat), 2) AS avg_runs_per_ball
FROM ipl
GROUP BY venue
ORDER BY avg_runs_per_ball DESC
LIMIT 10;

CREATE TABLE ipl_winners (
    season INT PRIMARY KEY,
    champion VARCHAR(100)
);

INSERT INTO ipl_winners VALUES
(2008,'Rajasthan Royals'),
(2009,'Deccan Chargers'),
(2010,'Chennai Super Kings'),
(2011,'Chennai Super Kings'),
(2012,'Kolkata Knight Riders'),
(2013,'Mumbai Indians'),
(2014,'Kolkata Knight Riders'),
(2015,'Mumbai Indians'),
(2016,'Sunrisers Hyderabad'),
(2017,'Mumbai Indians'),
(2018,'Chennai Super Kings'),
(2019,'Mumbai Indians'),
(2020,'Mumbai Indians'),
(2021,'Chennai Super Kings'),
(2022,'Gujarat Titans'),
(2023,'Chennai Super Kings');

SELECT champion,
COUNT(*) AS titles
FROM ipl_winners
GROUP BY champion
ORDER BY titles DESC;

SELECT bowler,
COUNT(*) AS wickets
FROM ipl
WHERE wicket_type IS NOT NULL
AND wicket_type NOT IN ('run out','retired hurt','obstructing the field')
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 10;