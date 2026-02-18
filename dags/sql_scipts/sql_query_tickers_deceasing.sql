INSERT INTO tickers_deceasing select * from (with aa as (
	select ticker as ticker, full_date as full_date,  CASE WHEN (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back  AND 
	price_six_day_back < price_seven_day_back  AND 
	price_seven_day_back < price_eight_day_back  AND 
	price_eight_day_back < price_nine_day_back  AND 
	price_nine_day_back < price_ten_day_back  AND 
	price_ten_day_back < price_eleven_day_back  AND 
	price_eleven_day_back < price_twelve_day_back  AND 
	price_twelve_day_back < price_thirteen_day_back  AND 
	price_thirteen_day_back < price_fourteen_day_back ) then add_working_days(full_date, 14)
WHEN (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back  AND 
	price_six_day_back < price_seven_day_back  AND 
	price_seven_day_back < price_eight_day_back  AND 
	price_eight_day_back < price_nine_day_back  AND 
	price_nine_day_back < price_ten_day_back  AND 
	price_ten_day_back < price_eleven_day_back  AND 
	price_eleven_day_back < price_twelve_day_back  AND 
	price_twelve_day_back < price_thirteen_day_back ) then add_working_days(full_date, 13)
WHEN (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back  AND 
	price_six_day_back < price_seven_day_back  AND 
	price_seven_day_back < price_eight_day_back  AND 
	price_eight_day_back < price_nine_day_back  AND 
	price_nine_day_back < price_ten_day_back  AND 
	price_ten_day_back < price_eleven_day_back  AND 
	price_eleven_day_back < price_twelve_day_back ) then add_working_days(full_date, 12)
WHEN (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back  AND 
	price_six_day_back < price_seven_day_back  AND 
	price_seven_day_back < price_eight_day_back  AND 
	price_eight_day_back < price_nine_day_back  AND 
	price_nine_day_back < price_ten_day_back  AND 
	price_ten_day_back < price_eleven_day_back ) then add_working_days(full_date, 11)
WHEN (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back  AND 
	price_six_day_back < price_seven_day_back  AND 
	price_seven_day_back < price_eight_day_back  AND 
	price_eight_day_back < price_nine_day_back  AND 
	price_nine_day_back < price_ten_day_back ) then add_working_days(full_date, 10)
WHEN (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back  AND 
	price_six_day_back < price_seven_day_back  AND 
	price_seven_day_back < price_eight_day_back  AND 
	price_eight_day_back < price_nine_day_back ) then add_working_days(full_date, 9)
WHEN (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back  AND 
	price_six_day_back < price_seven_day_back  AND 
	price_seven_day_back < price_eight_day_back ) then add_working_days(full_date, 8)
WHEN (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back  AND 
	price_six_day_back < price_seven_day_back ) then add_working_days(full_date, 7)
WHEN (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back ) then add_working_days(full_date, 6)
WHEN (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back ) then add_working_days(full_date, 5)
WHEN (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back ) then add_working_days(full_date, 4)
WHEN (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back ) then add_working_days(full_date, 3)
WHEN (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back ) then add_working_days(full_date, 2)

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
	, lag(price, 9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back
	, lag(price, 10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back
	, lag(price, 11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back
	, lag(price, 12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back
	, lag(price, 13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back
	, lag(price, 14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back
	, lag(full_date, 1) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_one_day_back
	, lag(full_date, 2) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_two_day_back
	, lag(full_date, 3) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_three_day_back
	, lag(full_date, 4) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_four_day_back
	, lag(full_date, 5) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_five_day_back
	, lag(full_date, 6) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_six_day_back
	, lag(full_date, 7) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_seven_day_back
	, lag(full_date, 8) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_eight_day_back
	, lag(full_date, 9) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_nine_day_back
	, lag(full_date, 10) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_ten_day_back
	, lag(full_date, 11) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_eleven_day_back
	, lag(full_date, 12) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_twelve_day_back
	, lag(full_date, 13) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_thirteen_day_back
	, lag(full_date, 14) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_fourteen_day_back
from ( 
	select * from (
	select *,  ROW_NUMBER() over (PARTITION BY ticker, full_date order by time_ desc) rn 
from( 
	select ticker, full_date, price, volume as volume, time_ from finviz_result 
where  
 full_date > (20260105)  

)
)
where rn = 1
) 

)
where (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back )
 or (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back )
 or (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back )
 or (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back )
 or (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back )
 or (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back  AND 
	price_six_day_back < price_seven_day_back )
 or (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back  AND 
	price_six_day_back < price_seven_day_back  AND 
	price_seven_day_back < price_eight_day_back )
 or (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back  AND 
	price_six_day_back < price_seven_day_back  AND 
	price_seven_day_back < price_eight_day_back  AND 
	price_eight_day_back < price_nine_day_back )
 or (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back  AND 
	price_six_day_back < price_seven_day_back  AND 
	price_seven_day_back < price_eight_day_back  AND 
	price_eight_day_back < price_nine_day_back  AND 
	price_nine_day_back < price_ten_day_back )
 or (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back  AND 
	price_six_day_back < price_seven_day_back  AND 
	price_seven_day_back < price_eight_day_back  AND 
	price_eight_day_back < price_nine_day_back  AND 
	price_nine_day_back < price_ten_day_back  AND 
	price_ten_day_back < price_eleven_day_back )
 or (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back  AND 
	price_six_day_back < price_seven_day_back  AND 
	price_seven_day_back < price_eight_day_back  AND 
	price_eight_day_back < price_nine_day_back  AND 
	price_nine_day_back < price_ten_day_back  AND 
	price_ten_day_back < price_eleven_day_back  AND 
	price_eleven_day_back < price_twelve_day_back )
 or (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back  AND 
	price_six_day_back < price_seven_day_back  AND 
	price_seven_day_back < price_eight_day_back  AND 
	price_eight_day_back < price_nine_day_back  AND 
	price_nine_day_back < price_ten_day_back  AND 
	price_ten_day_back < price_eleven_day_back  AND 
	price_eleven_day_back < price_twelve_day_back  AND 
	price_twelve_day_back < price_thirteen_day_back )
 or (
	price < price_one_day_back  AND 
	price_one_day_back < price_two_day_back  AND 
	price_two_day_back < price_three_day_back  AND 
	price_three_day_back < price_four_day_back  AND 
	price_four_day_back < price_five_day_back  AND 
	price_five_day_back < price_six_day_back  AND 
	price_six_day_back < price_seven_day_back  AND 
	price_seven_day_back < price_eight_day_back  AND 
	price_eight_day_back < price_nine_day_back  AND 
	price_nine_day_back < price_ten_day_back  AND 
	price_ten_day_back < price_eleven_day_back  AND 
	price_eleven_day_back < price_twelve_day_back  AND 
	price_twelve_day_back < price_thirteen_day_back  AND 
	price_thirteen_day_back < price_fourteen_day_back )

), bb as (
	select ticker as avg_ticker, full_date as avg_full_date,  CASE WHEN (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back  AND 
	volume_six_day_back < volume_seven_day_back  AND 
	volume_seven_day_back < volume_eight_day_back  AND 
	volume_eight_day_back < volume_nine_day_back  AND 
	volume_nine_day_back < volume_ten_day_back  AND 
	volume_ten_day_back < volume_eleven_day_back  AND 
	volume_eleven_day_back < volume_twelve_day_back  AND 
	volume_twelve_day_back < volume_thirteen_day_back  AND 
	volume_thirteen_day_back < volume_fourteen_day_back ) then add_working_days(full_date, 14)
WHEN (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back  AND 
	volume_six_day_back < volume_seven_day_back  AND 
	volume_seven_day_back < volume_eight_day_back  AND 
	volume_eight_day_back < volume_nine_day_back  AND 
	volume_nine_day_back < volume_ten_day_back  AND 
	volume_ten_day_back < volume_eleven_day_back  AND 
	volume_eleven_day_back < volume_twelve_day_back  AND 
	volume_twelve_day_back < volume_thirteen_day_back ) then add_working_days(full_date, 13)
WHEN (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back  AND 
	volume_six_day_back < volume_seven_day_back  AND 
	volume_seven_day_back < volume_eight_day_back  AND 
	volume_eight_day_back < volume_nine_day_back  AND 
	volume_nine_day_back < volume_ten_day_back  AND 
	volume_ten_day_back < volume_eleven_day_back  AND 
	volume_eleven_day_back < volume_twelve_day_back ) then add_working_days(full_date, 12)
WHEN (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back  AND 
	volume_six_day_back < volume_seven_day_back  AND 
	volume_seven_day_back < volume_eight_day_back  AND 
	volume_eight_day_back < volume_nine_day_back  AND 
	volume_nine_day_back < volume_ten_day_back  AND 
	volume_ten_day_back < volume_eleven_day_back ) then add_working_days(full_date, 11)
WHEN (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back  AND 
	volume_six_day_back < volume_seven_day_back  AND 
	volume_seven_day_back < volume_eight_day_back  AND 
	volume_eight_day_back < volume_nine_day_back  AND 
	volume_nine_day_back < volume_ten_day_back ) then add_working_days(full_date, 10)
WHEN (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back  AND 
	volume_six_day_back < volume_seven_day_back  AND 
	volume_seven_day_back < volume_eight_day_back  AND 
	volume_eight_day_back < volume_nine_day_back ) then add_working_days(full_date, 9)
WHEN (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back  AND 
	volume_six_day_back < volume_seven_day_back  AND 
	volume_seven_day_back < volume_eight_day_back ) then add_working_days(full_date, 8)
WHEN (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back  AND 
	volume_six_day_back < volume_seven_day_back ) then add_working_days(full_date, 7)
WHEN (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back ) then add_working_days(full_date, 6)
WHEN (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back ) then add_working_days(full_date, 5)
WHEN (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back ) then add_working_days(full_date, 4)
WHEN (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back ) then add_working_days(full_date, 3)
WHEN (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back ) then add_working_days(full_date, 2)

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
	, lag(volume, 9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back
	, lag(volume, 10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back
	, lag(volume, 11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back
	, lag(volume, 12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back
	, lag(volume, 13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back
	, lag(volume, 14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back
	, lag(full_date, 1) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_one_day_back
	, lag(full_date, 2) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_two_day_back
	, lag(full_date, 3) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_three_day_back
	, lag(full_date, 4) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_four_day_back
	, lag(full_date, 5) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_five_day_back
	, lag(full_date, 6) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_six_day_back
	, lag(full_date, 7) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_seven_day_back
	, lag(full_date, 8) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_eight_day_back
	, lag(full_date, 9) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_nine_day_back
	, lag(full_date, 10) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_ten_day_back
	, lag(full_date, 11) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_eleven_day_back
	, lag(full_date, 12) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_twelve_day_back
	, lag(full_date, 13) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_thirteen_day_back
	, lag(full_date, 14) OVER (PARTITION BY ticker ORDER BY full_date) AS full_date_fourteen_day_back
from ( 
	select 
	ticker as ticker, 
	full_date as full_date, 
	avg(volume) as volume from 
(
	select ticker, full_date, price, volume as volume, time_ from finviz_result 
where  
 full_date > (20260105)  

)group by ticker, full_date
) 

)
where (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back )
 or (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back )
 or (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back )
 or (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back )
 or (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back )
 or (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back  AND 
	volume_six_day_back < volume_seven_day_back )
 or (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back  AND 
	volume_six_day_back < volume_seven_day_back  AND 
	volume_seven_day_back < volume_eight_day_back )
 or (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back  AND 
	volume_six_day_back < volume_seven_day_back  AND 
	volume_seven_day_back < volume_eight_day_back  AND 
	volume_eight_day_back < volume_nine_day_back )
 or (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back  AND 
	volume_six_day_back < volume_seven_day_back  AND 
	volume_seven_day_back < volume_eight_day_back  AND 
	volume_eight_day_back < volume_nine_day_back  AND 
	volume_nine_day_back < volume_ten_day_back )
 or (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back  AND 
	volume_six_day_back < volume_seven_day_back  AND 
	volume_seven_day_back < volume_eight_day_back  AND 
	volume_eight_day_back < volume_nine_day_back  AND 
	volume_nine_day_back < volume_ten_day_back  AND 
	volume_ten_day_back < volume_eleven_day_back )
 or (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back  AND 
	volume_six_day_back < volume_seven_day_back  AND 
	volume_seven_day_back < volume_eight_day_back  AND 
	volume_eight_day_back < volume_nine_day_back  AND 
	volume_nine_day_back < volume_ten_day_back  AND 
	volume_ten_day_back < volume_eleven_day_back  AND 
	volume_eleven_day_back < volume_twelve_day_back )
 or (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back  AND 
	volume_six_day_back < volume_seven_day_back  AND 
	volume_seven_day_back < volume_eight_day_back  AND 
	volume_eight_day_back < volume_nine_day_back  AND 
	volume_nine_day_back < volume_ten_day_back  AND 
	volume_ten_day_back < volume_eleven_day_back  AND 
	volume_eleven_day_back < volume_twelve_day_back  AND 
	volume_twelve_day_back < volume_thirteen_day_back )
 or (
	volume < volume_one_day_back  AND 
	volume_one_day_back < volume_two_day_back  AND 
	volume_two_day_back < volume_three_day_back  AND 
	volume_three_day_back < volume_four_day_back  AND 
	volume_four_day_back < volume_five_day_back  AND 
	volume_five_day_back < volume_six_day_back  AND 
	volume_six_day_back < volume_seven_day_back  AND 
	volume_seven_day_back < volume_eight_day_back  AND 
	volume_eight_day_back < volume_nine_day_back  AND 
	volume_nine_day_back < volume_ten_day_back  AND 
	volume_ten_day_back < volume_eleven_day_back  AND 
	volume_eleven_day_back < volume_twelve_day_back  AND 
	volume_twelve_day_back < volume_thirteen_day_back  AND 
	volume_thirteen_day_back < volume_fourteen_day_back )

)
select Current_DATE as current_date_, aa.ticker, aa.full_date::INT as full_date, aa.days_back, bb.* from aa join bb on 
 aa.ticker=bb.avg_ticker AND
 aa.full_date=bb.avg_full_date);

