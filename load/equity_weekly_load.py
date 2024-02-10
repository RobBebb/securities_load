"""
Date: 16/10/2023
Author: Rob Bebbington

Get the data from polygon and load it into the local polygon database.
"""

from dotenv import load_dotenv

from postgresql_database_functions import connect
import equity_load_ticker_types as eltt
import equity_load_exchanges as ele
import equity_load_tickers as elt
import equity_load_splits as els
import equity_load_dividends as eld
import equity_load_daily_prices as eldp


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
# eltt.load_ticker_types()
# ele.load_exchanges()
# elt.load_tickers()
# els.load_splits()
eld.load_dividends()
# eldp.load_daily_prices()
