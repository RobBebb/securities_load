import logging

import pandas as pd

from securities_load.securities.securities_table_functions import (
    get_ticker_id,
    get_watchlist_id_from_code,
)

logger = logging.getLogger(__name__)


def read_watchlist_tickers() -> pd.DataFrame:
    """Read the watchlists.csv text file. This file id a list of watchlists and their constituent tickers"""
    logger.debug("Started")
    # Read in the watcjlist csv file
    watchlist_tickers = pd.read_csv(
        "/home/ubuntuuser/karra/securities_load/data/watchlists.csv"
    )
    logger.debug("File read")
    return watchlist_tickers


def transform_watchlist_tickers(conn, watchlist_tickers: pd.DataFrame) -> pd.DataFrame:
    logger.debug("Started")

    watchlist_tickers["watchlist_id"] = watchlist_tickers["watchlist_name"].map(
        lambda x: get_watchlist_id_from_code(conn, x)
    )
    print(watchlist_tickers.head())
    watchlist_tickers["ticker_id"] = watchlist_tickers[
        ["exchange_code", "ticker"]
    ].apply(lambda x: get_ticker_id(conn, *x), axis=1)
    watchlist_tickers.drop(
        columns=["watchlist_group_name", "watchlist_name", "exchange_code", "ticker"],
        inplace=True,
    )

    return watchlist_tickers
