# import libraries
import pandas as pd
from sqlalchemy import create_engine
import time
import csv
from io import StringIO
import psycopg2
from typing import List, Optional
import sys

def psql_insert_copy(table, conn, keys, data_iter): #mehod
    """
    Execute SQL statement inserting data

    Parameters
    ----------
    table : pandas.io.sql.SQLTable
    conn : sqlalchemy.engine.Engine or sqlalchemy.engine.Connection
    keys : list of str
        Column names
    data_iter : Iterable that iterates the values to be inserted
    """
    # gets a DBAPI connection that can provide a cursor
    dbapi_conn = conn.connection
    with dbapi_conn.cursor() as cur:
        s_buf = StringIO()
        writer = csv.writer(s_buf)
        writer.writerows(data_iter)
        s_buf.seek(0)

        columns = ', '.join('"{}"'.format(k) for k in keys)
        if table.schema:
            table_name = '{}.{}'.format(table.schema, table.name)
        else:
            table_name = table.name

        sql = 'COPY {} ({}) FROM STDIN WITH CSV'.format(
            table_name, columns)
        #print(sql)
        cur.copy_expert(sql=sql, file=s_buf)


def create_engine(connection:str):

    connection = create_engine(connection)

    return connection



def postgres_bulk(data,table_name:str,  if_exists:str , engine_conn, ) :
    if type(data) == str:
        df = pd.read_csv(data)
    else:
        df = data

    # Example: 'postgresql://username:password@localhost:5432/your_database'
    engine = 'postgresql://airflow:airflow@host.docker.internal:5432/airflow'#engine_conn 

    start_time = time.time() # get start time before insert
    print("inserting data")
    df.to_sql(
        name=table_name,
        con=engine,
        if_exists="append",
        index=False,
        method=psql_insert_copy
    )

    end_time = time.time() # get end time after insert
    total_time = end_time - start_time # calculate the time
    
    print(f"Insert time: {total_time} seconds") # print time

def create_connection():
    """ Connect to database """
    
    try:
        print("Connecting…")
        conn = psycopg2.connect(
                        host='host.docker.internal',
                        database="airflow",
                        user="airflow",
                        password="airflow")
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        
    print("All good, Connection successful!")
    return conn

def sql_to_dataframe(query:str, conn, column_names = None)-> pd.DataFrame:
    """
    Import data from a PostgreSQL database using a SELECT query 
    """ 
    #print("Connector to be initiated!")
    #cursor = conn.cursor()
    #print("After initiation of cursor")
    #try:
    #   cursor.execute(query)
    #except (Exception, psycopg2.DatabaseError) as error:
    #   print("Error: %s" % error)
    #
    ## The execute returns a list of tuples:
    #tuples_list = cursor.fetchall()
    #cursor.close()
    ## Now we need to transform the list into a pandas DataFrame:
    #print(tuples_list)
    #if column_names == None:
    #    df = pd.DataFrame(tuples_list)
    #elif len(column_names)>0:
    #    
    #    df = pd.DataFrame(tuples_list, columns=column_names)
#
    #else:
    #    raise Exception("Cannot assign data to DataFrame")
    df = pd.read_sql(query,con = conn)
    

    
    return df