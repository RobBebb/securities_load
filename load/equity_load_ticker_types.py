"""
Date: 6/08/2023
Author: Rob Bebbington

Get the ticker_type data from the local polygon schema and load it into the local equity schema.
"""

from dotenv import load_dotenv

from securities_load.load.postgresql_database_functions import connect
from securities_load.load.equity_table_functions import add_ticker_types


def load_ticker_types():
    """
    Read the polygon ticker_type table and insert/update the
    data into the equity ticker_type table.
    """

    load_dotenv()

    # Open a connection
    conn = connect()

    # if ticker_type_data is not None:
    add_ticker_types(conn)

    # Close the connection
    conn.close()
