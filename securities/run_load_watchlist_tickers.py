from securities_load.securities.load_watchlist_tickers import load_watchlist_tickers

load_watchlist_tickers("/home/ubuntuuser/karra/securities_load/data/watchlists.csv")


import logging

from dotenv import load_dotenv

from securities_load.securities.load_watchlist_tickers import load_watchlist_tickers

load_dotenv()


logger = logging.getLogger(__name__)

logging.basicConfig(
    filename="load_watchlist_tickers.log",
    filemode="w",
    encoding="utf-8",
    level=logging.INFO,
    format="{asctime} - {name}.{funcName} - {levelname} - {message}",
    style="{",
)

logger.info("Start")

load_watchlist_tickers("/home/ubuntuuser/karra/securities_load/data/watchlists.csv")

logger.info("Finish")
