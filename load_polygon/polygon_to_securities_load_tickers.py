"""
Date: 22/9/2024
Author: Rob Bebbington

Get the daily_price data from the local polygon schema and load it into the local securities schema.
"""

from dotenv import load_dotenv

from securities_load.load_polygon.polygon_to_securities_table_functions import (
    add_etp_tickers,
    add_stock_tickers,
)
from securities_load.securities.postgresql_database_functions import connect


def load_tickers():
    """
    Read the polygon daily_prices table and insert/update the
    data into the securities ohlcv table.
    """

    load_dotenv()

    # Open a connection
    conn = connect()

    add_stock_tickers(conn)
    add_etp_tickers(conn)
    # Close the connection
    conn.close()
