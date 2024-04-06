"""
Read the daily prices from the PostgreSQL database
"""
from dotenv import load_dotenv
import pandas as pd
from securities_load.load.postgresql_database_functions import connect

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
# loading our dataframe
goog = pd.read_sql_query(SQL, con=conn, index_col="price_date")
# closing the connection
conn.close()
# Let’s see if we loaded the df successfully
print(goog.head())
