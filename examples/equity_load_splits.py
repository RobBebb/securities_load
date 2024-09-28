"""
Date: 22/10/2023
Author: Rob Bebbington

Get the split data from the local polygon schema and load it into the local equity schema.
"""

from dotenv import load_dotenv

from securities.postgresql_database_functions import connect
from securities_load.load_polygon.equity_table_functions import add_splits


def load_splits():
    """
    Read the polygon split table and insert/update the
    data into the equity split table.
    """

    load_dotenv()

    # Open a connection
    conn = connect()

    add_splits(conn)

    # Close the connection
    conn.close()
