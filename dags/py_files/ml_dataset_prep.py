from airflow import DAG
from airflow.operators.python import PythonOperator, BranchPythonOperator
from airflow.operators.postgres_operator import PostgresOperator
#from airflow.operators.branch_operator import BaseBranchOperator
from airflow.operators.bash import BashOperator
import datetime
import pandas as pd
from datetime import timedelta
from py_files.get_d2d_indicators import get_raw_data, get_statistical_metrics_avg, get_statistical_metrics_std, get_lagged_data, get_data, get_last_price, get_first_price\
    , join_operator, sql_merge_operator, get_day_part
from py_files.d2d_rules import volume_and_price_declining_3, volume_below_08_average,volume_and_price_raising_3, volume_declining_3, \
    volume_declining_with_multiplicator, volume_price_declining_2, price_declining_3, sql_volume_and_price_declining_3, \
    sql_price_declining_3, sql_volume_and_price_raising_3, sql_volume_below_08_average, sql_volume_declining_3,\
    sql_volume_declining_with_multiplicator, sql_volume_price_declining_2
from py_files.commons import add_column_based_on_confition, types_mapper
from py_files.attr import CommonConditions, JoinOperators
from py_files.postgres_bulk import create_connection, sql_to_dataframe, postgres_bulk
from airflow.operators.email_operator import EmailOperator
from airflow.hooks.base_hook import BaseHook
from py_files.commons import get_time
from py_files.mail_operator import MessageOperator
from py_files.email_templates.message_body import get_statistical_results
import random
from random import randint



_num_of_days = 21
random.seed(44)
day_dict = {1:"one", 2:"two", 3:"three", 4:"four", 5:"five", 6:"six", 7:"seven", 8:"eight", 9:"nine", 10:"ten", 11:"eleven", 
        12:"twelve", 13:"thirteen", 14:"fourteen", 15:"fiveteen", 16:"sixteen", 17:"seveteen", 18:"eighteen", 19:"nineteen", 20:"twenty", 21:"twenty_one", 
        22:"twenty_two", 23:"twenty_three", 24:"twenty_four", 25:"twenty_five", 26:"twenty_six"}
#price_{day_dict[day]}_day_back

def get_data_view():
    sql_query =  get_raw_data(day = get_day_part(_num_of_days))
    sql_query = get_data(sql_query)
    sql_query = get_lagged_data(query_data= sql_query,day_count = get_day_part(_num_of_days))

    view_def = f"drop view if exists ml_temp; \ncreate view ml_temp as select * from ({sql_query})"
    with open("./dags/sql_scipts/sql_query_check_ml.sql", "w") as file:
        file.write(view_def)
    

def get_data_query():


###OLD
    #query = "with cc as ( \n"
    #query += "\t select * from ml_temp\n"
    #query += ")"
    #query += ",bb as( \n"
    #query += "\t select ticker, avg_price, avg_volume from finviz_result group by ticker"
    #query += ")\n"
    #query += ",cc as( \n"
    #query += "\t select aa.ticker, aa.full_date, sum(aa.price - bb.avg_price) as std_price, sum(aa.volume - bb.avg_volume) as std_vol from aa join bb on aa.ticker = bb.ticker"
    #query += "\n\t group by aa.ticker, aa.full_date"
    #query += ")\n"
    #query += ",dd as( \n"
    #query += "\t select cc.ticker, cc.full_date, (aa.price - bb.avg_price)/cc.std_price as z_score_price, (aa.volume - bb.avg_volume)/cc.std_vol as z_score_volume, \n"
    #for day in range(1,_num_of_days+1):
    #    if day <_num_of_days:
    #        query += f"\t (aa.price_{day_dict[day]}_day_back - bb.avg_price)/cc.std_price as z_score_price_{day_dict[day]}_day_back, aa.volume_{day_dict[day]}_day_back - bb.avg_volume/cc.std_vol as z_score_volume_{day_dict[day]}_day_back, \n"
    #    elif day ==_num_of_days:
    #        query += f"\t (aa.price_{day_dict[day]}_day_back - bb.avg_price)/cc.std_price as z_score_price_{day_dict[day]}_day_back, aa.volume_{day_dict[day]}_day_back - bb.avg_volume/cc.std_vol as z_score_volume_{day_dict[day]}_day_back \n"
#
    #query += "from aa left join bb on aa.ticker = bb.ticker left join cc on aa.ticker=cc.ticker"
    #query += ")\n"
    #query += "select  aa.price, aa.market, aa.volume, dd.*  from aa join dd on aa.ticker = dd.ticker and aa.full_date = dd.full_date"
   
   
    query = "with aa as ( \n"
    query += "\t select * from ml_temp\n"
    query += ")"
    query += ",cc as( \n"
    query += "\t select c.ticker, std_price, std_volume from c"

    query += ")\n"

    
    query += ",dd as( \n"
    query += "\t select aa.ticker, aa.full_date, round(aa.price - aa.avg_price)/cc.std_price,3) as z_score_price, round(aa.volume - aa.avg_volume)/cc.std_volume, 3) as z_score_volume, \n"
    for day in range(1,_num_of_days+1):
        if day <_num_of_days:
            query += f"\t round((aa.price_{day_dict[day]}_day_back - aa.avg_price)/cc.std_price,3) as z_score_price_{day_dict[day]}_day_back, round((aa.volume_{day_dict[day]}_day_back - aa.avg_volume)/cc.std_volume,3) as z_score_volume_{day_dict[day]}_day_back, \n"
        elif day ==_num_of_days:
            query += f"\t round((aa.price_{day_dict[day]}_day_back - aa.avg_price)/cc.std_price,3) as z_score_price_{day_dict[day]}_day_back, round((aa.volume_{day_dict[day]}_day_back - aa.avg_volume)/cc.std_volume,3) as z_score_volume_{day_dict[day]}_day_back \n"

    query += "from aa left join cc on aa.ticker = cc.ticker"
    query += ")\n"
    query += "select  aa.price, aa.market, aa.volume, dd.*  from aa join dd on aa.ticker = dd.ticker and aa.full_date = dd.full_date"

    print(query)

    return query



def get_data_query_validate():


   
    query = "with aa as ( \n"
    query += "\t select * from ml_temp_validate\n"
    query += ")"

    query += ",cc as( \n"
    query += "\t select c.ticker, std_price, std_volume from c"

    query += ")\n"

    
    query += ",dd as( \n"
    query += "\t select aa.ticker, aa.full_date, round(aa.price - aa.avg_price)/cc.std_price,3) as z_score_price, round(aa.volume - aa.avg_volume)/cc.std_volume, 3) as z_score_volume, \n"
    for day in range(1,_num_of_days+1):
        if day <_num_of_days:
            query += f"\t round((aa.price_{day_dict[day]}_day_back - aa.avg_price)/cc.std_price,3) as z_score_price_{day_dict[day]}_day_back, round((aa.volume_{day_dict[day]}_day_back - aa.avg_volume)/cc.std_volume,3) as z_score_volume_{day_dict[day]}_day_back, \n"
        elif day ==_num_of_days:
            query += f"\t round((aa.price_{day_dict[day]}_day_back - aa.avg_price)/cc.std_price,3) as z_score_price_{day_dict[day]}_day_back, round((aa.volume_{day_dict[day]}_day_back - aa.avg_volume)/cc.std_volume,3) as z_score_volume_{day_dict[day]}_day_back \n"

    query += "from aa left join cc on aa.ticker = cc.ticker"
    query += ")\n"
    query += "select  aa.price, aa.market, aa.volume, dd.*  from aa join dd on aa.ticker = dd.ticker and aa.full_date = dd.full_date"


    print(query)



    return query

def get_zscore_difference(df = pd.DataFrame, interval:int=2):
    
    if interval<2:
        raise Exception("Interval has to be at least 2")
    lagged_day = day_dict[interval]
    #print(df.columns)
    df["difference"] = df["z_score_price_one_day_back"] - df["z_score_price_"+lagged_day+"_day_back"]
    print("^"*54)
    for column in range(1, interval+1):
        print("z_score_price_"+day_dict[column]+"_day_back")
        df.drop(columns = ["z_score_price_"+day_dict[column]+"_day_back"], inplace = True)
        df.drop(columns = ["z_score_volume_"+day_dict[column]+"_day_back"], inplace = True)

    return df


def get_list_of_ticker_with_count(DataFrame = pd.DataFrame, count:int = 10):
    print(DataFrame.head())
    print(DataFrame.columns)
    #full_df_copy_grouped = DataFrame.groupby(['ticker', 'full_date']).count()
    #print(full_df_copy_grouped)
    #full_df_copy_grouped.reset_index(inplace = True)#["Ticker"].value_counts()>30
    
    full_df_copy_grouped = DataFrame[DataFrame["difference"]>1.1]
    tickers = full_df_copy_grouped["ticker"].value_counts()>count
    
    tickers= tickers.index[:].to_list()
    #tickers = tickers[tickers == True].index[:].to_list()
    print(tickers)
    return tickers

def prepare_df_1(tickers, DataFrame: pd.DataFrame):

    DataFrame = DataFrame[DataFrame["ticker"].isin(tickers)]
    print(len(DataFrame))
    DataFrame["category"] = 1
    return DataFrame

def prepare_df_0(tickers, DataFrame: pd.DataFrame):

    
    
    DataFrame = DataFrame[DataFrame["ticker"].isin(tickers)==0]
    DataFrame = DataFrame.sample(len(tickers))
    print(DataFrame["ticker"].unique())
    print(len(DataFrame))
    DataFrame["category"] = 0
    return DataFrame

def get_data_sets(df_1: pd.DataFrame, df_0: pd.DataFrame, split_size: float=0.33):

    from sklearn.model_selection import train_test_split
    
    df = pd.concat([df_1, df_0])
    target = df["category"]
    df.drop(columns = ["ticker", "category", "difference", "z_score_price", 
    "z_score_volume", "volume", "price"], inplace = True)

    print(df.columns)
    print("#"*100)

    

    #X_train, X_test, y_train, y_test = 0,0,0,0

    X_train, X_test, y_train, y_test = train_test_split(
        df, target, test_size=split_size, random_state=42)##
    
    return X_train, X_test, y_train, y_test




