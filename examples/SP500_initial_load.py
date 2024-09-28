"""
Date: 29/04/2023
Author: Rob Bebbington

Get S&P500 sysmbols from Wikipedia and insert them into our database.
"""

import SP500_initial_functions as SP500_initial_functions
from dotenv import load_dotenv

from securities.postgresql_database_functions import connect

load_dotenv()

# Open a connection
conn = connect()

symbols = SP500_initial_functions.obtain_parse_wiki_snp500()
SP500_initial_functions.insert_snp500_symbols(conn, symbols)
print(f"{len(symbols)} symbols were successfully added.")

# Close the connection
conn.close()
