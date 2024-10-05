import logging
from datetime import datetime, timezone

import pandas as pd
from dotenv import load_dotenv

from securities_load.securities.postgresql_database_functions import sqlalchemy_engine
from securities_load.securities.securities_table_functions import (
    get_tickers_using_exchange_code,
)

module_logger = logging.getLogger(__name__)


def get_tickers() -> None:
    """
    Get the tickers and load them into the equity ticker table"""

    module_logger.debug("Started")
    print("hi")
    # load_dotenv()
    # Open a connection
    engine = sqlalchemy_engine()
    tickers = get_tickers_using_exchange_code(engine, "XASX")
    # Write the data to the local polygon database
    # if ticker_list is not None:
    #     add_tickers(conn, ticker_list)
    print(tickers)
    yahoo_tickers = []
    for i in tickers:
        yahoo_tickers.append(i[1])
