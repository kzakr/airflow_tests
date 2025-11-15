from airflow import DAG
from airflow.operators.python import PythonOperator, BranchPythonOperator
from airflow.operators.postgres_operator import PostgresOperator
#from airflow.operators.branch_operator import BaseBranchOperator
from airflow.operators.bash import BashOperator
import datetime
from datetime import timedelta
from py_files.get_d2d_indicators import get_raw_data, get_statistical_metrics, get_lagged_data, get_data, get_last_price, get_first_price, join_operator
from py_files.d2d_rules import volume_and_price_declining_3, volume_below_08_average,volume_and_price_raising_3, volume_declining_3, \
    volume_declining_with_multiplicator, volume_price_declining_2, price_declining_3, sql_volume_and_price_declining_3, \
    sql_price_declining_3, sql_volume_and_price_raising_3, sql_volume_below_08_average, sql_volume_declining_3, sql_volume_declining_with_multiplicator, sql_volume_price_declining_2
from py_files.commons import add_column_based_on_confition, types_mapper
from py_files.attr import CommonConditions, JoinOperators
from py_files.postgres_bulk import create_connection, sql_to_dataframe, postgres_bulk



def _add_first_price_validation_data(ti):
    list_of_results = ti.xcom_pull(task_ids = [prepare_set_of_results])
    for result in list_of_results:
        query = join_operator(target = result, source =get_first_price(), columns_to_join = ["first_price"], keys = ["ticker"], join_operator= JoinOperators.Join)

    with open("./dags/sql_scipts/join_first_price.sql", "a") as file:
        file.write(query)

def _add_last_price_validation_data(ti):
    list_of_results = ti.xcom_pull(task_ids = [prepare_set_of_results])
    for result in list_of_results:
        query = join_operator(target = result, source =get_last_price(), columns_to_join = ["last_price"], keys = ["ticker"], join_operator= JoinOperators.Join)

    with open("./dags/sql_scipts/join_last_price.sql", "a") as file:
        file.write(query)


def _return_set_of_rules():
    return ( sql_volume_and_price_declining_3, sql_price_declining_3, sql_volume_and_price_raising_3, sql_volume_declining_3,  sql_volume_price_declining_2, sql_volume_below_08_average)

def _prepare_set_of_results():
    
    print("ok")

    sql_query = get_lagged_data()
    df =  sql_to_dataframe( query=sql_query, conn= create_connection())

    columns_of_df = df.columns.tolist()
    #print("ok1")
    #df_avg = get_statistical_metrics()
    #print("ok2")
    #df = df.merge(df_avg, how ="inner", right_on = "ticker", left_on = "ticker")
    print("ok2")
    #print(df.columns)
    set_of_rules = list(_return_set_of_rules())
    set_of_rules.remove(sql_volume_below_08_average)
    for rule in set_of_rules:

        
        ticker_list = rule(df, "ticker")
        print(rule.__name__)
        df = add_column_based_on_confition(df,rule.__name__, 'ticker', CommonConditions.isin, ticker_list)

    ticker_list = sql_volume_below_08_average(df, "ticker", multiplicator = 0.8)
    print(rule.__name__)
    df = add_column_based_on_confition(df, "sql_volume_below_08_average", 'ticker', CommonConditions.isin, ticker_list)

    dict_of_df ={}
    ti_DataFrame = df
    del df
    ti_DataFrame["base_price"] = 100
    columns_of_df.append("base_price")
    set_of_rules = _return_set_of_rules()

    for rule in set_of_rules:  
        columns_of_df.append(rule.__name__)
        dict_of_df[rule.__name__] = ti_DataFrame[columns_of_df][ti_DataFrame[rule.__name__] =="Y"]
        columns_of_df.remove(rule.__name__)

    rules = list(dict_of_df.keys())
    for rule, df in dict_of_df.items():
        print(df)

        #create_sql_script(rule = rule+"_y_day", DataFrame=df) #one time use for creating table
        postgres_bulk(df, rule+"_y_day",if_exists="replace", engine_conn= create_connection())

    return rules



def _split_results(ti):

    dict_of_df ={}
    ti_DataFrame = ti.xcom_pull(task_ids = [prepare_set_of_results])
    ti_DataFrame["base_price"] = 100
    set_of_rules = _return_set_of_rules()

    for rule in set_of_rules():
        dict_of_df[rule.__name__] = ti_DataFrame[ti_DataFrame[rule.__name__] =="Y"]


    return dict_of_df


def _upload_to_postgres(ti):
    ti_dict_of_df = ti.xcom_pull(task_ids = [split_results])
    for rule, df in ti_dict_of_df.items():
        postgres_bulk(df, rule+"y_day",if_exists="replace", engine_conn= create_connection())

#    #    sql_query = file.read()
#    sql_query = "select * from finviz_result"
#
#    df= sql_to_dataframe(conn= connection, query=sql_query)
#
#    return df

def create_sql_script(rule :str, DataFrame):

    dict_of_types = types_mapper()
    query = "\n"
    
    data_types = DataFrame.dtypes.tolist()
    for i in range(0, len(data_types)):
        if data_types[i] == 'O':
            data_types[i] = "O"
        if data_types[i] == 'int64':
            data_types[i] = 'int64'
        if data_types[i] == 'float':
            data_types[i] = 'float'
    print(data_types)
    cols_and_dtypes = dict(zip(DataFrame.columns,  data_types  ))
    
    query += f"DROP TABLE IF EXISTS {rule};\n"
    query += f"CREATE TABLE  {rule} ("

    for column, type_ in cols_and_dtypes.items():
        query += f"\n\t{column}  {dict_of_types[type_]},"
    query += f");\n\n"   
    query = query.replace(",)",")")


    with open("./dags/sql_scipts/create_analytics_tables.sql", "a") as file:
        file.write(query)


    
    
with DAG(dag_id = "analyze_datasets", start_date=datetime.datetime(2021, 1, 1), schedule="@daily", catchup = False) as dag:

   #get_webdriver_options = PythonOperator(

   #    task_id = "get_webdriver_options",
   #    python_callable = _webdriver_options
   #)
    
    #get_data_postgres = PythonOperator(
    #    task_id='get_data_postgres',
    #    python_callable = _get_data_postgres,
    #    retries=4,
    #    retry_delay=timedelta(minutes=3),
    #
    #)


    create_db_tables_task = PostgresOperator(
        task_id='create_db_tables',
        postgres_conn_id="airflow",
        sql='./sql_scipts/create_analytics_tables.sql',
        retries=3,
        retry_delay=timedelta(minutes=3),
    )
    

    prepare_set_of_results = PythonOperator(
        task_id='prepare_set_of_results',
        python_callable = _prepare_set_of_results,
        retries=4,
        retry_delay=timedelta(minutes=3),

    )

    add_first_price_validation_data = PythonOperator(
        task_id='_add_first_price_validation_data',
        python_callable = _add_first_price_validation_data,
        retries=2,
        retry_delay=timedelta(minutes=3),

    )

    add_last_price_validation_data = PythonOperator(
        task_id='add_last_price_validation_data',
        python_callable = _add_last_price_validation_data,
        retries=2,
        retry_delay=timedelta(minutes=3),

    )

    execute_add_first_price_validation_data = PostgresOperator(
        task_id='create_db_tables',
        postgres_conn_id="airflow",
        sql="./dags/sql_scipts/join_first_price.sql"',
        retries=3,
        retry_delay=timedelta(minutes=3),
    )

    execute_add_last_price_validation_data = PostgresOperator(
        task_id='create_db_tables',
        postgres_conn_id="airflow",
        sql="./dags/sql_scipts/join_first_price.sql",
        retries=3,
        retry_delay=timedelta(minutes=3),
    )

    #split_results = PythonOperator(
    #    task_id='split_results',
    #    python_callable = _split_results,
    #    retries=4,
    #    retry_delay=timedelta(minutes=3),
#
    #)
#
    #upload_to_postgres = PythonOperator(
    #    task_id='upload_to_postgres',
    #    python_callable = _upload_to_postgres,
    #    retries=4,
    #    retry_delay=timedelta(minutes=3),
#
    #)

    #copy_csv_to_table = PythonOperator(
    #    task_id='copy_csv_to_table',
    #    python_callable=copy_csv_to_table
    #    
    #)
    #copy_csv_to_table = PythonOperator(
    #    task_id='copy_csv_to_table',
    #    python_callable=copy_csv_to_table
    #    
    #)
    #write_df_to_postgres = PythonOperator(
    #    task_id='write_df_to_postgres',
    #    python_callable=write_df_to_postgres,
    #    retries=1,
    #    retry_delay=timedelta(seconds=15))
    

    #scan_finwiz = PythonOperator(
#
    #    task_id = "scan_finwiz",
    #    python_callable = _scan_finwiz
    #)
    
    
    create_db_tables_task>>prepare_set_of_results #>>split_results >> upload_to_postgres
    #prepare_set_of_results