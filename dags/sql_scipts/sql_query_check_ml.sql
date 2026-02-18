drop view if exists ml_temp_0; 
create view ml_temp_0 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20251114) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250725 and full_date < 20251031
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250725 and fr.full_date < 20251031)
where full_date> 20250725 and full_date < 20251031
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_1; 
create view ml_temp_1 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20251117) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250728 and full_date < 20251103
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250728 and fr.full_date < 20251103)
where full_date> 20250728 and full_date < 20251103
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_2; 
create view ml_temp_2 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20251120) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250731 and full_date < 20251106
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250731 and fr.full_date < 20251106)
where full_date> 20250731 and full_date < 20251106
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_3; 
create view ml_temp_3 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20251123) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250804 and full_date < 20251110
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250804 and fr.full_date < 20251110)
where full_date> 20250804 and full_date < 20251110
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_4; 
create view ml_temp_4 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20251130) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250811 and full_date < 20251117
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250811 and fr.full_date < 20251117)
where full_date> 20250811 and full_date < 20251117
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_5; 
create view ml_temp_5 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20251201) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250811 and full_date < 20251117
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250811 and fr.full_date < 20251117)
where full_date> 20250811 and full_date < 20251117
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_6; 
create view ml_temp_6 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20251205) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250815 and full_date < 20251121
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250815 and fr.full_date < 20251121)
where full_date> 20250815 and full_date < 20251121
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_7; 
create view ml_temp_7 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20251208) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250818 and full_date < 20251124
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250818 and fr.full_date < 20251124)
where full_date> 20250818 and full_date < 20251124
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_8; 
create view ml_temp_8 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20251210) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250820 and full_date < 20251126
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250820 and fr.full_date < 20251126)
where full_date> 20250820 and full_date < 20251126
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_9; 
create view ml_temp_9 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20251211) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250821 and full_date < 20251127
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250821 and fr.full_date < 20251127)
where full_date> 20250821 and full_date < 20251127
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_10; 
create view ml_temp_10 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20251212) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250822 and full_date < 20251128
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250822 and fr.full_date < 20251128)
where full_date> 20250822 and full_date < 20251128
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_11; 
create view ml_temp_11 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20251216) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250826 and full_date < 20251202
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250826 and fr.full_date < 20251202)
where full_date> 20250826 and full_date < 20251202
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_12; 
create view ml_temp_12 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20251217) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250827 and full_date < 20251203
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250827 and fr.full_date < 20251203)
where full_date> 20250827 and full_date < 20251203
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_13; 
create view ml_temp_13 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20251230) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250909 and full_date < 20251216
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250909 and fr.full_date < 20251216)
where full_date> 20250909 and full_date < 20251216
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_14; 
create view ml_temp_14 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20260102) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250912 and full_date < 20251219
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250912 and fr.full_date < 20251219)
where full_date> 20250912 and full_date < 20251219
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_15; 
create view ml_temp_15 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20260106) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250916 and full_date < 20251223
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250916 and fr.full_date < 20251223)
where full_date> 20250916 and full_date < 20251223
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_16; 
create view ml_temp_16 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20260107) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250917 and full_date < 20251224
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250917 and fr.full_date < 20251224)
where full_date> 20250917 and full_date < 20251224
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_17; 
create view ml_temp_17 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20260109) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250919 and full_date < 20251226
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250919 and fr.full_date < 20251226)
where full_date> 20250919 and full_date < 20251226
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_18; 
create view ml_temp_18 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20260112) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250922 and full_date < 20251229
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250922 and fr.full_date < 20251229)
where full_date> 20250922 and full_date < 20251229
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_19; 
create view ml_temp_19 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20260115) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250925 and full_date < 20260101
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250925 and fr.full_date < 20260101)
where full_date> 20250925 and full_date < 20260101
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_20; 
create view ml_temp_20 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20260116) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250926 and full_date < 20260102
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250926 and fr.full_date < 20260102)
where full_date> 20250926 and full_date < 20260102
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

drop view if exists ml_temp_21; 
create view ml_temp_21 as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select distinct full_date from finviz_result where full_date > 20260120) order by full_date desc limit 55)  
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250930 and full_date < 20260106
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker join (select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count  from finviz_result  
where full_date> 20250924 and full_date < 20251231
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker where fr.full_date > 20250930 and fr.full_date < 20260106)
where full_date> 20250930 and full_date < 20260106
group by ticker) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0)
, b as ( select *, 
 lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  
 lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  
 lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_day_back,  
 lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_day_back,  
 lag (volume,3) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_three_day_back,  
 lag (price,3) OVER (PARTITION BY ticker ORDER BY full_date) AS price_three_day_back,  
 lag (volume,4) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_four_day_back,  
 lag (price,4) OVER (PARTITION BY ticker ORDER BY full_date) AS price_four_day_back,  
 lag (volume,5) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_five_day_back,  
 lag (price,5) OVER (PARTITION BY ticker ORDER BY full_date) AS price_five_day_back,  
 lag (volume,6) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_six_day_back,  
 lag (price,6) OVER (PARTITION BY ticker ORDER BY full_date) AS price_six_day_back,  
 lag (volume,7) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seven_day_back,  
 lag (price,7) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seven_day_back,  
 lag (volume,8) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eight_day_back,  
 lag (price,8) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eight_day_back,  
 lag (volume,9) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nine_day_back,  
 lag (price,9) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nine_day_back,  
 lag (volume,10) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_ten_day_back,  
 lag (price,10) OVER (PARTITION BY ticker ORDER BY full_date) AS price_ten_day_back,  
 lag (volume,11) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eleven_day_back,  
 lag (price,11) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eleven_day_back,  
 lag (volume,12) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twelve_day_back,  
 lag (price,12) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twelve_day_back,  
 lag (volume,13) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirteen_day_back,  
 lag (price,13) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirteen_day_back,  
 lag (volume,14) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fourteen_day_back,  
 lag (price,14) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fourteen_day_back,  
 lag (volume,15) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fiveteen_day_back,  
 lag (price,15) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fiveteen_day_back,  
 lag (volume,16) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_sixteen_day_back,  
 lag (price,16) OVER (PARTITION BY ticker ORDER BY full_date) AS price_sixteen_day_back,  
 lag (volume,17) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_seveteen_day_back,  
 lag (price,17) OVER (PARTITION BY ticker ORDER BY full_date) AS price_seveteen_day_back,  
 lag (volume,18) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_eighteen_day_back,  
 lag (price,18) OVER (PARTITION BY ticker ORDER BY full_date) AS price_eighteen_day_back,  
 lag (volume,19) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_nineteen_day_back,  
 lag (price,19) OVER (PARTITION BY ticker ORDER BY full_date) AS price_nineteen_day_back,  
 lag (volume,20) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_day_back,  
 lag (price,20) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_day_back,  
 lag (volume,21) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_one_day_back,  
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back,  
 lag (volume,22) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_two_day_back,  
 lag (price,22) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_two_day_back,  
 lag (volume,23) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_three_day_back,  
 lag (price,23) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_three_day_back,  
 lag (volume,24) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_four_day_back,  
 lag (price,24) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_four_day_back,  
 lag (volume,25) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_five_day_back,  
 lag (price,25) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_five_day_back,  
 lag (volume,26) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_six_day_back,  
 lag (price,26) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_six_day_back,  
 lag (volume,27) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_seven_day_back,  
 lag (price,27) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_seven_day_back,  
 lag (volume,28) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_eight_day_back,  
 lag (price,28) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_eight_day_back,  
 lag (volume,29) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_twenty_nine_day_back,  
 lag (price,29) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_nine_day_back,  
 lag (volume,30) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_day_back,  
 lag (price,30) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_day_back,  
 lag (volume,31) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_one_day_back,  
 lag (price,31) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_one_day_back,  
 lag (volume,32) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_two_day_back,  
 lag (price,32) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_two_day_back,  
 lag (volume,33) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_three_day_back,  
 lag (price,33) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_three_day_back,  
 lag (volume,34) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_four_day_back,  
 lag (price,34) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_four_day_back,  
 lag (volume,35) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_five_day_back,  
 lag (price,35) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_five_day_back,  
 lag (volume,36) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_six_day_back,  
 lag (price,36) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_six_day_back,  
 lag (volume,37) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_seven_day_back,  
 lag (price,37) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_seven_day_back,  
 lag (volume,38) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_eight_day_back,  
 lag (price,38) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_eight_day_back,  
 lag (volume,39) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_thirty_nine_day_back,  
 lag (price,39) OVER (PARTITION BY ticker ORDER BY full_date) AS price_thirty_nine_day_back,  
 lag (volume,40) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_day_back,  
 lag (price,40) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_day_back,  
 lag (volume,41) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_one_day_back,  
 lag (price,41) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_one_day_back,  
 lag (volume,42) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_two_day_back,  
 lag (price,42) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_two_day_back,  
 lag (volume,43) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_three_day_back,  
 lag (price,43) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_three_day_back,  
 lag (volume,44) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_four_day_back,  
 lag (price,44) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_four_day_back,  
 lag (volume,45) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_five_day_back,  
 lag (price,45) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_five_day_back,  
 lag (volume,46) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_six_day_back,  
 lag (price,46) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_six_day_back,  
 lag (volume,47) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_seven_day_back,  
 lag (price,47) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_seven_day_back,  
 lag (volume,48) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_eight_day_back,  
 lag (price,48) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_eight_day_back,  
 lag (volume,49) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_forty_nine_day_back,  
 lag (price,49) OVER (PARTITION BY ticker ORDER BY full_date) AS price_forty_nine_day_back,  
 lag (volume,50) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_day_back,  
 lag (price,50) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_day_back,  
 lag (volume,51) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_one_day_back,  
 lag (price,51) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_one_day_back,  
 lag (volume,52) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_two_day_back,  
 lag (price,52) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_two_day_back,  
 lag (volume,53) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_three_day_back,  
 lag (price,53) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_three_day_back,  
 lag (volume,54) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_four_day_back,  
 lag (price,54) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_four_day_back,  
 lag (volume,55) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_fifty_five_day_back,  
 lag (price,55) OVER (PARTITION BY ticker ORDER BY full_date) AS price_fifty_five_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a));

