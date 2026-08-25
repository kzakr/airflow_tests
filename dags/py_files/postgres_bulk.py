# import libraries
import os
import time
import csv
from io import StringIO
from pathlib import Path

import pandas as pd
import psycopg2
from sqlalchemy import create_engine as sqlalchemy_create_engine
from typing import List, Optional
import sys

try:
    from dotenv import load_dotenv
except ModuleNotFoundError:  # pragma: no cover - optional for local development
    load_dotenv = None

from py_files.logging_utils import get_logger

logger = get_logger(__name__)

if load_dotenv is not None:
    load_dotenv(Path(__file__).resolve().parents[2] / ".env", override=False)


def get_postgres_url() -> str:
    """Build the Postgres URL from environment variables.

    Inside Docker Compose, POSTGRES_HOST should resolve to the service name `postgres`.
    When running directly on the host, `localhost` or `host.docker.internal` is typical.
    """
    host = os.getenv("POSTGRES_HOST", "localhost")
    dbname = os.getenv("POSTGRES_DB", "airflow")
    user = os.getenv("POSTGRES_USER", "airflow")
    password = os.getenv("POSTGRES_PASSWORD", "airflow")
    port = os.getenv("POSTGRES_PORT", "5432")
    return f"postgresql://{user}:{password}@{host}:{port}/{dbname}"

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


def create_engine(connection: Optional[str] = None):
    """Create a SQLAlchemy engine for Postgres, defaulting to env-based configuration."""
    if connection is None:
        connection = get_postgres_url()
    return sqlalchemy_create_engine(connection)


def postgres_bulk(data,table_name:str,  if_exists:str , engine_conn, ) :
    if type(data) == str:
        df = pd.read_csv(data)
    else:
        df = data

    # Example: 'postgresql://username:password@localhost:5432/your_database'
    engine = engine_conn if engine_conn is not None else create_engine()

    start_time = time.time()  # get start time before insert
    logger.info("Inserting data into %s", table_name)
    df.to_sql(
        name=table_name,
        con=engine,
        if_exists="append",
        index=False,
        method=psql_insert_copy
    )

    end_time = time.time() # get end time after insert
    total_time = end_time - start_time # calculate the time
    
    logger.info("Insert time: %s seconds", total_time)

def create_connection():
    """Connect to database."""
    try:
        logger.info("Connecting to Postgres")
        conn = create_engine()
        logger.info("Connection successful")
        return conn
    except (Exception, psycopg2.DatabaseError) as error:
        logger.exception("Error connecting to Postgres")
        raise

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