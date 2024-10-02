import logging

import pandas as pd
import yfinance as yf
from pyrate_limiter import Duration, Limiter, RequestRate
from requests import Session
from requests_cache import CacheMixin, SQLiteCache
from requests_ratelimiter import LimiterMixin, MemoryQueueBucket

from securities_load.securities.postgresql_database_functions import connect
from securities_load.securities.securities_table_functions import (
    add_or_update_ohlcvs,
    get_data_vendor_id,
    get_tickers_using_exchange_code,
)

logger = logging.getLogger(__name__)


def load_asx_ohlcv(period: str = "5d") -> None:
    """_summary_

    Args:
        period (str): 1d, 5d, 1mo, 3mo, 6mo, 1y, 2y, 5y, 10y, ytd, max
    """

    # disable chained assignments
    pd.options.mode.chained_assignment = None
    logger.info("Chained assignments disabled")

    # Open a connection
    conn = connect()

    class CachedLimiterSession(CacheMixin, LimiterMixin, Session):
        pass

    session = CachedLimiterSession(
        limiter=Limiter(
            RequestRate(2, Duration.SECOND * 6)
        ),  # max 2 requests per 6 seconds
        bucket_class=MemoryQueueBucket,
        backend=SQLiteCache("yfinance.cache"),
    )

    data_vendor_id = get_data_vendor_id(conn, "Yahoo")

    tickers = get_tickers_using_exchange_code(conn, "XASX")

    for ticker_tuple in tickers:
        ticker_id = ticker_tuple[0]
        yahoo_ticker = ticker_tuple[1]
        if yahoo_ticker in ["CCE.AX", "NVQ.AX"]:
            continue
        yf_ticker = yf.Ticker(yahoo_ticker, session=session)
        message = f"Prcessing ticker: {yahoo_ticker}"
        logger.info(message)
        hist = yf_ticker.history(period=period, repair=True)
        print(hist.head())
        if not hist.empty:
            hist["ticker_id"] = ticker_id
            hist["data_vendor_id"] = data_vendor_id
            hist = hist.reset_index()
            hist = hist.dropna()
            hist_prices = hist[
                [
                    "Date",
                    "Open",
                    "High",
                    "Low",
                    "Close",
                    "Volume",
                    "ticker_id",
                    "data_vendor_id",
                ]
            ]
            hist_prices.columns = [
                "date",
                "open",
                "high",
                "low",
                "close",
                "volume",
                "ticker_id",
                "data_vendor_id",
            ]
            print(hist_prices.head())
            add_or_update_ohlcvs(conn, hist_prices)

    # Close the connection
    conn.close()
