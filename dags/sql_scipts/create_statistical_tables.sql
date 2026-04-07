  CREATE TABLE IF NOT EXISTS tickers_increasing(
    current_date_ DATE,
    ticker VARCHAR(10), 
    full_date INT, 
    days_back INT, 
    avg_ticker VARCHAR(10), 
    avg_full_date INT, 
    avg_days_back INT
  );


  CREATE TABLE IF NOT EXISTS tickers_decreasing(
    current_date_ DATE,
    ticker VARCHAR(10), 
    full_date INT, 
    days_back INT, 
    avg_ticker VARCHAR(10), 
    avg_full_date INT, 
    avg_days_back INT
  );

