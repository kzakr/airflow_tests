FROM apache/airflow:3.1.0

WORKDIR /opt/airflow
COPY pyproject.toml uv.lock ./
RUN pip install --no-cache-dir uv && uv sync
ENV PATH="/opt/airflow/.venv/bin:${PATH}"
ENV AIRFLOW_HOME=/opt/airflow/py_files
ENV PYTHONPATH="${PYTHONPATH}:${AIRFLOW_HOME}"

RUN apt-get update && apt-get install -y python-pip && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -U scikit-learn scipy matplotlib psycopg2-binary

COPY dags /opt/airflow/dags
COPY py_files /opt/airflow/py_files
COPY config /opt/airflow/config
COPY plugins /opt/airflow/plugins
#COPY external_scheduler.py /opt/airflow/external_scheduler.py
#COPY external_scheduler_config.json /opt/airflow/external_scheduler_config.json
COPY base.py base.py

CMD ["python", "base.py"]