import logging

from dotenv import load_dotenv

from securities_load.securities.load_ohlcv_from_yahoo import load_ohlcv_from_yahoo

load_dotenv()

logger = logging.getLogger(__name__)

logging.basicConfig(
    filename="load_ohlcv_from_yahoo.log",
    filemode="w",
    encoding="utf-8",
    level=logging.INFO,
    format="{asctime} - {name}.{funcName} - {levelname} - {message}",
    style="{",
)

logger.info("Started")

load_ohlcv_from_yahoo(period="max")

logger.info("Completed")
