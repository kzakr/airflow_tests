import numpy as np
import pandas as pd
#from attr import CommonAttributes, CommonConditions
from py_files.commons import get_time, add_working_days, iterative_list, day_dict
from typing import List

_NUM_OD_DAYS = 4
now, dt_string_with_hour, dt_string = get_time()

def get_raw_data_change(days_back: int) -> str:
    interval_start = add_working_days(num_days = -days_back)

    sql_query = "select ticker, full_date, price, volume as volume, time_ from finviz_result \n"
    sql_query += "where  \n"
    sql_query += f" full_date > ({interval_start})  \n"
    sql_query += "AND  ticker in \n\t("
    sql_query += "\n\t\tselect ticker from finviz_result "
    sql_query += "\n\t\tgroup by ticker"
    sql_query += "\n\t\thaving avg(volume)>2500000"
    sql_query += "\n)"




    #df =  sql_to_dataframe( query=sql_query, conn= create_connection())

    return sql_query


def get_closed_price(source:str, partition_list:str = ["ticker", "full_date"], order_by:str= "time_"):
    partition_list = ', '.join(partition_list)
    sql_query = f"select * from (\n\tselect *,  ROW_NUMBER() over (PARTITION BY {partition_list} order by {order_by} desc) rn \nfrom( \n\t{source}\n)\n)\nwhere rn = 1"
    return sql_query

def get_avg_value(source:str, measure_values: str, measure_names: str):
    if isinstance(measure_values, str):
        measure_values = [measure_values]
    if isinstance(measure_names, str):
        measure_names = [measure_names]
    sql_query = "select "
    measure_names_listed = ""
    measure_values_listed = ""
    for measure_name in measure_names:
        measure_names_listed += f"\n\t{measure_name} as {measure_name}, "
    for measure_value in measure_values:
        if measure_name != measure_values[-1]:
            measure_values_listed += f"\n\tavg({measure_value}) as {measure_value} "
        elif measure_name == measure_values[-1]:
            measure_values_listed += f"\n\tavg({measure_value}) as {measure_value}"

    sql_query += measure_names_listed
    sql_query += measure_values_listed
    sql_query += f"from \n(\n\t{source}\n)"
    sql_query += "group by "
    sql_query += ", ".join(measure_names)
    
    return sql_query

def get_lagged_values(source:str, lags:int, lagged_column:str):
    if lags<1:
        print("Cannot be less than 1 lag")
    if isinstance(lagged_column, str):
        lagged_column = [lagged_column]
    sql_query = "select *" 
    for column in lagged_column:
        for i in range(1, lags):
            sql_query += f"\n\t, lag({column}, {i}) OVER (PARTITION BY ticker ORDER BY full_date) AS {column}_{day_dict[i]}_day_back"
    
    sql_query += f"\nfrom ( \n\t{source}\n) \n"
    return sql_query


def get_changing_pattern(source:str, lags:int, lagged_column:str, sign: str = ">", prefix:str="", multiplier:float=1):
    if lags<1:
        print("Cannot be less than 1 lag")
    try:
        lagged_column.remove("full_date")
    except Exception as ex:
        print(ex)
    sql_query = f"select ticker as {prefix}ticker, full_date as {prefix}full_date, "
    #sql_query += "\nCOALESCE ("
    #for lag in reversed(range(1, lags)):
    #    sql_query += f"\n\tfull_date_{day_dict[lag]}_day_back,"
    #sql_query = sql_query[:-1]
    #sql_query += f"\n) as {prefix}start_date"
    sql_query += " CASE "
    lists_to_iterate = iterative_list(range_from=2, range_to= lags)
    list_to_reverse = []
    sql_part= ""
    for iterated_list in  reversed(lists_to_iterate):
        min_iterated_list = min(iterated_list)
        max_iterated_list = max(iterated_list)-1
        for column in  lagged_column:
            for lag in range(min_iterated_list,max_iterated_list):
                if lag == min_iterated_list:
                    sql_query += f"WHEN (\n\t{column} {sign} {multiplier}*{column}_{day_dict[lag]}_day_back  AND "
                if lag +1 < max_iterated_list:
                    if lag>=min_iterated_list:
                        sql_query += f"\n\t{column}_{day_dict[lag]}_day_back {sign} {multiplier}*{column}_{day_dict[lag+1]}_day_back "
                    sql_query += " AND "
                elif lag +1 == max_iterated_list:
                    sql_query += f"\n\t{column}_{day_dict[lag]}_day_back {sign} {multiplier}*{column}_{day_dict[lag+1]}_day_back ) then add_working_days(full_date, {max_iterated_list})\n"
                #if lag +2< lags and lag  == max_iterated_list:
                #    sql_query += " when  "
                list_to_reverse.append(sql_part) 
    #for sql_part in reversed(list_to_reverse):
    #    sql_query += sql_part
    print(list_to_reverse)
    sql_query += f"\n end as {prefix}days_back"
    
    sql_query += f"\nfrom ( \n\t{source}\n)"
    sql_query += "\nwhere "
    
    for iterated_list in  lists_to_iterate:
        min_iterated_list = min(iterated_list)
        max_iterated_list = max(iterated_list)-1

        for column in  lagged_column:
            for lag in range(min_iterated_list,max_iterated_list):
                if lag == min_iterated_list:
                    sql_query += f"(\n\t{column} {sign} {multiplier}*{column}_{day_dict[lag]}_day_back  AND "
                if lag +1 < max_iterated_list:
                    if lag>=min_iterated_list:
                        sql_query += f"\n\t{column}_{day_dict[lag]}_day_back {sign} {multiplier}*{column}_{day_dict[lag+1]}_day_back "
                    sql_query += " AND "
                elif lag +1 == max_iterated_list:
                    sql_query += f"\n\t{column}_{day_dict[lag]}_day_back {sign} {multiplier}*{column}_{day_dict[lag+1]}_day_back )\n"
                if lag +2< lags and lag +1 == max_iterated_list:
                    sql_query += " or " 
                
    return sql_query


def prepare_full_query(source_1: str, source_2: str, join_columns: List[str], prefix:str=None):
    if isinstance(join_columns, str):
        join_columns = [join_columns]
    sql_query = "with aa as ("
    sql_query += f"\n\t{source_1}"
    sql_query += "\n)"
    sql_query += ", bb as ("
    sql_query += f"\n\t{source_2}"
    sql_query += "\n)"
    sql_query += "\nselect Current_DATE as current_date_, aa.ticker, CAST(aa.full_date as INT) as full_date, aa.days_back, bb.* from aa join bb on "
    for join_column in join_columns:
        if join_column!=join_columns[-1]:
            sql_query += f"\n aa.{join_column}=bb.{prefix}{join_column} AND"
        elif join_column==join_columns[-1]:
            sql_query += f"\n aa.{join_column}=bb.{prefix}{join_column}"
    return sql_query


def get_results(table_1:str, table_2:str)-> str:

    result_query = f"WITH {table_1} as ("
    result_query += f"\n\tselect * from {table_1}"
    result_query += "\n)"
    result_query = f"\n, {table_2} as ("
    result_query += f"\n\tselect * from {table_2}"
    result_query += "\n)"
    result_query += f"\nselect {table_1}.*, {table_2}.* \nfrom {table_1} JOIN {table_2}"
    result_query += f"\nON {table_1}.ticker={table_2}.ticker AND"
    result_query += f"\n({table_1}.full_date = {table_2}.days_back OR {table_1}.days_back={table_2}.full_date)"
    result_query += f"\nwhere current_date_ in (select MAX(current_date_) FROM {table_1})"

    return result_query