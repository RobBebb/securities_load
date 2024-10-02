import logging
from datetime import datetime, timezone

import pandas as pd

from securities_load.load_asx.asx_functions import (
    clean_asx_company_gics_codes,
    read_asx_company_gics_codes,
    transform_asx_company_gics_codes,
)
from securities_load.securities.postgresql_database_functions import connect
from securities_load.securities.securities_table_functions import add_or_update_tickers

module_logger = logging.getLogger(__name__)


def load_asx_gics_codes() -> None:
    """
    Get the tickers and load them into the equity ticker table"""

    module_logger.debug("Started")
    conn = connect()
    asx_listed_companies = read_asx_company_gics_codes()

    asx_listed_companies_cleaned = clean_asx_company_gics_codes(asx_listed_companies)

    asx_listed_companies_transformed = transform_asx_company_gics_codes(
        conn, asx_listed_companies_cleaned
    )
    print(asx_listed_companies_transformed.head())
    module_logger.debug("Transformed")

    if asx_listed_companies_transformed is not None:
        add_or_update_tickers(conn, asx_listed_companies_transformed)

    # Close the connection
    conn.close()
