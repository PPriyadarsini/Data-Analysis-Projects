/*

@Steel Data & @Matthew Steel

SQL Challenge 2 - Esports Tournament

Link: https://www.steeldata.org.uk/sql2.html

Intro: 
	The top eSports competitors from across the globe have gathered to battle it out
	Can you analyse the following data to find out all about the tournament?

Concepts used:
	- SELECT
	- AGGREGATE FUNCTIONS (SUM, COUNT, AVERAGE)
	- JOINS
	- WHERE
	- AND
	- GROUP BY
	- ORDER BY
	- TOP 

*/


CREATE TABLE Teams (
team_id INT PRIMARY KEY,
team_name VARCHAR(50) NOT NULL,
country VARCHAR(50),
captain_id INT
);

--------------------

INSERT INTO Teams (team_id, team_name, country, captain_id)
VALUES (1, 'Cloud9', 'USA', 1),
(2, 'Fnatic', 'Sweden', 2),
(3, 'SK Telecom T1', 'South Korea', 3),
(4, 'Team Liquid', 'USA', 4),
(5, 'G2 Esports', 'Spain', 5);

--------------------

CREATE TABLE Players (
player_id INT PRIMARY KEY,
player_name VARCHAR(50) NOT NULL,
team_id INT,
role VARCHAR(50),
salary INT,
FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

--------------------

INSERT INTO Players (player_id, player_name, team_id, role, salary)
VALUES (1, 'Shroud', 1, 'Rifler', 100000),
(2, 'JW', 2, 'AWP', 90000),
(3, 'Faker', 3, 'Mid laner', 120000),
(4, 'Stewie2k', 4, 'Rifler', 95000),
(5, 'Perkz', 5, 'Mid laner', 110000),
(6, 'Castle09', 1, 'AWP', 120000),
(7, 'Pike', 2, 'Mid Laner', 70000),
(8, 'Daron', 3, 'Rifler', 125000),
(9, 'Felix', 4, 'Mid Laner', 95000),
(10, 'Stadz', 5, 'Rifler', 98000),
(11, 'KL34', 1, 'Mid Laner', 83000),
(12, 'ForceZ', 2, 'Rifler', 130000),
(13, 'Joker', 3, 'AWP', 128000),
(14, 'Hari', 4, 'AWP', 90000),
(15, 'Wringer', 5, 'Mid laner', 105000);

--------------------

CREATE TABLE Matches (
match_id INT PRIMARY KEY,
team1_id INT,
team2_id INT,
match_date DATE,
winner_id INT,
score_team1 INT,
score_team2 INT,
FOREIGN KEY (team1_id) REFERENCES Teams(team_id),
FOREIGN KEY (team2_id) REFERENCES Teams(team_id),
FOREIGN KEY (winner_id) REFERENCES Teams(team_id)
);

--------------------

INSERT INTO Matches (match_id, team1_id, team2_id, match_date, winner_id, score_team1, score_team2)
VALUES (1, 1, 2, '2022-01-01', 1, 16, 14),
(2, 3, 5, '2022-02-01', 3, 14, 9),
(3, 4, 1, '2022-03-01', 1, 17, 13),
(4, 2, 5, '2022-04-01', 5, 13, 12),
(5, 3, 4, '2022-05-01', 3, 16, 10),
(6, 1, 3, '2022-02-01', 3, 13, 17),
(7, 2, 4, '2022-03-01', 2, 12, 9),
(8, 5, 1, '2022-04-01', 1, 11, 15),
(9, 2, 3, '2022-05-01', 3, 9, 10),
(10, 4, 5, '2022-01-01', 4, 13, 10);

--------------------

SELECT *
FROM Teams

SELECT *
FROM Players

SELECT *
FROM Matches

-- Questions:

-- 1. The names of the players whose salary is greater than 100,000.

SELECT player_name, salary
FROM Players
WHERE salary > 100000

-- 2. The team name of the player with player_id = 3.

SELECT P.player_id, T.team_name, P.player_name
FROM Teams T
INNER JOIN Players P ON P.team_id = T.team_id
WHERE player_id = 3

-- 3. The total number of players in each team.

SELECT T.team_name, COUNT(*) AS total_no_of_players 
FROM Players P
INNER JOIN Teams T ON T.team_id = P.team_id
GROUP BY team_name

-- 4. The team name and captain name of the team with team_id = 2.

SELECT T.team_id, T.team_name, P.player_name AS captain_name
FROM Teams T
INNER JOIN Players P ON T.captain_id = P.player_id
WHERE T.team_id = 2

-- 5. The player names and their roles in the team with team_id = 1.

SELECT team_id, player_name, role
FROM Players 
WHERE team_id = 1

-- 6. The team names and the number of matches they have won.

SELECT T.team_name, COUNT(M.winner_id) AS no_of_matches_won
FROM Teams T
INNER JOIN Matches M ON M.winner_id = T.team_id
GROUP BY team_name

-- 7. The average salary of players in the teams with country 'USA'.

SELECT T.team_name, AVG(P.salary) AS avg_salary
FROM Players P 
INNER JOIN Teams T ON T.team_id = P.team_id
WHERE country = 'USA'
GROUP BY team_name

-- 8. Team won the most matches.

SELECT TOP 1 T.team_name, COUNT(M.winner_id) AS team_won_most_matches
FROM Teams T
INNER JOIN Matches M ON M.winner_id = T.team_id
GROUP BY team_name
ORDER BY COUNT(M.winner_id) DESC 

-- 9. The team names and the number of players in each team whose salary is greater than 100,000.

SELECT T.team_name, COUNT(*) AS no_of_players
FROM Teams T
INNER JOIN Players P ON P.team_id = T.team_id
WHERE salary > 100000
GROUP BY team_name

-- 10. The date and the score of the match with match_id = 3.

SELECT match_date, score_team1, score_team2, (score_team1 + score_team2) AS match_score
FROM Matches M
WHERE match_id = 3
GROUP BY match_date, score_team1, score_team2