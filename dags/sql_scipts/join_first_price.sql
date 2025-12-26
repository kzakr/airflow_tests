ALTER TABLE sql_volume_and_price_declining_3_yday ADD COLUMN first_price FLOAT;
MERGE INTO sql_volume_and_price_declining_3_yday target_table
USING ( with a as ( 
	select ticker, time_, price from finviz_result 
where  
 full_date in (select max(full_date) from finviz_result) 

)
, b as ( 
select ticker, price, ROW_NUMBER() OVER (PARTITION by ticker order by time_ asc) as rn from a)
, last_with_clause as ( 
select ticker, price as first_price from b where rn = 1)
select ticker, first_price from last_with_clause )S
ON target_table.ticker = S.ticker 
WHEN MATCHED THEN UPDATE SET  first_price = S.first_price ;
ALTER TABLE sql_price_declining_3_yday ADD COLUMN first_price FLOAT;
MERGE INTO sql_price_declining_3_yday target_table
USING ( with a as ( 
	select ticker, time_, price from finviz_result 
where  
 full_date in (select max(full_date) from finviz_result) 

)
, b as ( 
select ticker, price, ROW_NUMBER() OVER (PARTITION by ticker order by time_ asc) as rn from a)
, last_with_clause as ( 
select ticker, price as first_price from b where rn = 1)
select ticker, first_price from last_with_clause )S
ON target_table.ticker = S.ticker 
WHEN MATCHED THEN UPDATE SET  first_price = S.first_price ;
ALTER TABLE sql_volume_and_price_raising_3_yday ADD COLUMN first_price FLOAT;
MERGE INTO sql_volume_and_price_raising_3_yday target_table
USING ( with a as ( 
	select ticker, time_, price from finviz_result 
where  
 full_date in (select max(full_date) from finviz_result) 

)
, b as ( 
select ticker, price, ROW_NUMBER() OVER (PARTITION by ticker order by time_ asc) as rn from a)
, last_with_clause as ( 
select ticker, price as first_price from b where rn = 1)
select ticker, first_price from last_with_clause )S
ON target_table.ticker = S.ticker 
WHEN MATCHED THEN UPDATE SET  first_price = S.first_price ;
ALTER TABLE sql_volume_declining_3_yday ADD COLUMN first_price FLOAT;
MERGE INTO sql_volume_declining_3_yday target_table
USING ( with a as ( 
	select ticker, time_, price from finviz_result 
where  
 full_date in (select max(full_date) from finviz_result) 

)
, b as ( 
select ticker, price, ROW_NUMBER() OVER (PARTITION by ticker order by time_ asc) as rn from a)
, last_with_clause as ( 
select ticker, price as first_price from b where rn = 1)
select ticker, first_price from last_with_clause )S
ON target_table.ticker = S.ticker 
WHEN MATCHED THEN UPDATE SET  first_price = S.first_price ;
ALTER TABLE sql_volume_price_declining_2_yday ADD COLUMN first_price FLOAT;
MERGE INTO sql_volume_price_declining_2_yday target_table
USING ( with a as ( 
	select ticker, time_, price from finviz_result 
where  
 full_date in (select max(full_date) from finviz_result) 

)
, b as ( 
select ticker, price, ROW_NUMBER() OVER (PARTITION by ticker order by time_ asc) as rn from a)
, last_with_clause as ( 
select ticker, price as first_price from b where rn = 1)
select ticker, first_price from last_with_clause )S
ON target_table.ticker = S.ticker 
WHEN MATCHED THEN UPDATE SET  first_price = S.first_price ;
ALTER TABLE sql_volume_below_08_average_yday ADD COLUMN first_price FLOAT;
MERGE INTO sql_volume_below_08_average_yday target_table
USING ( with a as ( 
	select ticker, time_, price from finviz_result 
where  
 full_date in (select max(full_date) from finviz_result) 

)
, b as ( 
select ticker, price, ROW_NUMBER() OVER (PARTITION by ticker order by time_ asc) as rn from a)
, last_with_clause as ( 
select ticker, price as first_price from b where rn = 1)
select ticker, first_price from last_with_clause )S
ON target_table.ticker = S.ticker 
WHEN MATCHED THEN UPDATE SET  first_price = S.first_price ;
