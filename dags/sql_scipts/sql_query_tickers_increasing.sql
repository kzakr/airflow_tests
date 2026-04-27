INSERT INTO tickers_increasing select * from (with aa as (
	select ticker as ticker, full_date as full_date,  CASE WHEN (
	price > 1.02*price_two_day_back  AND 
	price_two_day_back > 1.02*price_three_day_back  AND 
	price_three_day_back > 1.02*price_four_day_back  AND 
	price_four_day_back > 1.02*price_five_day_back  AND 
	price_five_day_back > 1.02*price_six_day_back  AND 
	price_six_day_back > 1.02*price_seven_day_back  AND 
	price_seven_day_back > 1.02*price_eight_day_back ) then add_working_days(full_date, 8)
WHEN (
	price > 1.02*price_two_day_back  AND 
	price_two_day_back > 1.02*price_three_day_back  AND 
	price_three_day_back > 1.02*price_four_day_back  AND 
	price_four_day_back > 1.02*price_five_day_back  AND 
	price_five_day_back > 1.02*price_six_day_back  AND 
	price_six_day_back > 1.02*price_seven_day_back ) then add_working_days(full_date, 7)
WHEN (
	price > 1.02*price_two_day_back  AND 
	price_two_day_back > 1.02*price_three_day_back  AND 
	price_three_day_back > 1.02*price_four_day_back  AND 
	price_four_day_back > 1.02*price_five_day_back  AND 
	price_five_day_back > 1.02*price_six_day_back ) then add_working_days(full_date, 6)
WHEN (
	price > 1.02*price_two_day_back  AND 
	price_two_day_back > 1.02*price_three_day_back  AND 
	price_three_day_back > 1.02*price_four_day_back  AND 
	price_four_day_back > 1.02*price_five_day_back ) then add_working_days(full_date, 5)
WHEN (
	price > 1.02*price_two_day_back  AND 
	price_two_day_back > 1.02*price_three_day_back  AND 
	price_three_day_back > 1.02*price_four_day_back ) then add_working_days(full_date, 4)
WHEN (
	price > 1.02*price_two_day_back  AND 
	price_two_day_back > 1.02*price_three_day_back ) then add_working_days(full_date, 3)

 end as days_back
from ( 
	select *
	, lag(price, 1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back
	, lag(price, 2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back
	, lag(price, 3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back
	, lag(price, 4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back
	, lag(price, 5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back
	, lag(price, 6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back
	, lag(price, 7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back
	, lag(price, 8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back
	, lag(full_date, 1) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_one_day_back
	, lag(full_date, 2) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_two_day_back
	, lag(full_date, 3) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_three_day_back
	, lag(full_date, 4) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_four_day_back
	, lag(full_date, 5) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_five_day_back
	, lag(full_date, 6) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_six_day_back
	, lag(full_date, 7) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_seven_day_back
	, lag(full_date, 8) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_eight_day_back
from ( 
	select * from (
	select *,  ROW_NUMBER() over (PARTITION BY ticker, full_date order by time_ desc) rn 
from( 
	select ticker, full_date, price, volume as volume, time_ from finviz_result 
where  
 full_date > (20260330)  
AND  ticker in 
	(
		select ticker from finviz_result 
		group by ticker
		having avg(volume)>2500000
)
)
)
where rn = 1
) 

)
where (
	price > 1.02*price_two_day_back  AND 
	price_two_day_back > 1.02*price_three_day_back )
 or (
	price > 1.02*price_two_day_back  AND 
	price_two_day_back > 1.02*price_three_day_back  AND 
	price_three_day_back > 1.02*price_four_day_back )
 or (
	price > 1.02*price_two_day_back  AND 
	price_two_day_back > 1.02*price_three_day_back  AND 
	price_three_day_back > 1.02*price_four_day_back  AND 
	price_four_day_back > 1.02*price_five_day_back )
 or (
	price > 1.02*price_two_day_back  AND 
	price_two_day_back > 1.02*price_three_day_back  AND 
	price_three_day_back > 1.02*price_four_day_back  AND 
	price_four_day_back > 1.02*price_five_day_back  AND 
	price_five_day_back > 1.02*price_six_day_back )
 or (
	price > 1.02*price_two_day_back  AND 
	price_two_day_back > 1.02*price_three_day_back  AND 
	price_three_day_back > 1.02*price_four_day_back  AND 
	price_four_day_back > 1.02*price_five_day_back  AND 
	price_five_day_back > 1.02*price_six_day_back  AND 
	price_six_day_back > 1.02*price_seven_day_back )
 or (
	price > 1.02*price_two_day_back  AND 
	price_two_day_back > 1.02*price_three_day_back  AND 
	price_three_day_back > 1.02*price_four_day_back  AND 
	price_four_day_back > 1.02*price_five_day_back  AND 
	price_five_day_back > 1.02*price_six_day_back  AND 
	price_six_day_back > 1.02*price_seven_day_back  AND 
	price_seven_day_back > 1.02*price_eight_day_back )

), bb as (
	select ticker as avg_ticker, full_date as avg_full_date,  CASE WHEN (
	volume > 1.02*volume_two_day_back  AND 
	volume_two_day_back > 1.02*volume_three_day_back  AND 
	volume_three_day_back > 1.02*volume_four_day_back  AND 
	volume_four_day_back > 1.02*volume_five_day_back  AND 
	volume_five_day_back > 1.02*volume_six_day_back  AND 
	volume_six_day_back > 1.02*volume_seven_day_back  AND 
	volume_seven_day_back > 1.02*volume_eight_day_back ) then add_working_days(full_date, 8)
WHEN (
	volume > 1.02*volume_two_day_back  AND 
	volume_two_day_back > 1.02*volume_three_day_back  AND 
	volume_three_day_back > 1.02*volume_four_day_back  AND 
	volume_four_day_back > 1.02*volume_five_day_back  AND 
	volume_five_day_back > 1.02*volume_six_day_back  AND 
	volume_six_day_back > 1.02*volume_seven_day_back ) then add_working_days(full_date, 7)
WHEN (
	volume > 1.02*volume_two_day_back  AND 
	volume_two_day_back > 1.02*volume_three_day_back  AND 
	volume_three_day_back > 1.02*volume_four_day_back  AND 
	volume_four_day_back > 1.02*volume_five_day_back  AND 
	volume_five_day_back > 1.02*volume_six_day_back ) then add_working_days(full_date, 6)
WHEN (
	volume > 1.02*volume_two_day_back  AND 
	volume_two_day_back > 1.02*volume_three_day_back  AND 
	volume_three_day_back > 1.02*volume_four_day_back  AND 
	volume_four_day_back > 1.02*volume_five_day_back ) then add_working_days(full_date, 5)
WHEN (
	volume > 1.02*volume_two_day_back  AND 
	volume_two_day_back > 1.02*volume_three_day_back  AND 
	volume_three_day_back > 1.02*volume_four_day_back ) then add_working_days(full_date, 4)
WHEN (
	volume > 1.02*volume_two_day_back  AND 
	volume_two_day_back > 1.02*volume_three_day_back ) then add_working_days(full_date, 3)

 end as avg_days_back
from ( 
	select *
	, lag(volume, 1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back
	, lag(volume, 2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back
	, lag(volume, 3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back
	, lag(volume, 4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back
	, lag(volume, 5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back
	, lag(volume, 6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back
	, lag(volume, 7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back
	, lag(volume, 8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back
	, lag(full_date, 1) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_one_day_back
	, lag(full_date, 2) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_two_day_back
	, lag(full_date, 3) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_three_day_back
	, lag(full_date, 4) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_four_day_back
	, lag(full_date, 5) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_five_day_back
	, lag(full_date, 6) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_six_day_back
	, lag(full_date, 7) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_seven_day_back
	, lag(full_date, 8) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_eight_day_back
from ( 
	select 
	ticker as ticker, 
	full_date as full_date, 
	avg(volume) as volume from 
(
	select ticker, full_date, price, volume as volume, time_ from finviz_result 
where  
 full_date > (20260330)  
AND  ticker in 
	(
		select ticker from finviz_result 
		group by ticker
		having avg(volume)>2500000
)
)group by ticker, full_date
) 

)
where (
	volume > 1.02*volume_two_day_back  AND 
	volume_two_day_back > 1.02*volume_three_day_back )
 or (
	volume > 1.02*volume_two_day_back  AND 
	volume_two_day_back > 1.02*volume_three_day_back  AND 
	volume_three_day_back > 1.02*volume_four_day_back )
 or (
	volume > 1.02*volume_two_day_back  AND 
	volume_two_day_back > 1.02*volume_three_day_back  AND 
	volume_three_day_back > 1.02*volume_four_day_back  AND 
	volume_four_day_back > 1.02*volume_five_day_back )
 or (
	volume > 1.02*volume_two_day_back  AND 
	volume_two_day_back > 1.02*volume_three_day_back  AND 
	volume_three_day_back > 1.02*volume_four_day_back  AND 
	volume_four_day_back > 1.02*volume_five_day_back  AND 
	volume_five_day_back > 1.02*volume_six_day_back )
 or (
	volume > 1.02*volume_two_day_back  AND 
	volume_two_day_back > 1.02*volume_three_day_back  AND 
	volume_three_day_back > 1.02*volume_four_day_back  AND 
	volume_four_day_back > 1.02*volume_five_day_back  AND 
	volume_five_day_back > 1.02*volume_six_day_back  AND 
	volume_six_day_back > 1.02*volume_seven_day_back )
 or (
	volume > 1.02*volume_two_day_back  AND 
	volume_two_day_back > 1.02*volume_three_day_back  AND 
	volume_three_day_back > 1.02*volume_four_day_back  AND 
	volume_four_day_back > 1.02*volume_five_day_back  AND 
	volume_five_day_back > 1.02*volume_six_day_back  AND 
	volume_six_day_back > 1.02*volume_seven_day_back  AND 
	volume_seven_day_back > 1.02*volume_eight_day_back )

)
select Current_DATE as current_date_, aa.ticker, CAST(aa.full_date as INT) as full_date, aa.days_back, bb.* from aa join bb on 
 aa.ticker=bb.avg_ticker AND
 aa.full_date=bb.avg_full_date);

