CREATE OR REPLACE VIEW statistical_results_yahoo AS SELECT * FROM (
WITH tickers_increasing as (
    select current_date_, ticker, _date, avg_ticker, avg_date, 
    to_date(days_back::text, 'YYYYMMDD') AS days_back, to_date(avg_days_back::text, 'YYYYMMDD') AS avg_days_back from tickers_increasing_yahoo
)
, tickers_decreasing as (
select current_date_, ticker, _date, avg_ticker, avg_date, 
    to_date(days_back::text, 'YYYYMMDD') AS days_back, to_date(avg_days_back::text, 'YYYYMMDD') AS avg_days_back  from tickers_decreasing_yahoo
)
, ranked_data AS (
  SELECT *, RANK() OVER (PARTITION BY ticker, _date  ORDER BY current_date_ DESC) AS rank
  FROM (
    select tickers_increasing.*, tickers_decreasing.current_date_ as current_date__2,
    tickers_decreasing.ticker as ticker_2, 
    tickers_decreasing._date AS _date_2, 
    tickers_decreasing.days_back AS days_back_2, 
    tickers_decreasing.avg_ticker AS avg_ticker_2, 
    tickers_decreasing.avg_date AS avg_date_2, 
    tickers_decreasing.avg_days_back AS avg_days_back_2  from tickers_increasing JOIN tickers_decreasing
ON tickers_increasing.ticker=tickers_decreasing.ticker AND
(
  tickers_increasing._date = tickers_decreasing.days_back 
  OR tickers_increasing.days_back = tickers_decreasing._date
  OR ABS(tickers_increasing._date - tickers_decreasing.days_back) <= 3
  OR ABS(tickers_increasing.days_back - tickers_decreasing._date) <= 3
)
--where tickers_increasing.current_date_ in (select MAX(current_date_) FROM tickers_increasing)
--or tickers_decreasing.current_date_ in (select MAX(current_date_) FROM tickers_decreasing)
) AS subquery
)
SELECT * FROM ranked_data WHERE rank = 1
);

select * from statistical_results_yahoo

