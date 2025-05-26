"""
Date: 16/10/2023
Author: Rob Bebbington

Get the ohlcv data from my polygon schema and add it into the securities schema
"""

import logging

from dotenv import load_dotenv

from securities_load.load_polygon.polygon_to_securities_table_functions import (
    add_ohlcvs,
)
from securities_load.securities.postgresql_database_functions import connect

load_dotenv()

logger = logging.getLogger(__name__)
logging.basicConfig(
    filename="add_ohlcv_securities_from_polygon_schema.log",
    filemode="w",
    encoding="utf-8",
    level=logging.DEBUG,
    format="{asctime} - {name}.{funcName} - {levelname} - {message}",
    style="{",
)

logger.info("Start")

# Open a connection
conn = connect()

add_ohlcvs(conn)

# Close the connection
conn.close()

logger.info("Finish")
