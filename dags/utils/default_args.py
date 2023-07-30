from datetime import timedelta
from utils.setup_logger import setup_logging

logger = setup_logging()

# Define callback functions
def on_success_task(dict):
    """Log a success message when a task succeeds."""
    logger.info('Task succeeded: %s', dict)

def on_failure_task(dict):
    """Log an error message when a task fails."""
    logger.error('Task failed: %s', dict)

default_args = {
    'owner': 'Airflow',
    'retries':3,
    'retry_delay': timedelta(seconds=60),
    'emails': ['sample@gmail.com'],
    'email_on_failure': True,
    'email_on_retry': True,
    'on_failure_callback': on_failure_task,
    'on_success_callback': on_success_task,
    'execution_time': timedelta(seconds=60)
}