"""
Date: 23/10/2023
Author: Rob Bebbington

Get the data from polygon and load it into the local polygon database.
Parameters:
    start_date - the earliest date to get stock prices
    end_date - the day after the last date to get stock prices 

"""

from dotenv import load_dotenv

import securities_load.load_polygon.polygon_load_ohlcv as plo
from securities.postgresql_database_functions import connect

load_dotenv()

# Open a connection
conn = connect()

plo.load_ohlcvs_by_date(start_date="2024-02-16", end_date="2024-04-01")
