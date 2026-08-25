import os

os.chdir(os.path.dirname(os.getcwd()))

from airflow import DAG
from airflow.operators.python import PythonOperator, BranchPythonOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
#from airflow.operators.branch_operator import BaseBranchOperator
from airflow.operators.bash import BashOperator
import datetime
from datetime import timedelta
import pandas as pd
from py_files.analyze_results import upload_data_to_postgres
from py_files.postgres_bulk import postgres_bulk, create_connection

def copy_csv_to_table():
    table_to_insert = pd.read_csv("/opt/airflow/dags/yahoo_results/check_data.csv")
    postgres_bulk(table_to_insert, table_name ='yahoo_check_result', if_exists="append", engine_conn= create_connection())


def _get_data_postgres():
    # Connect to the PostgreSQL database
    conn = create_connection()
    
    # Define the SQL query to retrieve data from the table
    query = """WITH start_date AS (
    SELECT ticker, _date AS min_date, close AS start_close
    FROM yahoo_check_result
    where _date = (SELECT MIN(_date) FROM yahoo_check_result)
)
, end_date AS (
    SELECT ticker, _date AS max_date, close AS end_close
    FROM yahoo_check_result
    where _date = (SELECT MAX(_date) FROM yahoo_check_result)
)
SELECT s.ticker, s.min_date, e.max_date, s.start_close, e.end_close, (e.end_close - s.start_close)/s.start_close *100 AS price_change_percentage
FROM start_date s
JOIN end_date e ON s.ticker = e.ticker
ORDER BY price_change_percentage DESC;
"""
    
    # Execute the query and fetch the results into a DataFrame
    df = pd.read_sql(query, conn)
    
    
    # Save the DataFrame to a CSV file
    df.to_csv("/opt/airflow/dags/yahoo_results/check_data_verification.csv", index=False)

with DAG(dag_id = "yahoo_data_check_result", start_date=datetime.datetime(2025, 1, 1), schedule="30 22 * * 1-5", catchup = False) as dag:

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
    
    create_db_table_task = SQLExecuteQueryOperator(
        task_id='create_db_table',
        conn_id="airflow",
        sql='./sql_scipts/yahoo_prices_check_table.sql',
        retries=3,
        retry_delay=timedelta(minutes=3),
    )
 

    upload_data_to_postgres_loop = PythonOperator(
        task_id='upload_data_to_postgres_loop',
        python_callable = copy_csv_to_table,
        retries=2,
        retry_delay=timedelta(minutes=2),

    )
    export_results_to_csv = PythonOperator(
        task_id='export_results_to_csv',
        python_callable = _get_data_postgres,
        retries=2,
        retry_delay=timedelta(minutes=2),

    )



    [create_db_table_task] >> upload_data_to_postgres_loop >> export_results_to_csv