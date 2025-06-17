import logging

import pandas as pd

from securities_load.securities.postgresql_database_functions import (
    connect,
    sqlalchemy_engine,
)
from securities_load.securities.securities_file_functions import (
    read_watchlist_tickers,
    transform_watchlist_tickers,
)
from securities_load.securities.securities_table_functions import (
    add_or_update_watchlist_tickers,
)

logger = logging.getLogger(__name__)


def load_watchlist_tickers(watchlist_csv_file: str) -> None:
    """
    Get the tickers and load them into the equity ticker table"""

    logger.debug("Started")

    # load_dotenv()
    # Open a connection
    conn = connect()
    engine = sqlalchemy_engine()

    watchlist_tickers = read_watchlist_tickers(watchlist_csv_file)

    # Write the data to the securities schema
    watchlist_tickers_transformed = transform_watchlist_tickers(
        engine, watchlist_tickers
    )

    watchlist_tickers_transformed.to_csv(
        "watchlist_tickers_transformed.csv", index=False
    )
    logger.debug("Transformed")

    if watchlist_tickers_transformed is not None:
        add_or_update_watchlist_tickers(conn, watchlist_tickers_transformed)

    # Close the connection
    conn.close()
    logger.debug("Finished")
