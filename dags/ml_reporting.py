from airflow import DAG
from jinja2 import Template
from datetime import datetime, timedelta
import smtplib
from airflow.utils.email import send_email
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.email_operator import EmailOperator
from airflow.operators.postgres_operator import PostgresOperator
from airflow.hooks.base_hook import BaseHook
from py_files.mail_operator import MessageOperator
from py_files.email_templates.email_template import get_message_body
from py_files.commons import get_time
from py_files.email_templates.message_body import get_statistical_results
from py_files.ml_dataset_prep import get_data_view, get_data_query, get_data_query_validate, get_list_of_ticker_with_count, prepare_df_0, prepare_df_1, get_zscore_difference, get_data_sets
from py_files.postgres_bulk import create_connection, sql_to_dataframe, postgres_bulk
from py_files.models import dt_model, ct_model


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


def _prepare_view():
    get_data_view()

def _get_data_from_view(**kwargs):
    sql_query = get_data_query()
    print(sql_query)
    kwargs["ti"].xcom_push(key='sql_query', value = sql_query)
    
def _get_data_validate_from_view(**kwargs):
    sql_query_validate = get_data_query_validate()
    print(sql_query_validate)
    kwargs["ti"].xcom_push(key='sql_query_validate', value = sql_query_validate)
    


def _prepare_ds(**kwargs):
    
    ti = kwargs['ti']
    sql_query = ti.xcom_pull(task_ids = "get_data_from_view", key='sql_query')
    print(sql_query)
    print("ok")

    df =  sql_to_dataframe( query=sql_query, conn= create_connection())
    
    df = get_zscore_difference(df, interval = 5)
    df.drop(columns = ['z_score_price_twenty_one_day_back',
       'z_score_volume_twenty_one_day_back'], inplace = True)
    df.dropna(inplace = True)
    tickers_list = get_list_of_ticker_with_count(df, 10)
    print(tickers_list)
    df_1 = prepare_df_1(tickers_list, df)
    df_0 = prepare_df_0(tickers_list, df)

    X_train, X_test, y_train, y_test = get_data_sets(df_1, df_0)
    print(X_train.columns)
    print(y_test.count())
    dt = dt_model(X_train, X_test, y_train, y_test)
    ct = ct_model(X_train, X_test, y_train, y_test)
    
    df_1_t = prepare_df_1(tickers_list, df)
    df_0_t = df[df["ticker"].isin(tickers_list)==0]
    df_0_t["category"] = 0
    print("PpPpPp"*34)
    X_train, X_test, y_train, y_test = get_data_sets(df_1_t, df_0_t)
    print(dt.score(X_test,y_test))
    print(ct.score(X_test,y_test))


    #####print validate
    ti = kwargs['ti']
    sql_query_validate = ti.xcom_pull(task_ids = "get_data_validate_from_view", key='sql_query_validate')
    print(sql_query_validate)

    df2 =  sql_to_dataframe( query=sql_query_validate, conn= create_connection())
    
    df2 = get_zscore_difference(df2, interval = 5)
    df2.drop(columns = ['z_score_price_twenty_one_day_back',
       'z_score_volume_twenty_one_day_back'], inplace = True)
    df2.dropna(inplace = True)
    tickers_list = get_list_of_ticker_with_count(df2, 10)
    print(tickers_list)
    df2_1 = prepare_df_1(tickers_list, df2)
    df2_0 = prepare_df_0(tickers_list, df2)

    X_train, X_test, y_train, y_test = get_data_sets(df2_1, df2_0)
    print(dt.score(X_test,y_test))
    print(ct.score(X_test,y_test))





# Instantiate the DAG


dag = DAG(

    'ml_view',
    start_date= datetime(2025, 3, 17),
    default_args = default_args,
    description = 'description of your dag',
    schedule_interval = None, #you can set any schedule interval you want.
    catchup = False,
)

prepare_view = PythonOperator(
     task_id = 'prepare_view',
     python_callable = _prepare_view,
     provide_context = True,
     dag = dag
)
create_view_staging_table_task = PostgresOperator(
        task_id='create_db_staging_tables',
        postgres_conn_id="airflow",
        sql='./sql_scipts/sql_query_check_ml.sql',
        retries=3,
        retry_delay=timedelta(minutes=3),
    )
    
get_data_from_view = PythonOperator(
     task_id = 'get_data_from_view',
     python_callable = _get_data_from_view,
     provide_context = True,
     dag = dag
)

get_data_validate_from_view = PythonOperator(
     task_id = 'get_data_validate_from_view',
     python_callable = _get_data_validate_from_view,
     provide_context = True,
     dag = dag
)

prepare_ds = PythonOperator(
     task_id = 'prepare_ds',
     python_callable = _prepare_ds,
     provide_context = True,
     dag = dag
)

prepare_view>>create_view_staging_table_task>>[get_data_from_view,get_data_validate_from_view]
[get_data_from_view,get_data_validate_from_view]>>prepare_ds


