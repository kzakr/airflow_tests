from airflow import DAG
from datetime import datetime, timedelta
from airflow.operators.python import PythonOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

from py_files.commons import get_time, get_last_weekday
from py_files.ml_dataset_prep_yahoo import (
    get_data_view,
    get_data_query,
    get_data_validate_view,
    get_data_query_validate,
    get_data_query_predict,
    get_list_of_ticker_with_count,
    prepare_df_0,
    prepare_df_1,
    get_zscore_difference,
    get_data_sets,
)
from py_files.postgres_bulk import create_connection, sql_to_dataframe
from py_files.models import dt_model, ct_model, svm_model, gbc_model
from py_files.logging_utils import get_logger
import os
import pandas as pd

logger = get_logger(__name__)


SQL_SCRIPT_DIR = os.path.join(os.path.dirname(__file__), 'sql_scipts')
SQL_QUERY_FILE = os.path.join(SQL_SCRIPT_DIR, 'sql_query_check_ml_yahoo.sql')
SQL_VALIDATE_FILE = os.path.join(SQL_SCRIPT_DIR, 'sql_query_check_ml_validate_yahoo.sql')
OUTPUT_DIR = os.path.join('/opt/airflow/dags/output_files', 'yahoo')


def ensure_sql_files():
    os.makedirs(SQL_SCRIPT_DIR, exist_ok=True)
    for path in [SQL_QUERY_FILE, SQL_VALIDATE_FILE]:
        if os.path.exists(path):
            os.remove(path)

    for i in range(len(dates_to_train)):
        get_data_view(file_num=i, after_day=dates_to_train[i], interval=_interval)
    get_data_validate_view(after_day=get_last_weekday(format='%Y-%m-%d'), interval=_interval)


def load_sql_file(path: str) -> str:
    if not os.path.exists(path):
        ensure_sql_files()
    if not os.path.exists(path):
        return "-- no sql generated yet"
    with open(path, 'r') as file:
        return file.read()


default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2025, 3, 17),
    'email_on_failure': False,
    'email_on_success': True,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(seconds=5),
}


now, dt_string_with_hour, dt_string = get_time()
dates_to_train = [
    20260603,
    20260604,
    20260610,
    20260612,
    20260615,
    20260619,
    20260718,
    20260720,
    20260710,
    20260724,
    20260725,
    20260730,
    20260731,
    20260805,
]
_interval = 10
cut_offs = [0.1, 1, 1.3, 1.5, 2]
cut_off_model_dict = {}

# Generate the SQL files before Airflow imports the DAG so task SQL can be loaded
# without raising FileNotFoundError during module import.
ensure_sql_files()


def _prepare_view():
    os.makedirs(SQL_SCRIPT_DIR, exist_ok=True)
    for path in [SQL_QUERY_FILE, SQL_VALIDATE_FILE]:
        try:
            if os.path.exists(path):
                os.remove(path)
        except Exception as ex:
            logger.warning("Unable to remove SQL file: %s", ex)

    for i in range(len(dates_to_train)):
        get_data_view(file_num=i, after_day=dates_to_train[i], interval=_interval)
    get_data_validate_view(after_day=get_last_weekday(format='%Y-%m-%d'), interval=_interval)


def _get_data_from_view(**kwargs):
    for i in range(len(dates_to_train)):
        sql_query = get_data_query(table=f'ml_temp_{i}_yahoo')
        kwargs['ti'].xcom_push(key=f'sql_query_{i}', value=sql_query)


def _get_data_validate_from_view(**kwargs):
    sql_query_validate = get_data_query_validate()
    kwargs['ti'].xcom_push(key='sql_query_validate', value=sql_query_validate)


def _get_data_predict_from_view(**kwargs):
    sql_query_predict = get_data_query_predict()
    kwargs['ti'].xcom_push(key='sql_query_predict', value=sql_query_predict)


def _prepare_ds(**kwargs):
    ti = kwargs['ti']
    df = pd.DataFrame()
    df_1_total = pd.DataFrame()
    df_0_total = pd.DataFrame()

    for i in range(len(dates_to_train)):
        sql_query = ti.xcom_pull(task_ids='get_data_from_view', key=f'sql_query_{i}')
        df_tmp_base = sql_to_dataframe(query=sql_query, conn=create_connection())
        if df_tmp_base is None or df_tmp_base.empty:
            continue

        for cut_off in cut_offs:
            df_tmp = get_zscore_difference(df_tmp_base.copy(), interval=_interval)
            for col in ['_date', 'z_score_close_sixty_nine_day_back', 'z_score_volume_seventy_day_back',
                        'z_score_close_fourty_five_day_back', 'z_score_volume_fifty_five_day_back',
                        'fifty_four_fifty_five_difference']:
                if col in df_tmp.columns:
                    df_tmp.drop(columns=[col], inplace=True, errors='ignore')

            if df_tmp.empty:
                continue

            df_tmp.fillna(-99999, inplace=True)
            n_sample1 = min(1000, len(df_tmp))
            df_tmp = df_tmp.sample(n_sample1, random_state=42)

            tickers_list = get_list_of_ticker_with_count(df_tmp, 20, z_score_diff=cut_off)
            if not tickers_list:
                continue

            df_1_tmp = prepare_df_1(tickers_list, df_tmp)
            df_0_tmp = prepare_df_0(tickers_list, df_tmp)
            if not df_1_tmp.empty:
                df_1_total = pd.concat([df_1_total, df_1_tmp], ignore_index=True)
            if not df_0_tmp.empty:
                df_0_total = pd.concat([df_0_total, df_0_tmp], ignore_index=True)

            df_1_total.fillna(-99999, inplace=True)
            df_0_total.fillna(-99999, inplace=True)

            n_sample2 = min(500, len(df_tmp))
            df = pd.concat([df, df_tmp.sample(n_sample2, random_state=42)], ignore_index=True)

            cut_off_model_dict[str(cut_off)] = {
                'positive': df_1_total.copy(),
                'negative': df_0_total.copy(),
            }

    sql_query_validate = ti.xcom_pull(task_ids='get_data_validate_from_view', key='sql_query_validate')
    df2 = sql_to_dataframe(query=sql_query_validate, conn=create_connection())
    if df2 is None or df2.empty:
        logger.warning('No validation data available, skipping validation step.')
        return

    df2 = get_zscore_difference(df2.copy(), interval=_interval)
    for col in ['_date', 'z_score_close_sixty_nine_day_back', 'z_score_volume_seventy_day_back',
                        'z_score_close_fourty_five_day_back', 'z_score_volume_fifty_five_day_back',
                        'fifty_four_fifty_five_difference']:
        if col in df2.columns:
            df2.drop(columns=[col], inplace=True, errors='ignore')
    df2.fillna(-99999, inplace=True)

    sql_query_predict = ti.xcom_pull(task_ids='get_data_predict_from_view', key='sql_query_predict')
    df3 = sql_to_dataframe(query=sql_query_predict, conn=create_connection())
    if df3 is not None and not df3.empty:
        df3 = get_zscore_difference(df3.copy(), interval=_interval)
        for col in ['_date', 'z_score_close_sixty_nine_day_back', 'z_score_volume_seventy_day_back',
                        'z_score_close_fourty_five_day_back', 'z_score_volume_fifty_five_day_back',
                        'fifty_four_fifty_five_difference']:
            if col in df3.columns:
                df3.drop(columns=[col], inplace=True, errors='ignore')
        df3.fillna(-99999, inplace=True)
    else:
        df3 = pd.DataFrame()

    models = {}
    for cut_off in cut_offs:
        model_data = cut_off_model_dict.get(str(cut_off), {})
        df_1 = model_data.get('positive')
        df_0 = model_data.get('negative')

        if df_1 is None or df_0 is None or df_1.empty or df_0.empty:
            print(f'Not enough samples for cut_off {cut_off}, skipping model training')
            continue

        X_train, X_test, y_train, y_test = get_data_sets(df_1, df_0)
        if X_train is None:
            logger.warning('Not enough samples for cut_off %s, skipping model training', cut_off)
            continue

        dt = dt_model(X_train, X_test, y_train, y_test)
        ct = ct_model(X_train, X_test, y_train, y_test)
        svm = svm_model(X_train, X_test, y_train, y_test)
        gbc = gbc_model(X_train, X_test, y_train, y_test)
        models[str(cut_off)] = [dt, ct, svm, gbc]

    if not models:
        logger.warning('No model was trained. Exiting safely.')
        return

    os.makedirs(OUTPUT_DIR, exist_ok=True)
    tickers_list = get_list_of_ticker_with_count(df2, 15, -20)
    if not df2.empty:
        df2 = df2.sample(min(300, len(df2)), random_state=42)
    df2 = df2.drop(columns=['z_score_close', 'z_score_volume', 'volume', 'close'], errors='ignore')
    X_full = df2.copy()
    tickers_to_verify = X_full[['ticker', 'difference']].copy()
    X_full = X_full.drop(columns=['ticker', 'difference'], errors='ignore')

    for cut_off, model in models.items():
        dt, ct, svm, gbc = model
        dictionary_or_results = {
            'dt_pred': dt.predict(X_full).tolist(),
            'gbc_pred': gbc.predict(X_full).tolist(),
            'svm_pred': svm.predict(X_full).tolist(),
            'ct_pred': ct.predict(X_full).tolist(),
        }
        temp_df = pd.DataFrame(dictionary_or_results)
        temp_df.reset_index(drop=True, inplace=True)
        tickers_to_verify.reset_index(drop=True, inplace=True)

        results_df = pd.concat([tickers_to_verify, temp_df], axis=1)
        results_df['difference'] = pd.to_numeric(results_df['difference'], errors='coerce')
        results_df['suma'] = (
            results_df['dt_pred'] + results_df['gbc_pred'] + results_df['svm_pred'] + results_df['ct_pred']
        )

        safe_cut_off = str(cut_off).replace('.', '_')
        results_df.to_csv(os.path.join(OUTPUT_DIR, f'data_to_verify_{dt_string_with_hour}__{safe_cut_off}.csv'), index=False)
        results_df[results_df['suma'] >= 2].to_csv(
            os.path.join(OUTPUT_DIR, f'data4_to_verify_{dt_string_with_hour}__{safe_cut_off}.csv'),
            index=False,
        )

    if not df3.empty:
        df3 = df3.sample(min(300, len(df3)), random_state=42)
        df3 = df3.drop(columns=['z_score_close', 'z_score_volume', 'volume', 'close'], errors='ignore')
        X_pred = df3.copy()
        tickers_to_predict = X_pred[['ticker']].copy()
        X_pred = X_pred.drop(columns=['ticker', 'difference'], errors='ignore')

        for cut_off, model in models.items():
            dt, ct, svm, gbc = model
            dictionary_or_results_predict = {
                'dt_pred': dt.predict(X_pred).tolist(),
                'gbc_pred': gbc.predict(X_pred).tolist(),
                'svm_pred': svm.predict(X_pred).tolist(),
                'ct_pred': ct.predict(X_pred).tolist(),
            }
            temp_pred = pd.DataFrame(dictionary_or_results_predict)
            temp_pred.reset_index(drop=True, inplace=True)
            tickers_to_predict.reset_index(drop=True, inplace=True)
            results_predict = pd.concat([tickers_to_predict, temp_pred], axis=1)
            results_predict['suma'] = (
                results_predict['dt_pred'] + results_predict['gbc_pred'] + results_predict['svm_pred'] + results_predict['ct_pred']
            )
            safe_cut_off = str(cut_off).replace('.', '_')
            results_predict.to_csv(
                os.path.join(OUTPUT_DIR, f'data_to_prdict_{dt_string_with_hour}__{safe_cut_off}.csv'),
                index=False,
            )


# DAG definition

dag = DAG(
    'ml_view_yahoo_safe',
    start_date=datetime(2025, 3, 17),
    default_args=default_args,
    description='Safe Yahoo ML validation/prediction DAG',
    schedule=None,
    catchup=False,
    template_searchpath=[SQL_SCRIPT_DIR],
)

prepare_view = PythonOperator(
    task_id='prepare_view',
    python_callable=_prepare_view,
    dag=dag,
)

create_view_staging_table_task = SQLExecuteQueryOperator(
    task_id='create_db_staging_tables',
    conn_id='airflow',
    sql=load_sql_file(SQL_QUERY_FILE),
    retries=3,
    retry_delay=timedelta(minutes=3),
    dag=dag,
)

create_view_validate_staging_table_task = SQLExecuteQueryOperator(
    task_id='create_db_validate_staging_tables',
    conn_id='airflow',
    sql=load_sql_file(SQL_VALIDATE_FILE),
    retries=3,
    retry_delay=timedelta(minutes=3),
    dag=dag,
)

get_data_from_view = PythonOperator(
    task_id='get_data_from_view',
    python_callable=_get_data_from_view,
    dag=dag,
)

get_data_validate_from_view = PythonOperator(
    task_id='get_data_validate_from_view',
    python_callable=_get_data_validate_from_view,
    dag=dag,
)

get_data_predict_from_view = PythonOperator(
    task_id='get_data_predict_from_view',
    python_callable=_get_data_predict_from_view,
    dag=dag,
)

prepare_ds = PythonOperator(
    task_id='prepare_ds',
    python_callable=_prepare_ds,
    dag=dag,
)

prepare_view >> [create_view_staging_table_task, create_view_validate_staging_table_task]
create_view_staging_table_task >> get_data_from_view
create_view_validate_staging_table_task >> get_data_validate_from_view >> get_data_predict_from_view
[get_data_from_view, get_data_validate_from_view, get_data_predict_from_view] >> prepare_ds
