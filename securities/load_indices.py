import logging

import pandas as pd
import polars as pl

from securities_load.securities.polar_file_functions import (
    read_indices,
    transform_indices,
)
from securities_load.securities.postgresql_database_functions import (
    connect,
    sqlalchemy_engine,
)
from securities_load.securities.securities_table_functions import (
    add_or_update_tickers,
)

logger = logging.getLogger(__name__)


def load_indices(indices_csv_file: str) -> None:
    """
    Get the indices and load them into the equity ticker table"""

    logger.debug("Started")

    indices = read_indices(indices_csv_file)

    # Write the data to the securities schema
    indices_transformed = transform_indices(indices)

    indices_transformed.write_csv("indices_transformed.csv")
    logger.debug("Transformed")

    # Open a connection
    conn = connect()
    # engine = sqlalchemy_engine()

    pandas_indices_transformed = indices_transformed.to_pandas()

    if indices_transformed is not None:
        add_or_update_tickers(conn, pandas_indices_transformed)

    # Close the connection
    logger.debug("Finished")
