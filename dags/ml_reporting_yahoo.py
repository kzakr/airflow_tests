from airflow import DAG
from datetime import datetime, timedelta
from airflow.operators.python import PythonOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

from py_files.commons import get_time, get_last_weekday

from py_files.ml_dataset_prep_yahoo import get_data_view, get_data_query,\
     get_data_validate_view, get_data_query_validate, get_list_of_ticker_with_count, \
        prepare_df_0, prepare_df_1, get_zscore_difference, get_data_sets
from py_files.postgres_bulk import create_connection, sql_to_dataframe
from py_files.models import dt_model, ct_model, svm_model, gbc_model
from py_files.logging_utils import get_logger
import pandas as pd
import os

logger = get_logger(__name__)

SQL_SCRIPT_DIR = os.path.join(os.path.dirname(__file__), 'sql_scipts')
SQL_QUERY_FILE = os.path.join(SQL_SCRIPT_DIR, 'sql_query_check_ml_yahoo.sql')
SQL_VALIDATE_FILE = os.path.join(SQL_SCRIPT_DIR, 'sql_query_check_ml_validate_yahoo.sql')


def ensure_sql_files():
    os.makedirs(SQL_SCRIPT_DIR, exist_ok=True)
    if os.path.exists(SQL_QUERY_FILE):
        os.remove(SQL_QUERY_FILE)
    for i in range(len(dates_to_train)):
        get_data_view(file_num=i, after_day=dates_to_train[i], interval=_interval)
    get_data_validate_view(after_day = get_last_weekday(format="%Y-%m-%d"), interval = _interval)


def load_sql_file(path: str) -> str:
    if not os.path.exists(path):
        ensure_sql_files()
    with open(path, 'r') as f:
        return f.read()


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

now, dt_string_with_hour, dt_string = get_time()
dates_to_train = [ #20251117, 20251130, 20251201, 20251205
                    #  , 20251208 , 20251212, 20251217,20251230
                   #   , 20260102, 20260106, 20260107, 20260109, 
                   #  20260112,
                    20260603
                    , 20260604, 20260610, 20260612,  20260615, 20260617
                      , 20260619, 20260701, 20260703, 20260706, 20260708, 20260710,
                      20260714 , 20260715 ,20260718, 20260720, 20260710,
                     # 20260303,20260305,20260310,
                      20260724,20260725,20260730,
                    20260731,20260805]
_interval = 10

cut_offs = [0.1, 1, 1.3, 1.5,2]
    
cut_off_model_dict = {}

def _prepare_view():
    sql_path = os.path.join(os.path.dirname(__file__), "sql_scipts", "sql_query_check_ml_yahoo.sql")
    try:
        os.remove(sql_path)
    except Exception as ex:
        logger.warning("Unable to remove SQL file: %s", ex)
    for i in range(0,len(dates_to_train)):
        get_data_view(file_num=i, after_day=dates_to_train[i], interval = _interval)
    get_data_validate_view(after_day = get_last_weekday(format="%Y-%m-%d"  ), interval = _interval)

def _get_data_from_view(**kwargs):
    for i in range(0,len(dates_to_train)):
        sql_query = get_data_query(table=f"ml_temp_{i}_yahoo")
        kwargs["ti"].xcom_push(key=f'sql_query_{i}', value = sql_query)



        
def _get_data_validate_from_view(**kwargs):
    sql_query_validate = get_data_query_validate()
    kwargs["ti"].xcom_push(key='sql_query_validate', value = sql_query_validate)
    


def _prepare_ds(**kwargs):
    
    ti = kwargs['ti']
    df = pd.DataFrame()
    df_1 = pd.DataFrame()
    df_0 = pd.DataFrame()
    
    for i in range(0,len(dates_to_train)):
        sql_query = ti.xcom_pull(task_ids = "get_data_from_view", key=f'sql_query_{i}')
        
        df_tmp_base =  sql_to_dataframe( query=sql_query, conn= create_connection())
        
        for cut_off in cut_offs:

            df_tmp = get_zscore_difference(df_tmp_base, interval = _interval)
            logger.debug("Prepared z-score slice for cutoff processing with %s rows", len(df_tmp))
            try:
                df_tmp.drop(columns = ["_date"], inplace = True)
            except Exception:
                logger.debug("No _date column to drop in Yahoo training slice")

            try:
                df_tmp.drop(columns = ['z_score_close_sixty_nine_day_back',
                    'z_score_volume_seventy_day_back'], inplace = True)
            except Exception:
                logger.debug("Skipped removal of z-score close/volume back columns")
            try:
                df_tmp.drop(columns = ['z_score_close_fourty_five_day_back',
                    'z_score_volume_fifty_five_day_back',
                    "fifty_four_fifty_five_difference"], inplace = True)
            except Exception:
                logger.debug("Skipped removal of additional Yahoo z-score columns")
            #df.dropna(inplace = True)
            df_tmp.fillna( -99999,inplace = True)

            if df_tmp.empty:
                # nothing to sample or process for this date/cutoff
                continue
            n_sample1 = min(1000, len(df_tmp))
            df_tmp = df_tmp.sample(n_sample1, random_state=42)


      
            tickers_list = get_list_of_ticker_with_count(df_tmp, 20, z_score_diff = cut_off)
            df_1_tmp = prepare_df_1(tickers_list, df_tmp)
            df_0_tmp = prepare_df_0(tickers_list, df_tmp)
            df_1 = pd.concat([df_1, df_1_tmp])
            df_0 = pd.concat([df_0, df_0_tmp])
            df_1.fillna( -99999,inplace = True)
            df_0.fillna( -99999,inplace = True)
            n_sample2 = min(500, len(df_tmp))
            df= pd.concat([df, df_tmp.sample(n_sample2, random_state=42)])

            
            cut_off_model_dict[str(cut_off)]  = {"positive": df_1, "negative": df_0}


    ############
    ti = kwargs['ti']
    sql_query_validate = ti.xcom_pull(task_ids = "get_data_validate_from_view", key='sql_query_validate')


    df2 =  sql_to_dataframe( query=sql_query_validate, conn= create_connection())
    
    df2 = get_zscore_difference(df2, interval = _interval)
    try:
        df2.drop(columns = ['_date'], inplace = True)
    except Exception:
        logger.debug("No _date column to drop in Yahoo validation data")

    try:
        df2.drop(columns = ['z_score_close_sixty_nine_day_back',
            'z_score_volume_seventy_day_back'], inplace = True)
    except Exception:
        logger.debug("Skipped removal of Yahoo validation z-score columns")
    try:
        df2.drop(columns = ['z_score_close_fourty_five_day_back',
            'z_score_volume_fifty_five_day_back'], inplace = True)
    except Exception:
        logger.debug("Skipped removal of Yahoo validation extra z-score columns")
    nan_cols = [i for i in df2.columns if df2[i].isnull().any()]
    #df2.dropna(inplace = True)
    df2.fillna( -99999,inplace = True)
    
    ############

    models = {}

    for cut_off in cut_offs:

        df_1 = cut_off_model_dict[str(cut_off)]["positive"]
        df_0 = cut_off_model_dict[str(cut_off)]["negative"]
        X_train, X_test, y_train, y_test = get_data_sets(df_1, df_0)
        if X_train is None:
            logger.warning("Not enough samples for cut_off %s, skipping model training", cut_off)
            continue

        # write column names and their dtypes to help debugging
        with open("./dags/sql_scipts/df_cols.txt", "w") as file:
            for col in X_train.columns.tolist():
                file.write(f"\n {col}: {X_train[col].dtype}")

        dt = dt_model(X_train, X_test, y_train, y_test)
        ct = ct_model(X_train, X_test, y_train, y_test)
        svm = svm_model(X_train, X_test, y_train, y_test)
        gbc = gbc_model(X_train, X_test, y_train, y_test)

        df_1_t = prepare_df_1(tickers_list, df)
        df_0_t = df[df["ticker"].isin(tickers_list)==0]
        df_0_t["category"] = 0


        X_train2, X_test2, y_train2, y_test2 = get_data_sets(df_1_t, df_0_t)
        if X_train2 is not None:
            logger.info("Yahoo model evaluation for cut_off %s: DT=%s, CT=%s, SVM=%s, GBC=%s",
                        cut_off,
                        dt.score(X_test2, y_test2),
                        ct.score(X_test2, y_test2),
                        svm.score(X_test2, y_test2),
                        gbc.score(X_test2, y_test2))
        else:
            logger.warning("Not enough samples to evaluate models for cut_off %s", cut_off)

        models[str(cut_off)]= [dt, ct, svm, gbc]


    #####print validate

    tickers_list = get_list_of_ticker_with_count(df2, 15, -20)
    
    if df2.empty:
        logger.warning("No validation rows (df2) available, skipping validation/prediction step")
        return

    df2 = df2.sample(min(300, len(df2)), random_state=42)
    df2.drop(columns = [ "z_score_close", 
    "z_score_volume", "volume", "close"], inplace = True, errors='ignore')
    X_full = df2
    tickers_to_verify = X_full[["ticker", "difference"]]
    X_full.drop(columns = ["ticker",  "difference"], inplace = True, errors='ignore')


    for cut_off, model in models.items():
        dt = model[0]
        ct = model[1]
        svm = model[2]
        gbc = model[3]
        logger.info("Predictions for Yahoo cutoff %s: DT=%s, SVM=%s", cut_off, sum(dt.predict(X_full).tolist()), sum(svm.predict(X_full).tolist()))
        dictionary_or_results = { "dt_pred": dt.predict(X_full).tolist() \
            , "gbc_pred": gbc.predict(X_full).tolist(), "svm_pred": svm.predict(X_full).tolist(),\
               "ct_pred": ct.predict(X_full).tolist() }
        temp_df= pd.DataFrame(dictionary_or_results)

        temp_df.reset_index(inplace=True)
        temp_df.drop(columns=["index"], inplace = True)
        tickers_to_verify.reset_index(inplace=True)
        tickers_to_verify.drop(columns=["index"], inplace = True)

        results_df  = pd.concat([tickers_to_verify, temp_df], axis = 1)
        results_df["difference"] = results_df["difference"].astype(float)
        results_df["suma"] = results_df["dt_pred"]+results_df["gbc_pred"]+results_df["svm_pred"]+results_df["ct_pred"]

        results_df.to_csv(f"/opt/airflow/dags/output_files/yahoo/data_to_verify_{dt_string_with_hour}__{cut_off}.csv", index = False)
        cut_off = cut_off.replace(".","_")
        results_df[results_df["suma"]>=2].to_csv(f"/opt/airflow/dags/output_files/yahoo/data4_to_verify_{dt_string_with_hour}__{cut_off}.csv", index = False)




    





# Instantiate the DAG


dag = DAG(

    'ml_view_yahoo',
    start_date= datetime(2025, 3, 17),
    default_args = default_args,
    description = 'ml_view_yahoo',
    schedule = None, #you can set any schedule interval you want.
    catchup = False,
    template_searchpath=[os.path.join(os.path.dirname(__file__), 'sql_scipts')],
)

prepare_view = PythonOperator(
     task_id = 'prepare_view',
     python_callable = _prepare_view,
    
     dag = dag
)
create_view_staging_table_task = SQLExecuteQueryOperator(
        task_id='create_db_staging_tables',
        conn_id="airflow",
        sql=load_sql_file(SQL_QUERY_FILE),
        retries=3,
        retry_delay=timedelta(minutes=3),
    )
    

create_view_validate_staging_table_task = SQLExecuteQueryOperator(
        task_id='create_db_validate_staging_tables',
        conn_id="airflow",
        sql=load_sql_file(SQL_VALIDATE_FILE),
        retries=3,
        retry_delay=timedelta(minutes=3),
    )
get_data_from_view = PythonOperator(
     task_id = 'get_data_from_view',
     python_callable = _get_data_from_view,
    
     dag = dag
)


get_data_validate_from_view = PythonOperator(
     task_id = 'get_data_validate_from_view',
     python_callable = _get_data_validate_from_view,
    
     dag = dag
)

prepare_ds = PythonOperator(
     task_id = 'prepare_ds',
     python_callable = _prepare_ds,
    
     dag = dag
)

prepare_view>>[create_view_staging_table_task, create_view_validate_staging_table_task]
create_view_staging_table_task>>get_data_from_view

create_view_validate_staging_table_task>>get_data_validate_from_view
[get_data_from_view, get_data_validate_from_view]>>prepare_ds


