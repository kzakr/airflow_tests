import pandas as pd
import os
from typing import List
import datetime
from datetime import datetime, timedelta
from typing import Any
from py_files.attr import CommonConditions

def get_time():

    now = datetime.now()

    dt_string_with_hour = now.strftime("%Y%m%d_%H_%M")
    dt_string = now.strftime("%Y%m%d")

    return now, dt_string_with_hour, dt_string

    files=[];
    files  = [os.path.join(path,i) for i in os.listdir(path) if i.startswith(lookup_pattern) ]
    return files

def convert_str_values_to_dec(DataFrame:pd.DataFrame ,columns:[str]):
    for column in columns:
        DataFrame[column]= DataFrame[column].apply(lambda x: str(x).replace(',',''))
        DataFrame[column]= DataFrame[column].apply(lambda x: float(x.replace('-','0')))

    return DataFrame

def split_dates_finwiz(DataFrame:pd.DataFrame ,date_column:str)-> pd.DataFrame:

    DataFrame['Year'] = DataFrame[date_column].str[0:4];
    DataFrame['Month'] = DataFrame[date_column].str[4:6];
    DataFrame['Day'] = DataFrame[date_column].str[6:8];
    DataFrame['Full_date'] = DataFrame[date_column].str[:8];
    DataFrame['Full_date_ticker'] = DataFrame[date_column].str[:8] + DataFrame['Ticker'];


    return DataFrame

def create_grouped_df(DataFrame: pd.DataFrame, attributes:[str], grouped_column:[str], aggregate_type, suffix:str ='')->pd.DataFrame:
    #temp_DataFrame = DataFrame[attributes].groupby(grouped_column).agg(aggregate_type)
    
    temp_DataFrame = DataFrame[attributes].groupby(grouped_column).agg(aggregate_type)
    
    #print(temp_DataFrame)
    temp_DataFrame.reset_index(inplace = True)
    #grouped_by_ticker.rename(columns= {'Volume': 'Avg. Volume'}, inplace = True)
    temp_DataFrame.columns = temp_DataFrame.columns.get_level_values(0)
    list_of_columns=[]
    
    
    measure_attributes = [column for column in attributes if column not in grouped_column]
    print(measure_attributes)
    for attribute in measure_attributes:
        
        list_of_columns = list_of_columns = list_of_columns+[attribute +"_"+ str(aggregate_typ.__name__) + suffix if callable(aggregate_typ) else attribute +"_"+ str(aggregate_typ) + suffix for aggregate_typ in aggregate_type ]
    print(grouped_column+list_of_columns)
    temp_DataFrame.columns = grouped_column+list_of_columns
    
    DataFrame = DataFrame.merge(temp_DataFrame, left_on = grouped_column, right_on = grouped_column, how = 'inner')

    return DataFrame

    


#def create_statistics_mean(DataFrame: pd.DataFrame, calculated_columns: list):
#
#    temp_df = DataFrame[calculated_columns].mean()
#    DataFrame. 

def get_last_file(DataFrame: pd.DataFrame, time_date:str) -> pd.DataFrame:

    last_date = DataFrame[time_date].max()
    last_data = DataFrame[DataFrame[time_date]==last_date]

    return last_data



def get_offsetted_days(date:datetime, weekdays: tuple, offset_param:int) -> datetime:


    if date.weekday in weekdays:
        offsetted_date = date - timedelta(days=offset_param+2)
    else:
        offsetted_date = date - timedelta(days=offset_param)

    dt_string = offsetted_date.strftime("%Y%m%d")

    return offsetted_date, dt_string


def add_column_based_on_confition(DataFrame: pd.DataFrame, new_colname:str, condition_column:str, condition:CommonConditions,  function: Any) -> pd.DataFrame:


    DataFrame[new_colname] = "N"
    if condition == CommonConditions.isin:
        
        print("#"*100)
        print(f"{condition}")
        print(f"{CommonConditions.isin}")
        DataFrame[new_colname][DataFrame[condition_column].isin(function)] = "Y"

    elif condition == CommonConditions.higher:

        DataFrame[new_colname][DataFrame[condition_column]> function] = "Y"
    
    elif condition == CommonConditions.lower:

        DataFrame[new_colname][DataFrame[condition_column]< function] = "Y"
    
    elif condition == CommonConditions.equal_or_higher:

        DataFrame[new_colname][DataFrame[condition_column] >= function] = "Y"


    elif condition == CommonConditions.equal_or_lower:

        DataFrame[new_colname][DataFrame[condition_column] <= function] = "Y"

    elif condition == CommonConditions.str_contains:

        DataFrame[new_colname][DataFrame[condition_column].str_contains(function)] = "Y"

    elif condition == CommonConditions.str_not_contains:

        DataFrame[new_colname][DataFrame[condition_column].str_contains(function) ==0 ] = "Y"
    
    else:

        raise Exception("No valid condition found")

    return DataFrame        
    



def list_in_directory(path:str, lookup_pattern: str)->[str]:
    pass


def types_mapper():
    dict_of_types={}
    dict_of_types["object"] = "VARCHAR (100)"
    dict_of_types['O'] = "VARCHAR (100)"
    dict_of_types["float"] = "numeric(38,8)"
    dict_of_types["int64"] = "integer"

    return dict_of_types