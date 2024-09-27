"""
Date: 23/10/2023
Author: Rob Bebbington

Get the data from polygon and load it into the local polygon database.
"""

from dotenv import load_dotenv

import securities_load.load_polygon.equity_load_daily_prices as eldp
from securities_load.load_polygon.postgresql_database_functions import connect

load_dotenv()

# Open a connection
conn = connect()

# last updated 25/07/2023
# exchange_data = get_exchanges()
# if exchange_data is not None:
#     add_exchanges(conn, exchange_data)

# # last updated 25/07/2023
# ticker_type_data = polygon_rest_functions.get_ticker_types()
# if ticker_type_data is not None:
#     polygon_table_functions.add_ticker_types(conn, ticker_type_data)

# # last updated 5/10/2023
eldp.load_daily_prices()
