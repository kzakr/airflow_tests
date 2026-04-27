INSERT INTO tickers_decreasing_yahoo select * from (with aa as (
	select ticker as ticker, _date as _date,  CASE WHEN (
	close < 1*close_two_day_back  AND 
	close_two_day_back < 1*close_three_day_back  AND 
	close_three_day_back < 1*close_four_day_back  AND 
	close_four_day_back < 1*close_five_day_back  AND 
	close_five_day_back < 1*close_six_day_back  AND 
	close_six_day_back < 1*close_seven_day_back  AND 
	close_seven_day_back < 1*close_eight_day_back ) then add_working_days_date(_date, 8)
WHEN (
	close < 1*close_two_day_back  AND 
	close_two_day_back < 1*close_three_day_back  AND 
	close_three_day_back < 1*close_four_day_back  AND 
	close_four_day_back < 1*close_five_day_back  AND 
	close_five_day_back < 1*close_six_day_back  AND 
	close_six_day_back < 1*close_seven_day_back ) then add_working_days_date(_date, 7)
WHEN (
	close < 1*close_two_day_back  AND 
	close_two_day_back < 1*close_three_day_back  AND 
	close_three_day_back < 1*close_four_day_back  AND 
	close_four_day_back < 1*close_five_day_back  AND 
	close_five_day_back < 1*close_six_day_back ) then add_working_days_date(_date, 6)
WHEN (
	close < 1*close_two_day_back  AND 
	close_two_day_back < 1*close_three_day_back  AND 
	close_three_day_back < 1*close_four_day_back  AND 
	close_four_day_back < 1*close_five_day_back ) then add_working_days_date(_date, 5)
WHEN (
	close < 1*close_two_day_back  AND 
	close_two_day_back < 1*close_three_day_back  AND 
	close_three_day_back < 1*close_four_day_back ) then add_working_days_date(_date, 4)
WHEN (
	close < 1*close_two_day_back  AND 
	close_two_day_back < 1*close_three_day_back ) then add_working_days_date(_date, 3)

 end as days_back
from ( 
	select *
	, lag(close, 1) OVER (PARTITION BY ticker ORDER BY _date) AS close_one_day_back
	, lag(close, 2) OVER (PARTITION BY ticker ORDER BY _date) AS close_two_day_back
	, lag(close, 3) OVER (PARTITION BY ticker ORDER BY _date) AS close_three_day_back
	, lag(close, 4) OVER (PARTITION BY ticker ORDER BY _date) AS close_four_day_back
	, lag(close, 5) OVER (PARTITION BY ticker ORDER BY _date) AS close_five_day_back
	, lag(close, 6) OVER (PARTITION BY ticker ORDER BY _date) AS close_six_day_back
	, lag(close, 7) OVER (PARTITION BY ticker ORDER BY _date) AS close_seven_day_back
	, lag(close, 8) OVER (PARTITION BY ticker ORDER BY _date) AS close_eight_day_back
from ( 
	select * from (
	(select ticker, _date, close AS close, volume as volume from yahoo_result 
where  
 _date > DATE('2026-03-30')  
AND  ticker in 
	(
		select ticker from yahoo_result 
		group by ticker
		having avg(volume)>2500000
)))
) 

)
where (
	close < 1*close_two_day_back  AND 
	close_two_day_back < 1*close_three_day_back )
OR (
	close < 1*close_two_day_back  AND 
	close_two_day_back < 1*close_three_day_back   AND 
	close_three_day_back < 1*close_four_day_back )
OR (
	close < 1*close_two_day_back  AND 
	close_two_day_back < 1*close_three_day_back   AND 
	close_three_day_back < 1*close_four_day_back   AND 
	close_four_day_back < 1*close_five_day_back )
OR (
	close < 1*close_two_day_back  AND 
	close_two_day_back < 1*close_three_day_back   AND 
	close_three_day_back < 1*close_four_day_back   AND 
	close_four_day_back < 1*close_five_day_back   AND 
	close_five_day_back < 1*close_six_day_back )
OR (
	close < 1*close_two_day_back  AND 
	close_two_day_back < 1*close_three_day_back   AND 
	close_three_day_back < 1*close_four_day_back   AND 
	close_four_day_back < 1*close_five_day_back   AND 
	close_five_day_back < 1*close_six_day_back   AND 
	close_six_day_back < 1*close_seven_day_back )
OR (
	close < 1*close_two_day_back  AND 
	close_two_day_back < 1*close_three_day_back   AND 
	close_three_day_back < 1*close_four_day_back   AND 
	close_four_day_back < 1*close_five_day_back   AND 
	close_five_day_back < 1*close_six_day_back   AND 
	close_six_day_back < 1*close_seven_day_back   AND 
	close_seven_day_back < 1*close_eight_day_back )

), bb as (
	select ticker as avg_ticker, _date as avg__date,  CASE WHEN (
	volume < 1*volume_two_day_back  AND 
	volume_two_day_back < 1*volume_three_day_back  AND 
	volume_three_day_back < 1*volume_four_day_back  AND 
	volume_four_day_back < 1*volume_five_day_back  AND 
	volume_five_day_back < 1*volume_six_day_back  AND 
	volume_six_day_back < 1*volume_seven_day_back  AND 
	volume_seven_day_back < 1*volume_eight_day_back ) then add_working_days_date(_date, 8)
WHEN (
	volume < 1*volume_two_day_back  AND 
	volume_two_day_back < 1*volume_three_day_back  AND 
	volume_three_day_back < 1*volume_four_day_back  AND 
	volume_four_day_back < 1*volume_five_day_back  AND 
	volume_five_day_back < 1*volume_six_day_back  AND 
	volume_six_day_back < 1*volume_seven_day_back ) then add_working_days_date(_date, 7)
WHEN (
	volume < 1*volume_two_day_back  AND 
	volume_two_day_back < 1*volume_three_day_back  AND 
	volume_three_day_back < 1*volume_four_day_back  AND 
	volume_four_day_back < 1*volume_five_day_back  AND 
	volume_five_day_back < 1*volume_six_day_back ) then add_working_days_date(_date, 6)
WHEN (
	volume < 1*volume_two_day_back  AND 
	volume_two_day_back < 1*volume_three_day_back  AND 
	volume_three_day_back < 1*volume_four_day_back  AND 
	volume_four_day_back < 1*volume_five_day_back ) then add_working_days_date(_date, 5)
WHEN (
	volume < 1*volume_two_day_back  AND 
	volume_two_day_back < 1*volume_three_day_back  AND 
	volume_three_day_back < 1*volume_four_day_back ) then add_working_days_date(_date, 4)
WHEN (
	volume < 1*volume_two_day_back  AND 
	volume_two_day_back < 1*volume_three_day_back ) then add_working_days_date(_date, 3)

 end as avg_days_back
from ( 
	select *
	, lag(volume, 1) OVER (PARTITION BY ticker ORDER BY _date) AS volume_one_day_back
	, lag(volume, 2) OVER (PARTITION BY ticker ORDER BY _date) AS volume_two_day_back
	, lag(volume, 3) OVER (PARTITION BY ticker ORDER BY _date) AS volume_three_day_back
	, lag(volume, 4) OVER (PARTITION BY ticker ORDER BY _date) AS volume_four_day_back
	, lag(volume, 5) OVER (PARTITION BY ticker ORDER BY _date) AS volume_five_day_back
	, lag(volume, 6) OVER (PARTITION BY ticker ORDER BY _date) AS volume_six_day_back
	, lag(volume, 7) OVER (PARTITION BY ticker ORDER BY _date) AS volume_seven_day_back
	, lag(volume, 8) OVER (PARTITION BY ticker ORDER BY _date) AS volume_eight_day_back
from ( 
	select 
	ticker as ticker, 
	_date as _date, 
	avg(volume) as volume from 
(
	(select ticker, _date, close AS close, volume as volume from yahoo_result 
where  
 _date > DATE('2026-03-30')  
AND  ticker in 
	(
		select ticker from yahoo_result 
		group by ticker
		having avg(volume)>2500000
))
)group by ticker, _date
) 

)
where (
	volume < 1*volume_two_day_back  AND 
	volume_two_day_back < 1*volume_three_day_back )
OR (
	volume < 1*volume_two_day_back  AND 
	volume_two_day_back < 1*volume_three_day_back   AND 
	volume_three_day_back < 1*volume_four_day_back )
OR (
	volume < 1*volume_two_day_back  AND 
	volume_two_day_back < 1*volume_three_day_back   AND 
	volume_three_day_back < 1*volume_four_day_back   AND 
	volume_four_day_back < 1*volume_five_day_back )
OR (
	volume < 1*volume_two_day_back  AND 
	volume_two_day_back < 1*volume_three_day_back   AND 
	volume_three_day_back < 1*volume_four_day_back   AND 
	volume_four_day_back < 1*volume_five_day_back   AND 
	volume_five_day_back < 1*volume_six_day_back )
OR (
	volume < 1*volume_two_day_back  AND 
	volume_two_day_back < 1*volume_three_day_back   AND 
	volume_three_day_back < 1*volume_four_day_back   AND 
	volume_four_day_back < 1*volume_five_day_back   AND 
	volume_five_day_back < 1*volume_six_day_back   AND 
	volume_six_day_back < 1*volume_seven_day_back )
OR (
	volume < 1*volume_two_day_back  AND 
	volume_two_day_back < 1*volume_three_day_back   AND 
	volume_three_day_back < 1*volume_four_day_back   AND 
	volume_four_day_back < 1*volume_five_day_back   AND 
	volume_five_day_back < 1*volume_six_day_back   AND 
	volume_six_day_back < 1*volume_seven_day_back   AND 
	volume_seven_day_back < 1*volume_eight_day_back )

)
select Current_DATE as current_date_, aa.ticker, aa._date as _date, aa.days_back, bb.* from aa join bb on 
 aa.ticker=bb.avg_ticker AND
 aa._date=bb.avg__date);

