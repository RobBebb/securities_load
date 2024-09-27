"""
Date: 16/10/2023
Author: Rob Bebbington

Get the data from polygon and load it into the local polygon database.
"""

import logging

from dotenv import load_dotenv

from securities_load.load_polygon.polygon_table_functions import read_tickers
from securities_load.load_polygon.polygon_to_securities_table_functions import (
    get_currency_code,
)
from securities_load.load_polygon.postgresql_database_functions import connect

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
tickers = read_tickers(conn, "crypto")
print(tickers.head())
tickers.loc[tickers.currency_name == "United States Dollar", "currency_name"] = (
    "US Dollar"
)
print(tickers.head())

# name = get_currency_code(conn, 'New ZEALAND dollar')
# print(name)

# Close the connection
conn.close()
