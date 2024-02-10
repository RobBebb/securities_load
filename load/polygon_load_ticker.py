"""
Date: 7/08/2023
Author: Rob Bebbington

Get the data from polygon and load it into the local polygon database.
"""

from dotenv import load_dotenv

from postgresql_database_functions import connect
from polygon_rest_functions import get_tickers
from polygon_table_functions import add_tickers


def load_tickers():
    """
    Using the polygon API get the tickers
    and insert them into the local polygon ticker table
    """

    load_dotenv()

    # Open a connection
    conn = connect()

    # Get a dataframe of data from polygon
    ticker_data = get_tickers()
    # Write the data to the local polygon database
    if ticker_data is not None:
        add_tickers(conn, ticker_data)

    # Close the connection
    conn.close()
