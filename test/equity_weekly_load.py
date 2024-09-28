"""
Date: 16/10/2023
Author: Rob Bebbington

Get the data from polygon and load it into the local polygon database.
"""

from dotenv import load_dotenv

import securities_load.load_polygon.equity_load_daily_prices as eldp
import securities_load.load_polygon.equity_load_dividends as eld
import securities_load.load_polygon.equity_load_exchanges as ele
import securities_load.load_polygon.equity_load_splits as els
import securities_load.load_polygon.equity_load_ticker_types as eltt
import securities_load.load_polygon.equity_load_tickers as elt
from securities.postgresql_database_functions import connect

load_dotenv()

# Open a connection
conn = connect()

eltt.load_ticker_types()
ele.load_exchanges()
elt.load_tickers()
els.load_splits()
eld.load_dividends()
eldp.load_daily_prices()
