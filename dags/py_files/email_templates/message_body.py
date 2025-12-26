from py_files.get_postgres_data import sql_to_dataframe
from py_files.email_templates.email_template import get_message_body
from jinja2 import Template
from py_files.postgres_bulk import create_connection

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