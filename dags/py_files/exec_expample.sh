#!/bin/bash

mypath=$(pwd)
# Path to the Python interpreter in the virtual environment
VENV_PATH="${AIRFLOW_EXAMPLES}.venv/bin/python"
# Path to the Python script to be executed
SCRIPT_PATH="${AIRFLOW_EXAMPLES}example/example.py"
# Activate the virtual environment and run the Python script
$VENV_PATH $SCRIPT_PATH