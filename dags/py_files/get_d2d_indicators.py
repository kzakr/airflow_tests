import numpy as np
import pandas as pd
import os

#from attr import CommonAttributes, CommonConditions
from py_files.commons import get_time, list_in_directory, convert_str_values_to_dec,split_dates_finwiz, create_grouped_df, add_column_based_on_confition
from py_files.calculations import std,calc_z_score, convert_big_numbers
from py_files.postgres_bulk import postgres_bulk, sql_to_dataframe, create_engine, create_connection
from py_files.d2d_rules import volume_and_price_declining_3, volume_below_08_average,volume_and_price_raising_3, volume_declining_3, volume_declining_with_multiplicator, volume_price_declining_2, price_declining_3
import re
from typing import List
from py_files.attr import  JoinOperators

def get_max_date( time_column:str = "full_date", table:str = "finviz_result"):
    statement = f"select max({time_column} from {table}"

    return (statement)


def get_raw_data() -> str:
    _three_days_part = "select distinct full_date from finviz_result where full_date not in (select max(full_date) from finviz_result ) order by full_date desc limit 3"
    columns_to_keep = ['no_', 'ticker', 'company', 'sector', 'industry',
           'country', 'market', 'p_e', 'price', 'change_', 'volume','full_date', 'full_date_ticker', 'time_', 
           'volume_mean', 'volume_std', 'price_mean', 'price_std']

    sql_query = "select ticker, full_date, avg(price) as price, avg(cast (market as decimal)) as market, avg(volume) as volume  from finviz_result \n"
    sql_query += "where  \n"
    sql_query += f" full_date in ({_three_days_part}) \n"
    sql_query += "group by ticker, full_date \n"
    sql_query += "having avg(cast (market as decimal)) > 1500000" 

    print(sql_query)

    #df =  sql_to_dataframe( query=sql_query, conn= create_connection())

    return sql_query

def get_statistical_metrics() -> str:

    sql_query_avg = "select ticker,  avg(volume) as avg_volume, avg(price) as avg_price from finviz_result \n"
    #sql_query_avg += "where company  not like  \"ETF%\" \n"
    sql_query_avg += "group by ticker \n"
    sql_query_avg += "having avg(cast (market as decimal))>1500000 \n"
    print(sql_query_avg)
    #df_avg =  sql_to_dataframe( query=sql_query_avg, conn= create_connection())
    return sql_query_avg

def get_data(sql_query: str = get_raw_data(), statistical_metrics: str = get_statistical_metrics()) -> str:
    
    query =  "select sql_query.*, statistical_metrics.avg_volume, statistical_metrics.avg_price from ((" + sql_query + ") sql_query join \n"
    query += "(" + statistical_metrics + ") statistical_metrics \n"
    query += "on sql_query.ticker = statistical_metrics.ticker)"

    print(query)

    return query

def get_lagged_data(query_data: str = get_data()):


    query_lag = "with a as ( \n"
    query_lag += f"\t {query_data}" 
    query_lag +=")\n"
    query_lag +=", b as ( select *, \n"
    query_lag +=" lag (volume,1) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_one_day_back,  \n"
    query_lag +=" lag (volume,2) OVER (PARTITION BY ticker ORDER BY full_date) AS volume_two_days_back,  \n"
    query_lag +=" lag (price,1) OVER (PARTITION BY ticker ORDER BY full_date) AS price_one_day_back,  \n"
    query_lag +=" lag (price,2) OVER (PARTITION BY ticker ORDER BY full_date) AS price_two_days_back  \n"
    query_lag += " from a )  \n"
    query_lag += " select * from b where full_date = (select max(full_date) from finviz_result)"

    print(query_lag)    

    return query_lag
    

def get_price_base():

    _three_days_part = "select distinct full_date from finviz_result where full_date not in (select max(full_date) from finviz_result ) order by full_date desc limit 3"
    
    columns_to_keep = ['no_', 'ticker', 'company', 'sector', 'industry',
           'country', 'market', 'p_e', 'price', 'change_', 'volume','full_date', 'full_date_ticker', 'time_', 
           'volume_mean', 'volume_std', 'price_mean', 'price_std']

    base_query = "select ticker, time_, price from finviz_result \n"
    base_query += "where  \n"
    base_query += f" full_date in ({get_max_date()}) \n"

    return base_query


def get_first_price(base_query:str = get_price_base()):

    first_price_query = "with a as ( \n"
    first_price_query += f"\t{base_query}\m"
    first_price_query += ")\n"
    first_price_query = ", b as ( \n"
    first_price_query += "select ticker, price, ROW_NUMBER() OVER (PARTITION by ticker order by time_ asc) as rn from a"
    first_price_query += ")\n"
    first_price_query += ", last_with_clause as ( \n"
    first_price_query += "select ticker, price as first_price from b where rn = 1"
    first_price_query += ")\n\n"
    
    return first_price_query

def get_lst_price(base_query:str = get_price_base()):

    last_price_query = "with a as ( \n"
    last_price_query += f"\t{base_query}\m"
    last_price_query += ")\n"
    last_price_query = ", b as ( \n"
    last_price_query += "select ticker, price, ROW_NUMBER() OVER (PARTITION by ticker order by time_ desc) as rn from a"
    last_price_query += ")\n"
    last_price_query += ", last_with_clause as ( \n"
    last_price_query += "select ticker, price as last_price from b where rn = 1"
    last_price_query += ")\n\n"

    return last_price_query

def sql_merge_operator(target: str, source:str, key: str, additional_condition:str, when_match:str, when_not_match:str):

    merge_query = f"MERGE INTO {target} T\n"
    merge_query += "USING "
    #ToDo

    return merge_query


def join_operator(target: str, source:str, columns_to_join, keys, join_operator:JoinOperators, additional_condition:str | None = None):
    
    join_query = f"{source} "
    join_query += f"select T.*"
    for column_to_join in columns_to_join:
        join_query += f"\t, S.{column_to_join} "
    join_query += f"\nfrom {target} T {join_operator.value} last_with_clause S\n"
    join_query += "on"
    for i in range(1, len(keys)+1):
        if i == len(keys):
            join_query += f" T.{keys[i]} = S.{keys[i]} "
        elif i < len(keys):
            join_query += f" T.{keys[i]} = S.{keys[i]} and"
    if additional_condition:
        join_query += f"\n {additional_condition}"
    join_query += f";\n"

    print(join_query)    
    #ToDo

    return join_query


    
    