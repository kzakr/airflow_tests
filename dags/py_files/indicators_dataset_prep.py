from airflow.operators.bash import BashOperator
import datetime
import pandas as pd

from py_files.commons import  get_last_weekday
from py_files.get_d2d_change_indicators import get_raw_data_change, get_avg_value, get_changing_pattern, get_closed_price,  \
    get_lagged_values, prepare_full_query
import random
from random import randint

_interval = 20
last_week_date = get_last_weekday()
_num_of_days = 70
random.seed(44)

def prepare_final_query(lags:int, days_back:int, lagged_column_1: str, lagged_column_2: str,measure_values:str, measure_names:str, sign:str, multiplier:float):
    if lags> days_back:
        print("Lags value must me lower than days back")
    price_query = get_changing_pattern(source=get_lagged_values(source=get_closed_price(source= get_raw_data_change(days_back= days_back)), lags = lags, lagged_column=lagged_column_1), lags = lags, lagged_column=lagged_column_1, sign= sign, multiplier = multiplier)
    print(price_query)
    volume_query = get_changing_pattern(source=get_lagged_values(source=get_avg_value(source= get_raw_data_change(days_back= days_back),measure_values= measure_values, measure_names=measure_names), lags = lags, lagged_column=lagged_column_2), lags = lags, lagged_column=measure_values, prefix= "avg_", sign= sign, multiplier = multiplier)
    full_query = prepare_full_query(source_1= price_query, source_2=volume_query, join_columns=measure_names, prefix="avg_")
    print(full_query)

    return full_query

def insert_to_stats(name:str, sql_query:str = None):

    view_def = f"INSERT INTO {name} select * from ({sql_query});\n\n"
    with open(f"./dags/sql_scipts/sql_query_{name}.sql", "w") as file:
        file.write(view_def)

def create_results_query(query:str)->None:

    with open(f"./dags/sql_scipts/results_view.sql", "w") as file:
        file.write(query)