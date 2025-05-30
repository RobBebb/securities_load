"""
Date: 7/08/2023
Author: Rob Bebbington

Get the data from polygon and load it into the local polygon database.
"""

import logging
from datetime import datetime, timedelta

from securities_load.load_polygon.polygon_rest_functions import (
    get_ohlcv,
    get_ohlcv_by_date,
)
from securities_load.load_polygon.polygon_table_functions import add_ohlcv
from securities_load.securities.postgresql_database_functions import connect

logger = logging.getLogger(__name__)


def load_ohlcvs(days=2):
    """
    Using the polygon API get the splits for the last specified number of days
    and insert them into the local polygon split table
    """

    logger.debug("Started")

    # Open a connection
    conn = connect()

    start = 1
    stop = days + 1

    # Loop through the previous days
    for day in range(start, stop):
        # Get a dataframe of data from polygon
        ohlcv_data = get_ohlcv(days=day)
        # Write the data to the local polygon database
        if ohlcv_data is not None:
            # print(ohlcv_data.shape)
            add_ohlcv(conn, ohlcv_data)

    # Close the connection
    conn.close()
    logger.debug("Finished")


def load_ohlcvs_by_date(start_date="2022-01-01", end_date="2022-12-31"):
    """
    Using the polygon API get the splits for the last specified number of days
    and insert them into the local polygon split table
    """

    logger.debug("Started")

    # Open a connection
    conn = connect()

    start = datetime.strptime(start_date, "%Y-%m-%d")
    end = datetime.strptime(end_date, "%Y-%m-%d")
    date_array = (start + timedelta(days=x) for x in range(0, (end - start).days))

    # Loop through the previous days
    for date_object in date_array:
        logger.debug(f"load_ohlcvs_by_date date is {date_object}")
        # Get a dataframe of data from polygon
        ohlcv_data = get_ohlcv_by_date(date_object)
        # Write the data to the local polygon database
        if ohlcv_data is not None:
            add_ohlcv(conn, ohlcv_data)

    # Close the connection
    conn.close()
    logger.debug("Finished")
