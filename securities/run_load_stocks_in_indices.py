from dotenv import load_dotenv

from securities_load.securities.load_watchlist_tickers import load_watchlist_tickers

load_dotenv()

load_watchlist_tickers(
    "/home/ubuntuuser/karra/securities_load/data/stocks_in_indices.csv"
)
