import pandas
import inspect

from airflow import DAG
from airflow.operators.python import PythonOperator, BranchPythonOperator
#from airflow.operators.branch_operator import BaseBranchOperator
from airflow.operators.bash import BashOperator
import numpy
import datetime




def _webdriver_options():
    print(inspect.getfile(pandas))
    return  inspect.getfile(pandas)

def _webdriver_options_2():
    print(inspect.getfile(pandas))
    return  inspect.getfile(numpy)


def _choose_webdriver_options(ti):

    reu = ti.xcom_pull(task_ids = [get_webdriver_options_bc, get_webdriver_options_db])
    

    return reu


with DAG(dag_id = "test_KZ", start_date=datetime.datetime(2021, 1, 1), schedule="@daily", catchup = False) as dag:

    get_webdriver_options_bc = PythonOperator(

        task_id = "get_webdriver_options_bc",
        python_callable = _webdriver_options
    )

    get_webdriver_options_db = PythonOperator(

        task_id = "get_webdriver_options_db",
        python_callable = _webdriver_options_2
    )

    pathss = BashOperator(

        task_id = "accurate",
        bash_command = "echo 'accurate'"
    )

    get_webdriver_options_bc >> get_webdriver_options_db >>pathss