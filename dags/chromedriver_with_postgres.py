import os

os.chdir(os.path.dirname(os.getcwd()))

from airflow import DAG
from airflow.operators.python import PythonOperator, BranchPythonOperator
from airflow.operators.postgres_operator import PostgresOperator
#from airflow.operators.branch_operator import BaseBranchOperator
from airflow.operators.bash import BashOperator
import datetime
from datetime import timedelta


#def _get_data_postgres():
#    connection = create_connection_for_import()
#
#    print(connection)
#    #with open("./sql_scipts/get_data_from_postgres.sql", "r") as file:
#    #    sql_query = file.read()
#    sql_query = "select * from finviz_result"
#
#    df= sql_to_dataframe(conn= connection, query=sql_query)
#
#    return df



def _webdriver_options():

    
    Chromebrowser = ChromebrowserOption()
    

    Chromebrowser.initialize_chrom_options()
    
    chrome_options = Chromebrowser.get_options()
   

    return chrome_options


def _upload_data_to_postgres(ti):
    print("Yet to pull")
    #ti_DataFrame = ti.xcom_pull(task_ids = [get_data_postgres])
    print("pulled")
    upload_data_to_postgres() 
    
    
#def _launch_driver(ti):
#    ti_chrome_options = ti.xcom_pull(task_ids = [get_webdriver_options])
#    ChromeBrowser_page = OpenChromeBrowser()
#    launched_driver = ChromeBrowser_page.open_chrome(ti_chrome_options)
#    return launched_driver

def _scan_finwiz(ti):
    
    Chromebrowser = ChromebrowserOption()
    
    Chromebrowser.initialize_chrom_options()
    
    chrome_options = Chromebrowser.get_options()
    
    #ti_chrome_options = ti.xcom_pull(task_ids = [get_webdriver_options])
    res = StockResults()
    res.run_process(how_many = res.how_many_to_repeat(how_many = 10), 
                    grid = res.specify_grid(from_param = 1, to_param = 41, interval_param = 20), #9921
                    options = chrome_options, 
                    url = r"https://finviz.com/screener.ashx?v=111&r="
                    )



with DAG(dag_id = "chromedriver_with_postgres", start_date=datetime.datetime(2025, 1, 1), schedule="30 22 * * 1-5", catchup = False) as dag:

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
        task_id='create_db_tables',
        postgres_conn_id="airflow",
        sql='./sql_scipts/finwiz_result_create_table.sql',
        retries=3,
        retry_delay=timedelta(minutes=3),
    )
    create_db_staging_table_task = PostgresOperator(
        task_id='create_db_staging_tables',
        postgres_conn_id="airflow",
        sql='./sql_scipts/finwiz_result_create_table_staging.sql',
        retries=3,
        retry_delay=timedelta(minutes=3),
    )
    insert_into_db_table_task = PostgresOperator(
        task_id='insert_db_table',
        postgres_conn_id="airflow",
        sql='./sql_scipts/finwiz_result_insert_staging.sql',
        retries=3,
        retry_delay=timedelta(minutes=3),
    )

    upload_data_to_postgres_loop = PythonOperator(
        task_id='upload_data_to_postgres_loop',
        python_callable = _upload_data_to_postgres,
        retries=2,
        retry_delay=timedelta(minutes=2),

    )

    #copy_csv_to_table = PythonOperator(
    #    task_id='copy_csv_to_table',
    #    python_callable=copy_csv_to_table
    #    
    #)
    #copy_csv_to_table = PythonOperator(
    #    task_id='copy_csv_to_table',
    #    python_callable=copy_csv_to_table
    #    
    #)
    #write_df_to_postgres = PythonOperator(
    #    task_id='write_df_to_postgres',
    #    python_callable=write_df_to_postgres,
    #    retries=1,
    #    retry_delay=timedelta(seconds=15))
    

    #scan_finwiz = PythonOperator(
#
    #    task_id = "scan_finwiz",
    #    python_callable = _scan_finwiz
    #)
    
    
    [create_db_table_task, create_db_staging_table_task] >>upload_data_to_postgres_loop >> insert_into_db_table_task