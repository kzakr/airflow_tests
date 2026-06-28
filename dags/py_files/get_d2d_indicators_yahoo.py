import numpy as np
import pandas as pd
import re
from typing import Optional


#from attr import CommonAttributes, CommonConditions
from py_files.commons import get_time, add_working_days
from py_files.commons_sql import get_max_date

from py_files.attr import  JoinOperators

_NUM_OD_DAYS = 4
now, dt_string_with_hour, dt_string = get_time(format = "%Y-%m-%d")

def get_raw_data(day) -> str:
    
    columns_to_keep = ['no_', 'ticker', 'company', 'sector', 'industry',
           'country', 'market', 'p_e', 'price', 'change_', 'volume','full_date', 'full_date_ticker', 'time_', 
           'volume_mean', 'volume_std', 'price_mean', 'price_std']

    sql_query = "select ticker, _date, close as price,  volume as volume  from yahoo_result \n"
    sql_query += "where  \n"
    sql_query += f" full_date in ({day})  \n"



    #df =  sql_to_dataframe( query=sql_query, conn= create_connection())

    return sql_query

def get_statistical_metrics_avg(ticker_conditions= [], to_date:int = 20260401) -> str:

    interval_start = add_working_days(date_as_int = to_date,num_days = -70, format = "%Y-%m-%d")


    sql_query_avg = "select ticker,  avg(volume) as avg_volume, avg(price) as avg_price,count(*) as full_date_count "
    sql_query_avg += " from yahoo_result  \n"
    #sql_query_avg += "where company  not like  \"ETF%\" \n"
    sql_query_avg += f"where _date> {interval_start} and _date < {to_date}\n"
    if ticker_conditions:
        sql_query_avg += f"and ticker in {ticker_conditions}\n".replace("[", "(").replace("]", ")")
    sql_query_avg += "group by ticker \n"
    sql_query_avg += "having avg(cast (market as decimal))>1500000 \n"
    sql_query_avg += "and avg(volume)<>0 and avg(price)<>0 \n"
    #df_avg =  sql_to_dataframe( query=sql_query_avg, conn= create_connection())
    return sql_query_avg


def get_statistical_metrics_std(statistical_metrics_avg: str = get_statistical_metrics_avg(), ticker_conditions =[], to_date:int = 20260401) -> str:

    
    interval_start = add_working_days(date_as_int = to_date, num_days =  -70, format = "%Y-%m-%d")

    sql_query_std = "select ticker, sqrt(sum(std_price_unsum)) as std_price, sqrt(sum(std_volume_unsum)) as std_volume from \n"
    sql_query_std += "\t(select fr.ticker, fr._date, power(price - avg_price,2)/full_date_count as std_price_unsum, power(volume - avg_volume,2)/full_date_count as std_volume_unsum "
    sql_query_std += f"\tfrom yahoo_result fr join ({statistical_metrics_avg}) avg\n"
    sql_query_std += f"\t on fr.ticker = avg.ticker where fr._date > {interval_start} and fr._date < {to_date})\n"
    sql_query_std += f"where _date> {interval_start} and _date < {to_date}\n"
    if ticker_conditions:
        sql_query_std += f"and ticker in {ticker_conditions}\n".replace("[", "(").replace("]", ")")
    sql_query_std += "group by ticker"
    
    #df_avg =  sql_to_dataframe( query=sql_query_avg, conn= create_connection())
    return sql_query_std

def get_data(sql_query: str, statistical_metrics_avg: str = get_statistical_metrics_avg(), statistical_metrics_std: str = get_statistical_metrics_std()) -> str:
    
    query =  "select sql_query.*, statistical_metrics_avg.avg_volume, statistical_metrics_avg.avg_price, statistical_metrics_avg.full_date_count, statistical_metrics_std.std_price, statistical_metrics_std.std_volume from ((" + sql_query + ") sql_query join \n"
    query += "(" + statistical_metrics_avg + ") statistical_metrics_avg \n"
    query += "on sql_query.ticker = statistical_metrics_avg.ticker join "
    query += "(" + statistical_metrics_std + ") statistical_metrics_std \n"
    query += "on sql_query.ticker = statistical_metrics_std.ticker) "
    query += "where statistical_metrics_avg.avg_volume <>0 and statistical_metrics_avg.avg_price <>0"
    

    return query

def get_lagged_data(query_data: str,day_count:str):

    day_count = int(re.findall("(?<=limit ).*", day_count)[0])
    day_dict = {1:"one", 2:"two", 3:"three", 4:"four", 5:"five", 6:"six", 7:"seven", 8:"eight", 9:"nine", 10:"ten", 11:"eleven", 
        12:"twelve", 13:"thirteen", 14:"fourteen", 15:"fiveteen", 16:"sixteen", 17:"seveteen", 18:"eighteen", 19:"nineteen", 20:"twenty", 21:"twenty_one", 
        22:"twenty_two", 23:"twenty_three", 24:"twenty_four", 25:"twenty_five", 26:"twenty_six", 27:"twenty_seven"
        , 28:"twenty_eight", 29:"twenty_nine", 30:"thirty", 31:"thirty_one", 32:"thirty_two", 33:"thirty_three", 34:"thirty_four"
        , 35:"thirty_five", 36:"thirty_six", 37:"thirty_seven", 38:"thirty_eight", 39:"thirty_nine", 40:"forty", 41:"forty_one"
        , 42:"forty_two", 43:"forty_three", 44:"forty_four", 45:"forty_five", 46:"forty_six", 47:"forty_seven", 48:"forty_eight"
        , 49:"forty_nine", 50:"fifty", 51:"fifty_one", 52:"fifty_two", 53:"fifty_three", 54:"fifty_four", 55:"fifty_five", 56:"fifty_six", 57:"fifty_seven", 58:"fifty_eight"
        , 59:"fifty_nine", 60:"sixty", 61:"sixty_one", 62:"sixty_two", 63:"sixty_three", 64:"sixty_four", 65:"sixty_five", 66:"sixty_six", 67:"sixty_seven", 68:"sixty_eight"
        , 69:"sixty_nine",
         70:"seventy", 71:"seventy_one", 72:"seventy_two", 73:"seventy_three", 74:"seventy_four", 75:"seventy_five", 76:"seventy_six", 77:"seventy_seven", 78:"seventy_eight"
        , 79:"seventy_nine"}
    query_lag = "with a as ( \n"
    query_lag += f"\t {query_data}" 
    query_lag +=")\n"
    query_lag +=", b as ( select *, \n"
    for day in range(1,day_count+1):
        if day !=day_count:
            query_lag += f" lag (volume,{day}) OVER (PARTITION BY ticker ORDER BY _date) AS volume_{day_dict[day]}_day_back,  \n"
            query_lag += f" lag (price,{day}) OVER (PARTITION BY ticker ORDER BY _date) AS price_{day_dict[day]}_day_back,  \n"
        elif  day ==day_count:
            query_lag += f" lag (volume,{day}) OVER (PARTITION BY ticker ORDER BY _date) AS volume_{day_dict[day]}_day_back,  \n"
            query_lag += f" lag (price,{day}) OVER (PARTITION BY ticker ORDER BY _date) AS price_{day_dict[day]}_day_back  \n"
    query_lag += " from a )  \n"
    query_lag += " select * from b where _date = (select max(_date) from a)"

    return query_lag
    

def get_price_base():

    _three_day_part = "select distinct _date from yahoo_result where _date not in (select max(_date) from yahoo_result ) order by _date desc limit 3"
    
    columns_to_keep = ['no_', 'ticker', 'company', 'sector', 'industry',
           'country', 'market', 'p_e', 'price', 'change_', 'volume','_date', '_date_ticker', 'time_', 
           'volume_mean', 'volume_std', 'price_mean', 'price_std']

    base_query = "select ticker, close as close_price, open as price_open,  volume as volume  from yahoo_result \n"
    base_query += "where  \n"
    base_query += f" _date in ({get_max_date()}) \n"

    return base_query


def get_first_price(base_query:str = get_price_base()):

    first_price_query = "with a as ( \n"
    first_price_query += f"\t{base_query}\n"
    first_price_query += ")\n"
    first_price_query += ", b as ( \n"
    first_price_query += "select ticker, price_open, price_close from a"
    first_price_query += ")\n"
    first_price_query += ", last_with_clause as ( \n"
    first_price_query += "select ticker, price_open as first_price from b"
    first_price_query += ")\n"
    first_price_query += "select ticker, first_price from last_with_clause"
    
    return first_price_query

def get_last_price(base_query:str = get_price_base()):

    last_price_query = "with a as ( \n"
    last_price_query += f"\t{base_query}\n"
    last_price_query += ")\n"
    last_price_query += ", b as ( \n"
    last_price_query += "select ticker, price_close from a"
    last_price_query += ")\n"
    last_price_query += ", last_with_clause as ( \n"
    last_price_query += "select ticker, price_close as last_price from b 1"
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
    join_query += "select T.*"
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

    #ToDo

    return join_query


    
    