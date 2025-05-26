"""
Date: 16/10/2023
Author: Rob Bebbington

Get the ohlcv data from polygon and load it into my polygon schema
"""

import logging

from dotenv import load_dotenv

from securities_load.load_polygon.polygon_load_ohlcv import (
    load_ohlcvs,
)

load_dotenv()


logger = logging.getLogger(__name__)

logging.basicConfig(
    filename="polygon_load_ohlcvs.log",
    filemode="w",
    encoding="utf-8",
    level=logging.INFO,
    format="{asctime} - {name}.{funcName} - {levelname} - {message}",
    style="{",
)

logger.info("Start")

load_ohlcvs(days=5)

logger.info("Finish")
