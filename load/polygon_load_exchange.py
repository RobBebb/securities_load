"""
Date: 7/08/2023
Author: Rob Bebbington

Get the data from polygon and load it into the local polygon database.
"""

from dotenv import load_dotenv

from securities_load.load.postgresql_database_functions import connect
from securities_load.load.polygon_rest_functions import get_exchanges
from securities_load.load.polygon_table_functions import add_exchanges


def load_exchanges():
    """
    Using the polygon API get the exchanges
    and insert them into the local polygon exchange table
    """

    load_dotenv()

    # Open a connection
    conn = connect()

    # Get a dataframe of data from polygon
    exchange_data = get_exchanges()
    # Write the data to the local polygon database
    if exchange_data is not None:
        add_exchanges(conn, exchange_data)

    # Close the connection
    conn.close()
