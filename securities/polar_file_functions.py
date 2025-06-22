import logging

import polars as pl

from securities_load.securities.polar_table_functions import (
    get_exchange_id_using_code,
    get_ticker_sub_type_id_using_code,
    get_ticker_type_id_using_code,
)

logger = logging.getLogger(__name__)


def read_indices(indices_csv_file: str) -> pl.DataFrame:
    """Read the indices.csv text file. This file lists the indices we interested in. It has their
    name,symbol,asx_symbol,yahoo_symbol,country,currency,ticker_type,ticker_sub_type where applicable."""
    logger.debug("Started")
    # Read in the Asx indices csv file
    indices = pl.read_csv(
        "/home/ubuntuuser/karra/securities_load/data/indices.csv", has_header=True
    )

    logger.debug("File read")
    return indices


def transform_indices(indices: pl.DataFrame) -> pl.DataFrame:
    """Cleans and transforms the ASX indices"""
    logger.debug("Started")

    indices = indices.with_columns(
        pl.col("ticker_type")
        .map_elements(get_ticker_type_id_using_code, return_dtype=pl.Int32)
        .alias("ticker_type_id")
    )
    indices = indices.with_columns(
        pl.col("ticker_sub_type")
        .map_elements(get_ticker_sub_type_id_using_code, return_dtype=pl.Int32)
        .alias("ticker_sub_type_id")
    )
    indices = indices.with_columns(
        pl.col("exchange")
        .map_elements(get_exchange_id_using_code, return_dtype=pl.Int32)
        .alias("exchange_id")
    )

    indices = indices.rename(
        {
            "symbol": "ticker",
            "yahoo_symbol": "yahoo_ticker",
            "currency": "currency_code",
        }
    )

    indices = indices.drop(
        "exchange", "ticker_type", "ticker_sub_type", "asx_symbol", "country"
    )

    return indices


if __name__ == "__main__":
    logger = logging.getLogger(__name__)

    logging.basicConfig(
        filename="polars_testing.log",
        filemode="w",
        encoding="utf-8",
        level=logging.DEBUG,
        format="{asctime} - {name}.{funcName} - {levelname} - {message}",
        style="{",
    )

    logger.info("Start")

    result = read_indices("/home/ubuntuuser/karra/securities_load/data/watchlists.csv")
    result2 = transform_indices(result)
    logger.info(f"Finished - result = {result}")
    logger.info(f"Finished - result2 = {result2}")
    print(f"Finished - result = {result}")
    print(f"Finished - result2 = {result2}")
    print(f"result2 schema: {result2.schema}")
