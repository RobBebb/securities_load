"""
Date: 7/08/2023
Author: Rob Bebbington

Get the data from polygon and load it into the local polygon database.
"""

from dotenv import load_dotenv

from postgresql_database_functions import connect
from polygon_rest_functions import get_splits
from polygon_table_functions import add_splits


def load_splits(days=28):
    """
    Using the polygon API get the splits for the last specified number of days
    and insert them into the local polygon split table
    """

    load_dotenv()

    # Open a connection
    conn = connect()

    # Get a dataframe of data from polygon
    split_data = get_splits(days)
    # Write the data to the local polygon database
    if split_data is not None:
        add_splits(conn, split_data)

    # Close the connection
    conn.close()
