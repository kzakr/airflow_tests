INSERT INTO tickers_decreasing_yahoo
WITH filtered_closes AS (
    SELECT ticker, _date, close
    FROM yahoo_result
    WHERE _date > DATE('2026-05-27')
      AND ticker IN (
          SELECT ticker
          FROM yahoo_result
          GROUP BY ticker
          HAVING AVG(volume) > 2500000
      )
),
close_lags AS (
    SELECT
        ticker,
        _date,
        close,
        lag(close, 1) OVER (PARTITION BY ticker ORDER BY _date) AS close_one_day_back,
        lag(close, 2) OVER (PARTITION BY ticker ORDER BY _date) AS close_two_day_back,
        lag(close, 3) OVER (PARTITION BY ticker ORDER BY _date) AS close_three_day_back,
        lag(close, 4) OVER (PARTITION BY ticker ORDER BY _date) AS close_four_day_back,
        lag(close, 5) OVER (PARTITION BY ticker ORDER BY _date) AS close_five_day_back,
        lag(close, 6) OVER (PARTITION BY ticker ORDER BY _date) AS close_six_day_back,
        lag(close, 7) OVER (PARTITION BY ticker ORDER BY _date) AS close_seven_day_back,
        lag(close, 8) OVER (PARTITION BY ticker ORDER BY _date) AS close_eight_day_back,
        lag(_date, 1) OVER (PARTITION BY ticker ORDER BY _date) AS close_one_day_back_date,
        lag(_date, 2) OVER (PARTITION BY ticker ORDER BY _date) AS close_two_day_back_date,
        lag(_date, 3) OVER (PARTITION BY ticker ORDER BY _date) AS close_three_day_back_date,
        lag(_date, 4) OVER (PARTITION BY ticker ORDER BY _date) AS close_four_day_back_date,
        lag(_date, 5) OVER (PARTITION BY ticker ORDER BY _date) AS close_five_day_back_date,
        lag(_date, 6) OVER (PARTITION BY ticker ORDER BY _date) AS close_six_day_back_date,
        lag(_date, 7) OVER (PARTITION BY ticker ORDER BY _date) AS close_seven_day_back_date,
        lag(_date, 8) OVER (PARTITION BY ticker ORDER BY _date) AS close_eight_day_back_date
    FROM filtered_closes
),
close_decrease AS (
    SELECT
        ticker,
        _date,
        CASE
            WHEN close < close_one_day_back
                 AND close_one_day_back < close_two_day_back
                 AND close_two_day_back < close_three_day_back
                 AND close_three_day_back < close_four_day_back
                 AND close_four_day_back < close_five_day_back
                 AND close_five_day_back < close_six_day_back
                 AND close_six_day_back < close_seven_day_back
                 AND close_seven_day_back < close_eight_day_back
                THEN add_working_days_date(_date, 8)
            WHEN close < close_one_day_back
                 AND close_one_day_back < close_two_day_back
                 AND close_two_day_back < close_three_day_back
                 AND close_three_day_back < close_four_day_back
                 AND close_four_day_back < close_five_day_back
                 AND close_five_day_back < close_six_day_back
                 AND close_six_day_back < close_seven_day_back
                THEN add_working_days_date(_date, 7)
            WHEN close < close_one_day_back
                 AND close_one_day_back < close_two_day_back
                 AND close_two_day_back < close_three_day_back
                 AND close_three_day_back < close_four_day_back
                 AND close_four_day_back < close_five_day_back
                 AND close_five_day_back < close_six_day_back
                THEN add_working_days_date(_date, 6)
            WHEN close < close_one_day_back
                 AND close_one_day_back < close_two_day_back
                 AND close_two_day_back < close_three_day_back
                 AND close_three_day_back < close_four_day_back
                 AND close_four_day_back < close_five_day_back
                THEN add_working_days_date(_date, 5)
            WHEN close < close_one_day_back
                 AND close_one_day_back < close_two_day_back
                 AND close_two_day_back < close_three_day_back
                 AND close_three_day_back < close_four_day_back
                THEN add_working_days_date(_date, 4)
            WHEN close < close_one_day_back
                 AND close_one_day_back < close_two_day_back
                 AND close_two_day_back < close_three_day_back
                THEN add_working_days_date(_date, 3)
        END AS days_back
    FROM close_lags
    WHERE close < close_one_day_back
      AND close_one_day_back < close_two_day_back
      AND close_two_day_back < close_three_day_back
),
filtered_volumes AS (
    SELECT ticker, _date, AVG(volume) AS volume
    FROM yahoo_result
    WHERE _date > DATE('2026-05-27')
      AND ticker IN (
          SELECT ticker
          FROM yahoo_result
          GROUP BY ticker
          HAVING AVG(volume) > 2500000
      )
    GROUP BY ticker, _date
),
volume_lags AS (
    SELECT
        ticker,
        _date,
        volume,
        lag(volume, 1) OVER (PARTITION BY ticker ORDER BY _date) AS volume_one_day_back,
        lag(volume, 2) OVER (PARTITION BY ticker ORDER BY _date) AS volume_two_day_back,
        lag(volume, 3) OVER (PARTITION BY ticker ORDER BY _date) AS volume_three_day_back,
        lag(volume, 4) OVER (PARTITION BY ticker ORDER BY _date) AS volume_four_day_back,
        lag(volume, 5) OVER (PARTITION BY ticker ORDER BY _date) AS volume_five_day_back,
        lag(volume, 6) OVER (PARTITION BY ticker ORDER BY _date) AS volume_six_day_back,
        lag(volume, 7) OVER (PARTITION BY ticker ORDER BY _date) AS volume_seven_day_back,
        lag(volume, 8) OVER (PARTITION BY ticker ORDER BY _date) AS volume_eight_day_back,
        lag(_date, 1) OVER (PARTITION BY ticker ORDER BY _date) AS volume_one_day_back_date,
        lag(_date, 2) OVER (PARTITION BY ticker ORDER BY _date) AS volume_two_day_back_date,
        lag(_date, 3) OVER (PARTITION BY ticker ORDER BY _date) AS volume_three_day_back_date,
        lag(_date, 4) OVER (PARTITION BY ticker ORDER BY _date) AS volume_four_day_back_date,
        lag(_date, 5) OVER (PARTITION BY ticker ORDER BY _date) AS volume_five_day_back_date,
        lag(_date, 6) OVER (PARTITION BY ticker ORDER BY _date) AS volume_six_day_back_date,
        lag(_date, 7) OVER (PARTITION BY ticker ORDER BY _date) AS volume_seven_day_back_date,
        lag(_date, 8) OVER (PARTITION BY ticker ORDER BY _date) AS volume_eight_day_back_date
    FROM filtered_volumes
),
volume_decrease AS (
    SELECT
        ticker,
        _date,
        CASE
            WHEN volume < volume_one_day_back
                 AND volume_one_day_back < volume_two_day_back
                 AND volume_two_day_back < volume_three_day_back
                 AND volume_three_day_back < volume_four_day_back
                 AND volume_four_day_back < volume_five_day_back
                 AND volume_five_day_back < volume_six_day_back
                 AND volume_six_day_back < volume_seven_day_back
                 AND volume_seven_day_back < volume_eight_day_back
                THEN add_working_days_date(_date, 8)
            WHEN volume < volume_one_day_back
                 AND volume_one_day_back < volume_two_day_back
                 AND volume_two_day_back < volume_three_day_back
                 AND volume_three_day_back < volume_four_day_back
                 AND volume_four_day_back < volume_five_day_back
                 AND volume_five_day_back < volume_six_day_back
                 AND volume_six_day_back < volume_seven_day_back
                THEN add_working_days_date(_date, 7)
            WHEN volume < volume_one_day_back
                 AND volume_one_day_back < volume_two_day_back
                 AND volume_two_day_back < volume_three_day_back
                 AND volume_three_day_back < volume_four_day_back
                 AND volume_four_day_back < volume_five_day_back
                 AND volume_five_day_back < volume_six_day_back
                THEN add_working_days_date(_date, 6)
            WHEN volume < volume_one_day_back
                 AND volume_one_day_back < volume_two_day_back
                 AND volume_two_day_back < volume_three_day_back
                 AND volume_three_day_back < volume_four_day_back
                 AND volume_four_day_back < volume_five_day_back
                THEN add_working_days_date(_date, 5)
            WHEN volume < volume_one_day_back
                 AND volume_one_day_back < volume_two_day_back
                 AND volume_two_day_back < volume_three_day_back
                 AND volume_three_day_back < volume_four_day_back
                THEN add_working_days_date(_date, 4)
            WHEN volume < volume_one_day_back
                 AND volume_one_day_back < volume_two_day_back
                 AND volume_two_day_back < volume_three_day_back
                THEN add_working_days_date(_date, 3)
        END AS avg_days_back
    FROM volume_lags
    WHERE volume < volume_one_day_back
      AND volume_one_day_back < volume_two_day_back
      AND volume_two_day_back < volume_three_day_back
)
SELECT
    CURRENT_DATE AS current_date_,
    aa.ticker,
    aa._date,
    aa.days_back,
    bb.ticker AS avg_ticker,
    bb._date AS avg_date,
    bb.avg_days_back
FROM close_decrease aa
JOIN volume_decrease bb ON aa.ticker = bb.ticker
    AND aa._date = bb._date
    AND aa.days_back = bb.avg_days_back;
	

