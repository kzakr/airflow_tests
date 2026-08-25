from airflow import DAG
from datetime import datetime, timedelta

from airflow.operators.python import PythonOperator
from airflow.hooks.base import BaseHook
from airflow.sensors.external_task import ExternalTaskSensor
from py_files.mail_operator import MessageOperator
from py_files.commons import get_time, list_in_directory
from py_files.email_templates.message_body import get_ml_results

results_path= r"/opt/airflow/dags/output_files/"
connection = BaseHook.get_connection("email_conn")
slack_token = connection.password
connection_user = connection.login
now, dt_string_with_hour, dt_string = get_time()
subject = f"bajojoajp {dt_string}"
ml_resultes = list_in_directory(results_path, f"data4_to_verify_{dt_string}")
print("data4_to_verify")
print(ml_resultes)

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2025, 3, 17),
    'email_on_failure': False,
    'email_on_success': True,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(seconds=5)
}

def prepare_message(**kwargs):
    ti = kwargs['ti']
    list_of_results = ti.xcom_pull(task_ids = "prepare_set_of_results_task ", key='pass_rules')
    print(list_of_results)
    email_message = MessageOperator(sender_email = connection_user, password = slack_token)
    session =  email_message.initialize_session()
    email_message.bulid_base_msg()
    email_message.get_sender()
    email_message.create_recepient_list(("kzakrzewski17@gmail.com"))
    email_message.get_subject(subject)
    email_message.get_body(get_ml_results(ml_resultes))
    email_message.release_message(session)


# Instantiate the DAG

dag = DAG(

    'email_distribution_ml',
    default_args = default_args,
    description = 'description of your dag',
    schedule = None, #you can set any schedule interval you want.
    catchup = False,
)

task1 = PythonOperator(
     task_id = 'execute_python_command',
     python_callable = prepare_message,
    
     dag = dag
)

#wait_for_upload = ExternalTaskSensor(
#    task_id='wait_for_upload',
#    external_dag_id='ml_view_2',
#    external_task_id='prepare_ds',
#    start_date=datetime(2025, 4, 29),
#    execution_delta=timedelta(minutes=45),
#    timeout=2,
#)

_=task1
