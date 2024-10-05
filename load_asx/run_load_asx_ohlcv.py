import logging

import pandas as pd
from dotenv import load_dotenv

from securities_load.load_asx.load_asx_ohlcv import load_asx_ohlcv

logger = logging.getLogger(__name__)
logging.basicConfig(
    filename="load_asx.log",
    filemode="w",
    encoding="utf-8",
    level=logging.INFO,
    format="{asctime} - {name}.{funcName} - {levelname} - {message}",
    style="{",
)

logger.info("Started")

load_dotenv()

load_asx_ohlcv(period="5y")
