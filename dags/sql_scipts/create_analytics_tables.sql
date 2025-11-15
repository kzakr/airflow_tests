
DROP TABLE IF EXISTS sql_volume_and_price_declining_3_y_day;
CREATE TABLE  sql_volume_and_price_declining_3_y_day (
	ticker  VARCHAR (100),
	full_date  integer,
	price  numeric(38,8),
	market  numeric(38,8),
	volume  numeric(38,8),
	avg_volume  numeric(38,8),
	avg_price  numeric(38,8),
	volume_one_day_back  numeric(38,8),
	volume_two_days_back  numeric(38,8),
	price_one_day_back  numeric(38,8),
	price_two_days_back  numeric(38,8),
	base_price  integer,
	sql_volume_and_price_declining_3  VARCHAR (100));


DROP TABLE IF EXISTS sql_price_declining_3_y_day;
CREATE TABLE  sql_price_declining_3_y_day (
	ticker  VARCHAR (100),
	full_date  integer,
	price  numeric(38,8),
	market  numeric(38,8),
	volume  numeric(38,8),
	avg_volume  numeric(38,8),
	avg_price  numeric(38,8),
	volume_one_day_back  numeric(38,8),
	volume_two_days_back  numeric(38,8),
	price_one_day_back  numeric(38,8),
	price_two_days_back  numeric(38,8),
	base_price  integer,
	sql_price_declining_3  VARCHAR (100));


DROP TABLE IF EXISTS sql_volume_and_price_raising_3_y_day;
CREATE TABLE  sql_volume_and_price_raising_3_y_day (
	ticker  VARCHAR (100),
	full_date  integer,
	price  numeric(38,8),
	market  numeric(38,8),
	volume  numeric(38,8),
	avg_volume  numeric(38,8),
	avg_price  numeric(38,8),
	volume_one_day_back  numeric(38,8),
	volume_two_days_back  numeric(38,8),
	price_one_day_back  numeric(38,8),
	price_two_days_back  numeric(38,8),
	base_price  integer,
	sql_volume_and_price_raising_3  VARCHAR (100));


DROP TABLE IF EXISTS sql_volume_declining_3_y_day;
CREATE TABLE  sql_volume_declining_3_y_day (
	ticker  VARCHAR (100),
	full_date  integer,
	price  numeric(38,8),
	market  numeric(38,8),
	volume  numeric(38,8),
	avg_volume  numeric(38,8),
	avg_price  numeric(38,8),
	volume_one_day_back  numeric(38,8),
	volume_two_days_back  numeric(38,8),
	price_one_day_back  numeric(38,8),
	price_two_days_back  numeric(38,8),
	base_price  integer,
	sql_volume_declining_3  VARCHAR (100));


DROP TABLE IF EXISTS sql_volume_price_declining_2_y_day;
CREATE TABLE  sql_volume_price_declining_2_y_day (
	ticker  VARCHAR (100),
	full_date  integer,
	price  numeric(38,8),
	market  numeric(38,8),
	volume  numeric(38,8),
	avg_volume  numeric(38,8),
	avg_price  numeric(38,8),
	volume_one_day_back  numeric(38,8),
	volume_two_days_back  numeric(38,8),
	price_one_day_back  numeric(38,8),
	price_two_days_back  numeric(38,8),
	base_price  integer,
	sql_volume_price_declining_2  VARCHAR (100));


DROP TABLE IF EXISTS sql_volume_below_08_average_y_day;
CREATE TABLE  sql_volume_below_08_average_y_day (
	ticker  VARCHAR (100),
	full_date  integer,
	price  numeric(38,8),
	market  numeric(38,8),
	volume  numeric(38,8),
	avg_volume  numeric(38,8),
	avg_price  numeric(38,8),
	volume_one_day_back  numeric(38,8),
	volume_two_days_back  numeric(38,8),
	price_one_day_back  numeric(38,8),
	price_two_days_back  numeric(38,8),
	base_price  integer,
	sql_volume_below_08_average  VARCHAR (100));

