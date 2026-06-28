from airflow import DAG
from datetime import datetime, timedelta
from airflow.operators.python_operator import PythonOperator
from airflow.operators.postgres_operator import PostgresOperator

from py_files.commons import get_time, get_last_weekday

from py_files.ml_dataset_prep_yahoo import get_data_view, get_data_query,\
     get_data_validate_view, get_data_query_validate, get_list_of_ticker_with_count, \
        prepare_df_0, prepare_df_1, get_zscore_difference, get_data_sets
from py_files.postgres_bulk import create_connection, sql_to_dataframe
from py_files.models import dt_model, ct_model, svm_model, gbc_model
import pandas as pd
import os


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

now, dt_string_with_hour, dt_string = get_time()
dates_to_train = [ #20251117, 20251130, 20251201, 20251205
                    #  , 20251208 , 20251212, 20251217,20251230
                   #   , 20260102, 20260106, 20260107, 20260109, 
                   #  20260112,
                    20260115
                      , 20260120, 20260218, 20260220, #20260224, 20260226, 20260227,
                     # 20260303,20260305,20260310,
                      20260311,20260313,20260323,
                    20260325,20260425]
_interval = 10

cut_offs = [1, 1.3, 1.5,2]
    
cut_off_model_dict = {}

def _prepare_view():
    try:
        os.remove("./dags/sql_scipts/sql_query_check_ml_yahoo.sql")
    except Exception as ex:
        print(ex)
    for i in range(0,len(dates_to_train)):
        get_data_view(file_num=i, after_day=dates_to_train[i], interval = _interval)
    get_data_validate_view(after_day = get_last_weekday(), interval = _interval)

def _get_data_from_view(**kwargs):
    for i in range(0,len(dates_to_train)):
        sql_query = get_data_query(table=f"ml_temp_{i}")
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
            try:
                df_tmp.drop(columns = ['z_score_price_sixty_nine_day_back',
                    'z_score_volume_seventy_day_back'], inplace = True)
            except:
                print("cos")
            try:
                df_tmp.drop(columns = ['z_score_price_fourty_five_day_back',
                    'z_score_volume_fifty_five_day_back'], inplace = True)
            except:
                print("cos")
            #df.dropna(inplace = True)
            df_tmp.fillna( -99999,inplace = True)
            df_tmp = df_tmp.sample(1000)
      
            tickers_list = get_list_of_ticker_with_count(df_tmp, 20, z_score_diff = cut_off)
            df_1_tmp = prepare_df_1(tickers_list, df_tmp)
            df_0_tmp = prepare_df_0(tickers_list, df_tmp)
            df_1 = pd.concat([df_1, df_1_tmp])
            df_0 = pd.concat([df_0, df_0_tmp])
            df_1.fillna( -99999,inplace = True)
            df_0.fillna( -99999,inplace = True)
            df= pd.concat([df, df_tmp.sample(3000)])

            
            cut_off_model_dict[str(cut_off)]  = {"positive": df_1, "negative": df_0}

    
    #vailidate
    ############
    ti = kwargs['ti']
    sql_query_validate = ti.xcom_pull(task_ids = "get_data_validate_from_view", key='sql_query_validate')


    df2 =  sql_to_dataframe( query=sql_query_validate, conn= create_connection())
    
    df2 = get_zscore_difference(df2, interval = _interval)
    try:
        df2.drop(columns = ['z_score_price_sixty_nine_day_back',
            'z_score_volume_seventy_day_back'], inplace = True)
    except:
        print("cos")
    try:
        df2.drop(columns = ['z_score_price_fourty_five_day_back',
            'z_score_volume_fifty_five_day_back'], inplace = True)
    except:
        print("cos")
    nan_cols = [i for i in df2.columns if df2[i].isnull().any()]
    #df2.dropna(inplace = True)
    df2.fillna( -99999,inplace = True)
    
    ############

    models = {}

    for cut_off in cut_offs:
        
        df_1 = cut_off_model_dict[str(cut_off)]["positive"]
        df_0 = cut_off_model_dict[str(cut_off)]["negative"]
        X_train, X_test, y_train, y_test = get_data_sets(df_1, df_0)

        dt = dt_model(X_train, X_test, y_train, y_test)
        ct = ct_model(X_train, X_test, y_train, y_test)
        svm = svm_model(X_train, X_test, y_train, y_test)
        gbc = gbc_model(X_train, X_test, y_train, y_test)

        df_1_t = prepare_df_1(tickers_list, df)
        df_0_t = df[df["ticker"].isin(tickers_list)==0]
        df_0_t["category"] = 0
 
        with open("./dags/sql_scipts/df_cols.txt", "w") as file:
            for tt in df_1_t.columns.tolist():
                file.write("\n "+ tt)
        print(df_1_t.columns.tolist())
        X_train, X_test, y_train, y_test = get_data_sets(df_1_t, df_0_t)
        print(dt.score(X_test,y_test))
        print(ct.score(X_test,y_test))
        print(svm.score(X_test,y_test))
        print(gbc.score(X_test,y_test))
        models[str(cut_off)]= [dt, ct, svm, gbc]


    #####print validate

    tickers_list = get_list_of_ticker_with_count(df2, 15, -20)
    
    df2 = df2.sample(500)
    df2.drop(columns = [ "z_score_price", 
    "z_score_volume", "volume", "price"], inplace = True)
    X_full = df2
    tickers_to_verify = X_full[["ticker", "difference"]]
    X_full.drop(columns = ["ticker",  "difference"], inplace = True)

    for cut_off, model in models.items():
        dt = model[0]
        ct = model[1]
        svm = model[2]
        gbc = model[3]
        print("-"*111)
        print(len(dt.predict(X_full).tolist()))
        print(sum(dt.predict(X_full).tolist()))
        print(dt.predict(X_full).tolist())
        print("-"*111)
        print(len(svm.predict(X_full).tolist()))
        print(sum(svm.predict(X_full).tolist()))
        print(svm.predict(X_full).tolist())
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
        results_df[results_df["suma"]>=4].to_csv(f"/opt/airflow/dags/output_files/yahoo/data4_to_verify_{dt_string_with_hour}__{cut_off}.csv", index = False)




    





# Instantiate the DAG


dag = DAG(

    'ml_view_yahoo',
    start_date= datetime(2025, 3, 17),
    default_args = default_args,
    description = 'ml_view_yahoo',
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
        sql='./sql_scipts/sql_query_check_ml_yahoo.sql',
        retries=3,
        retry_delay=timedelta(minutes=3),
    )
    

create_view_validate_staging_table_task = PostgresOperator(
        task_id='create_db_validate_staging_tables',
        postgres_conn_id="airflow",
        sql='./sql_scipts/sql_query_check_ml_validate_yahoo.sql',
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

prepare_view>>[create_view_staging_table_task, create_view_validate_staging_table_task]
create_view_staging_table_task>>get_data_from_view

create_view_validate_staging_table_task>>get_data_validate_from_view
[get_data_from_view, get_data_validate_from_view]>>prepare_ds


