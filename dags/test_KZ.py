import pandas
import inspect

from airflow import DAG
from airflow.operators.python import PythonOperator, BranchPythonOperator
#from airflow.operators.branch_operator import BaseBranchOperator
from airflow.operators.bash import BashOperator

import datetime




def _webdriver_options():
    return inspect.getfile(pandas)


with DAG(dag_id = "scanfile", start_date=datetime.datetime(2021, 1, 1), schedule="@daily", catchup = False) as dag:

    get_webdriver_options_bc = PythonOperator(

        task_id = "get_webdriver_options_bc",
        python_callable = _webdriver_options
    )

    get_webdriver_options_db = PythonOperator(

        task_id = "get_webdriver_options_db",
        python_callable = _webdriver_options
    )

    get_webdriver_options_bc >> get_webdriver_options_db