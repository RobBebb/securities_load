"""
Date: 22/10/2023
Author: Rob Bebbington

Get the dividend data from the local polygon schema and load it into the local equity schema.
"""

from dotenv import load_dotenv

from securities_load.load_polygon.equity_table_functions import add_dividends
from securities_load.load_polygon.postgresql_database_functions import connect


def load_dividends():
    """
    Read the polygon dividend table and insert/update the
    data into the equity dividend table.
    """

    load_dotenv()

    # Open a connection
    conn = connect()

    add_dividends(conn)

    # Close the connection
    conn.close()
