import logging

from dotenv import load_dotenv

from securities_load.securities.load_option_data_from_yahoo import (
    load_option_data_from_yahoo,
)

load_dotenv()


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


load_option_data_from_yahoo()
