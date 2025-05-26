"""
Date: 2/10/2024
Author: Rob Bebbington

Use airflow to schedule a daily run to get ohlcv prices for asx stoxks from yahoo.
"""

from datetime import datetime

from airflow.models import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

import load_asx.load_ohlcv_from_yahoo as lao

with DAG(
    dag_id="daily_aus_pipeline_dag",
    start_date=datetime(2023, 8, 6),
    # zero minute of at 8 o'clock in the morning from monday to saturday
    schedule_interval="0 8 * * 0-4",
    catchup=False,
) as dag:
    load_asx_ohlcvs = PythonOperator(
        task_id="polygon_load_ohlcvs",
        python_callable=lao.load_asx_ohlcv_from_yahoo,
        op_kwargs={"periods": "5d"},
    )
