import os
import pandas as pd
from airflow.decorators import task, dag
from airflow.operators.postgres_operator import PostgresOperator
from datetime import datetime, timedelta
from utlis.setup_logger import setup_logging
from utlis.postgres_writer import write_to_postgres
from utils.default_args import default_args

logger = setup_logging()

@task
def process_csv(datasets):
    """
    Read and process csv
    """
    current_path = '/opt/airflow'

    for dataset in datasets:
        try:
            # Read CSV from parent path
            df = pd.read_csv(f'{current_path}/{dataset}')

            # Remove any rows which do not have a name field
            has_name = (df['name'].notna())

            # remove any zeros prepended to the price field
            above_0 = (df['price'] > 0)

            clean_df = df[above_0 & has_name]

            # split the name field into first_name and last name
            clean_df[['first_name','last_name']] = clean_df['name'].apply(split_name)


            # Create a new field name above_100, which is true if the price is strictly greater than 100
            clean_df["above_100"] = clean_df['price'] > 100


            # Reorganize the dataframe
            output_df = clean_df[['first_name', 'last_name', 'price', 'above_100']]

            # Write results to csv
            write_output_csv(output_df, current_path, dataset)

            # Write results to postgres
            write_to_postgres(output_df, "processed_data")
            logger.info('Job Done')
    
        except Exception as error:
            logger.error('Error Message: %s', error)

def split_name(name):
    """
    Split name to first and last name
    """
    parts = name.split()
    # All names before the last name are considered as first name
    first_name = ' '.join(parts[:-1])
    last_name = parts[-1]
    return pd.Series({'first_name': first_name, 'last_name': last_name})

def write_output_csv(output_df, current_path, dataset):
    """
    Write results to csv
    """    

    output_path = f'{current_path}/results'
    # create directory if not exist
    os.makedirs(output_path, exist_ok=True)

    # write to respective path
    output_df.to_csv(f'{output_path}/{dataset}', index=False)

@dag("1_data_pipeline", start_date=datetime(2023, 7, 30), schedule_interval=timedelta(days=1), default_args=default_args, catchup=False)
def data_pipeline_dag():
    create_table_task = PostgresOperator(
        task_id="create_table",
        postgres_conn_id="postgres",
        sql="""
            CREATE TABLE IF NOT EXISTS processed_data (
                first_name VARCHAR(50),
                last_name VARCHAR(50),
                price NUMERIC(10,2),
                above_100 BOOLEAN
            );
        """
    )

    process_csv_task = process_csv(["dataset1.csv", "dataset2.csv"])

    create_table_task >> process_csv_task

data_pipeline_dag = data_pipeline_dag()