--CREATE OR REPLACE VIEW statistical_results_yahoo AS
SELECT * FROM (

WITH tickers_increasing as (
    select current_date_, ticker, _date, avg_ticker, avg_date, days_back, avg_days_back from tickers_increasing_yahoo
)
, tickers_decreasing as (
select current_date_, ticker, _date, avg_ticker, avg_date, days_back, avg_days_back from tickers_decreasing_yahoo
)
, ranked_data AS (
  SELECT *, CASE WHEN increasing_ind IS NOT NULL THEN 'WAS INCREASING' ELSE NULL END AS is_increasing_stauts, row_number() OVER (PARTITION BY ticker ORDER BY current_date_ DESC, _date DESC) AS rank
  FROM (
    select-- tickers_increasing.ticker, tickers_increasing.current_date_ , tickers_increasing._date,
     tickers_decreasing.ticker, tickers_decreasing._date, tickers_decreasing.days_back, tickers_decreasing.current_date_, tickers_increasing.ticker as increasing_ind

  from  tickers_decreasing LEFT JOIN tickers_increasing
ON tickers_increasing.ticker=tickers_decreasing.ticker-- AND
--(
--  tickers_increasing._date = tickers_decreasing.days_back 
--  OR tickers_increasing.days_back = tickers_decreasing._date
--  OR ABS(tickers_increasing._date - tickers_decreasing.days_back) <= 3
--  OR ABS(tickers_increasing.days_back - tickers_decreasing._date) <= 3
--)
--where tickers_increasing.current_date_ in (select MAX(current_date_) FROM tickers_increasing)
--or tickers_decreasing.current_date_ in (select MAX(current_date_) FROM tickers_decreasing)
)
)
SELECT * FROM ranked_data WHERE rank = 1
);
