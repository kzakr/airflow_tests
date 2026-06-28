from airflow import DAG
from datetime import datetime, timedelta
from airflow.operators.python_operator import PythonOperator
from airflow.operators.postgres_operator import PostgresOperator

from py_files.commons import get_time

from py_files.indicators_dataset_prep_yahoo import prepare_final_query, insert_to_stats
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
        os.remove("./dags/sql_scipts/statistical_indicators_yahoo.sql")
    except Exception as ex:
        print(ex)
    final_query = prepare_final_query(lags=9, days_back=20, lagged_column_1= ["close"], lagged_column_2= ["volume"], measure_values = ["volume"], measure_names = ["ticker", "_date", "days_back"], sign='>', multiplier = 1)
    insert_to_stats(name= "tickers_increasing_yahoo", sql_query=final_query)


def _prepare_decreasing_view():
    
    final_query = prepare_final_query(lags=9, days_back=20, lagged_column_1= ["close"], lagged_column_2= ["volume",], measure_values = ["volume"], measure_names = ["ticker", "_date", "days_back"], sign = '<', multiplier = 1)
    insert_to_stats(name= "tickers_decreasing_yahoo", sql_query=final_query)





# Instantiate the DAG


dag = DAG(

    'statistical_view_yahoo',
    start_date= datetime(2025, 3, 17),
    default_args = default_args,
    description = 'description of your dag_2',
    schedule_interval = None, #you can set any schedule interval you want.
    catchup = False,
)


create_tables = PostgresOperator(
        task_id='create_view_with_increasing_values',
        postgres_conn_id="airflow",
        sql='./sql_scipts/create_statistical_tables_yahoo.sql',
        retries=3,
        retry_delay=timedelta(minutes=3),
        dag=dag,
    )

#prepare_increasing_view = PythonOperator(
#     task_id = 'prepare_view_increasing',
#     python_callable = _prepare_increasing_view,
#     provide_context = True,
#     dag = dag
#)
#
#prepare_decreasing_view = PythonOperator(
#     task_id = 'prepare_view_decreasing',
#     python_callable = _prepare_decreasing_view,
#     provide_context = True,
#     dag = dag
#)
#

create_view_with_increasing_values_task = PostgresOperator(
        task_id='insert_values_inc',
        postgres_conn_id="airflow",
        sql='./sql_scipts/sql_query_tickers_increasing_yahoo.sql',
        retries=3,
        retry_delay=timedelta(minutes=3),
        dag=dag,
    )

create_view_with_decreasing_values_task = PostgresOperator(
        task_id='insert_values_dec',
        postgres_conn_id="airflow",
        sql='./sql_scipts/sql_query_tickers_decreasing_yahoo.sql',
        retries=3,
        retry_delay=timedelta(minutes=3),
        dag=dag,
    )

_ = create_tables>> create_view_with_decreasing_values_task 
_= create_tables>> create_view_with_increasing_values_task

