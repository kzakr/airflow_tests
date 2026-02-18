
import smtplib
from pydantic import BaseModel
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


class EmailOperator:
    def __init__(self, sender_email:str, password: str):
        self.sender_email= sender_email
        self.password = password
        self.server = 'smtp.gmail.com'
        self.port = 587

    def initialize_session(self):
        session = smtplib.SMTP(self.server, self.port)        
        
        session.starttls()
        
        session.login(self.sender_email, self.password)
        return session
         

class MessageOperator(EmailOperator):

    def bulid_base_msg(self):
        self.msg = MIMEMultipart()
        
    def get_sender(self):

        self.msg["From"] = self.sender_email

    def create_recepient_list(self, recepient_list):

        self.msg["To"] = recepient_list

    def get_subject(self, subject_text:str):

        self.msg["Subject"] = subject_text

    def get_body(self, body_text:str):

        self.msg.attach(MIMEText(body_text, "html"))
        #self.msg_body = body_text

    def release_message(self, session):

        session.sendmail(self.sender_email, self.msg["To"], self.msg.as_string())



        