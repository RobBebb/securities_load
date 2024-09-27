"""
Date: 5/10/2023
Author: Rob Bebbington

Use airflow to schedule a daily run to refresh/update the polygon tables.
"""

from datetime import datetime

from airflow.models import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

import securities_load.load_polygon.polygon_load_ohlcv as plo
import securities_load.load_polygon.polygon_to_securities_load_ohlcvs as psldp

with DAG(
    dag_id="daily_pipeline_dag",
    start_date=datetime(2023, 8, 6),
    # zero minute of at 8 o'clock in the morning from monday to saturday
    schedule_interval="0 22 * * 1-5",
    catchup=False,
) as dag:
    truncate_daily_polygon_tables = SQLExecuteQueryOperator(
        task_id="truncate_daily_polygon_tables",
        conn_id="postgres_securities",
        sql="sql/truncate_daily_polygon_tables.sql",
        autocommit=True,
    )
    polygon_load_ohlcvs = PythonOperator(
        task_id="polygon_load_ohlcvs",
        python_callable=plo.load_ohlcvs,
        op_kwargs={"days": 3},
    )
    polygon_to_securities_load_ohlcvs = PythonOperator(
        task_id="polygon_to_securities_load_daily_prices",
        python_callable=psldp.load_ohlcvs,
    )

    truncate_daily_polygon_tables >> polygon_load_ohlcvs
    polygon_load_ohlcvs >> polygon_to_securities_load_ohlcvs
