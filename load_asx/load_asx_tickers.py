import logging
from datetime import datetime, timezone

import pandas as pd
from dotenv import load_dotenv

from securities_load.load_asx.asx_functions import (
    read_asx_listed_companies,
    transform_asx_listed_companies,
)
from securities_load.securities.postgresql_database_functions import (
    connect,
    sqlalchemy_engine,
)
from securities_load.securities.securities_table_functions import add_or_update_tickers


def load_asx_tickers() -> None:
    """
    Get the tickers and load them into the equity ticker table"""

    load_dotenv()
    logger = logging.getLogger(__name__)

    logger.debug("Started")
    conn = connect()
    engine = sqlalchemy_engine()

    asx_listed_companies = read_asx_listed_companies()
    asx_listed_companies_transformed = transform_asx_listed_companies(
        engine, asx_listed_companies
    )
    logger.debug("Transformed")

    if asx_listed_companies_transformed is not None:
        add_or_update_tickers(conn, asx_listed_companies_transformed)

    # Close the connection
    conn.close()
