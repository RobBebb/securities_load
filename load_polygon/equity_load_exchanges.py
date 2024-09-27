"""
Date: 19/10/2023
Author: Rob Bebbington

Get the exchange data from the local polygon schema and load it into the local equity schema.
"""

from dotenv import load_dotenv

from securities_load.load_polygon.equity_table_functions import add_exchanges
from securities_load.load_polygon.postgresql_database_functions import connect


def load_exchanges():
    """
    Read the polygon exchange table and insert/update the
    data into the equity exchange table.
    """

    load_dotenv()

    # Open a connection
    conn = connect()

    add_exchanges(conn)

    # Close the connection
    conn.close()
