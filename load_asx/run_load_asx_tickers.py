import logging

import pandas as pd

from securities_load.load_asx.load_asx_tickers import load_asx_tickers

logger = logging.getLogger(__name__)
logging.basicConfig(
    filename="load_asx.log",
    filemode="w",
    encoding="utf-8",
    level=logging.INFO,
    format="{asctime} - {name}.{funcName} - {levelname} - {message}",
    style="{",
)

logger.info("run_load_asx_indices started")
load_asx_tickers()
