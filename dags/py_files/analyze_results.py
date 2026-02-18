import numpy as np
import pandas as pd

#from attr import CommonAttributes, CommonConditions
from py_files.commons import get_time, list_in_directory, convert_str_values_to_dec,split_dates_finwiz, create_grouped_df
from py_files.calculations import std, convert_big_numbers
from py_files.postgres_bulk import postgres_bulk, create_connection
import re






def upload_data_to_postgres():
    now, dt_string_with_hour, dt_string = get_time()
    finwiz_path= "/opt/airflow/dags/output_files"
    files = list_in_directory(finwiz_path, "finviz")

    
    #with open("./sql_scipts/get_data_from_postgres.sql", "r") as file:
    #    sql_query = file.read()
    #sql_query = "select * from finviz_result"

    columns_to_keep = ['no_', 'ticker', 'company', 'sector', 'industry',
           'country', 'market', 'p_e', 'price', 'change_', 'volume','full_date', 'full_date_ticker', 'time_', 
           'volume_mean', 'volume_std', 'price_mean', 'price_std',
           'volume_mean_all', 'volume_std_all', 'price_mean_all', 'price_std_all',
            'z_score', 'z_score_price']
    #DataFrame_post = pd.DataFrame() #sql_to_dataframe( query="select * from finviz_result", conn= create_connection(),column_names=columns_to_keep)
    #
#
    ##print(DataFrame_post)
    #
    #    
    #if len(DataFrame_post)>0:
    #    full_df = DataFrame_post
    #else:
        
    full_df = pd.DataFrame()


    if len(files)>0:
        print("Wieksze od 0")

        for file in files:
            print(file)

            part_df = pd.read_csv(file)
            part_df.drop(columns = ["ticker"], inplace = True)
            part_df = convert_str_values_to_dec(part_df, ["Volume", "Price"])
            part_df = split_dates_finwiz(part_df,'time')

            part_df.rename(columns = {"Change": "change_", "time": "time_"}, inplace = True)
            date_from_time = part_df["time_"].str[:8].unique().tolist()
            #date_from_time = [int(date) for date in date_from_time]

            #print(part_df)
            part_df.columns = [re.sub('[^a-zA-Z0-9]', '_', column).lower() for column in part_df.columns]
            part_df=create_grouped_df(part_df, ['ticker', 'volume', 'price'],grouped_column = ['ticker'], aggregate_type=['mean',std])

            part_df['market'] =  part_df['market'].apply(lambda x: convert_big_numbers(x))
            part_df['p_e'] =  part_df['p_e'][part_df['p_e']=="-"] =0
            part_df['p_e'] = part_df['p_e'].astype(float)
            date_from_part_df = part_df['full_date'].unique()[0]
            full_df = pd.concat([full_df, part_df])
            del(part_df)




            #full_df=create_grouped_df(full_df, ['ticker', 'volume', 'price'],grouped_column = ['ticker'], aggregate_type=['mean',std], suffix = "_all")
            #try:
            #    
            #    full_df.rename(columns = {"price_std_all_x":"price_std_all", "volume_std_all_x":"volume_std_all",
            #                              "price_mean_all_x":"price_mean_all", "volume_mean_all_x":"volume_mean_all"}, inplace = True)
            #    
            #    full_df[["volume_mean_all", "volume_std_all", "price_mean_all", "price_std_all"]].fillna(0, inplace=True)
            #    full_df.drop(columns = ["price_std_all_y", "volume_std_all_y", "price_mean_all_y", "volume_mean_all_y"], inplace = True)
            #    
#   
            #except:
            #    continue


            full_df["price_std_all"] = 0
            full_df["volume_std_all"] = 0
            full_df["price_mean_all"] = 0
            full_df["volume_mean_all"] = 0






            full_df['z_score'] = 0#=full_df.apply(lambda x: calc_z_score(x.volume, x.volume_mean_all,x.volume_std_all), axis=1)
            full_df['z_score'].fillna(0, inplace= True)
            print('ok')
            full_df['z_score_price']  = 0#=full_df.apply(lambda x: calc_z_score(x.price, x.price_mean_all,x.price_std_all), axis=1)
            #print(full_df.columns)
            full_df['z_score_price'].fillna(0, inplace= True)
            print('ok')
            print("zscore_price is: ")




            full_df = full_df[columns_to_keep]

            #full_df['abs_z_score'] =full_df['z_score'].apply(lambda x: abs(x))  ##disabled to lower resources

            #print(full_df["volume_mean_all"].unique())    
            #print(date_from_part_df)

            #print(full_df[["full_date", "volume_mean_all"]])
            table_to_insert = full_df[full_df['full_date'].isin(date_from_time)]
            print("table_to_insert")

            try:
                postgres_bulk(table_to_insert, table_name ='finviz_result_staging', if_exists="append", engine_conn= create_connection())
            except:
                print("cannot insert file")
            del table_to_insert

    
