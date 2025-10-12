from airflow import DAG
from airflow.operators.python import PythonOperator, BranchPythonOperator
#from airflow.operators.branch_operator import BaseBranchOperator
from airflow.operators.bash import BashOperator
import datetime
from py_files.get import ChromebrowserOption, OpenChromeBrowser, StockResults



def _webdriver_options():
    Chromebrowser = ChromebrowserOption()
    Chromebrowser.initialize_chrom_options()
    chrome_options = Chromebrowser.get_options()
    return chrome_options
    
def _launch_driver(ti):
    ti_chrome_options = ti.xcom_pull(task_ids = [get_webdriver_options])
    ChromeBrowser_page = OpenChromeBrowser()
    launched_driver = ChromeBrowser_page.open_chrome(ti_chrome_options)
    return launched_driver

def _sacn_finwiz(ti):
    ti_launched_driver = ti.xcom_pull(task_ids = [get_chromedrive])
    res = StockResults()
    res.run_process(how_many = res.how_many_to_repeat(how_many = 10), 
                    grid = res.specify_grid(from_param = 1, to_param = 9921, interval_param = 20), 
                    launched_driver = ti_launched_driver, 
                    url = r"https://finviz.com/screener.ashx?v=111&r="
                    )



with DAG(dag_id = "scanfile", start_date=datetime.datetime(2021, 1, 1), schedule="@daily", catchup = False) as dag:

    get_webdriver_options = PythonOperator(

        task_id = "get_webdriver_options",
        python_callable = _webdriver_options
    )
    
    get_chromedrive = PythonOperator(

        task_id = "get_chromedrive",
        python_callable = _launch_driver
    )

    scan_finwiz = PythonOperator(

        task_id = "scan_finwiz",
        python_callable = _sacn_finwiz
    )
    
    
    get_webdriver_options>>get_chromedrive>>scan_finwiz