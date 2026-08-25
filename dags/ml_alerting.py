from airflow import DAG
from datetime import datetime, timedelta
from airflow.operators.python import PythonOperator
from py_files.models import dt_model, ct_model
from py_files.ml_dataset_prep import get_data_sets, prepare_df_0, prepare_df_1,get_list_of_ticker_with_count, get_zscore_difference,get_data_query,get_data_view
from py_files.postgres_bulk import  create_connection
import pandas as pd

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

def _ml_flow(**kwargs):
    get_data_view()
    query = get_data_query()
    conn= create_connection()
    dfr = pd.read_sql(query,con = conn)
    dfr = get_zscore_difference(dfr, interval = 5)
    
    dfr.drop(columns = ['z_score_price_twenty_one_day_back',
       'z_score_volume_twenty_one_day_back'], inplace = True)

    dfr.dropna(inplace = True)
    tickers  = get_list_of_ticker_with_count(dfr)
    dfr1= prepare_df_1(tickers, dfr)
    dfr0= prepare_df_0(tickers, dfr)
    X_train, X_test, y_train, y_test = get_data_sets(dfr1, dfr0)


    dt_model(X_train, X_test, y_train, y_test)
    ct_model(X_train, X_test, y_train, y_test)

# Instantiate the DAG

dag = DAG(

    'aa_ml_test_nl',
    default_args = default_args,
    description = 'description of your dag',
    schedule = None, #you can set any schedule interval you want.
    catchup = False,
)

ml_flow = PythonOperator(
     task_id = 'ml_flow',
     python_callable = _ml_flow,
    
     dag = dag
)





