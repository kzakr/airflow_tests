from airflow import DAG
from datetime import datetime, timedelta
from airflow.operators.python_operator import PythonOperator
from airflow.hooks.base_hook import BaseHook
from py_files.mail_operator import MessageOperator

import pandas as pd

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

def _ml_flow(**kwargs):


    import sys
    import subprocess

    subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'scikit-learn'])

    

# Instantiate the DAG

dag = DAG(

    'ml_pack',
    default_args = default_args,
    description = 'description of your dag',
    schedule_interval = None, #you can set any schedule interval you want.
    catchup = False,
)

ml_flow = PythonOperator(
     task_id = 'ml_flow',
     python_callable = _ml_flow,
     provide_context = True,
     dag = dag
)





