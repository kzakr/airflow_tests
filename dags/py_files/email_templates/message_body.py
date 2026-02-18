from py_files.get_postgres_data import sql_to_dataframe
from py_files.get_d2d_indicators import get_statistical_metrics_avg, get_statistical_metrics_std
from py_files.email_templates.email_template import get_message_body
from jinja2 import Template
from py_files.postgres_bulk import create_connection
import pandas as pd
import re
   


def get_statistical_results(context, template = get_message_body()):
    body = ""
    for rule in context:
        
        query = f"select * from {rule}_yday where first_price is not null"
        df = sql_to_dataframe(query=query, conn= create_connection())
        df["first_price_result"] =( df["first_price"]/df["price"])*df["base_price"]
        df["last_price_result"] =( df["last_price"]/df["price"])*df["base_price"]
        body += f"<pre>{rule}<br>"
        body += f"{df.to_html()}<br>"
        body += f"Total gain/loss for first record: {(df['first_price_result'].sum())/len(df)}<br>"
        body += f"Total gain/loss for last record: {(df['last_price_result'].sum())/len(df)}<br>"
        print(body)
    message = {"Rule_and_table": body}

    email_content = template.render(message)

    return email_content

def get_statistical_results_2(template = get_message_body()):

    body=''
    query = "select * from statistical_results"
    
    df = sql_to_dataframe(query=query, conn= create_connection())
        
    body += f"{df.to_html()}<br>"
    
    message = {"Rule_and_table": body}
    email_content = template.render(message)

    return email_content


def get_ml_results(files, template = get_message_body()):
    body = ""
    for file in files:
        
        param = re.search('(?<=__)(.*)', file)[0]
        param = param.replace(".csv", "")
        
        df = pd.read_csv(file)
        tickers = df["ticker"].to_list()
        df_avg = sql_to_dataframe(query=get_statistical_metrics_avg(ticker_conditions= tickers), conn= create_connection())
        df_std =  sql_to_dataframe(query=get_statistical_metrics_std(ticker_conditions= tickers), conn= create_connection())

        df = df.merge(df_avg, left_on = 'ticker', right_on = 'ticker')
        df = df.merge(df_std, left_on = 'ticker', right_on = 'ticker')
        len_of_1 = len(df[df["difference"]>0])
        len_of_0 = len(df[df["difference"]<=0])
        body += f"<br>{param}<br>"
        body += f"{df.to_html()}<br>"
        body += f"Total count for positive result: {len_of_1}<br>"
        body += f"Total count for negative result: {len_of_0}<br>"
        print(body)
    message = {"Rule_and_table": body}

    email_content = template.render(message)

    return email_content