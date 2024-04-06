"""
Date: 22/10/2023
Author: Rob Bebbington

Get the dividend data from the local polygon schema and load it into the local equity schema.
"""

from dotenv import load_dotenv

from securities_load.load.postgresql_database_functions import connect
from securities_load.load.equity_table_functions import add_dividends


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
