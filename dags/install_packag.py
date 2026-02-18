import sys
import os
from pathlib import Path

from airflow import DAG
from airflow.operators.python import PythonOperator, BranchPythonOperator

#from airflow.operators.branch_operator import BaseBranchOperator

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