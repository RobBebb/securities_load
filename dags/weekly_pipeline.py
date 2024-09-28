"""
Date: 26/08/2023
Author: Rob Bebbington

Use airflow to schedule a weekly run to refresh/update the polygon tables.
"""

from datetime import datetime

from airflow.models import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

import securities_load.load_polygon.polygon_load_dividend as pld
import securities_load.load_polygon.polygon_load_exchange as ple
import securities_load.load_polygon.polygon_load_ohlcv as plo
import securities_load.load_polygon.polygon_load_split as pls
import securities_load.load_polygon.polygon_load_ticker as plt
import securities_load.load_polygon.polygon_load_ticker_type as pltt
import securities_load.load_polygon.polygon_to_securities_load_dividends as psld
import securities_load.load_polygon.polygon_to_securities_load_ohlcvs as psldp
import securities_load.load_polygon.polygon_to_securities_load_splits as psls
import securities_load.load_polygon.polygon_to_securities_load_tickers as pslt

with DAG(
    dag_id="weekly_pipeline_dag",
    start_date=datetime(2023, 8, 6),
    # 8:00 in the morning on sundays in Australia
    schedule_interval="0 22 * * 6",
    catchup=False,
) as dag:
    truncate_daily_polygon_tables = SQLExecuteQueryOperator(
        task_id="truncate_daily_polygon_tables",
        conn_id="postgres_securities",
        sql="sql/truncate_daily_polygon_tables.sql",
        autocommit=True,
    )
    truncate_weekly_polygon_tables = SQLExecuteQueryOperator(
        task_id="truncate_weekly_polygon_tables",
        conn_id="postgres_securities",
        sql="sql/truncate_weekly_polygon_tables.sql",
        autocommit=True,
    )
    polygon_load_exchanges = PythonOperator(
        task_id="polygon_load_exchanges",
        python_callable=ple.load_exchanges,
    )
    polygon_load_ticker_types = PythonOperator(
        task_id="polygon_load_ticker_types",
        python_callable=pltt.load_ticker_types,
    )
    polygon_load_tickers = PythonOperator(
        task_id="polygon_load_tickers",
        python_callable=plt.load_tickers,
    )
    polygon_load_dividends = PythonOperator(
        task_id="polygon_load_dividends",
        python_callable=pld.load_dividends,
    )
    polygon_load_splits = PythonOperator(
        task_id="polygon_load_splits",
        python_callable=pls.load_splits,
    )
    polygon_load_ohlcvs = PythonOperator(
        task_id="polygon_load_ohlcvs",
        python_callable=plo.load_ohlcvs,
        op_kwargs={"days": 14},
    )
    polygon_to_securities_load_tickers = PythonOperator(
        task_id="polygon_to_securities_load_tickers",
        python_callable=pslt.load_tickers,
    )
    polygon_to_securities_load_dividends = PythonOperator(
        task_id="polygon_to_securities_load_dividends",
        python_callable=psld.load_dividends,
    )
    polygon_to_securities_load_splits = PythonOperator(
        task_id="polygon_to_securities_load_splits",
        python_callable=psls.load_splits,
    )
    polygon_to_securities_load_ohlcvs = PythonOperator(
        task_id="polygon_to_securities_load_ohlcvs",
        python_callable=psldp.load_ohlcvs,
    )

truncate_daily_polygon_tables >> truncate_weekly_polygon_tables
truncate_weekly_polygon_tables >> polygon_load_exchanges
truncate_weekly_polygon_tables >> polygon_load_ticker_types
polygon_load_ticker_types >> polygon_load_tickers
polygon_load_tickers >> polygon_load_dividends
polygon_load_tickers >> polygon_load_splits
polygon_load_tickers >> polygon_load_ohlcvs
polygon_load_tickers >> polygon_to_securities_load_tickers
polygon_load_splits >> polygon_to_securities_load_splits
polygon_load_dividends >> polygon_to_securities_load_dividends
polygon_load_ohlcvs >> polygon_to_securities_load_ohlcvs
polygon_to_securities_load_tickers >> polygon_to_securities_load_splits
polygon_to_securities_load_tickers >> polygon_to_securities_load_dividends
polygon_to_securities_load_tickers >> polygon_to_securities_load_ohlcvs
