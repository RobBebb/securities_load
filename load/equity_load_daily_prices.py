"""
Date: 22/10/2023
Author: Rob Bebbington

Get the daily_price data from the local polygon schema and load it into the local equity schema.
"""

from dotenv import load_dotenv

from securities_load.load.postgresql_database_functions import connect
from securities_load.load.equity_table_functions import add_daily_prices


def load_daily_prices():
    """
    Read the polygon daily_prices table and insert/update the
    data into the equity daily_prices table.
    """

    load_dotenv()

    # Open a connection
    conn = connect()

    add_daily_prices(conn)

    # Close the connection
    conn.close()
