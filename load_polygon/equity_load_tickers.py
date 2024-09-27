"""
Date: 22/10/2023
Author: Rob Bebbington

Get the ticker data from the local polygon schema and
load it into the local equity schema.
"""

from dotenv import load_dotenv

from securities_load.load_polygon.equity_table_functions import add_tickers
from securities_load.load_polygon.postgresql_database_functions import connect


def load_tickers():
    """
    Read the polygon ticker table and insert/update the
    data into the equity ticker table.
    """

    load_dotenv()

    # Open a connection
    conn = connect()

    add_tickers(conn)

    # Close the connection
    conn.close()
