import logging

from dotenv import load_dotenv

from securities_load.securities.load_indices import load_indices

load_dotenv()

logger = logging.getLogger(__name__)

logging.basicConfig(
    filename="load_indices.log",
    filemode="w",
    encoding="utf-8",
    level=logging.DEBUG,
    format="{asctime} - {name}.{funcName} - {levelname} - {message}",
    style="{",
)

logger.info("Start")

load_indices("/home/ubuntuuser/karra/securities_load/data/tickers.csv")

logger.info("Finish")
