"""
Date: 16/10/2023
Author: Rob Bebbington

Get the data from polygon and load it into the local polygon database.
"""

import logging
import os

from dotenv import load_dotenv

schema = os.environ["DB_SCHEMA"]

from securities.postgresql_database_functions import connect
from securities_load.load_polygon.polygon_to_securities_table_functions import (
    add_dividends,
    add_etp_tickers,
    add_ohlcvs,
    add_splits,
    add_stock_tickers,
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

# add_dividends(conn)
# add_splits(conn)
# FIXME For indices duplicates are added as the primary_exchange is NULL.
# Need to find a way around it.
# add_index_tickers(conn)
# add_stock_tickers(conn)
# add_etp_tickers(conn)
add_ohlcvs(conn)

# Close the connection
conn.close()
