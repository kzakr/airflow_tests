from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.branch_operator import BaseBranchOperator
from airflow.operators.bash import BashOperator
import datetime



def _webdriver_options():
    return "hello world"

def _choose_webdriver_options(ti):

    reu = ti.xcom_pull(task_ids = [get_webdriver_options, get_webdriver_options_a, get_webdriver_options_b])
    max(reu)
    if (message == "hello world"):
        return accurate
    return inacurate


with DAG(dag_id = "scanfile", start_date=datetime.datetime(2021, 1, 1), schedule="@daily", catchup = False) as dag:

    get_webdriver_options = PythonOperator(

        task_id = "get_webdriver_options",
        python_callable = _webdriver_options
    )
    
    get_webdriver_options_a = PythonOperator(

        task_id = "get_webdriver_options_a",
        python_callable = _webdriver_options
    )

    get_webdriver_options_b = PythonOperator(

        task_id = "get_webdriver_options_b",
        python_callable = _webdriver_options
    )
    csss = BaseBranchOperator(

        task_id = "csss",
        python_callable = _choose_webdriver_options
    )

    accurate = BashOperator(

        task_id = "accurate",
        bash_command = "echo 'accurate'"
    )
    inaccurate = BashOperator(

        task_id = "inaccurate",
        bash_command = "echo 'inaccurate'"
    )
    
    [get_webdriver_options, get_webdriver_options_a, get_webdriver_options_b]>>csss>>[accurate, inaccurate]