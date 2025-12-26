import numpy as np
import pandas as pd
import os
import re
from typing import Optional


#from attr import CommonAttributes, CommonConditions
from py_files.commons import get_time, list_in_directory, convert_str_values_to_dec,split_dates_finwiz, create_grouped_df, add_column_based_on_confition
from py_files.calculations import std,calc_z_score, convert_big_numbers
from py_files.postgres_bulk import postgres_bulk, sql_to_dataframe, create_engine, create_connection
from py_files.d2d_rules import volume_and_price_declining_3, volume_below_08_average,volume_and_price_raising_3, volume_declining_3, volume_declining_with_multiplicator, volume_price_declining_2, price_declining_3
import re
from typing import List
from py_files.attr import  JoinOperators

_NUM_OD_DAYS = 4

def get_max_date( time_column:str = "full_date", table:str = "finviz_result")->str:
    statement = f"select max({time_column}) from {table}"

    return (statement)


def get_day_part(how_many_day:int = _NUM_OD_DAYS ):
    _day_part = f"select distinct full_date from finviz_result where full_date not in (select max(full_date) from finviz_result ) order by full_date desc limit {how_many_day}"
    return _day_part

def get_raw_data(day = get_day_part()) -> str:
    
    columns_to_keep = ['no_', 'ticker', 'company', 'sector', 'industry',
           'country', 'market', 'p_e', 'price', 'change_', 'volume','full_date', 'full_date_ticker', 'time_', 
           'volume_mean', 'volume_std', 'price_mean', 'price_std']

    sql_query = "select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result \n"
    sql_query += "where  \n"
    sql_query += f" full_date in ({day}) \n"
    sql_query += "group by ticker, full_date \n"
    sql_query += "having avg(cast (market as decimal)) > 2000000" 

    print(sql_query)

    #df =  sql_to_dataframe( query=sql_query, conn= create_connection())

    return sql_query

def get_statistical_metrics_avg() -> str:

    sql_query_avg = "select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(distinct full_date) as full_date_count, "
    sql_query_avg += "sum(power(price - avg(price),2))/count(distinct full_date) as std_price, sum(power(volume - avg(volume),2))/count(distinct full_date) as std_volume\n"
    sql_query_avg += " from finviz_result  \n"
    #sql_query_avg += "where company  not like  \"ETF%\" \n"
    sql_query_avg += "group by ticker \n"
    sql_query_avg += "having avg(cast (market as decimal))>1500000 \n"
    sql_query_avg += "and avg(volume)<>0 and avg(price)<>0 \n"
    print(sql_query_avg)
    #df_avg =  sql_to_dataframe( query=sql_query_avg, conn= create_connection())
    return sql_query_avg


def get_statistical_metrics_std(statistical_metrics_avg: str = get_statistical_metrics_avg()) -> str:

    sql_query_std = "select ticker, sum(std_price_unsum) as std_price, sum(std_volume_unsum) as std_volume from \n"
    sql_query_std += "\t(select fr.ticker, fr.full_date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum "
    sql_query_std += f"\tfrom finviz_result fr join ({statistical_metrics_avg}) avg\n"
    sql_query_std += "\t on fr.ticker = avg.ticker)"
    
    print(sql_query_std)
    #df_avg =  sql_to_dataframe( query=sql_query_avg, conn= create_connection())
    return sql_query_std

def get_data(sql_query: str = get_raw_data(), statistical_metrics_avg: str = get_statistical_metrics_avg(), statistical_metrics_std: str = get_statistical_metrics_std()) -> str:
    
    query =  "select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((" + sql_query + ") sql_query join \n"
    query += "(" + statistical_metrics_avg + ") statistical_metrics_avg \n"
    query += "on sql_query.ticker = statistical_metrics_avg.ticker) join "
    query += "(" + statistical_metrics_std + ") statistical_metrics_std \n"
    query += "on sql_query.ticker = statistical_metrics_std.ticker) "
    query += "where statistical_metrics.avg_volume <>0 and statistical_metrics.avg_price <>0"
    

    print(query)

    return query

def get_lagged_data(query_data: str = get_data(),day_count = get_day_part()):

    day_count = int(re.findall("(?<=limit ).*", day_count)[0])
    day_dict = {1:"one", 2:"two", 3:"three", 4:"four", 5:"five", 6:"six", 7:"seven", 8:"eight", 9:"nine", 10:"ten", 11:"eleven", 
                12:"twelve", 13:"thirteen", 14:"fourteen", 15:"fiveteen", 16:"sixteen", 17:"seveteen", 18:"eighteen", 19:"nineteen", 20:"twenty", 21:"twenty_one", 
                22:"twenty_two", 23:"twenty_three", 24:"twenty_four", 25:"twenty_five", 26:"twenty_six"}
    query_lag = "with a as ( \n"
    query_lag += f"\t {query_data}" 
    query_lag +=")\n"
    query_lag +=", b as ( select *, \n"
    for day in range(1,day_count+1):
        if day !=day_count:
            query_lag += f" lag (volume,{day}) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_{day_dict[day]}_day_back,  \n"
            query_lag += f" lag (price,{day}) OVER (PARTITION BY ticker ORDER BY full_date) AS price_{day_dict[day]}_day_back,  \n"
        elif  day ==day_count:
            query_lag += f" lag (volume,{day}) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_{day_dict[day]}_day_back,  \n"
            query_lag += f" lag (price,{day}) OVER (PARTITION BY ticker ORDER BY full_date) AS price_{day_dict[day]}_day_back  \n"
    query_lag += " from a )  \n"
    query_lag += " select * from b where full_date = (select max(full_date) from a)"

    print(query_lag)    

    return query_lag
    

def get_price_base():

    _three_day_part = "select distinct full_date from finviz_result where full_date not in (select max(full_date) from finviz_result ) order by full_date desc limit 3"
    
    columns_to_keep = ['no_', 'ticker', 'company', 'sector', 'industry',
           'country', 'market', 'p_e', 'price', 'change_', 'volume','full_date', 'full_date_ticker', 'time_', 
           'volume_mean', 'volume_std', 'price_mean', 'price_std']

    base_query = "select ticker, time_, price from finviz_result \n"
    base_query += "where  \n"
    base_query += f" full_date in ({get_max_date()}) \n"

    return base_query


def get_first_price(base_query:str = get_price_base()):

    first_price_query = "with a as ( \n"
    first_price_query += f"\t{base_query}\n"
    first_price_query += ")\n"
    first_price_query += ", b as ( \n"
    first_price_query += "select ticker, price, ROW_NUMBER() OVER (PARTITION by ticker order by time_ asc) as rn from a"
    first_price_query += ")\n"
    first_price_query += ", last_with_clause as ( \n"
    first_price_query += "select ticker, price as first_price from b where rn = 1"
    first_price_query += ")\n"
    first_price_query += "select ticker, first_price from last_with_clause"
    
    return first_price_query

def get_last_price(base_query:str = get_price_base()):

    last_price_query = "with a as ( \n"
    last_price_query += f"\t{base_query}\n"
    last_price_query += ")\n"
    last_price_query += ", b as ( \n"
    last_price_query += "select ticker, price, ROW_NUMBER() OVER (PARTITION by ticker order by time_ desc) as rn from a"
    last_price_query += ")\n"
    last_price_query += ", last_with_clause as ( \n"
    last_price_query += "select ticker, price as last_price from b where rn = 1"
    last_price_query += ")\n"
    last_price_query += "select ticker, last_price from last_with_clause"
    

    return last_price_query

def sql_merge_operator(target: str, source:str, columns_to_merge, keys: str,  when_not_match:Optional[str] = None):

    
    merge_query = f"ALTER TABLE {target} ADD COLUMN {columns_to_merge[0]} FLOAT;\n"

    merge_query += f"MERGE INTO {target} target_table\n"
    merge_query += f"USING ( {source} )S"
    merge_query += "\nON"
    for i in range(0, len(keys)):
        if i == len(keys)-1:
            merge_query += f" target_table.{keys[i]} = S.{keys[i]} "
        elif i < len(keys)-1:
            merge_query += f" target_table.{keys[i]} = S.{keys[i]} and"
    
    merge_query += "\nWHEN MATCHED THEN UPDATE SET "
    for i in range(0, len(columns_to_merge)):
        if i == len(columns_to_merge)-1:
            merge_query += f" {columns_to_merge[i]} = S.{columns_to_merge[i]} "
        elif i < len(keys)-1:
            merge_query += f" {columns_to_merge[i]} = S.{columns_to_merge[i]} and"

    if when_not_match:
        #ToDo
        pass
    merge_query += ";\n"
    #ToDo

    return merge_query


def join_operator(target: str, source:str, columns_to_join, keys, join_operator:JoinOperators, additional_condition: Optional[str] = None):
    
    join_query = f"{source}"
    join_query += f"select T.*"
    for column_to_join in columns_to_join:
        join_query += f"\t, S.{column_to_join} "
    join_query += f"\nfrom {target} T {join_operator.value} last_with_clause S\n"
    join_query += "on"
    for i in range(0, len(keys)):
        if i == len(keys)-1:
            join_query += f" T.{keys[i]} = S.{keys[i]} "
        elif i < len(keys)-1:  
            join_query += f" T.{keys[i]} = S.{keys[i]} and"
    if additional_condition:
        join_query += f"\n {additional_condition}"
    join_query += ";\n"

    print(join_query)    
    #ToDo

    return join_query


    
    