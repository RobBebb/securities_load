"""
Date: 7/05/2023
Author: Rob Bebbington

Get static files from polygon and insert them into our database.
"""

import polygon_load_dividend as pld
import polygon_load_exchange as ple
import polygon_load_ohlcv as plo
import polygon_load_split as pls
import polygon_load_ticker as plt
import polygon_load_ticker_type as pltt
from dotenv import load_dotenv

from securities_load.load_polygon.postgresql_database_functions import connect

load_dotenv()

# Open a connection
conn = connect()

# pls.load_splits(days=1825)
# pld.load_dividends(days=1825)
# ple.load_exchanges()
plt.load_tickers()
# pltt.load_ticker_types()
# plo.load_ohlcvs(days=20)

# Close the connection
conn.close()
