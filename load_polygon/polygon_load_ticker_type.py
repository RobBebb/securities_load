"""
Date: 6/08/2023
Author: Rob Bebbington

Get the data from polygon and load it into the local polygon database.
"""

from dotenv import load_dotenv

from securities_load.load_polygon.polygon_rest_functions import get_ticker_types
from securities_load.load_polygon.polygon_table_functions import add_ticker_types
from securities_load.load_polygon.postgresql_database_functions import connect


def load_ticker_types():
    """
    Using the polygon API get the ticker types
    and insert them into the local polygon ticker type table
    """

    load_dotenv()

    # Open a connection
    conn = connect()

    # Get a dataframe of data from polygon
    ticker_type_data = get_ticker_types()
    # Write the data to the local polygon database
    if ticker_type_data is not None:
        add_ticker_types(conn, ticker_type_data)

    # Close the connection
    conn.close()
