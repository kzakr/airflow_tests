import pandas as pd
import os
import datetime
from datetime import datetime, timedelta
from typing import Any
from py_files.attr import CommonConditions

def get_time(format="%Y%m%d"):

    now = datetime.now()

    dt_string_with_hour = now.strftime("%Y%m%d_%H_%M")
    dt_string = now.strftime(format)

    return now, dt_string_with_hour, dt_string

def get_last_weekday(format:str = "%Y%m%d"):
     
    now = datetime.now()
    if now.weekday() == 0:
        report_date = now - timedelta(days=3)
    else:
        report_date = now - timedelta(days=1)

    report_date = report_date.strftime(format)
    return report_date



def quarter_back(date_as_int:int):
    if date_as_int:
        start_date = datetime.strptime(str(date_as_int), '%Y%m%d')
    else: 
        start_date = datetime.now()
    report_date = start_date - timedelta(days=90)
    
    return report_date.strftime("%Y%m%d")

def add_working_days(num_days:int, date_as_int:int= None, format:str = "%Y%m%d"):
    if date_as_int:
        start_date = datetime.strptime(str(date_as_int), '%Y%m%d')
    else: 
        start_date = datetime.now()
    my_num_days = abs(num_days)
    inc = 1 if num_days  > 0 else -1
    while my_num_days > 0:
        start_date += timedelta(days=inc)
        weekday = start_date.weekday()
        if weekday >= 5:
            continue
        my_num_days -= 1
    return start_date.strftime(format)



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
    for attribute in measure_attributes:
        
        list_of_columns = list_of_columns = list_of_columns+[attribute +"_"+ str(aggregate_typ.__name__) + suffix if callable(aggregate_typ) else attribute +"_"+ str(aggregate_typ) + suffix for aggregate_typ in aggregate_type ]
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



def get_offsetted_day(date:datetime, weekday: tuple, offset_param:int) -> datetime:


    if date.weekday in weekday:
        offsetted_date = date - timedelta(day=offset_param+2)
    else:
        offsetted_date = date - timedelta(day=offset_param)

    dt_string = offsetted_date.strftime("%Y%m%d")

    return offsetted_date, dt_string


def add_column_based_on_confition(DataFrame: pd.DataFrame, new_colname:str, condition_column:str, condition:CommonConditions,  function: Any) -> pd.DataFrame:


    DataFrame[new_colname] = "N"
    if condition == CommonConditions.isin:
        

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
    



def list_in_directory(path:str, lookup_pattern: str):
    files = [path + "/"+file for file in os.listdir(path) if file.startswith(lookup_pattern)]
    
    return files


def types_mapper():
    dict_of_types={}
    dict_of_types["object"] = "VARCHAR (100)"
    dict_of_types['O'] = "VARCHAR (100)"
    dict_of_types["float"] = "numeric(38,8)"
    dict_of_types["int64"] = "integer"

    return dict_of_types

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

def iterative_list(range_from:int =1, range_to:int = None):
    range_to = range_to+1
    if range_to is None or range_to<=range_from :
        print("range_to has to be higher than range_from")
    full_list = []
    for element in range(range_from, range_to+1):
        if len(list(range(range_from, element))) >0: full_list.append(list(range(range_from, element))) 
    return full_list



