"""
Get symbols and load the data
"""
from datetime import datetime as dt
import time
from dotenv import load_dotenv
from securities_load.load.postgresql_database_functions import connect
import SP500_daily_functions as SP500_daily_functions
from dateutil.relativedelta import relativedelta


TICKER_COUNT = 505  # Change this to 500+ (503 currently) to download all tickers
WAIT_TIME_IN_SECONDS = 1.0  # Adjust how frequently the API is called
YEARS = 1  # Adjust the number of years to get data for

load_dotenv()

# Open a connection
conn = connect()

# Loop over the tickers and insert the daily historical
# data into the database
tickers = SP500_daily_functions.obtain_list_of_db_tickers(conn)[:TICKER_COUNT]
len_tickers = len(tickers)

# Stores the current time, for the created_at field
now = dt.utcnow()

end_date = f"{now.year}-{now.month}-{now.day}"
print(end_date)

start_date = now - relativedelta(years=YEARS)
start_date = f"{start_date.year}-{start_date.month}-{start_date.day}"
print(start_date)

for i, t in enumerate(tickers):
    print(f"adding data for {t[1]}: {i+1} out of {len_tickers}.")
    yf_data = SP500_daily_functions.get_daily_historic_data_yahoo_finance(
        t[1], start=start_date, end=end_date
    )
    # print(yf_data.head())
    # print(yf_data.tail())
    if len(yf_data.index) > 0:
        SP500_daily_functions.insert_daily_data_into_db(conn, "1", t[0], yf_data)
    else:
        print(f"No data available for {t[1]}")
    time.sleep(WAIT_TIME_IN_SECONDS)

print("Successfully added Yahoo Finance data to database.")

# Close the connection
conn.close()
