"""
Date: 7/05/2023
Author: Rob Bebbington

Get static files from polygon and insert them into our database.
"""

from dotenv import load_dotenv

from securities_load.load.postgresql_database_functions import connect
import polygon_load_split as pls
import polygon_load_exchange as ple
import polygon_load_ticker as plt
import polygon_load_ticker_type as pltt
import polygon_load_dividend as pld
import polygon_load_ohlcv as plo

load_dotenv()

# Open a connection
conn = connect()

pls.load_splits(days=1825)
pld.load_dividends(days=1825)
ple.load_exchanges()
plt.load_tickers()
pltt.load_ticker_types()
plo.load_ohlcvs(days=20)
# ticker_data = polygon_rest_functions.get_tickers()
# if ticker_data is not None:
#     polygon_table_functions.add_tickers(conn, ticker_data)

# # # last updated 25/07/2023
# ohlcv_data = polygon_rest_functions.get_ohlcv()
# if ohlcv_data is not None:
#     polygon_table_functions.add_ohlcv(conn, ohlcv_data)

# # # last updated 5/10/2023
# pls.load_splits()
# split_data = polygon_rest_functions.get_splits()
# if split_data is not None:
#     polygon_table_functions.add_splits(conn, split_data)

# # last updated 25/07/2023
# dividend_data = get_dividends()
# if dividend_data is not None:
#     add_dividends(conn, dividend_data)

# Close the connection
conn.close()
