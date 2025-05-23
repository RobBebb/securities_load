import logging

import pandas as pd
from sqlalchemy import Engine

from securities_load.securities.securities_table_functions import (
    get_ticker_id,
    get_watchlist_id_from_code,
)

logger = logging.getLogger(__name__)


def read_watchlist_tickers(watchlist_csv_file: str) -> pd.DataFrame:
    """Read the watchlists.csv text file. This file id a list of watchlists and their constituent tickers"""
    logger.debug("Started")
    # Read in the watcjlist csv file
    watchlist_tickers = pd.read_csv(watchlist_csv_file)
    logger.debug("File read")
    return watchlist_tickers


def transform_watchlist_tickers(
    engine: Engine, watchlist_tickers: pd.DataFrame
) -> pd.DataFrame:
    logger.debug("Started")

    watchlist_tickers["watchlist_id"] = watchlist_tickers["watchlist_name"].apply(
        lambda x: get_watchlist_id_from_code(engine, x)
    )
    print(watchlist_tickers.head())
    print(f"Data types: {watchlist_tickers.dtypes}")
    # watchlist_tickers["ticker_id"] = watchlist_tickers[
    #     ["exchange_code", "ticker"]
    # ].apply(lambda x: get_ticker_id(engine, *x), axis=1)
    watchlist_tickers["exchange_code"] = watchlist_tickers["exchange_code"].astype(str)
    watchlist_tickers["ticker"] = watchlist_tickers["ticker"].astype(str)
    watchlist_tickers["ticker_id"] = [
        get_ticker_id(engine, row.exchange_code, row.ticker)  # type: ignore
        for row in watchlist_tickers.itertuples()
    ]
    watchlist_tickers.drop(
        columns=["watchlist_group_name", "watchlist_name", "exchange_code", "ticker"],
        inplace=True,
    )
    watchlist_tickers["watchlist_id"] = watchlist_tickers["watchlist_id"].astype(float)
    watchlist_tickers["ticker_id"] = watchlist_tickers["ticker_id"].astype(float)
    print(watchlist_tickers.head())
    print(watchlist_tickers.tail())
    return watchlist_tickers
