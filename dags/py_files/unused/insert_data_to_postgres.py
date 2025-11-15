
def copy_csv_to_table():
    conn = psycopg2.connect(database='airflow',user='airflow',password='airflow',
                            host='host.docker.internal',port='5432')
    conn.autocommit = True
    cursor = conn.cursor()
    copy_csv = '''
               COPY finwiz_result (No_,
    Ticker,
    Company,
    Sector	,
    Industry,
    Country_Market,
    P_E,
    Price 	,
    Change_	,
    Volume	,
    Full_date ,
    Full_date_ticker ,
    Volume_mean ,
    Volume_std ,
    Mean ,
    St_dev ,
    z_score ,
    z_score_price,
    abs_z_score
)
               FROM '\opt\airflow\dags\output_files\finviz_date.csv'
               DELIMITER ','
               CSV HEADER;
               '''
    cursor.execute(copy_csv)
    conn.close()

def write_df_to_postgres():
    """
    Create the dataframe and write to Postgres table if it doesn't already exist
    """
    try:
        conn = psycopg2.connect(
            host='host.docker.internal',
            database='airflow',
            user='airflow',
            password='airflow',
            port=5432
        )
        cur = conn.cursor()
        logging.info('Postgres server connection is successful')
    except Exception as e:
        
        logging.error("Couldn't create the Postgres connection")

    df = pd.read_csv('/opt/airflow/dags/output_files/finviz_date.csv')
    df=df.head(10)
    inserted_row_count = 0

    for _, row in df.iterrows():
        #tbl_qry = "SELECT id,dag_id,queued_at,execution_date,start_date,end_date,state,run_id,creating_job_id,external_trigger,run_type,conf,data_interval_start,data_interval_end,last_scheduling_decision,dag_hash,log_template_id,updated_at FROM dag_run;"
        #print(tbl_qry)
        ##count_query = f"""SELECT COUNT(*) FROM finviz_result"""
        #cur.execute(tbl_qry)
        #result = cur.fetchone()
        result = []
        result.append(0)
        if result[0] == 0:
            inserted_row_count += 1
            cur.execute("""INSERT INTO finwiz_result (No_,
    Ticker,
    Company,
    Sector	,
    Industry,
    Country,
    Market,
    P_E,
    Price 	,
    Change_	,
    Volume	,
    Full_date ,
    Full_date_ticker ,
    Volume_mean ,
    Volume_std ,
    Mean ,
    St_dev ,
    z_score ,
    z_score_price,
    abs_z_score
) VALUES (%s, %s, %s,%s, %s, %s,%s, %s, %s,%s, %s, %s,%s, %s, %s, %s, %s, %s, %s, %s)""", 
            (int(row[0]), str(row[1]), str(row[2]), str(row[3]), str(row[4]), str(row[5]), float(row[6]), float(row[7]), float(row[8]), str(row[9]), float(row[10]), int(row[11]), str(row[12]), float(row[13])
             , float(row[14]), float(row[15]), float(row[16]), float(row[17]) , float(row[18]), float(row[19])))

    logging.info(f' {inserted_row_count} rows from csv file inserted into churn_modelling table successfully')
