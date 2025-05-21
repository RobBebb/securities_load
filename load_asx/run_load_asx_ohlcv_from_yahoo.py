import logging

from load_asx.load_asx_ohlcv_from_yahoo import load_asx_ohlcv_from_yahoo

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

load_asx_ohlcv_from_yahoo(period="5d")

logger.info("Completed")
