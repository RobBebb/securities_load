"""
Date: 24/10/2023
Author: Rob Bebbington

Get daily data from polygon and insert it into our database.
"""

from os import lseek

from dotenv import load_dotenv

import securities_load.load_polygon.polygon_load_ohlcv as plo
from securities_load.load_polygon.postgresql_database_functions import connect

load_dotenv()

# Open a connection
conn = connect()

plo.load_ohlcvs(days=14)

# Close the connection
conn.close()
