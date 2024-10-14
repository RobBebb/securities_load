import logging
from datetime import datetime, timezone

import pandas as pd
from dotenv import load_dotenv

from securities_load.load_asx.asx_functions import (
    read_asx_indices,
    transform_asx_indices,
)
from securities_load.securities.postgresql_database_functions import (
    connect,
    sqlalchemy_engine,
)
from securities_load.securities.securities_table_functions import add_or_update_tickers


def load_asx_indices() -> None:
    """
    Get the tickers and load them into the equity ticker table"""
    load_dotenv()
    logger = logging.getLogger(__name__)

    logger.debug("Started")
    engine = sqlalchemy_engine()

    conn = connect()
    asx_indices = read_asx_indices()
    asx_indices_transformed = transform_asx_indices(engine, asx_indices)
    logger.debug("Transformed")

    if asx_indices_transformed is not None:
        add_or_update_tickers(conn, asx_indices_transformed)

    # Close the connection
    conn.close()
