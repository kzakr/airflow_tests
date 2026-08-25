import os
import pandas as pd

from py_files.get_d2d_indicators_yahoo import get_raw_data, get_statistical_metrics_avg, get_statistical_metrics_std, get_lagged_data, get_data
from py_files.commons import get_last_weekday, add_working_days
from py_files.commons_sql import get_day_part_yahoo, cut_training_period_yahoo
import random

SQL_SCRIPT_DIR = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'sql_scipts'))
os.makedirs(SQL_SCRIPT_DIR, exist_ok=True)

_interval = 15
last_week_date = get_last_weekday(format="%Y-%m-%d")
_num_of_days = 55
random.seed(44)
day_dict = {1:"one", 2:"two", 3:"three", 4:"four", 5:"five", 6:"six", 7:"seven", 8:"eight", 9:"nine", 10:"ten", 11:"eleven", 
        12:"twelve", 13:"thirteen", 14:"fourteen", 15:"fiveteen", 16:"sixteen", 17:"seveteen", 18:"eighteen", 19:"nineteen", 20:"twenty", 21:"twenty_one", 
        22:"twenty_two", 23:"twenty_three", 24:"twenty_four", 25:"twenty_five", 26:"twenty_six", 27:"twenty_seven"
        , 28:"twenty_eight", 29:"twenty_nine", 30:"thirty", 31:"thirty_one", 32:"thirty_two", 33:"thirty_three", 34:"thirty_four"
        , 35:"thirty_five", 36:"thirty_six", 37:"thirty_seven", 38:"thirty_eight", 39:"thirty_nine", 40:"forty", 41:"forty_one"
        , 42:"forty_two", 43:"forty_three", 44:"forty_four", 45:"forty_five", 46:"forty_six", 47:"forty_seven", 48:"forty_eight"
        , 49:"forty_nine", 50:"fifty", 51:"fifty_one", 52:"fifty_two", 53:"fifty_three", 54:"fifty_four", 55:"fifty_five", 56:"fifty_six", 57:"fifty_seven", 58:"fifty_eight"
        , 59:"fifty_nine", 60:"sixty", 61:"sixty_one", 62:"sixty_two", 63:"sixty_three", 64:"sixty_four", 65:"sixty_five", 66:"sixty_six", 67:"sixty_seven", 68:"sixty_eight"
        , 69:"sixty_nine",
         70:"seventy", 71:"seventy_one", 72:"seventy_two", 73:"seventy_three", 74:"seventy_four", 75:"seventy_five", 76:"seventy_six", 77:"seventy_seven", 78:"seventy_eight"
        , 79:"seventy_nine"}
#close_{day_dict[day]}_day_back

def get_data_view(file_num: int, num_of_days:int = _num_of_days, after_day:str = add_working_days(-1, format = "%Y-%m-%d"), interval: int = _interval):
    sql_query =  get_raw_data(day = get_day_part_yahoo(how_many_day = num_of_days,after_day= after_day))
    sql_query = get_data(sql_query, statistical_metrics_avg=get_statistical_metrics_avg(to_date = cut_training_period_yahoo(how_many_day = _num_of_days, after_day=after_day, to_date_interval= interval))\
                                                                                        ,statistical_metrics_std=get_statistical_metrics_std( to_date = cut_training_period_yahoo(how_many_day = _num_of_days, after_day=after_day, to_date_interval= interval)))
    sql_query = get_lagged_data(query_data= sql_query,day_count = get_day_part_yahoo(how_many_day = num_of_days,after_day= after_day))

    view_def = f"drop view if exists ml_temp_{file_num}_yahoo; \ncreate view ml_temp_{file_num}_yahoo as select * from ({sql_query});\n\n"
    sql_path = os.path.join(SQL_SCRIPT_DIR, "sql_query_check_ml_yahoo.sql")
    with open(sql_path, "a") as file:
        file.write(view_def)



def get_data_validate_view( after_day: str=add_working_days(0, format = "%Y-%m-%d"), num_of_days:int = _num_of_days, interval:int = _interval):
    sql_query =  get_raw_data(day = get_day_part_yahoo(how_many_day = num_of_days,after_day= after_day))
    sql_query = get_data(sql_query,statistical_metrics_avg=get_statistical_metrics_avg(to_date = cut_training_period_yahoo(how_many_day = _num_of_days, after_day=after_day, to_date_interval= interval))\
                                                                                        ,statistical_metrics_std=get_statistical_metrics_std(to_date = cut_training_period_yahoo(how_many_day = _num_of_days, after_day=after_day, to_date_interval= interval)))
    sql_query = get_lagged_data(query_data= sql_query,day_count = get_day_part_yahoo(how_many_day = num_of_days,after_day= after_day))

    view_def = f"drop view if exists ml_temp_validate_yahoo ; \ncreate view ml_temp_validate_yahoo as select * from ({sql_query})"
    sql_path = os.path.join(SQL_SCRIPT_DIR, "sql_query_check_ml_validate_yahoo.sql")
    with open(sql_path, "w") as file:
        file.write(view_def)
    

    

def get_data_query(table:str):


###OLD
    #query = "with cc as ( \n"
    #query += "\t select * from ml_temp\n"
    #query += ")"
    #query += ",bb as( \n"
    #query += "\t select ticker, avg_close, avg_volume from finviz_result group by ticker"
    #query += ")\n"
    #query += ",cc as( \n"
    #query += "\t select aa.ticker, aa._date, sum(aa.close - bb.avg_close) as std_close, sum(aa.volume - bb.avg_volume) as std_vol from aa join bb on aa.ticker = bb.ticker"
    #query += "\n\t group by aa.ticker, aa._date"
    #query += ")\n"
    #query += ",dd as( \n"
    #query += "\t select cc.ticker, cc._date, (aa.close - bb.avg_close)/cc.std_close as z_score_close, (aa.volume - bb.avg_volume)/cc.std_vol as z_score_volume, \n"
    #for day in range(1,_num_of_days+1):
    #    if day <_num_of_days:
    #        query += f"\t (aa.close_{day_dict[day]}_day_back - bb.avg_close)/cc.std_close as z_score_close_{day_dict[day]}_day_back, aa.volume_{day_dict[day]}_day_back - bb.avg_volume/cc.std_vol as z_score_volume_{day_dict[day]}_day_back, \n"
    #    elif day ==_num_of_days:
    #        query += f"\t (aa.close_{day_dict[day]}_day_back - bb.avg_close)/cc.std_close as z_score_close_{day_dict[day]}_day_back, aa.volume_{day_dict[day]}_day_back - bb.avg_volume/cc.std_vol as z_score_volume_{day_dict[day]}_day_back \n"
#
    #query += "from aa left join bb on aa.ticker = bb.ticker left join cc on aa.ticker=cc.ticker"
    #query += ")\n"
    #query += "select  aa.close, aa.volume, dd.*  from aa join dd on aa.ticker = dd.ticker and aa._date = dd._date"
   
   
    query = "with aa as ( \n"
    query += f"\t select * from {table}\n"
    query += ")"
    query += ",cc as( \n"
    query += "\t select ticker, std_close, std_volume from aa"
    query += "\t\t where  std_close <>0 and std_volume <> 0"

    query += ")\n"

    
    query += ",dd as( \n"
    query += "\t select aa.ticker, aa._date, round((aa.close - aa.avg_close)/cc.std_close,3) as z_score_close, round((aa.volume - aa.avg_volume)/cc.std_volume, 3) as z_score_volume, \n"
    for day in range(1,_num_of_days+1):
        if day <_num_of_days:
            query += f"\t round((aa.close_{day_dict[day]}_day_back - aa.avg_close)/cc.std_close,3) as z_score_close_{day_dict[day]}_day_back, round((aa.volume_{day_dict[day]}_day_back - aa.avg_volume)/cc.std_volume,3) as z_score_volume_{day_dict[day]}_day_back, \n"
        elif day ==_num_of_days:
            query += f"\t round((aa.close_{day_dict[day]}_day_back - aa.avg_close)/cc.std_close,3) as z_score_close_{day_dict[day]}_day_back, round((aa.volume_{day_dict[day]}_day_back - aa.avg_volume)/cc.std_volume,3) as z_score_volume_{day_dict[day]}_day_back \n"

    query += "from aa left join cc on aa.ticker = cc.ticker"
    query += ")\n"
    query += ",ee as( \n"
    query += "select *,"
    for day in range(1,_num_of_days):
        if day <_num_of_days-1:
            query += f"\t  z_score_close_{day_dict[day]}_day_back - z_score_close_{day_dict[day+1]}_day_back as {day_dict[day]}_{day_dict[day+1]}_difference, \n"
        elif day ==_num_of_days-1:
             query += f"\t z_score_close_{day_dict[day]}_day_back - z_score_close_{day_dict[day+1]}_day_back as {day_dict[day]}_{day_dict[day+1]}_difference \n"

    query +=  " from dd"
    query += ")\n"
    query += "select  aa.close, aa.volume, ee.*  from aa join ee on aa.ticker = ee.ticker and aa._date = ee._date"
    #query += "select  aa.close, aa.volume, dd.*  from aa join dd on aa.ticker = dd.ticker and aa._date = dd._date"

    return query



def get_data_query_validate():


   
    query = "with aa as ( \n"
    query += "\t select * from ml_temp_validate_yahoo\n"
    query += ")"

    query += ",cc as( \n"
    query += "\t select ticker, std_close, std_volume from aa"
    query += "\t\t where  std_close <>0 and std_volume <> 0"

    query += ")\n"

    
    query += ",dd as( \n"
    query += "\t select aa.ticker, aa._date, round((aa.close - aa.avg_close)/cc.std_close,3) as z_score_close, round((aa.volume - aa.avg_volume)/cc.std_volume, 3) as z_score_volume, \n"
    for day in range(1,_num_of_days+1):
        if day <_num_of_days:
            query += f"\t round((aa.close_{day_dict[day]}_day_back - aa.avg_close)/cc.std_close,3) as z_score_close_{day_dict[day]}_day_back, round((aa.volume_{day_dict[day]}_day_back - aa.avg_volume)/cc.std_volume,3) as z_score_volume_{day_dict[day]}_day_back, \n"
        elif day ==_num_of_days:
            query += f"\t round((aa.close_{day_dict[day]}_day_back - aa.avg_close)/cc.std_close,3) as z_score_close_{day_dict[day]}_day_back, round((aa.volume_{day_dict[day]}_day_back - aa.avg_volume)/cc.std_volume,3) as z_score_volume_{day_dict[day]}_day_back \n"

    query += "from aa left join cc on aa.ticker = cc.ticker"
    query += ")\n"
    query += ",ee as( \n"
    query += "select *,"
    for day in range(1,_num_of_days):
        if day <_num_of_days-1:
            query += f"\t  z_score_close_{day_dict[day]}_day_back - z_score_close_{day_dict[day+1]}_day_back as {day_dict[day]}_{day_dict[day+1]}_difference, \n"
        elif day ==_num_of_days-1:
             query += f"\t z_score_close_{day_dict[day]}_day_back - z_score_close_{day_dict[day+1]}_day_back as {day_dict[day]}_{day_dict[day+1]}_difference \n"

    query +=  " from dd"
    query += ")\n"
    query += "select  aa.close, aa.volume, ee.*  from aa join ee on aa.ticker = ee.ticker and aa._date = ee._date"
    #query += "select  aa.close, aa.volume, dd.*  from aa join dd on aa.ticker = dd.ticker and aa._date = dd._date"





    return query


def get_data_query_predict():

    query = "with aa as ( \n"
    query += "\t select * from ml_temp_predict_yahoo\n"
    query += ")"

    query += ",cc as( \n"
    query += "\t select ticker, std_close, std_volume from aa"
    query += "\t\t where  std_close <>0 and std_volume <> 0"
    query += ")\n"

    query += ",dd as( \n"
    query += "\t select aa.ticker, aa._date, round((aa.close - aa.avg_close)/cc.std_close,3) as z_score_close, round((aa.volume - aa.avg_volume)/cc.std_volume, 3) as z_score_volume, \n"
    for day in range(1,_num_of_days+1):
        if day <_num_of_days:
            query += f"\t round((aa.close_{day_dict[day]}_day_back - aa.avg_close)/cc.std_close,3) as z_score_close_{day_dict[day]}_day_back, round((aa.volume_{day_dict[day]}_day_back - aa.avg_volume)/cc.std_volume,3) as z_score_volume_{day_dict[day]}_day_back, \n"
        elif day ==_num_of_days:
            query += f"\t round((aa.close_{day_dict[day]}_day_back - aa.avg_close)/cc.std_close,3) as z_score_close_{day_dict[day]}_day_back, round((aa.volume_{day_dict[day]}_day_back - aa.avg_volume)/cc.std_volume,3) as z_score_volume_{day_dict[day]}_day_back \n"

    query += "from aa left join cc on aa.ticker = cc.ticker"
    query += ")\n"
    query += ",ee as( \n"
    query += "select *,"
    for day in range(1,_num_of_days):
        if day <_num_of_days-1:
            query += f"\t  z_score_close_{day_dict[day]}_day_back - z_score_close_{day_dict[day+1]}_day_back as {day_dict[day]}_{day_dict[day+1]}_difference, \n"
        elif day ==_num_of_days-1:
            query += f"\t z_score_close_{day_dict[day]}_day_back - z_score_close_{day_dict[day+1]}_day_back as {day_dict[day]}_{day_dict[day+1]}_difference \n"

    query += " from dd"
    query += ")\n"
    query += "select  aa.close, aa.volume, ee.*  from aa join ee on aa.ticker = ee.ticker and aa._date = ee._date"
    return query

def get_zscore_difference(df = pd.DataFrame, interval:int=_interval):

    if interval<2:
        raise Exception("Interval has to be at least 2")

    df = df.copy()
    lagged_day = day_dict[interval]
    df["difference"] = df["z_score_close_one_day_back"] - df["z_score_close_"+lagged_day+"_day_back"]
    df = df[df["difference"].notna()].copy()
    for column in range(1, interval+1):
        df = df.drop(columns = ["z_score_close_"+day_dict[column]+"_day_back"], errors='ignore')
        df = df.drop(columns = ["z_score_volume_"+day_dict[column]+"_day_back"], errors='ignore')
        df = df.drop(columns = [day_dict[column]+"_"+day_dict[column+1]+"_difference"], errors='ignore')

    return df.reset_index(drop=True)


def get_list_of_ticker_with_count(DataFrame = pd.DataFrame, count:int = 10, z_score_diff: float = 0.2):

    #full_df_copy_grouped = DataFrame.groupby(['ticker', '_date']).count()
    #print(full_df_copy_grouped)
    #full_df_copy_grouped.reset_index(inplace = True)#["Ticker"].value_counts()>30
    full_df_copy_grouped = DataFrame[DataFrame["difference"] > z_score_diff]

    tickers = full_df_copy_grouped["ticker"].value_counts()>count
    
    tickers= tickers.index[:].to_list()
    #tickers = tickers[tickers == True].index[:].to_list()
    return tickers

def prepare_df_1(tickers, DataFrame: pd.DataFrame):

    DataFrame = DataFrame[DataFrame["ticker"].isin(tickers)].copy()
    if DataFrame.empty:
        return pd.DataFrame(columns=list(DataFrame.columns) + ["category"]) 
    DataFrame["category"] = 1
    return DataFrame.reset_index(drop=True)

def prepare_df_0(tickers, DataFrame: pd.DataFrame):

    if not isinstance(tickers, (list, tuple, set)):
        tickers = list(tickers) if tickers is not None else []

    n = len(tickers)
    neg_df = DataFrame.loc[~DataFrame["ticker"].isin(tickers), :].copy()
    if n == 0 or neg_df.empty:
        return pd.DataFrame(columns=list(neg_df.columns) + ["category"]) 

    if len(neg_df) >= n:
        sampled = neg_df.sample(n, random_state=42)
    else:
        sampled = neg_df.sample(n, replace=True, random_state=42)

    sampled = sampled.copy()
    sampled["category"] = 0
    return sampled.reset_index(drop=True)

def get_data_sets(df_1: pd.DataFrame, df_0: pd.DataFrame, split_size: float=0.33):

    from sklearn.model_selection import train_test_split

    df_1 = df_1.copy().reset_index(drop=True)
    df_0 = df_0.copy().reset_index(drop=True)
    df = pd.concat([df_1, df_0], ignore_index=True)
    if df.empty:
        return None, None, None, None

    target = df["category"].reset_index(drop=True).copy()
    df = df.drop(columns=["ticker", "category", "difference", "z_score_close",
                          "z_score_volume", "volume", "close"], errors='ignore').copy()

    if len(df) < 2:
        return None, None, None, None

    import numpy as np
    numeric_df = df.select_dtypes(include=[np.number]).copy().reset_index(drop=True)
    if numeric_df.shape[1] == 0:
        return None, None, None, None

    target = target.iloc[:len(numeric_df)].reset_index(drop=True)
    X = numeric_df
    y = target

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=split_size, random_state=42)

    return X_train, X_test, y_train, y_test

def get_data_sets_with_ticker(df_1: pd.DataFrame, df_0: pd.DataFrame, split_size: float=0.33):

    from sklearn.model_selection import train_test_split

    df_1 = df_1.copy().reset_index(drop=True)
    df_0 = df_0.copy().reset_index(drop=True)
    df = pd.concat([df_1, df_0], ignore_index=True)
    target = df["category"].copy()
    df = df.drop(columns=["category", "difference", "z_score_close",
                          "z_score_volume", "volume", "close"], errors='ignore').copy()

    X_train, X_test, y_train, y_test = train_test_split(
        df, target, test_size=split_size, random_state=42)

    return X_train, X_test, y_train, y_test





