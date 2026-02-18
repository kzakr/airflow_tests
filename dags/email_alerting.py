from airflow import DAG
from datetime import datetime, timedelta
import smtplib
from airflow.hooks.base_hook import BaseHook
from py_files.mail_operator import MessageOperator
from py_files.commons import get_time
from py_files.email_templates.message_body import get_statistical_results

connection = BaseHook.get_connection("email_conn")
slack_token = connection.password
connection_user = connection.login
now, dt_string_with_hour, dt_string = get_time()
subject = f"bajojoajp {dt_string}"


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
    email_message.get_body(get_statistical_results(list_of_results))
    email_message.release_message(session)


# Instantiate the DAG

dag = DAG(

    'email_distribution',
    default_args = default_args,
    description = 'description of your dag',
    schedule_interval = None, #you can set any schedule interval you want.
    catchup = False,
)





