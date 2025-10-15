import pandas
import inspect

from airflow import DAG
from airflow.operators.python import PythonOperator, BranchPythonOperator
#from airflow.operators.branch_operator import BaseBranchOperator
from airflow.operators.bash import BashOperator
from airflow.operators.selenium_plugin import SeleniumOperator
import datetime




def _webdriver_options():
    return inspect.getfile(pandas)


with DAG(dag_id = "scanfile", start_date=datetime.datetime(2021, 1, 1), schedule="@daily", catchup = False) as dag:

    get_webdriver_options_b = PythonOperator(

        task_id = "get_webdriver_options_b",
        python_callable = _webdriver_options
    )

    get_webdriver_options_b = PythonOperator(

        task_id = "get_webdriver_options_b",
        python_callable = _webdriver_options
    )