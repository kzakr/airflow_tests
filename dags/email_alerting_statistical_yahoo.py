from airflow import DAG
from jinja2 import Template
from datetime import datetime, timedelta
import smtplib
from airflow.utils.email import send_email
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.email_operator import EmailOperator
from airflow.hooks.base_hook import BaseHook
from airflow.sensors.external_task import ExternalTaskSensor
from py_files.mail_operator import MessageOperator
from py_files.email_templates.email_template import get_message_body
from py_files.commons import get_time
from py_files.email_templates.message_body import get_statistical_results_2

connection = BaseHook.get_connection("email_conn")
slack_token = connection.password
connection_user = connection.login
now, dt_string_with_hour, dt_string = get_time()
subject = f"test {dt_string}"


default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2026, 2, 1),
    'schedule_interval' : 'None',
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
    email_message.get_body(get_statistical_results_2(table="statistical_results_yahoo"))
    email_message.release_message(session)

#def prepare_message_2(**kwargs):
#    ti = kwargs['ti']
#    list_of_results = ti.xcom_pull(task_ids = "prepare_set_of_results_task ", key='pass_rules')
#    print(list_of_results)
#    email_message = MessageOperator(sender_email = connection_user, password = slack_token)
#    session =  email_message.initialize_session()
#    email_message.bulid_base_msg()
#    email_message.get_sender()
#    email_message.create_recepient_list(("dzimacki@gmail.com"))
#    email_message.get_subject(subject)
#    email_message.get_body(get_statistical_results_2(table="statistical_results_yahoo"))
#    email_message.release_message(session)
#

# Instantiate the DAG

dag = DAG(

    'email_distribution_statistical_yahoo',
    default_args = default_args,
    description = 'description of your dag',
    schedule_interval = None, #you can set any schedule interval you want.
    catchup = False,
)

wait_for_statistical = ExternalTaskSensor(
    task_id='wait_for_statistical_results',
    external_dag_id='statistical_view_yahoo',
    external_task_id='finish_statistical_workflow',
    timeout=86400,
    mode='reschedule',
    dag=dag,
)

task1 = PythonOperator(
     task_id = 'statistical_results',
     python_callable = prepare_message,
     provide_context = True,
     dag = dag
)
#task2 = PythonOperator(
#     task_id = 'statistical_results_2',
#     python_callable = prepare_message_2,
#     provide_context = True,
#     dag = dag
#)

#wait_for_upload_inc = ExternalTaskSensor(
#    task_id='wait_for_upload_inc',
#    external_dag_id='statistical_view',
#    external_task_id='insert_values_inc',
#    start_date=datetime(2025, 4, 29),
#    execution_delta=timedelta(minutes=45),
#    timeout=2,
#)
#
#wait_for_upload_dec = ExternalTaskSensor(
#    task_id='wait_for_upload_dec',
#    external_dag_id='statistical_view',
#    external_task_id='insert_values_dec',
#    start_date=datetime(2025, 4, 29),
#    execution_delta=timedelta(minutes=45),
#    timeout=2,
#)

wait_for_statistical >> task1

