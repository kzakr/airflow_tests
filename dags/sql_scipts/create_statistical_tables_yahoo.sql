  CREATE TABLE IF NOT EXISTS  tickers_increasing_yahoo(
    current_date_ DATE,
    ticker VARCHAR(10), 
      _date DATE,
    days_back INT, 
    avg_ticker VARCHAR(10), 
    avg_date DATE, 
    avg_days_back INT
  );


  CREATE TABLE IF NOT EXISTS tickers_decreasing_yahoo(
    current_date_ DATE,
      ticker VARCHAR(10), 
      _date DATE, 
    days_back INT, 
    avg_ticker VARCHAR(10), 
    avg_date DATE, 
    avg_days_back INT
  );

