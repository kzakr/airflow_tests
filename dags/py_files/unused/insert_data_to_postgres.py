
import os
import logging

import pandas as pd
import psycopg2

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass


def get_postgres_conn():
    try:
        return psycopg2.connect(
            host=os.environ["POSTGRES_HOST"],
            database=os.environ["POSTGRES_DB"],
            user=os.environ["POSTGRES_USER"],
            password=os.environ["POSTGRES_PASSWORD"],
            port=int(os.environ.get("POSTGRES_PORT", 5432)),
        )
    except KeyError as exc:
        missing = exc.args[0]
        raise RuntimeError(
            f"Missing required environment variable for Postgres connection: {missing}"
        ) from exc
    except Exception as exc:
        logging.error("Couldn't create the Postgres connection: %s", exc)
        raise


def copy_csv_to_table():
    conn = get_postgres_conn()
    conn.autocommit = True
    cursor = conn.cursor()
    copy_csv = '''
               COPY finwiz_result (No_,
    Ticker,
    Company,
    Sector,
    Industry,
    Country_Market,
    P_E,
    Price,
    Change_,
    Volume,
    Full_date,
    Full_date_ticker,
    Volume_mean,
    Volume_std,
    Mean,
    St_dev,
    z_score,
    z_score_price,
    abs_z_score
)
               FROM '/opt/airflow/dags/output_files/finviz_date.csv'
               DELIMITER ','
               CSV HEADER;
               '''
    cursor.execute(copy_csv)
    cursor.close()
    conn.close()


def write_df_to_postgres():
    """
    Create the dataframe and write to Postgres table if it doesn't already exist
    """
    conn = get_postgres_conn()
    cur = conn.cursor()
    logging.info('Postgres server connection is successful')

    df = pd.read_csv('/opt/airflow/dags/output_files/finviz_date.csv')
    df = df.head(10)
    inserted_row_count = 0

    insert_sql = """INSERT INTO finwiz_result (No_,
    Ticker,
    Company,
    Sector,
    Industry,
    Country,
    Market,
    P_E,
    Price,
    Change_,
    Volume,
    Full_date,
    Full_date_ticker,
    Volume_mean,
    Volume_std,
    Mean,
    St_dev,
    z_score,
    z_score_price,
    abs_z_score
) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""

    for _, row in df.iterrows():
        values = [
            int(row[0]),
            str(row[1]),
            str(row[2]),
            str(row[3]),
            str(row[4]),
            str(row[5]),
            float(row[6]),
            float(row[7]),
            float(row[8]),
            str(row[9]),
            float(row[10]),
            int(row[11]),
            str(row[12]),
            float(row[13]),
            float(row[14]),
            float(row[15]),
            float(row[16]),
            float(row[17]),
            float(row[18]),
            float(row[19]),
        ]
        cur.execute(insert_sql, values)
        inserted_row_count += 1

    conn.commit()
    cur.close()
    conn.close()

    logging.info(
        f'{inserted_row_count} rows from csv file inserted into finwiz_result table successfully'
    )
