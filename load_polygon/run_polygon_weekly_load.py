"""
Date: 7/05/2023
Author: Rob Bebbington

Get static files from polygon and insert them into our database.
"""

import logging

from dotenv import load_dotenv

import securities_load.load_polygon.polygon_load_dividend as pld
import securities_load.load_polygon.polygon_load_exchange as ple
import securities_load.load_polygon.polygon_load_ohlcv as plo
import securities_load.load_polygon.polygon_load_split as pls
import securities_load.load_polygon.polygon_load_ticker as plt
import securities_load.load_polygon.polygon_load_ticker_type as pltt

logger = logging.getLogger(__name__)

logging.basicConfig(
    filename="securities_load.log",
    filemode="w",
    encoding="utf-8",
    level=logging.DEBUG,
    format="{asctime} - {name}.{funcName} - {levelname} - {message}",
    style="{",
)

logger.info("Start")

load_dotenv()

# plt.load_tickers()
# pltt.load_ticker_types()
# pls.load_splits()
# pld.load_dividends()
# ple.load_exchanges()
plo.load_ohlcvs(days=5)
