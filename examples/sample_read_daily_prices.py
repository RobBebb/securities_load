"""
Read the daily prices from the PostgreSQL database
"""

import pandas as pd
from dotenv import load_dotenv

from securities.postgresql_database_functions import connect, sqlalchemy_connect

load_dotenv()
# creating a query variable to store our query to pass into the function
SQL = """SELECT dp.price_date, dp.close_price
FROM equity.symbol AS sym
INNER JOIN equity.daily_price AS dp
ON dp.symbol_id = sym.id
WHERE sym.ticker = 'GOOG'
ORDER BY dp.price_date ASC;
"""
# opening the connection
conn = connect()
sqlalchemy_comm = sqlalchemy_connect()
# loading our dataframe
goog = pd.read_sql_query(SQL, con=sqlalchemy_comm, index_col="price_date")
# closing the connection
conn.close()
# Let’s see if we loaded the df successfully
print(goog.head())
