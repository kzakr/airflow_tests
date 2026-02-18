from airflow import DAG
from datetime import datetime, timedelta
from airflow.operators.python_operator import PythonOperator
from airflow.operators.postgres_operator import PostgresOperator

from py_files.commons import get_time

from py_files.indicators_dataset_prep import prepare_final_query, insert_to_stats
import pandas as pd
import os


default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2025, 3, 17),
    'schedule_interval' : 'None',
    'email_on_failure': False,
    'email_on_success': True,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(seconds=5)
}

now, dt_string_with_hour, dt_string = get_time()
_interval = 10

def _prepare_increasing_view():
    try:
        os.remove("./dags/sql_scipts/statistical_indicators.sql")
    except Exception as ex:
        print(ex)
    final_query = prepare_final_query(lags=16, days_back=20, lagged_column_1= ["price", "full_date"], lagged_column_2= ["volume", "full_date"], measure_values = ["volume"], measure_names = ["ticker", "full_date"], sign='>', multiplier = 1.02)
    insert_to_stats(name= "tickers_increasing", sql_query=final_query)


def _prepare_decreasing_view():
    
    final_query = prepare_final_query(lags=12, days_back=15, lagged_column_1= ["price", "full_date"], lagged_column_2= ["volume", "full_date"], measure_values = ["volume"], measure_names = ["ticker", "full_date"], sign = '<', multiplier = 1.02)
    insert_to_stats(name= "tickers_decreasing", sql_query=final_query)





# Instantiate the DAG


dag = DAG(

    'statistical_view',
    start_date= datetime(2025, 3, 17),
    default_args = default_args,
    description = 'description of your dag_2',
    schedule_interval = None, #you can set any schedule interval you want.
    catchup = False,
)


create_tables = PostgresOperator(
        task_id='create_view_with_increasing_values',
        postgres_conn_id="airflow",
        sql='./sql_scipts/create_statistical_tables.sql',
        retries=3,
        retry_delay=timedelta(minutes=3),
    )

prepare_increasing_view = PythonOperator(
     task_id = 'prepare_view_increasing',
     python_callable = _prepare_increasing_view,
     provide_context = True,
     dag = dag
)

prepare_decreasing_view = PythonOperator(
     task_id = 'prepare_view_decreasing',
     python_callable = _prepare_decreasing_view,
     provide_context = True,
     dag = dag
)


create_view_with_increasing_values_task = PostgresOperator(
        task_id='insert_values_inc',
        postgres_conn_id="airflow",
        sql='./sql_scipts/sql_query_tickers_increasing.sql',
        retries=3,
        retry_delay=timedelta(minutes=3),
    )

create_view_with_decreasing_values_task = PostgresOperator(
        task_id='insert_values_dec',
        postgres_conn_id="airflow",
        sql='./sql_scipts/sql_query_tickers_decreasing.sql',
        retries=3,
        retry_delay=timedelta(minutes=3),
    )

_ = create_tables>> [prepare_decreasing_view, prepare_increasing_view] 

_ =  prepare_increasing_view>> create_view_with_increasing_values_task
_ =  prepare_decreasing_view>> create_view_with_decreasing_values_task