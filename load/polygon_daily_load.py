"""
Date: 24/10/2023
Author: Rob Bebbington

Get daily data from polygon and insert it into our database.
"""

from os import lseek
from dotenv import load_dotenv

from postgresql_database_functions import connect
import polygon_load_ohlcv as plo

load_dotenv()

# Open a connection
conn = connect()

plo.load_ohlcvs(days=6)

# Close the connection
conn.close()