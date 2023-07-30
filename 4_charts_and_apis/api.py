import requests
import pandas as pd
from datetime import datetime, timedelta
from airflow.decorators import task, dag
from utlis.setup_logger import setup_logging
from utils.default_args import default_args

logger = setup_logging()

@task
def api():
    url = "https://api.covid19api.com/country/singapore"
    params = {"from": "2020-01-01T00:00:00Z"}

    current_path = '/opt/airflow'
    try:
        response = requests.get(url, params=params)
        response.raise_for_status()
        data = response.json()
        df = pd.DataFrame.from_records(data)
        df.to_csv(f'{current_path}/4_charts_and_apis/singapore_covid19_data.csv', index = False)
    except requests.exceptions.HTTPError as error:
        logger.error(f"Error fetching data from API endpoint: %s", error)

@dag("4_charts_and_apis", start_date=datetime(2023, 7, 30), schedule_interval=timedelta(days=1), default_args=default_args, catchup=False)

api_task = api()

api_task