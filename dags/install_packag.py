import sys
import os
from pathlib import Path

from airflow import DAG
from airflow.operators.python import PythonOperator, BranchPythonOperator
from airflow.operators.postgres_operator import PostgresOperator
#from airflow.operators.branch_operator import BaseBranchOperator
from airflow.operators.bash import BashOperator
import datetime
from datetime import timedelta
from py_files.get_d2d_indicators import get_raw_data, get_lagged_data, get_data, get_last_price, get_first_price, join_operator, sql_merge_operator
from py_files.d2d_rules import volume_and_price_declining_3, volume_below_08_average,volume_and_price_raising_3, volume_declining_3, \
    volume_declining_with_multiplicator, volume_price_declining_2, price_declining_3, sql_volume_and_price_declining_3, \
    sql_price_declining_3, sql_volume_and_price_raising_3, sql_volume_below_08_average, sql_volume_declining_3, sql_volume_declining_with_multiplicator, sql_volume_price_declining_2
from py_files.commons import add_column_based_on_confition, types_mapper
from py_files.attr import CommonConditions, JoinOperators
from py_files.postgres_bulk import create_connection, sql_to_dataframe, postgres_bulk
from airflow.operators.email_operator import EmailOperator
from airflow.hooks.base_hook import BaseHook



import datetime
from datetime import timedelta

from airflow import DAG
from airflow.operators.python import PythonOperator, BranchPythonOperator

def _install_package(**kwargs):

    import sys
    import subprocess

    subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'scikit-learn'])
    subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'matplotlib'])

    

   
with DAG(dag_id = "package", start_date=datetime.datetime(2025, 1, 1), schedule="30 22 * * 1-5", catchup = False) as dag:

    install_package = PythonOperator(
        task_id='install_package',
        python_callable = _install_package,
        retries=2,
        retry_delay=timedelta(minutes=2),

    )
    install_package