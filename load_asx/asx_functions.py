import logging

import pandas as pd
from sqlalchemy import Engine

from securities_load.securities.securities_table_functions import (
    get_exchange_id,
    get_gics_industry_group_id_from_name,
    get_gics_industry_id_from_name,
    get_gics_sector_id_from_industry_group_id,
    get_gics_sector_id_from_name,
    get_gics_sub_industry_id_from_name,
    get_ticker_type_id,
)

logger = logging.getLogger(__name__)


def read_asx_company_gics_codes() -> pd.DataFrame:
    """Read in the ASX Sectors with Companies.xlsx Excel file and get the first sheet.
    This sheet list all the ASX companies broken down by their GICS codes"""
    logger.debug("Started")
    company_gics_codes = pd.read_excel(
        "/home/ubuntuuser/karra/securities_load/data/ASX Sectors with Companies.xlsx",
        sheet_name="Sectors",
    )
    logger.debug("File read")
    return company_gics_codes


def clean_asx_company_gics_codes(company_gics_codes: pd.DataFrame) -> pd.DataFrame:
    logger.debug("Started")
    #  Check how many rows are missing a ticker code and the delete then
    missing_rows_count = company_gics_codes["code"].isna().sum()
    logger.debug(
        f"There are {missing_rows_count} rows without a ticker code. They will be deleted"
    )
    clean_company_gics_codes = company_gics_codes.dropna(subset=["code"])
    return clean_company_gics_codes


def transform_asx_company_gics_codes(
    engine: Engine, clean_company_gics_codes: pd.DataFrame
) -> pd.DataFrame:
    logger.debug("Started")

    exchange_code = "XASX"

    exchange_id = get_exchange_id(engine, exchange_code)
    if exchange_id is None:
        raise KeyError(f"No exchange id found for exchange code {exchange_code}!")

    ticker_type_id = get_ticker_type_id(engine, "stock")

    if ticker_type_id is None:
        raise KeyError("No ticker type id found for 'stock'!")
    clean_company_gics_codes = clean_company_gics_codes.assign(
        ticker_type_id=ticker_type_id
    )
    clean_company_gics_codes["exchange_id"] = exchange_id
    clean_company_gics_codes["ticker"] = clean_company_gics_codes["code"].str.replace(
        "ASX:", ""
    )
    clean_company_gics_codes["yahoo_ticker"] = (
        clean_company_gics_codes["ticker"] + ".AX"
    )
    clean_company_gics_codes["listcorp_url"] = (
        "https://www.listcorp.com/"
        + clean_company_gics_codes["market"]
        + "/"
        + clean_company_gics_codes["ticker"]
    )

    clean_company_gics_codes["gics_sector_id"] = clean_company_gics_codes[
        ["gics_sector_name"]
    ].map(lambda x: get_gics_sector_id_from_name(engine, x))

    clean_company_gics_codes["gics_industry_group_id"] = clean_company_gics_codes[
        ["gics_industry_group_name"]
    ].map(lambda x: get_gics_industry_group_id_from_name(engine, x))

    clean_company_gics_codes["gics_industry_id"] = clean_company_gics_codes[
        ["gics_industry_name"]
    ].map(lambda x: get_gics_industry_id_from_name(engine, x))

    clean_company_gics_codes["gics_sub_industry_id"] = clean_company_gics_codes[
        ["gics_sub_industry_name"]
    ].map(lambda x: get_gics_sub_industry_id_from_name(engine, x))

    clean_company_gics_codes.drop(
        columns=[
            "market",
            "gics_sector_name",
            "gics_industry_group_name",
            "gics_industry_name",
            "gics_sub_industry_name",
            "sector_ticker",
            "sector_ticker_yahoo",
            "code",
        ],
        inplace=True,
    )

    return clean_company_gics_codes


def read_asx_listed_companies() -> pd.DataFrame:
    """Read in the ASX listed companies csv file."""
    logger.debug("Started")
    asx_listed_companies = pd.read_csv(
        "/home/ubuntuuser/karra/securities_load/data/ASX_Listed_Companies.csv"
    )
    logger.debug("File read")
    return asx_listed_companies


def transform_asx_listed_companies(
    engine: Engine, asx_listed_companies: pd.DataFrame
) -> pd.DataFrame:
    """Read in the ASX listed companies csv file."""

    logger.debug("Started")

    exchange_code = "XASX"

    exchange_id = get_exchange_id(engine, exchange_code)
    if exchange_id is None:
        raise KeyError(f"No exchange id found for exchange code {exchange_code}!")

    ticker_type_id = get_ticker_type_id(engine, "stock")

    columns = ["ticker", "name", "gics_industry_group", "listed_date", "market_cap"]
    asx_listed_companies.columns = columns
    asx_listed_companies["gics_industry_group_id"] = asx_listed_companies[
        "gics_industry_group"
    ].apply(lambda x: get_gics_industry_group_id_from_name(engine, x))
    asx_listed_companies["gics_sector_id"] = asx_listed_companies[
        "gics_industry_group_id"
    ].apply(lambda x: get_gics_sector_id_from_industry_group_id(engine, x))
    asx_listed_companies.drop(
        columns=["gics_industry_group", "market_cap"], inplace=True
    )
    asx_listed_companies["listed_date"] = pd.to_datetime(
        asx_listed_companies["listed_date"], format="%d/%m/%Y"
    )
    asx_listed_companies["currency_code"] = "AUD"
    asx_listed_companies["ticker_type_id"] = ticker_type_id
    asx_listed_companies["yahoo_ticker"] = asx_listed_companies["ticker"] + ".AX"
    asx_listed_companies["exchange_id"] = exchange_id
    logger.debug("File transformed")
    return asx_listed_companies


def read_asx_indices() -> pd.DataFrame:
    """Read the ASX_indices.csv text file. This file lists the ASX indices. It has their
    name, ticker and the yahoo tocker where applicable."""
    logger.debug("Started")
    # Read in the Asx indices csv file
    indices = pd.read_csv(
        "/home/ubuntuuser/karra/securities_load/data/ASX_indices.csv", header=None
    )
    logger.debug("File read")
    return indices


def transform_asx_indices(engine: Engine, indices: pd.DataFrame) -> pd.DataFrame:
    """Cleans and transforms the ASX indices"""
    logger.debug("Started")

    exchange_code = "XASX"

    exchange_id = get_exchange_id(engine, exchange_code)
    if exchange_id is None:
        raise KeyError(f"No exchange id found for exchange code {exchange_code}!")

    ticker_type_id = get_ticker_type_id(engine, "index")

    transformed_indices = indices.iloc[:, 0].str.split(pat="(", expand=True)
    transformed_indices.columns = ["name", "ticker"]
    transformed_indices.ticker = transformed_indices.ticker.str.strip(")")
    transformed_indices["yahoo_ticker"] = indices.iloc[:, 1]
    transformed_indices["yahoo_ticker"] = [
        d if not pd.isnull(d) else None for d in transformed_indices["yahoo_ticker"]
    ]
    transformed_indices["currency_code"] = "AUD"
    transformed_indices["ticker_type_id"] = ticker_type_id
    transformed_indices["exchange_id"] = exchange_id

    return transformed_indices
