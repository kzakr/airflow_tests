WITH start_date AS (
    SELECT ticker, _date AS min_date, close AS start_close
    FROM yahoo_check_result
    where _date = (SELECT MIN(_date) FROM yahoo_check_result)
)
, end_date AS (
    SELECT ticker, _date AS max_date, close AS end_close
    FROM yahoo_check_result
    where _date = (SELECT MAX(_date) FROM yahoo_check_result)
)
SELECT s.ticker, s.min_date, e.max_date, s.start_close, e.end_close, (e.end_close - s.start_close)/s.start_close *100 AS price_change_percentage
FROM start_date s
JOIN end_date e ON s.ticker = e.ticker
ORDER BY price_change_percentage DESC;