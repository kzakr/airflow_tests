FROM apache/airflow:3.1.0
ADD requirements.txt .
RUN pip install apache-airflow==3.1.0 -r requirements.txt

ENV AIRFLOW_HOME=/opt/airflow/py_files
ENV PYTHONPATH "${PYTHONPATH}:${AIRFLOW_HOME}"

WORKDIR /opt/airflow
RUN apt-get update
RUN apt-get -y install python-pip
RUN apt-get update
RUN pip install --upgrade pip
RUN pip install -U scikit-learn scipy matplotlib
RUN pip install psycopg2-binary


COPY base.py base.py

CMD ["python", "base.py"]