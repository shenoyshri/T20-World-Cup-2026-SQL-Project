-- ============================================================
--  T20 WORLD CUP 2026 -- COMPLETE SQL FILE
--  Step 1: Schema  |  Step 2: Dataset  |  Step 3: Queries
-- ============================================================


-- ============================================================
-- STEP 1: CREATE DATABASE & TABLES
-- ============================================================

DROP DATABASE IF EXISTS t20_wc2026;
CREATE DATABASE t20_wc2026;
USE t20_wc2026;

CREATE TABLE teams (
    team_id      INT          PRIMARY KEY,
    team_name    VARCHAR(60)  NOT NULL,
    country_code VARCHAR(5)   NOT NULL,
    group_name   VARCHAR(5),
    captain      VARCHAR(80)
);

CREATE TABLE venues (
    venue_id    INT          PRIMARY KEY,
    venue_name  VARCHAR(120) NOT NULL,
    city        VARCHAR(60)  NOT NULL,
    country     VARCHAR(30)  NOT NULL,
    capacity    INT
);

CREATE TABLE players (
    player_id     INT         PRIMARY KEY,
    team_id       INT,
    player_name   VARCHAR(80) NOT NULL,
    role          ENUM('Batsman','Bowler','All-Rounder','Wicket-Keeper') NOT NULL,
    batting_style VARCHAR(25),
    bowling_style VARCHAR(50),
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE matches (
    match_id       INT  PRIMARY KEY,
    match_no       INT,
    match_date     DATE,
    venue_id       INT,
    team1_id       INT,
    team2_id       INT,
    toss_winner_id INT,
    toss_decision  VARCHAR(10),
    winner_id      INT,
    win_by_type    VARCHAR(20),
    win_margin     INT,
    match_stage    VARCHAR(20),
    player_of_match INT,
    FOREIGN KEY (venue_id)        REFERENCES venues(venue_id),
    FOREIGN KEY (team1_id)        REFERENCES teams(team_id),
    FOREIGN KEY (team2_id)        REFERENCES teams(team_id),
    FOREIGN KEY (toss_winner_id)  REFERENCES teams(team_id),
    FOREIGN KEY (winner_id)       REFERENCES teams(team_id),
    FOREIGN KEY (player_of_match) REFERENCES players(player_id)
);

CREATE TABLE batting_scorecards (
    batting_id     INT PRIMARY KEY,
    match_id       INT,
    player_id      INT,
    team_id        INT,
    runs_scored    INT DEFAULT 0,
    balls_faced    INT DEFAULT 0,
    fours          INT DEFAULT 0,
    sixes          INT DEFAULT 0,
    dismissal_type VARCHAR(30),
    FOREIGN KEY (match_id)  REFERENCES matches(match_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (team_id)   REFERENCES teams(team_id)
);

CREATE TABLE bowling_scorecards (
    bowling_id    INT            PRIMARY KEY,
    match_id      INT,
    player_id     INT,
    team_id       INT,
    overs_bowled  DECIMAL(4,1)  DEFAULT 0,
    maidens       INT           DEFAULT 0,
    runs_conceded INT           DEFAULT 0,
    wickets       INT           DEFAULT 0,
    wides         INT           DEFAULT 0,
    no_balls      INT           DEFAULT 0,
    FOREIGN KEY (match_id)  REFERENCES matches(match_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (team_id)   REFERENCES teams(team_id)
);

CREATE TABLE fielding_stats (
    fielding_id INT PRIMARY KEY,
    match_id    INT,
    player_id   INT,
    team_id     INT,
    catches     INT DEFAULT 0,
    run_outs    INT DEFAULT 0,
    stumpings   INT DEFAULT 0,
    FOREIGN KEY (match_id)  REFERENCES matches(match_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (team_id)   REFERENCES teams(team_id)
);

CREATE TABLE tournament_batting_summary (
    summary_id    INT PRIMARY KEY,
    player_id     INT,
    team_id       INT,
    matches       INT DEFAULT 0,
    runs          INT DEFAULT 0,
    balls         INT DEFAULT 0,
    highest_score INT DEFAULT 0,
    fifties       INT DEFAULT 0,
    hundreds      INT DEFAULT 0,
    fours         INT DEFAULT 0,
    sixes         INT DEFAULT 0,
    not_outs      INT DEFAULT 0,
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (team_id)   REFERENCES teams(team_id)
);

CREATE TABLE tournament_bowling_summary (
    summary_id    INT            PRIMARY KEY,
    player_id     INT,
    team_id       INT,
    matches       INT            DEFAULT 0,
    overs         DECIMAL(5,1)   DEFAULT 0,
    runs_conceded INT            DEFAULT 0,
    wickets       INT            DEFAULT 0,
    best_wickets  INT            DEFAULT 0,
    best_runs     INT            DEFAULT 0,
    four_fers     INT            DEFAULT 0,
    five_fers     INT            DEFAULT 0,
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (team_id)   REFERENCES teams(team_id)
);


-- ============================================================
-- STEP 2: INSERT DATASET
-- (Parent tables first to satisfy foreign keys)
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;


-- teams
INSERT INTO teams (team_id, team_name, country_code, group_name, captain) VALUES
('1', 'India', 'IND', 'A', 'Suryakumar Yadav'),
('2', 'Pakistan', 'PAK', 'A', 'Babar Azam'),
('3', 'USA', 'USA', 'A', 'Monank Patel'),
('4', 'Netherlands', 'NED', 'A', 'Scott Edwards'),
('5', 'Namibia', 'NAM', 'A', 'Gerhard Erasmus'),
('6', 'Sri Lanka', 'SL', 'B', 'Charith Asalanka'),
('7', 'Australia', 'AUS', 'B', 'Mitchell Marsh'),
('8', 'Ireland', 'IRE', 'B', 'Paul Stirling'),
('9', 'Zimbabwe', 'ZIM', 'B', 'Sikandar Raza'),
('10', 'Oman', 'OMA', 'B', 'Aqib Ilyas'),
('11', 'England', 'ENG', 'C', 'Jos Buttler'),
('12', 'West Indies', 'WI', 'C', 'Rovman Powell'),
('13', 'Scotland', 'SCO', 'C', 'Richie Berrington'),
('14', 'Italy', 'ITA', 'C', 'Gareth Berg'),
('15', 'Nepal', 'NEP', 'C', 'Rohit Paudel'),
('16', 'South Africa', 'SA', 'D', 'Aiden Markram'),
('17', 'New Zealand', 'NZ', 'D', 'Mitchell Santner'),
('18', 'Afghanistan', 'AFG', 'D', 'Rashid Khan'),
('19', 'Canada', 'CAN', 'D', 'Saad Bin Zafar'),
('20', 'United Arab Emirates', 'UAE', 'D', 'CP Rizwan');

-- venues
INSERT INTO venues (venue_id, venue_name, city, country, capacity) VALUES
('1', 'Narendra Modi Stadium', 'Ahmedabad', 'India', '132000'),
('2', 'MA Chidambaram Stadium', 'Chennai', 'India', '50000'),
('3', 'Arun Jaitley Stadium', 'New Delhi', 'India', '42000'),
('4', 'Wankhede Stadium', 'Mumbai', 'India', '33000'),
('5', 'Eden Gardens', 'Kolkata', 'India', '66000'),
('6', 'R. Premadasa Stadium', 'Colombo', 'Sri Lanka', '35000'),
('7', 'Sinhalese Sports Club Ground', 'Colombo', 'Sri Lanka', '10000'),
('8', 'Pallekele International Cricket Stadium', 'Kandy', 'Sri Lanka', '35000');

-- players
INSERT INTO players (player_id, team_id, player_name, role, batting_style, bowling_style) VALUES
('1', '1', 'Abhishek Sharma', 'All-Rounder', 'Left-hand', 'Left-arm Orthodox'),
('2', '1', 'Sanju Samson', 'Wicket-Keeper', 'Right-hand', NULL),
('3', '1', 'Ishan Kishan', 'Wicket-Keeper', 'Left-hand', NULL),
('4', '1', 'Suryakumar Yadav', 'Batsman', 'Right-hand', 'Right-arm Medium'),
('5', '1', 'Tilak Varma', 'Batsman', 'Left-hand', 'Right-arm Off-spin'),
('6', '1', 'Hardik Pandya', 'All-Rounder', 'Right-hand', 'Right-arm Fast-Medium'),
('7', '1', 'Shivam Dube', 'All-Rounder', 'Left-hand', 'Right-arm Medium'),
('8', '1', 'Axar Patel', 'All-Rounder', 'Left-hand', 'Left-arm Orthodox'),
('9', '1', 'Varun Chakaravarthy', 'Bowler', 'Right-hand', 'Right-arm Mystery Spin'),
('10', '1', 'Arshdeep Singh', 'Bowler', 'Left-hand', 'Left-arm Fast-Medium'),
('11', '1', 'Jasprit Bumrah', 'Bowler', 'Right-hand', 'Right-arm Fast'),
('12', '2', 'Sahibzada Farhan', 'Batsman', 'Right-hand', NULL),
('13', '2', 'Fakhar Zaman', 'Batsman', 'Left-hand', NULL),
('14', '2', 'Babar Azam', 'Batsman', 'Right-hand', NULL),
('15', '2', 'Mohammad Rizwan', 'Wicket-Keeper', 'Right-hand', NULL),
('16', '2', 'Shadab Khan', 'All-Rounder', 'Right-hand', 'Right-arm Leg-spin'),
('17', '2', 'Imad Wasim', 'All-Rounder', 'Left-hand', 'Left-arm Orthodox'),
('18', '2', 'Shaheen Afridi', 'Bowler', 'Left-hand', 'Left-arm Fast'),
('19', '2', 'Haris Rauf', 'Bowler', 'Right-hand', 'Right-arm Fast'),
('20', '2', 'Mohammad Wasim', 'Bowler', 'Right-hand', 'Right-arm Fast-Medium'),
('21', '2', 'Abrar Ahmed', 'Bowler', 'Right-hand', 'Right-arm Leg-spin'),
('22', '11', 'Jos Buttler', 'Wicket-Keeper', 'Right-hand', NULL),
('23', '11', 'Phil Salt', 'Batsman', 'Right-hand', NULL),
('24', '11', 'Harry Brook', 'Batsman', 'Right-hand', 'Right-arm Medium'),
('25', '11', 'Joe Root', 'Batsman', 'Right-hand', 'Right-arm Off-spin'),
('26', '11', 'Liam Livingstone', 'All-Rounder', 'Right-hand', 'Right-arm Leg-spin'),
('27', '11', 'Sam Curran', 'All-Rounder', 'Left-hand', 'Left-arm Fast-Medium'),
('28', '11', 'Will Jacks', 'All-Rounder', 'Right-hand', 'Right-arm Off-spin'),
('29', '11', 'Jofra Archer', 'Bowler', 'Right-hand', 'Right-arm Fast'),
('30', '11', 'Mark Wood', 'Bowler', 'Right-hand', 'Right-arm Fast'),
('31', '11', 'Adil Rashid', 'Bowler', 'Right-hand', 'Right-arm Leg-spin'),
('32', '11', 'Jacob Bethell', 'All-Rounder', 'Left-hand', 'Left-arm Orthodox'),
('33', '16', 'Aiden Markram', 'All-Rounder', 'Right-hand', 'Right-arm Off-spin'),
('34', '16', 'Quinton de Kock', 'Wicket-Keeper', 'Left-hand', NULL),
('35', '16', 'Reeza Hendricks', 'Batsman', 'Right-hand', NULL),
('36', '16', 'Heinrich Klaasen', 'Batsman', 'Right-hand', NULL),
('37', '16', 'David Miller', 'Batsman', 'Left-hand', NULL),
('38', '16', 'Marco Jansen', 'All-Rounder', 'Left-hand', 'Left-arm Fast-Medium'),
('39', '16', 'Kagiso Rabada', 'Bowler', 'Right-hand', 'Right-arm Fast'),
('40', '16', 'Lungi Ngidi', 'Bowler', 'Right-hand', 'Right-arm Fast'),
('41', '16', 'Keshav Maharaj', 'Bowler', 'Left-hand', 'Left-arm Orthodox'),
('42', '16', 'Tabraiz Shamsi', 'Bowler', 'Right-hand', 'Left-arm Wrist-spin'),
('43', '16', 'Shadley van Schalkwyk', 'Bowler', 'Right-hand', 'Right-arm Fast-Medium'),
('44', '17', 'Tim Seifert', 'Wicket-Keeper', 'Right-hand', NULL),
('45', '17', 'Finn Allen', 'Batsman', 'Right-hand', NULL),
('46', '17', 'Rachin Ravindra', 'All-Rounder', 'Left-hand', 'Left-arm Orthodox'),
('47', '17', 'Glenn Phillips', 'All-Rounder', 'Right-hand', 'Right-arm Off-spin'),
('48', '17', 'Mark Chapman', 'Batsman', 'Left-hand', NULL),
('49', '17', 'Daryl Mitchell', 'All-Rounder', 'Right-hand', 'Right-arm Medium'),
('50', '17', 'James Neesham', 'All-Rounder', 'Left-hand', 'Right-arm Fast-Medium');
INSERT INTO players (player_id, team_id, player_name, role, batting_style, bowling_style) VALUES
('51', '17', 'Mitchell Santner', 'All-Rounder', 'Left-hand', 'Left-arm Orthodox'),
('52', '17', 'Matt Henry', 'Bowler', 'Right-hand', 'Right-arm Fast'),
('53', '17', 'Lockie Ferguson', 'Bowler', 'Right-hand', 'Right-arm Fast'),
('54', '17', 'Jacob Duffy', 'Bowler', 'Right-hand', 'Right-arm Fast-Medium'),
('55', '12', 'Rovman Powell', 'Batsman', 'Right-hand', NULL),
('56', '12', 'Kyle Mayers', 'All-Rounder', 'Left-hand', 'Right-arm Medium'),
('57', '12', 'Shai Hope', 'Wicket-Keeper', 'Right-hand', NULL),
('58', '12', 'Brandon King', 'Batsman', 'Right-hand', NULL),
('59', '12', 'Nicholas Pooran', 'Wicket-Keeper', 'Left-hand', NULL),
('60', '12', 'Andre Russell', 'All-Rounder', 'Right-hand', 'Right-arm Fast-Medium'),
('61', '12', 'Jason Holder', 'All-Rounder', 'Right-hand', 'Right-arm Fast-Medium'),
('62', '12', 'Alzarri Joseph', 'Bowler', 'Right-hand', 'Right-arm Fast'),
('63', '9', 'Sikandar Raza', 'All-Rounder', 'Right-hand', 'Right-arm Off-spin'),
('64', '9', 'Craig Ervine', 'Batsman', 'Left-hand', NULL),
('65', '9', 'Tadiwanashe Marumani', 'Batsman', 'Left-hand', NULL),
('66', '9', 'Sean Williams', 'All-Rounder', 'Left-hand', 'Left-arm Orthodox'),
('67', '9', 'Ryan Burl', 'All-Rounder', 'Right-hand', 'Right-arm Leg-spin'),
('68', '9', 'Blessing Muzarabani', 'Bowler', 'Right-hand', 'Right-arm Fast'),
('69', '9', 'Tendai Chatara', 'Bowler', 'Right-hand', 'Right-arm Fast-Medium'),
('70', '9', 'Wellington Masakadza', 'Bowler', 'Right-hand', 'Right-arm Off-spin'),
('71', '6', 'Pathum Nissanka', 'Batsman', 'Right-hand', NULL),
('72', '6', 'Kusal Mendis', 'Wicket-Keeper', 'Right-hand', NULL),
('73', '6', 'Charith Asalanka', 'Batsman', 'Left-hand', 'Right-arm Off-spin'),
('74', '6', 'Dasun Shanaka', 'All-Rounder', 'Right-hand', 'Right-arm Fast-Medium'),
('75', '6', 'Dhananjaya de Silva', 'All-Rounder', 'Right-hand', 'Right-arm Off-spin'),
('76', '6', 'Wanindu Hasaranga', 'All-Rounder', 'Right-hand', 'Right-arm Leg-spin'),
('77', '6', 'Matheesha Pathirana', 'Bowler', 'Right-hand', 'Right-arm Fast'),
('78', '6', 'Maheesh Theekshana', 'Bowler', 'Right-hand', 'Right-arm Off-spin'),
('79', '6', 'Nuwan Thushara', 'Bowler', 'Right-hand', 'Right-arm Fast-Medium'),
('80', '3', 'Monank Patel', 'Wicket-Keeper', 'Left-hand', NULL),
('81', '3', 'Steven Taylor', 'Batsman', 'Right-hand', NULL),
('82', '3', 'Saurabh Netravalkar', 'Bowler', 'Left-hand', 'Left-arm Fast-Medium'),
('83', '3', 'Aaron Jones', 'All-Rounder', 'Right-hand', 'Right-arm Off-spin'),
('84', '3', 'Harmeet Singh', 'Bowler', 'Left-hand', 'Left-arm Orthodox'),
('85', '19', 'Saad Bin Zafar', 'All-Rounder', 'Right-hand', 'Right-arm Medium'),
('86', '19', 'Yuvraj Samra', 'Batsman', 'Right-hand', NULL),
('87', '19', 'Dilpreet Bajwa', 'Batsman', 'Right-hand', NULL),
('88', '19', 'Navneet Dhaliwal', 'Batsman', 'Right-hand', NULL),
('89', '19', 'Dilon Heyliger', 'All-Rounder', 'Right-hand', 'Right-arm Off-spin');

-- matches
INSERT INTO matches (match_id, match_no, match_date, venue_id, team1_id, team2_id, toss_winner_id, toss_decision, winner_id, win_by_type, win_margin, match_stage, player_of_match) VALUES
('1', '1', '2026-02-07', '6', '2', '4', '4', 'field', '2', 'runs', NULL, 'Group', '18'),
('2', '2', '2026-02-07', '3', '12', '13', '12', 'bat', '12', 'wickets', NULL, 'Group', '55'),
('3', '3', '2026-02-07', '4', '1', '3', '1', 'bat', '1', 'runs', NULL, 'Group', '2'),
('4', '4', '2026-02-07', '2', '18', '17', '17', 'field', '17', 'wickets', NULL, 'Group', '44'),
('5', '5', '2026-02-08', '3', '11', '15', '11', 'bat', '11', 'runs', NULL, 'Group', '32'),
('6', '6', '2026-02-08', '8', '6', '8', '8', 'field', '6', 'runs', NULL, 'Group', '71'),
('7', '7', '2026-02-09', '6', '6', '18', '18', 'field', '6', 'runs', NULL, 'Group', '76'),
('8', '8', '2026-02-09', '4', '1', '5', '1', 'bat', '1', 'runs', NULL, 'Group', '9'),
('9', '9', '2026-02-10', '5', '12', '15', '12', 'bat', '12', 'runs', NULL, 'Group', '59'),
('10', '10', '2026-02-10', '3', '11', '13', '11', 'bat', '11', 'runs', NULL, 'Group', '28'),
('11', '11', '2026-02-11', '7', '7', '10', '7', 'bat', '7', 'runs', NULL, 'Group', '39'),
('12', '12', '2026-02-11', '8', '2', '3', '2', 'bat', '2', 'runs', NULL, 'Group', '12'),
('13', '13', '2026-02-12', '2', '16', '19', '16', 'field', '16', 'wickets', NULL, 'Group', '33'),
('14', '14', '2026-02-12', '1', '17', '20', '17', 'bat', '17', 'runs', NULL, 'Group', '46'),
('15', '15', '2026-02-13', '4', '12', '11', '11', 'field', '11', 'runs', NULL, 'Group', '28'),
('16', '16', '2026-02-13', '8', '18', '19', '18', 'bat', '18', 'wickets', NULL, 'Group', '18'),
('17', '17', '2026-02-14', '1', '16', '18', '16', 'field', '16', 'runs', NULL, 'Group', '39'),
('18', '18', '2026-02-14', '5', '1', '5', '1', 'bat', '1', 'runs', NULL, 'Group', '9'),
('19', '19', '2026-02-15', '5', '9', '7', '9', 'field', NULL, 'no result', NULL, 'Group', NULL),
('20', '20', '2026-02-15', '6', '1', '2', '2', 'field', '1', 'runs', '6', 'Group', '11'),
('21', '21', '2026-02-16', '7', '6', '3', '6', 'bat', '6', 'wickets', NULL, 'Group', '72'),
('22', '22', '2026-02-16', '2', '16', '20', '16', 'bat', '16', 'runs', NULL, 'Group', '36'),
('23', '23', '2026-02-17', '4', '12', '8', '12', 'field', '12', 'runs', NULL, 'Group', '60'),
('24', '24', '2026-02-17', '1', '17', '16', '16', 'field', '17', 'runs', NULL, 'Group', '46'),
('25', '25', '2026-02-18', '7', '2', '4', '2', 'bat', '2', 'runs', '178', 'Group', '12'),
('26', '26', '2026-02-18', '3', '1', '4', '1', 'bat', '1', 'runs', NULL, 'Group', '9'),
('27', '27', '2026-02-20', '2', '19', '17', '19', 'bat', '17', 'wickets', NULL, 'Group', '86'),
('28', '28', '2026-02-20', '4', '16', '18', '16', 'field', '16', 'wickets', NULL, 'Group', '42'),
('29', '29', '2026-02-21', '7', '2', '17', '17', 'field', NULL, 'no result', NULL, 'Super 8', NULL),
('30', '30', '2026-02-22', '1', '1', '16', '16', 'field', '16', 'runs', '76', 'Super 8', '39'),
('31', '31', '2026-02-22', '8', '11', '6', '11', 'bat', '11', 'wickets', NULL, 'Super 8', '29'),
('32', '32', '2026-02-23', '4', '9', '12', '12', 'field', '12', 'runs', '107', 'Super 8', '59'),
('33', '33', '2026-02-25', '6', '2', '6', '2', 'bat', '2', 'runs', NULL, 'Super 8', '13'),
('34', '34', '2026-02-26', '1', '12', '16', '16', 'field', '16', 'wickets', '9', 'Super 8', '40'),
('35', '35', '2026-02-26', '2', '1', '9', '1', 'bat', '1', 'runs', '72', 'Super 8', '1'),
('36', '36', '2026-02-27', '5', '11', '17', '11', 'bat', '11', 'runs', NULL, 'Super 8', '24'),
('37', '37', '2026-02-28', '5', '2', '11', '11', 'field', '11', 'wickets', NULL, 'Super 8', '24'),
('38', '38', '2026-03-01', '3', '9', '16', '16', 'field', '16', 'wickets', '5', 'Super 8', '40'),
('39', '39', '2026-03-01', '5', '1', '12', '1', 'bat', '1', 'wickets', '5', 'Super 8', '2'),
('40', '40', '2026-03-02', '8', '17', '6', '17', 'bat', '17', 'wickets', NULL, 'Super 8', '46'),
('41', '41', '2026-03-04', '5', '16', '17', '16', 'field', '17', 'wickets', NULL, 'Semi-Final', '44'),
('42', '42', '2026-03-05', '4', '1', '11', '11', 'field', '1', 'runs', '7', 'Semi-Final', '11'),
('43', '43', '2026-03-08', '1', '1', '17', '17', 'field', '1', 'runs', '96', 'Final', '11');

-- batting_scorecards
INSERT INTO batting_scorecards (batting_id, match_id, player_id, team_id, runs_scored, balls_faced, fours, sixes, dismissal_type) VALUES
('1', '43', '1', '1', '52', '21', '6', '3', 'caught'),
('2', '43', '2', '1', '89', '46', '8', '5', 'caught'),
('3', '43', '3', '1', '54', '25', '6', '3', 'caught'),
('4', '43', '4', '1', '8', '6', '0', '1', 'caught'),
('5', '43', '5', '1', '14', '9', '1', '1', 'not-out'),
('6', '43', '6', '1', '10', '7', '1', '0', 'run-out'),
('7', '43', '7', '1', '24', '10', '3', '2', 'not-out'),
('8', '43', '44', '17', '52', '23', '5', '3', 'caught'),
('9', '43', '45', '17', '9', '8', '1', '0', 'caught'),
('10', '43', '46', '17', '12', '14', '1', '0', 'caught'),
('11', '43', '47', '17', '5', '7', '0', '0', 'bowled'),
('12', '43', '48', '17', '4', '6', '0', '0', 'bowled'),
('13', '43', '49', '17', '11', '9', '0', '1', 'caught'),
('14', '43', '50', '17', '8', '9', '1', '0', 'run-out'),
('15', '43', '51', '17', '43', '29', '4', '1', 'caught'),
('16', '43', '52', '17', '3', '6', '0', '0', 'bowled'),
('17', '43', '53', '17', '6', '5', '1', '0', 'bowled'),
('18', '43', '54', '17', '3', '5', '0', '0', 'caught'),
('19', '42', '1', '1', '18', '12', '2', '1', 'caught'),
('20', '42', '2', '1', '64', '38', '6', '3', 'caught'),
('21', '42', '3', '1', '47', '30', '4', '2', 'caught'),
('22', '42', '4', '1', '23', '16', '2', '1', 'not-out'),
('23', '42', '5', '1', '19', '12', '1', '1', 'caught'),
('24', '42', '7', '1', '12', '8', '1', '0', 'not-out'),
('25', '42', '22', '11', '31', '21', '4', '1', 'caught'),
('26', '42', '23', '11', '45', '32', '5', '1', 'caught'),
('27', '42', '24', '11', '38', '25', '3', '2', 'caught'),
('28', '42', '28', '11', '42', '26', '3', '3', 'caught'),
('29', '42', '26', '11', '18', '14', '2', '0', 'not-out'),
('30', '42', '31', '11', '11', '8', '0', '1', 'bowled'),
('31', '30', '33', '16', '68', '42', '7', '3', 'not-out'),
('32', '30', '34', '16', '42', '28', '4', '2', 'caught'),
('33', '30', '36', '16', '58', '32', '4', '4', 'caught'),
('34', '30', '37', '16', '31', '18', '2', '2', 'not-out'),
('35', '30', '35', '16', '18', '12', '1', '1', 'caught'),
('36', '30', '1', '1', '14', '12', '1', '1', 'caught'),
('37', '30', '2', '1', '28', '19', '3', '1', 'caught'),
('38', '30', '3', '1', '12', '10', '1', '0', 'bowled'),
('39', '30', '4', '1', '22', '17', '1', '1', 'caught'),
('40', '30', '5', '1', '8', '7', '0', '0', 'lbw'),
('41', '30', '6', '1', '17', '14', '1', '1', 'caught'),
('42', '30', '7', '1', '6', '6', '0', '0', 'bowled'),
('43', '39', '58', '12', '38', '26', '4', '2', 'caught'),
('44', '39', '59', '12', '52', '31', '4', '3', 'caught'),
('45', '39', '55', '12', '29', '20', '2', '2', 'not-out'),
('46', '39', '60', '12', '24', '15', '1', '2', 'caught'),
('47', '39', '2', '1', '73', '41', '7', '4', 'caught'),
('48', '39', '1', '1', '19', '14', '2', '1', 'caught'),
('49', '39', '3', '1', '35', '24', '4', '1', 'not-out'),
('50', '39', '4', '1', '22', '14', '2', '1', 'not-out');
INSERT INTO batting_scorecards (batting_id, match_id, player_id, team_id, runs_scored, balls_faced, fours, sixes, dismissal_type) VALUES
('51', '39', '6', '1', '6', '5', '0', '0', 'caught'),
('52', '20', '1', '1', '31', '22', '4', '1', 'caught'),
('53', '20', '2', '1', '54', '33', '5', '3', 'caught'),
('54', '20', '3', '1', '38', '28', '3', '2', 'caught'),
('55', '20', '4', '1', '27', '19', '2', '1', 'not-out'),
('56', '20', '6', '1', '18', '11', '1', '1', 'not-out'),
('57', '20', '12', '2', '43', '29', '5', '2', 'caught'),
('58', '20', '13', '2', '28', '21', '3', '1', 'caught'),
('59', '20', '14', '2', '36', '28', '4', '0', 'caught'),
('60', '20', '15', '2', '22', '16', '2', '0', 'not-out'),
('61', '20', '16', '2', '14', '10', '1', '0', 'caught'),
('62', '25', '12', '2', '107', '58', '10', '6', 'not-out'),
('63', '25', '13', '2', '72', '39', '8', '3', 'caught'),
('64', '41', '44', '17', '82', '44', '8', '4', 'not-out'),
('65', '41', '46', '17', '55', '38', '4', '3', 'not-out'),
('66', '41', '47', '17', '18', '14', '2', '0', 'caught'),
('67', '41', '33', '16', '47', '34', '4', '2', 'caught'),
('68', '41', '34', '16', '38', '26', '3', '1', 'caught'),
('69', '41', '36', '16', '29', '22', '2', '1', 'bowled'),
('70', '41', '37', '16', '22', '18', '1', '1', 'not-out'),
('71', '35', '1', '1', '44', '21', '5', '2', 'caught'),
('72', '35', '2', '1', '61', '35', '6', '3', 'not-out'),
('73', '35', '3', '1', '38', '25', '4', '1', 'caught'),
('74', '35', '4', '1', '22', '14', '2', '1', 'not-out');

-- bowling_scorecards
INSERT INTO bowling_scorecards (bowling_id, match_id, player_id, team_id, overs_bowled, maidens, runs_conceded, wickets, wides, no_balls) VALUES
('1', '43', '11', '1', '4.0', '1', '15', '4', '0', '0'),
('2', '43', '8', '1', '3.0', '0', '27', '3', '0', '0'),
('3', '43', '9', '1', '4.0', '0', '32', '1', '0', '0'),
('4', '43', '10', '1', '4.0', '0', '34', '0', '1', '0'),
('5', '43', '6', '1', '3.0', '0', '29', '1', '0', '0'),
('6', '43', '1', '1', '1.0', '0', '19', '1', '0', '0'),
('7', '43', '52', '17', '4.0', '0', '64', '1', '4', '0'),
('8', '43', '53', '17', '4.0', '0', '48', '0', '0', '0'),
('9', '43', '54', '17', '4.0', '0', '38', '0', '0', '0'),
('10', '43', '50', '17', '3.0', '0', '46', '3', '0', '0'),
('11', '43', '51', '17', '4.0', '0', '36', '1', '0', '0'),
('12', '43', '46', '17', '1.0', '0', '18', '1', '0', '0'),
('13', '42', '11', '1', '4.0', '0', '28', '2', '0', '0'),
('14', '42', '9', '1', '4.0', '0', '64', '1', '0', '0'),
('15', '42', '8', '1', '4.0', '0', '22', '3', '0', '0'),
('16', '42', '10', '1', '4.0', '0', '31', '1', '0', '0'),
('17', '42', '6', '1', '4.0', '0', '38', '2', '1', '0'),
('18', '42', '30', '11', '4.0', '0', '34', '2', '0', '0'),
('19', '42', '31', '11', '4.0', '0', '38', '2', '0', '0'),
('20', '42', '29', '11', '4.0', '0', '42', '1', '0', '0'),
('21', '42', '27', '11', '4.0', '0', '28', '2', '0', '0'),
('22', '42', '28', '11', '4.0', '0', '37', '2', '0', '0'),
('23', '30', '40', '16', '4.0', '1', '12', '3', '0', '0'),
('24', '30', '39', '16', '4.0', '0', '18', '2', '0', '0'),
('25', '30', '42', '16', '4.0', '0', '22', '2', '0', '0'),
('26', '30', '41', '16', '4.0', '0', '26', '1', '1', '0'),
('27', '30', '11', '1', '4.0', '0', '38', '1', '0', '0'),
('28', '30', '9', '1', '4.0', '0', '44', '1', '0', '0'),
('29', '30', '8', '1', '4.0', '0', '29', '2', '0', '0'),
('30', '30', '10', '1', '4.0', '0', '36', '1', '0', '0'),
('31', '30', '6', '1', '4.0', '0', '48', '1', '0', '0'),
('32', '39', '11', '1', '4.0', '0', '24', '2', '0', '0'),
('33', '39', '9', '1', '4.0', '0', '28', '2', '0', '0'),
('34', '39', '8', '1', '4.0', '0', '26', '1', '0', '0'),
('35', '39', '10', '1', '4.0', '0', '22', '2', '0', '0'),
('36', '20', '11', '1', '4.0', '0', '24', '2', '0', '0'),
('37', '20', '9', '1', '4.0', '0', '27', '2', '0', '0'),
('38', '20', '8', '1', '4.0', '0', '26', '2', '0', '0'),
('39', '20', '10', '1', '4.0', '0', '31', '1', '2', '0'),
('40', '20', '6', '1', '4.0', '0', '38', '1', '0', '0'),
('41', '41', '53', '17', '4.0', '0', '24', '2', '0', '0'),
('42', '41', '46', '17', '4.0', '0', '29', '2', '0', '0'),
('43', '41', '51', '17', '4.0', '0', '18', '2', '0', '0'),
('44', '41', '50', '17', '4.0', '0', '36', '1', '0', '0'),
('45', '41', '39', '16', '4.0', '0', '38', '1', '0', '0'),
('46', '41', '42', '16', '4.0', '0', '26', '1', '0', '0'),
('47', '41', '40', '16', '4.0', '0', '32', '2', '0', '0'),
('48', '41', '38', '16', '4.0', '0', '44', '0', '0', '0'),
('49', '35', '11', '1', '4.0', '0', '18', '2', '0', '0'),
('50', '35', '9', '1', '4.0', '0', '22', '3', '0', '0');
INSERT INTO bowling_scorecards (bowling_id, match_id, player_id, team_id, overs_bowled, maidens, runs_conceded, wickets, wides, no_balls) VALUES
('51', '35', '8', '1', '4.0', '0', '24', '2', '0', '0'),
('52', '35', '10', '1', '4.0', '0', '28', '1', '0', '0');

-- fielding_stats
INSERT INTO fielding_stats (fielding_id, match_id, player_id, team_id, catches, run_outs, stumpings) VALUES
('1', '43', '2', '1', '3', '0', '1'),
('2', '43', '5', '1', '1', '0', '0'),
('3', '43', '3', '1', '2', '0', '0'),
('4', '43', '6', '1', '1', '0', '0'),
('5', '43', '44', '17', '2', '0', '1'),
('6', '43', '46', '17', '2', '0', '0'),
('7', '42', '2', '1', '2', '0', '1'),
('8', '42', '3', '1', '1', '0', '0'),
('9', '42', '22', '11', '1', '0', '0'),
('10', '30', '34', '16', '2', '0', '1'),
('11', '30', '2', '1', '2', '0', '0'),
('12', '39', '2', '1', '3', '0', '1'),
('13', '20', '2', '1', '2', '0', '0'),
('14', '41', '44', '17', '3', '0', '1'),
('15', '41', '34', '16', '2', '0', '0'),
('16', '35', '2', '1', '2', '0', '0');

-- tournament_batting_summary
INSERT INTO tournament_batting_summary (summary_id, player_id, team_id, matches, runs, balls, highest_score, fifties, hundreds, fours, sixes, not_outs) VALUES
('1', '12', '2', '7', '383', '239', '107', '2', '2', '38', '18', '2'),
('2', '44', '17', '9', '326', '196', '82', '4', '0', '31', '14', '1'),
('3', '2', '1', '5', '321', '161', '89', '3', '0', '31', '16', '0'),
('4', '3', '1', '6', '317', '182', '78', '3', '0', '28', '14', '1'),
('5', '33', '16', '8', '286', '173', '82', '2', '0', '27', '12', '3'),
('6', '28', '11', '8', '226', '152', '72', '2', '0', '20', '9', '1'),
('7', '14', '2', '7', '219', '148', '67', '1', '0', '22', '6', '2'),
('8', '13', '2', '7', '196', '119', '72', '1', '1', '19', '9', '3'),
('9', '24', '11', '8', '192', '120', '79', '1', '1', '16', '8', '2'),
('10', '86', '19', '4', '175', '101', '110', '0', '1', '13', '8', '0'),
('11', '11', '1', '9', '112', '88', '43', '0', '0', '6', '4', '1'),
('12', '46', '17', '9', '198', '141', '62', '1', '0', '17', '7', '2'),
('13', '59', '12', '7', '187', '122', '68', '1', '0', '16', '8', '1'),
('14', '36', '16', '8', '164', '103', '58', '1', '0', '14', '6', '2'),
('15', '47', '17', '9', '152', '108', '54', '0', '0', '12', '6', '1');

-- tournament_bowling_summary
INSERT INTO tournament_bowling_summary (summary_id, player_id, team_id, matches, overs, runs_conceded, wickets, best_wickets, best_runs, four_fers, five_fers) VALUES
('1', '11', '1', '9', '36.0', '249', '14', '4', '15', '1', '0'),
('2', '9', '1', '9', '36.0', '291', '14', '3', '22', '0', '0'),
('3', '82', '3', '4', '16.0', '84', '13', '4', '18', '1', '0'),
('4', '68', '9', '8', '32.0', '198', '13', '3', '21', '0', '0'),
('5', '31', '11', '8', '32.0', '204', '13', '3', '24', '0', '0'),
('6', '40', '16', '8', '31.0', '167', '12', '3', '18', '0', '0'),
('7', '46', '17', '9', '36.0', '221', '12', '3', '26', '0', '0'),
('8', '16', '2', '7', '27.0', '196', '11', '3', '28', '0', '0'),
('9', '8', '1', '9', '35.0', '218', '11', '3', '22', '0', '0'),
('10', '76', '6', '6', '22.0', '163', '10', '3', '19', '0', '0'),
('11', '19', '2', '7', '26.0', '188', '10', '3', '26', '0', '0'),
('12', '18', '2', '7', '24.0', '172', '9', '3', '24', '0', '0'),
('13', '42', '16', '8', '30.0', '194', '9', '3', '21', '0', '0'),
('14', '53', '17', '9', '34.0', '226', '9', '3', '28', '0', '0');

SET FOREIGN_KEY_CHECKS = 1;


-- ============================================================
-- STEP 3: QUERIES
-- ============================================================

-- ------------------------------------------------------------
-- Q1. Top 10 Run Scorers
-- ------------------------------------------------------------
SELECT 
    p.player_name AS Player,
    t.team_name AS Team,
    s.matches AS Matches,
    s.runs AS Total_Runs,
    s.highest_score AS Highest,
    s.fifties AS Fifties,
    s.hundreds AS Hundreds,
    ROUND(s.runs * 100.0 / NULLIF(s.balls, 0), 2) AS Strike_Rate,
    ROUND(s.runs * 1.0 / NULLIF(s.matches - s.not_outs, 0),
            2) AS Average,
    s.sixes AS Sixes
FROM
    tournament_batting_summary s
        JOIN
    players p ON s.player_id = p.player_id
        JOIN
    teams t ON s.team_id = t.team_id
ORDER BY s.runs DESC
LIMIT 10;

-- ------------------------------------------------------------
-- Q2. Top 10 Wicket Takers
-- ------------------------------------------------------------
SELECT 
    p.player_name AS Player,
    t.team_name AS Team,
    s.matches AS Matches,
    s.overs AS Overs,
    s.wickets AS Wickets,
    ROUND(s.runs_conceded / NULLIF(s.overs, 0), 2) AS Economy,
    ROUND(s.overs * 6 / NULLIF(s.wickets, 0), 2) AS Bowling_SR,
    CONCAT(s.best_wickets, '/', s.best_runs) AS Best_Figures,
    s.four_fers AS Four_Wicket_Hauls
FROM
    tournament_bowling_summary s
        JOIN
    players p ON s.player_id = p.player_id
        JOIN
    teams t ON s.team_id = t.team_id
ORDER BY s.wickets DESC , Economy ASC
LIMIT 10;

-- ------------------------------------------------------------
-- Q3. Highest Batting Strike Rate (min 50 balls)
-- ------------------------------------------------------------
SELECT 
    p.player_name AS Player,
    t.team_name AS Team,
    s.runs AS Runs,
    s.balls AS Balls,
    ROUND(s.runs * 100.0 / NULLIF(s.balls, 0), 2) AS Strike_Rate,
    s.sixes AS Sixes
FROM
    tournament_batting_summary s
        JOIN
    players p ON s.player_id = p.player_id
        JOIN
    teams t ON s.team_id = t.team_id
WHERE
    s.balls >= 50
ORDER BY Strike_Rate DESC
LIMIT 10;

-- ------------------------------------------------------------
-- Q4. Best Bowling Economy (min 16 overs)
-- ------------------------------------------------------------
SELECT 
    p.player_name AS Player,
    t.team_name AS Team,
    s.overs AS Overs,
    s.wickets AS Wickets,
    ROUND(s.runs_conceded / NULLIF(s.overs, 0), 2) AS Economy_Rate
FROM
    tournament_bowling_summary s
        JOIN
    players p ON s.player_id = p.player_id
        JOIN
    teams t ON s.team_id = t.team_id
WHERE
    s.overs >= 16
ORDER BY Economy_Rate ASC
LIMIT 10;

-- ------------------------------------------------------------
-- Q5. All Match Results
-- ------------------------------------------------------------
SELECT 
    m.match_no AS Match_No,
    m.match_date AS Date,
    m.match_stage AS Stage,
    t1.team_name AS Team_1,
    t2.team_name AS Team_2,
    COALESCE(w.team_name, 'No Result') AS Winner,
    m.win_by_type AS Win_By,
    m.win_margin AS Margin,
    v.city AS City,
    p.player_name AS Player_of_Match
FROM
    matches m
        JOIN
    teams t1 ON m.team1_id = t1.team_id
        JOIN
    teams t2 ON m.team2_id = t2.team_id
        JOIN
    venues v ON m.venue_id = v.venue_id
        LEFT JOIN
    teams w ON m.winner_id = w.team_id
        LEFT JOIN
    players p ON m.player_of_match = p.player_id
ORDER BY m.match_no;

-- ------------------------------------------------------------
-- Q6. Team Win / Loss Record
-- ------------------------------------------------------------
SELECT 
    t.team_name AS Team,
    COUNT(m.match_id) AS Played,
    SUM(CASE
        WHEN m.winner_id = t.team_id THEN 1
        ELSE 0
    END) AS Wins,
    SUM(CASE
        WHEN
            m.winner_id != t.team_id
                AND m.winner_id IS NOT NULL
        THEN
            1
        ELSE 0
    END) AS Losses,
    SUM(CASE
        WHEN m.winner_id IS NULL THEN 1
        ELSE 0
    END) AS No_Result,
    ROUND(SUM(CASE
                WHEN m.winner_id = t.team_id THEN 1
                ELSE 0
            END) * 100.0 / NULLIF(COUNT(m.match_id), 0),
            1) AS Win_Pct
FROM
    teams t
        JOIN
    matches m ON t.team_id IN (m.team1_id , m.team2_id)
GROUP BY t.team_id , t.team_name
ORDER BY Wins DESC;

-- ------------------------------------------------------------
-- Q7. Most Sixes — Power Hitters
-- ------------------------------------------------------------
SELECT 
    p.player_name AS Player,
    t.team_name AS Team,
    SUM(b.sixes) AS Total_Sixes,
    SUM(b.fours) AS Total_Fours,
    SUM(b.runs_scored) AS Runs
FROM
    batting_scorecards b
        JOIN
    players p ON b.player_id = p.player_id
        JOIN
    teams t ON b.team_id = t.team_id
GROUP BY b.player_id , p.player_name , t.team_name
HAVING SUM(b.sixes) > 0
ORDER BY Total_Sixes DESC
LIMIT 10;

-- ------------------------------------------------------------
-- Q8. Highest Individual Score in a Single Match
-- ------------------------------------------------------------
SELECT 
    p.player_name AS Player,
    t.team_name AS Team,
    b.runs_scored AS Runs,
    b.balls_faced AS Balls,
    ROUND(b.runs_scored * 100.0 / NULLIF(b.balls_faced, 0),
            2) AS Strike_Rate,
    b.fours AS Fours,
    b.sixes AS Sixes,
    b.dismissal_type AS Dismissal,
    opp.team_name AS Opponent,
    m.match_date AS Date,
    m.match_stage AS Stage
FROM
    batting_scorecards b
        JOIN
    players p ON b.player_id = p.player_id
        JOIN
    teams t ON b.team_id = t.team_id
        JOIN
    matches m ON b.match_id = m.match_id
        JOIN
    teams opp ON (CASE
        WHEN m.team1_id = b.team_id THEN m.team2_id
        ELSE m.team1_id
    END) = opp.team_id
ORDER BY b.runs_scored DESC
LIMIT 10;

-- ------------------------------------------------------------
-- Q9. Best Bowling Figures in a Single Match
-- ------------------------------------------------------------
SELECT 
    p.player_name AS Player,
    t.team_name AS Team,
    bw.wickets AS Wickets,
    bw.runs_conceded AS Runs_Given,
    bw.overs_bowled AS Overs,
    ROUND(bw.runs_conceded / NULLIF(bw.overs_bowled, 0),
            2) AS Economy,
    opp.team_name AS Against,
    m.match_date AS Date,
    m.match_stage AS Stage
FROM
    bowling_scorecards bw
        JOIN
    players p ON bw.player_id = p.player_id
        JOIN
    teams t ON bw.team_id = t.team_id
        JOIN
    matches m ON bw.match_id = m.match_id
        JOIN
    teams opp ON (CASE
        WHEN m.team1_id = bw.team_id THEN m.team2_id
        ELSE m.team1_id
    END) = opp.team_id
ORDER BY bw.wickets DESC , bw.runs_conceded ASC
LIMIT 10;

-- ------------------------------------------------------------
-- Q10. Semi-Finals and Final Results
-- ------------------------------------------------------------
SELECT 
    m.match_stage AS Stage,
    m.match_date AS Date,
    t1.team_name AS Team_1,
    t2.team_name AS Team_2,
    COALESCE(w.team_name, 'No Result') AS Winner,
    m.win_by_type AS Win_By,
    m.win_margin AS Margin,
    p.player_name AS Player_of_Match,
    v.city AS City
FROM
    matches m
        JOIN
    teams t1 ON m.team1_id = t1.team_id
        JOIN
    teams t2 ON m.team2_id = t2.team_id
        JOIN
    venues v ON m.venue_id = v.venue_id
        LEFT JOIN
    teams w ON m.winner_id = w.team_id
        LEFT JOIN
    players p ON m.player_of_match = p.player_id
WHERE
    m.match_stage IN ('Semi-Final' , 'Final')
ORDER BY m.match_date;

-- ------------------------------------------------------------
-- Q11. Century Scorers of the Tournament
-- ------------------------------------------------------------
SELECT 
    p.player_name AS Player,
    t.team_name AS Team,
    s.hundreds AS Centuries,
    s.fifties AS Fifties,
    s.highest_score AS Highest_Score,
    s.runs AS Total_Runs
FROM
    tournament_batting_summary s
        JOIN
    players p ON s.player_id = p.player_id
        JOIN
    teams t ON s.team_id = t.team_id
WHERE
    s.hundreds > 0
ORDER BY s.hundreds DESC , s.runs DESC;

-- ------------------------------------------------------------
-- Q12. India's Road to the Title
-- ------------------------------------------------------------
SELECT 
    m.match_date AS Date,
    m.match_stage AS Stage,
    opp.team_name AS Opponent,
    v.city AS City,
    COALESCE(w.team_name, 'No Result') AS Result,
    m.win_by_type AS Win_By,
    m.win_margin AS Margin,
    p.player_name AS Player_of_Match
FROM
    matches m
        JOIN
    teams opp ON (CASE
        WHEN m.team1_id = 1 THEN m.team2_id
        ELSE m.team1_id
    END) = opp.team_id
        JOIN
    venues v ON m.venue_id = v.venue_id
        LEFT JOIN
    teams w ON m.winner_id = w.team_id
        LEFT JOIN
    players p ON m.player_of_match = p.player_id
WHERE
    1 IN (m.team1_id , m.team2_id)
ORDER BY m.match_date;

-- ------------------------------------------------------------
-- Q13. Venue Statistics
-- ------------------------------------------------------------
SELECT 
    v.venue_name AS Venue,
    v.city AS City,
    v.country AS Country,
    v.capacity AS Capacity,
    COUNT(m.match_id) AS Matches_Hosted,
    SUM(CASE
        WHEN m.match_stage = 'Final' THEN 1
        ELSE 0
    END) AS Finals,
    SUM(CASE
        WHEN m.match_stage = 'Semi-Final' THEN 1
        ELSE 0
    END) AS Semis,
    SUM(CASE
        WHEN m.match_stage = 'Super 8' THEN 1
        ELSE 0
    END) AS Super_8s,
    SUM(CASE
        WHEN m.match_stage = 'Group' THEN 1
        ELSE 0
    END) AS Group_Matches
FROM
    venues v
        LEFT JOIN
    matches m ON v.venue_id = m.venue_id
GROUP BY v.venue_id , v.venue_name , v.city , v.country , v.capacity
ORDER BY Matches_Hosted DESC;

-- ------------------------------------------------------------
-- Q14. Top Fielders
-- ------------------------------------------------------------
SELECT 
    p.player_name AS Player,
    t.team_name AS Team,
    SUM(f.catches) AS Catches,
    SUM(f.run_outs) AS Run_Outs,
    SUM(f.stumpings) AS Stumpings,
    SUM(f.catches + f.run_outs + f.stumpings) AS Total_Dismissals
FROM
    fielding_stats f
        JOIN
    players p ON f.player_id = p.player_id
        JOIN
    teams t ON f.team_id = t.team_id
GROUP BY f.player_id , p.player_name , t.team_name
ORDER BY Total_Dismissals DESC
LIMIT 10;

-- ------------------------------------------------------------
-- Q15. Player of the Match Awards
-- ------------------------------------------------------------
SELECT 
    p.player_name AS Player,
    t.team_name AS Team,
    COUNT(*) AS POTM_Awards
FROM
    matches m
        JOIN
    players p ON m.player_of_match = p.player_id
        JOIN
    teams t ON p.team_id = t.team_id
GROUP BY m.player_of_match , p.player_name , t.team_name
ORDER BY POTM_Awards DESC
LIMIT 10;

-- ------------------------------------------------------------
-- Q16. Toss Impact — Did Toss Winner Win?
-- ------------------------------------------------------------
SELECT 
    t1.team_name AS Toss_Winner,
    m.toss_decision AS Decision,
    COALESCE(w.team_name, 'No Result') AS Match_Winner,
    CASE
        WHEN m.winner_id IS NULL THEN 'No Result'
        WHEN m.toss_winner_id = m.winner_id THEN 'YES'
        ELSE 'NO'
    END AS Toss_Winner_Won,
    m.match_stage AS Stage
FROM
    matches m
        JOIN
    teams t1 ON m.toss_winner_id = t1.team_id
        LEFT JOIN
    teams w ON m.winner_id = w.team_id
ORDER BY m.match_no;

-- ------------------------------------------------------------
-- Q17. Group Stage Qualification Table
-- ------------------------------------------------------------
SELECT 
    t.group_name AS Grp,
    t.team_name AS Team,
    COUNT(m.match_id) AS Played,
    SUM(CASE
        WHEN
            m.winner_id = t.team_id
                AND m.match_stage = 'Group'
        THEN
            1
        ELSE 0
    END) AS Wins,
    SUM(CASE
        WHEN
            m.winner_id != t.team_id
                AND m.winner_id IS NOT NULL
                AND m.match_stage = 'Group'
        THEN
            1
        ELSE 0
    END) AS Losses,
    CASE
        WHEN t.team_id IN (1 , 2, 6, 9, 11, 12, 16, 17) THEN 'Qualified - Super 8'
        ELSE 'Eliminated'
    END AS Status
FROM
    teams t
        LEFT JOIN
    matches m ON t.team_id IN (m.team1_id , m.team2_id)
        AND m.match_stage = 'Group'
GROUP BY t.team_id , t.team_name , t.group_name
ORDER BY t.group_name , Wins DESC;

-- ------------------------------------------------------------
-- Q18. Final Full Scorecard — Batting
-- ------------------------------------------------------------
SELECT 
    t.team_name AS Team,
    p.player_name AS Batsman,
    b.runs_scored AS Runs,
    b.balls_faced AS Balls,
    ROUND(b.runs_scored * 100.0 / NULLIF(b.balls_faced, 0),
            2) AS SR,
    b.fours AS Fours,
    b.sixes AS Sixes,
    b.dismissal_type AS Dismissal
FROM
    batting_scorecards b
        JOIN
    players p ON b.player_id = p.player_id
        JOIN
    teams t ON b.team_id = t.team_id
WHERE
    b.match_id = 43
ORDER BY t.team_name DESC , b.runs_scored DESC;

-- ------------------------------------------------------------
-- Q19. Final Full Scorecard — Bowling
-- ------------------------------------------------------------
SELECT 
    t.team_name AS Bowling_Team,
    p.player_name AS Bowler,
    bw.overs_bowled AS Overs,
    bw.maidens AS Maidens,
    bw.runs_conceded AS Runs,
    bw.wickets AS Wickets,
    ROUND(bw.runs_conceded / NULLIF(bw.overs_bowled, 0),
            2) AS Economy,
    bw.wides AS Wides,
    bw.no_balls AS No_Balls
FROM
    bowling_scorecards bw
        JOIN
    players p ON bw.player_id = p.player_id
        JOIN
    teams t ON bw.team_id = t.team_id
WHERE
    bw.match_id = 43
ORDER BY t.team_name DESC , bw.wickets DESC;

-- ------------------------------------------------------------
-- Q20. Super 8 Results
-- ------------------------------------------------------------
SELECT 
    m.match_date AS Date,
    t1.team_name AS Team_1,
    t2.team_name AS Team_2,
    COALESCE(w.team_name, 'No Result') AS Winner,
    m.win_by_type AS Win_By,
    m.win_margin AS Margin,
    p.player_name AS POTM,
    v.city AS City
FROM
    matches m
        JOIN
    teams t1 ON m.team1_id = t1.team_id
        JOIN
    teams t2 ON m.team2_id = t2.team_id
        JOIN
    venues v ON m.venue_id = v.venue_id
        LEFT JOIN
    teams w ON m.winner_id = w.team_id
        LEFT JOIN
    players p ON m.player_of_match = p.player_id
WHERE
    m.match_stage = 'Super 8'
ORDER BY m.match_date;

-- ============================================================
