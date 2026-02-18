CREATE OR REPLACE VIEW statistical_results AS SELECT * FROM (
WITH tickers_increasing as (
    select * from tickers_increasing
)
, tickers_decreasing as (
select * from tickers_decreasing
)
select tickers_increasing.*, tickers_decreasing.current_date_ as current_date__2,
    tickers_decreasing.ticker as ticker_2, 
    tickers_decreasing.full_date AS full_date_2, 
    tickers_decreasing.days_back AS days_back_2, 
    tickers_decreasing.avg_ticker AS avg_ticker_2, 
    tickers_decreasing.avg_full_date AS avg_full_date_2, 
    tickers_decreasing.avg_days_back AS avg_days_back_2  from tickers_increasing JOIN tickers_decreasing
ON tickers_increasing.ticker=tickers_decreasing.ticker AND
(tickers_increasing.full_date = tickers_decreasing.days_back OR tickers_increasing.days_back=tickers_decreasing.full_date)
where tickers_increasing.current_date_ in (select MAX(current_date_) FROM tickers_increasing)
and tickers_decreasing.current_date_ in (select MAX(current_date_) FROM tickers_decreasing)
);

select * from statistical_results


