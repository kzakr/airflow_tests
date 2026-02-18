# First let's get jinja2
from jinja2 import Template
import jinja2
# We will need smtplib to connect to our smtp email server
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import os


def get_message_body():
    
    with open(r"/opt/airflow/dags/py_files/email_templates/template.html", "r") as file:
        template_str = file.read()
    environment = jinja2.Environment()
    jinja_template = environment.from_string(template_str)
    
    return jinja_template

# Read the Jinja2 email template





