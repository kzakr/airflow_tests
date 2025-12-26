drop view if exists ml_temp; 
create view ml_temp as select * from (with a as ( 
	 select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result 
where  
 full_date in (select distinct full_date from finviz_result where full_date not in (select max(full_date) from finviz_result ) order by full_date desc limit 21) 
group by ticker, full_date 
having avg(cast (market as decimal)) > 2000000) sql_query join 
(select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(distinct full_date) as full_date_count, sum(power(price - avg(price),2))/count(distinct full_date) as std_price, sum(power(volume - avg(volume),2))/count(distinct full_date) as std_volume
 from finviz_result  
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) statistical_metrics_avg 
on sql_query.ticker = statistical_metrics_avg.ticker) (select ticker, sum(std_price_unsum) as std_price, sum(std_volume_unsum) as std_volume from 
	(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum 	from finviz_result fr join (select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(distinct full_date) as full_date_count, sum(power(price - avg(price),2))/count(distinct full_date) as std_price, sum(power(volume - avg(volume),2))/count(distinct full_date) as std_volume
 from finviz_result  
group by ticker 
having avg(cast (market as decimal))>1500000 
and avg(volume)<>0 and avg(price)<>0 
) avg
	 on fr.ticker = avg.ticker)) statistical_metrics_std 
on sql_query.ticker = statistical_metrics_std.ticker) where statistical_metrics.avg_volume <>0 and statistical_metrics.avg_price <>0)
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
 lag (price,21) OVER (PARTITION BY ticker ORDER BY full_date) AS price_twenty_one_day_back  
 from a )  
 select * from b where full_date = (select max(full_date) from a))