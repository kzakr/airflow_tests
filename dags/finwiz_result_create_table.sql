CREATE TABLE IF NOT EXISTS finwiz_result (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(100),
    short_name VARCHAR(100),
    No_	INT,
    Ticker	VARCHAR(100),
    Company	VARCHAR(100),
    Sector	VARCHAR(100),
    Industry	VARCHAR(100),
    Country_Market	VARCHAR(100),
    P_E	DECIMAL(38,8),
    Price DECIMAL(38,8)	,
    Change_	DECIMAL(38,8),
    Volume	DECIMAL(38,8),
    time_day VARCHAR(100)

);