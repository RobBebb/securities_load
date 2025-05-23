from dotenv import load_dotenv

from securities_load.securities.add_exchange_to_watchlist import (
    add_exchange_to_watchlist,
)

load_dotenv()

add_exchange_to_watchlist(
    "/home/ubuntuuser/karra/securities_load/data/stocks_in_indices.csv", "USD"
)
