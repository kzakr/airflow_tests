import numpy as np
import pandas as pd
import os



#from attr import CommonAttributes, CommonConditions
from py_files.commons import get_time, list_in_directory, convert_str_values_to_dec,split_dates_finwiz, create_grouped_df
from py_files.calculations import std,calc_z_score, convert_big_numbers
from py_files.postgres_bulk import postgres_bulk, sql_to_dataframe, create_engine



#connection = create_connection_for_import()

#with open("./sql_scipts/finwiz_result_create_table_staging.sql", "r") as file:
#    sql_query = file.read()
#
#df= sql_to_dataframe(conn= connection, query=sql_query)