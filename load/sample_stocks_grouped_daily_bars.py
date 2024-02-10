"""
Get the open, high, low, close, volume for all stocks
"""
import os
import datetime
from dotenv import load_dotenv

from polygon import RESTClient
from polygon.rest.models import (
    GroupedDailyAgg,
)


# docs
# https://polygon.io/docs/stocks/get_v2_aggs_grouped_locale_us_market_stocks__date
# https://polygon-api-client.readthedocs.io/en/latest/Aggs.html#get-grouped-daily-aggs

# client = RESTClient("XXXXXX") # hardcoded api_key is used
load_dotenv()

key = os.environ["POLYGON"]
print(f"key: {key}")
client = RESTClient(
    f"{os.environ['POLYGON']}"
)  # POLYGON_API_KEY environment variable is used


groupedDailyAggs = client.get_grouped_daily_aggs(
    "2023-05-03",
)
data = []

# writing data
for agg in groupedDailyAggs:
    # verify this is an agg
    if isinstance(agg, GroupedDailyAgg):
        # verify this is an int
        if isinstance(agg.timestamp, int):
            new_record = {
                "ticker": agg.ticker,
                "open": agg.open,
                "high": agg.high,
                "low": agg.low,
                "close": agg.close,
                "volume": agg.volume,
                "vwap": agg.vwap,
                "timestamp": agg.timestamp,
            }

            data.append(new_record)
stock = data[0]
print(stock["ticker"])
timestamp = stock["timestamp"]
your_dt = datetime.datetime.fromtimestamp(int(timestamp) / 1000)
print(your_dt.strftime("%Y-%m-%d %H:%M:%S"))
