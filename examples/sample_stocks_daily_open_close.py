import os
from dotenv import load_dotenv

from polygon import RESTClient

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

# make request
request = client.get_daily_open_close_agg(
    "AAPL",
    "2023-02-07",
)

print(request)
