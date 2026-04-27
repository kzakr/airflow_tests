import os

os.chdir(os.path.dirname(os.getcwd()))

from airflow import DAG
from airflow.operators.python import PythonOperator, BranchPythonOperator
from airflow.operators.postgres_operator import PostgresOperator
#from airflow.operators.branch_operator import BaseBranchOperator
from airflow.operators.bash import BashOperator
import datetime
from datetime import timedelta
import pandas as pd
from py_files.analyze_results import upload_data_to_postgres
from py_files.postgres_bulk import postgres_bulk, create_connection

def copy_csv_to_table():
    table_to_insert = pd.read_csv("/opt/airflow/dags/yahoo_results/yahoo_data.csv")
    postgres_bulk(table_to_insert, table_name ='yahoo_result_staging', if_exists="append", engine_conn= create_connection())

with DAG(dag_id = "yahoo_data_upload", start_date=datetime.datetime(2025, 1, 1), schedule="30 22 * * 1-5", catchup = False) as dag:

   #get_webdriver_options = PythonOperator(

   #    task_id = "get_webdriver_options",
   #    python_callable = _webdriver_options
   #)
    
    #get_data_postgres = PythonOperator(
    #    task_id='get_data_postgres',
    #    python_callable = _get_data_postgres,
    #    retries=4,
    #    retry_delay=timedelta(minutes=3),
    #
    #)
    
    create_db_table_task = PostgresOperator(
        task_id='create_db_table',
        postgres_conn_id="airflow",
        sql='./sql_scipts/yahoo_prices_table.sql',
        retries=3,
        retry_delay=timedelta(minutes=3),
    )
    create_db_staging_table_task = PostgresOperator(
        task_id='create_db_staging_tables',
        postgres_conn_id="airflow",
        sql='./sql_scipts/yahoo_prices_table_staging.sql',
        retries=3,
        retry_delay=timedelta(minutes=3),
    )
    insert_into_db_table_task = PostgresOperator(
        task_id='insert_db_table',
        postgres_conn_id="airflow",
        sql='./sql_scipts/yahoo_result_insert_staging.sql',
        retries=3,
        retry_delay=timedelta(minutes=3),
    )

    upload_data_to_postgres_loop = PythonOperator(
        task_id='upload_data_to_postgres_loop',
        python_callable = copy_csv_to_table,
        retries=2,
        retry_delay=timedelta(minutes=2),

    )


    
    [create_db_table_task, create_db_staging_table_task] >>upload_data_to_postgres_loop >> insert_into_db_table_task