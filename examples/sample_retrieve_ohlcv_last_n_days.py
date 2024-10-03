"""
Date: 16/10/2023
Author: Rob Bebbington

Get the data from polygon and load it into the local polygon database.
"""

import logging

from dotenv import load_dotenv

from securities_load.securities.postgresql_database_functions import connect
from securities_load.securities.securities_table_functions import (
    retrieve_ohlcv_last_n_days,
)

logger = logging.getLogger(__name__)
logging.basicConfig(
    filename="securities_load.log",
    filemode="w",
    encoding="utf-8",
    level=logging.DEBUG,
    format="{asctime} - {name}.{funcName} - {levelname} - {message}",
    style="{",
)
logger.info("Start")

load_dotenv()

# Open a connection
conn = connect()
tickers = retrieve_ohlcv_last_n_days(conn, "XNAS", "GOOGL", 5)

print(tickers.head())
print(tickers.info())
