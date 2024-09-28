"""
Date: 7/08/2023
Author: Rob Bebbington

Get the data from polygon and load it into the local polygon database.
"""

from dotenv import load_dotenv

from securities_load.load_polygon.polygon_rest_functions import get_dividends
from securities_load.load_polygon.polygon_table_functions import add_dividends
from securities_load.securities.postgresql_database_functions import connect


def load_dividends(days=28):
    """
    Using the polygon API get the dividends for the last specified number of days
    and insert them into the local polygon dividend table
    """

    load_dotenv()

    # Open a connection
    conn = connect()

    # Get a dataframe of data from polygon
    dividend_data = get_dividends(days)
    # Write the data to the local polygon database
    if dividend_data is not None:
        add_dividends(conn, dividend_data)

    # Close the connection
    conn.close()
