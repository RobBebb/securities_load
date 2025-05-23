import logging

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

module_logger = logging.getLogger(__name__)


def load_watchlist_tickers(watchlist_csv_file: str) -> None:
    """
    Get the tickers and load them into the equity ticker table"""

    module_logger.debug("Started")

    # load_dotenv()
    # Open a connection
    conn = connect()
    engine = sqlalchemy_engine()
    watchlist_tickers = read_watchlist_tickers(watchlist_csv_file)

    # Write the data to the local polygon database
    # if ticker_list is not None:
    #     add_tickers(conn, ticker_list)
    # print(watchlist_tickers.head())
    watchlist_tickers_transformed = transform_watchlist_tickers(
        engine, watchlist_tickers
    )
    # print(watchlist_tickers_transformed.head())
    module_logger.debug("Transformed")

    if watchlist_tickers_transformed is not None:
        add_or_update_watchlist_tickers(conn, watchlist_tickers_transformed)

    # Close the connection
    conn.close()
