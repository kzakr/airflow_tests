from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
#from airflow.operators.branch_operator import BaseBranchOperator

import datetime
from datetime import timedelta
from py_files.get_d2d_indicators import get_lagged_data,get_last_price, get_first_price,sql_merge_operator
from py_files.d2d_rules import sql_volume_and_price_declining_3, \
    sql_price_declining_3, sql_volume_and_price_raising_3, sql_volume_below_08_average, sql_volume_declining_3, sql_volume_price_declining_2
from py_files.commons import add_column_based_on_confition, types_mapper
from py_files.attr import CommonConditions
from py_files.postgres_bulk import create_connection, sql_to_dataframe, postgres_bulk

from airflow.hooks.base import BaseHook
from py_files.commons import get_time
from py_files.mail_operator import MessageOperator
from py_files.email_templates.message_body import get_statistical_results




connection = BaseHook.get_connection("email_conn")
slack_token = connection.password
connection_user = connection.login
now, dt_string_with_hour, dt_string = get_time()
subject = f"bajojoajp {dt_string}"

def prepare_message(**kwargs):
    ti = kwargs['ti']
    list_of_results = ti.xcom_pull(task_ids = "prepare_set_of_results_task", key='pass_rules')
    print(list_of_results)
    email_message = MessageOperator(sender_email = connection_user, password = slack_token)
    session =  email_message.initialize_session()
    email_message.bulid_base_msg()
    email_message.get_sender()
    email_message.create_recepient_list(("kzakrzewski17@gmail.com"))
    email_message.get_subject(subject)
    email_message.get_body(get_statistical_results(list_of_results))
    email_message.release_message(session)    

def _add_first_price_validation_data(**kwargs):
    with open("./dags/sql_scipts/join_first_price.sql", "w") as file:
        ti = kwargs['ti']
        list_of_results = ti.xcom_pull(task_ids = "prepare_set_of_results_task", key='pass_rules')
        print("###"*34)
        print(list_of_results)
        for result in list_of_results:
            query = sql_merge_operator(target = result+"_yday", source =get_first_price(), columns_to_merge = ["first_price"], keys = ["ticker"])

    
            file.write(query)

def _add_last_price_validation_data(**kwargs):
    with open("./dags/sql_scipts/join_last_price.sql", "w") as file:
        ti = kwargs['ti']
        list_of_results = ti.xcom_pull(task_ids = "prepare_set_of_results_task", key='pass_rules')
        for result in list_of_results:
            query = sql_merge_operator(target = result+"_yday", source =get_last_price(), columns_to_merge = ["last_price"], keys = ["ticker"])

    
            file.write(query)


def _return_set_of_rules():
    return ( sql_volume_and_price_declining_3, sql_price_declining_3, sql_volume_and_price_raising_3, sql_volume_declining_3,  sql_volume_price_declining_2, sql_volume_below_08_average)

def _prepare_set_of_results(**kwargs):
    
    print("ok")

    sql_query = get_lagged_data()
    with open("./dags/sql_scipts/sql_query_check.sql", "a") as file:
        file.write(sql_query)
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

        #create_sql_script(rule = rule+"_yday", DataFrame=df) #one time use for creating table
        postgres_bulk(df, rule+"_yday",if_exists="replace", engine_conn= create_connection())
    kwargs["ti"].xcom_push(key='pass_rules', value = rules)



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
    cols_and_dtypes = dict(zip(DataFrame.columns,  data_types  ))
    
    query += f"DROP TABLE IF EXISTS {rule};\n"
    query += f"CREATE TABLE  {rule} ("

    for column, type_ in cols_and_dtypes.items():
        query += f"\n\t{column}  {dict_of_types[type_]},"
    query += f");\n\n"   
    query = query.replace(",)",")")
    print()


    with open("./dags/sql_scipts/create_analytics_tables.sql", "a") as file:
        file.write(query)


    
    
with DAG(dag_id = "analyze_datasets", start_date=datetime.datetime(2020, 1, 1), schedule="45 22 * * 1-5", catchup = False) as dag:

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


    create_db_tables_task_task = SQLExecuteQueryOperator(
        task_id='create_db_tables_task',
        conn_id="airflow",
        sql='./sql_scipts/create_analytics_tables.sql',
        retries=3,
        retry_delay=timedelta(minutes=3),
    )
    

    prepare_set_of_results_task = PythonOperator(
        task_id='prepare_set_of_results_task',
        python_callable = _prepare_set_of_results,
        retries=4,
        retry_delay=timedelta(minutes=3),

    )

    add_first_price_validation_data_task = PythonOperator(
        task_id='add_first_price_validation_data_task',
        python_callable = _add_first_price_validation_data,
        retries=2,
        retry_delay=timedelta(minutes=3),


    )

    add_last_price_validation_data_task = PythonOperator(
        task_id='add_last_price_validation_data_task',
        python_callable = _add_last_price_validation_data,
        retries=2,
        retry_delay=timedelta(minutes=3),


    )

    execute_add_first_price_validation_data_task = SQLExecuteQueryOperator(
        task_id='execute_add_first_price_validation_data_task',
        conn_id="airflow",
        sql="./sql_scipts/join_first_price.sql",
        retries=3,
        retry_delay=timedelta(minutes=3),
    )

    execute_add_last_price_validation_data_task = SQLExecuteQueryOperator(
        task_id='execute_add_last_price_validation_data_task',
        conn_id="airflow",
        sql="./sql_scipts/join_last_price.sql",
        retries=3,
        retry_delay=timedelta(minutes=3),
    )

    
    send_email = PythonOperator(
     task_id = 'send_emial',
     python_callable = prepare_message,
    
     
    )



    
    #prepare_set_of_results_task>>create_db_tables_task_task
    create_db_tables_task_task>>prepare_set_of_results_task
    prepare_set_of_results_task >> [add_first_price_validation_data_task, add_last_price_validation_data_task]
    add_first_price_validation_data_task >>execute_add_first_price_validation_data_task
    add_last_price_validation_data_task>>  execute_add_last_price_validation_data_task
    #prepare_set_of_results
    [execute_add_last_price_validation_data_task,execute_add_first_price_validation_data_task] >> send_email
