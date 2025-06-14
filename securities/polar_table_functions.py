import logging
import re

import polars as pl

from securities_load.securities.postgresql_database_functions import get_uri

logger = logging.getLogger(__name__)


def get_ticker_type_id_using_code(code: str) -> int:
    """
    Get the ticker type ID for a given ticker type code.
    """

    logger.debug("Started")

    query = f"SELECT id FROM securities.ticker_type WHERE code = '{code}'"

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No ticker type found for code: {code}")

    id = pl_df["id"][0]

    if not isinstance(id, int):
        raise TypeError(f"Expected id to be an int, got {type(id)}")

    logger.debug(f"Finished - id = {id}")

    return id


def get_data_vendor_id_using_name(name: str) -> int:
    """
    Get the data vendor ID for a given data vendor name.
    """

    logger.debug("Started")

    query = f"SELECT id FROM securities.data_vendor WHERE name = '{name}'"

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No data vendor found for name: {name}")

    id = pl_df["id"][0]

    if not isinstance(id, int):
        raise TypeError(f"Expected id to be an int, got {type(id)}")

    logger.debug(f"Finished - id = {id}")

    return id


def get_exchange_id_using_code(code: str) -> int:
    """
    Get the exchange ID for a given exchange code.
    """

    logger.debug("Started")

    query = f"SELECT id FROM securities.exchange WHERE code = '{code}'"

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No exchange found for code: {code}")

    id = pl_df["id"][0]

    if not isinstance(id, int):
        raise TypeError(f"Expected id to be an int, got {type(id)}")

    logger.debug(f"Finished - id = {id}")

    return id


def get_exchange_id_using_acronym(acronym: str) -> int:
    """
    Get the exchange ID for a given exchange acronym.
    """

    logger.debug("Started")

    query = f"SELECT id FROM securities.exchange WHERE acronym = '{acronym}'"

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No exchange found for acronym: {acronym}")

    id = pl_df["id"][0]

    if not isinstance(id, int):
        raise TypeError(f"Expected id to be an int, got {type(id)}")

    logger.debug(f"Finished - id = {id}")

    return id


def get_exchange_code_using_id(id: int) -> str:
    """
    Get the exchange code for a given exchange ID.
    """

    logger.debug("Started")

    query = f"SELECT code FROM securities.exchange WHERE id = {id}"

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No exchange found for id: {id}")

    code = pl_df["code"][0]

    if not isinstance(code, str):
        raise TypeError(f"Expected code to be a str, got {type(code)}")

    logger.debug(f"Finished - code = {code}")

    return code


def get_currency_code_using_name(name: str) -> str:
    """
    Get the currency code for a given currency name.
    """

    logger.debug("Started")

    upper_name = name.upper()

    query = (
        f"SELECT code FROM securities.currency WHERE UPPER(currency) = '{upper_name}'"
    )

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No currency found for name: {name}")

    code = pl_df["code"][0]

    if not isinstance(code, str):
        raise TypeError(f"Expected code to be a str, got {type(code)}")

    logger.debug(f"Finished - code = {code}")

    return code


def get_ticker_using_id(id: int) -> tuple:
    """
    Get the ticker information for a given ticker ID.
    Returns a tuple of (ticker, exchange.code).
    """

    logger.debug("Started")

    query = f"SELECT t.ticker, e.code FROM securities.ticker AS t INNER JOIN securities.exchange AS e ON t.exchange_id = e.id WHERE t.id = {id}"

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No ticker found for id: {id}")

    ticker_tuple = (pl_df["ticker"][0], pl_df["code"][0])

    if not isinstance(ticker_tuple[0], str) or not isinstance(ticker_tuple[1], str):
        raise TypeError(
            f"Expected ticker to be a tuple of str, got {type(ticker_tuple)}"
        )

    logger.debug(f"Finished - ticker = {ticker_tuple[0]}, code = {ticker_tuple[1]}")

    return ticker_tuple


def get_ticker_id_using_exchange_code_and_ticker(
    exchange_code: str, ticker: str
) -> int:
    """
    Get the ticker ID for a given exchange code and ticker.
    """

    logger.debug("Started")

    query = f"""
        SELECT t.id
        FROM securities.ticker AS t
        INNER JOIN securities.exchange AS e ON t.exchange_id = e.id
        WHERE e.code = '{exchange_code}' AND t.ticker = '{ticker}'
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(
            f"No ticker found for exchange code: {exchange_code} and ticker: {ticker}"
        )

    id = pl_df["id"][0]

    if not isinstance(id, int):
        raise TypeError(f"Expected id to be an int, got {type(id)}")

    logger.debug(f"Finished - id = {id}")

    return id


def get_ticker_id_using_yahoo_ticker(yahoo_ticker: str) -> int:
    """
    Get the ticker ID for a given ticker using the Yahoo ticker format.
    The ticker is expected to be in the format 'TICKER.YAHOO_EXCHANGE_SUFFIX'.
    """
    logger.debug("Started")

    query = f"SELECT id FROM securities.ticker WHERE yahoo_ticker = '{yahoo_ticker}'"

    print(f"Executing query: {query}")
    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No ticker found for yahoo_ticker: {yahoo_ticker}")

    id = pl_df["id"][0]

    if not isinstance(id, int):
        raise TypeError(f"Expected id to be an int, got {type(id)}")

    logger.debug(f"Finished - id = {id}")

    return id


def get_gics_sector_code_using_name(sector_name: str) -> str:
    """
    Get the GICS sector code for a given sector name.
    """

    logger.debug("Started")

    query = f"SELECT code FROM securities.gics_sector WHERE name = '{sector_name}'"

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No GICS sector found for name: {sector_name}")

    code = pl_df["code"][0]

    if not isinstance(code, str):
        raise TypeError(f"Expected code to be a str, got {type(code)}")

    logger.debug(f"Finished - code = {code}")

    return code


def get_gics_industry_group_code_using_name(industry_group_name: str) -> str:
    """
    Get the GICS industry group code for a given industry group name.
    """

    logger.debug("Started")

    query = f"SELECT code FROM securities.gics_industry_group WHERE name = '{industry_group_name}'"

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(
            f"No GICS industry group found for name: {industry_group_name}"
        )

    code = pl_df["code"][0]

    if not isinstance(code, str):
        raise TypeError(f"Expected code to be a str, got {type(code)}")

    logger.debug(f"Finished - code = {code}")

    return code


def get_gics_industry_code_using_name(industry_name: str) -> str:
    """
    Get the GICS industry code for a given industry name.
    """

    logger.debug("Started")

    query = f"SELECT code FROM securities.gics_industry WHERE name = '{industry_name}'"

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No GICS industry found for name: {industry_name}")

    code = pl_df["code"][0]

    if not isinstance(code, str):
        raise TypeError(f"Expected code to be a str, got {type(code)}")

    logger.debug(f"Finished - code = {code}")

    return code


def get_gics_sub_industry_code_using_name(sub_industry_name: str) -> str:
    """
    Get the GICS sub-industry code for a given sub-industry name.
    """

    logger.debug("Started")

    query = f"SELECT code FROM securities.gics_sub_industry WHERE name = '{sub_industry_name}'"

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No GICS sub-industry found for name: {sub_industry_name}")

    code = pl_df["code"][0]

    if not isinstance(code, str):
        raise TypeError(f"Expected code to be a str, got {type(code)}")

    logger.debug(f"Finished - code = {code}")

    return code


def get_gics_sector_id_using_name(sector_name: str) -> int:
    """
    Get the GICS sector ID for a given sector name.
    """

    logger.debug("Started")

    query = f"SELECT id FROM securities.gics_sector WHERE name = '{sector_name}'"

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No GICS sector found for name: {sector_name}")

    id = pl_df["id"][0]

    if not isinstance(id, int):
        raise TypeError(f"Expected id to be an int, got {type(id)}")

    logger.debug(f"Finished - id = {id}")

    return id


def get_gics_industry_group_id_using_name(industry_group_name: str) -> int:
    """
    Get the GICS industry group ID for a given industry group name.
    """

    logger.debug("Started")

    query = f"SELECT id FROM securities.gics_industry_group WHERE name = '{industry_group_name}'"

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(
            f"No GICS industry group found for name: {industry_group_name}"
        )

    id = pl_df["id"][0]

    if not isinstance(id, int):
        raise TypeError(f"Expected id to be an int, got {type(id)}")

    logger.debug(f"Finished - id = {id}")

    return id


def get_gics_industry_id_using_name(industry_name: str) -> int:
    """
    Get the GICS industry ID for a given industry name.
    """

    logger.debug("Started")

    query = f"SELECT id FROM securities.gics_industry WHERE name = '{industry_name}'"

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No GICS industry found for name: {industry_name}")

    id = pl_df["id"][0]

    if not isinstance(id, int):
        raise TypeError(f"Expected id to be an int, got {type(id)}")

    logger.debug(f"Finished - id = {id}")

    return id


def get_gics_sub_industry_id_using_name(sub_industry_name: str) -> int:
    """
    Get the GICS sub-industry ID for a given sub-industry name.
    """

    logger.debug("Started")

    query = f"SELECT id FROM securities.gics_sub_industry WHERE name = '{sub_industry_name}'"

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No GICS sub-industry found for name: {sub_industry_name}")

    id = pl_df["id"][0]

    if not isinstance(id, int):
        raise TypeError(f"Expected id to be an int, got {type(id)}")

    logger.debug(f"Finished - id = {id}")

    return id


def get_gics_sector_id_using_industry_group_id(industry_group_id: int) -> int:
    """
    Get the GICS sector ID using the industry group ID.
    """

    logger.debug("Started")

    query = f"""
        SELECT sector_id
        FROM securities.gics_industry_group
        WHERE id = {industry_group_id}
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(
            f"No GICS sector found for industry group id: {industry_group_id}"
        )

    id = pl_df["sector_id"][0]

    if not isinstance(id, int):
        raise TypeError(f"Expected id to be an int, got {type(id)}")

    logger.debug(f"Finished - id = {id}")

    return id


def retrieve_ohlcv_using_dates(
    exchange_code: str, ticker: str, start_date: str, end_date: str
) -> pl.DataFrame:
    """
    Retrieve OHLCV data for a given exchange_code and ticker between specified start and end dates.
    """

    logger.debug("Started")

    ticker_id = get_ticker_id_using_exchange_code_and_ticker(exchange_code, ticker)

    query = f"""
        SELECT date,
        open AS Open,
        high AS High,
        low AS Low,
        close AS Close,
        volume AS Volume
        FROM securities.ohlcv o
        WHERE ticker_id = {ticker_id}
        AND date >= '{start_date}'
        AND date <= '{end_date}'
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(
            f"No OHLCV data found for ticker_id: {ticker_id} between {start_date} and {end_date}"
        )

    logger.debug(f"Finished - Retrieved {len(pl_df)} rows")

    return pl_df


def retrieve_ohlcv_using_last_n_days(
    exchange_code: str, ticker: str, n_days: int
) -> pl.DataFrame:
    """
    Retrieve OHLCV data for a given exchange_code and ticker for the last n days.
    n includes weekends and holidays.
    """

    logger.debug("Started")

    ticker_id = get_ticker_id_using_exchange_code_and_ticker(exchange_code, ticker)

    query = f"""
        SELECT date,
        open AS Open,
        high AS High,
        low AS Low,
        close AS Close,
        volume AS Volume
        FROM securities.ohlcv o
        WHERE ticker_id = {ticker_id}
        AND date >= CURRENT_DATE - INTERVAL '{n_days} days'
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(
            f"No OHLCV data found for ticker_id: {ticker_id} in the last {n_days} days"
        )

    logger.debug(f"Finished - Retrieved {len(pl_df)} rows")

    return pl_df


def retrieve_yahoo_tickers_using_exchange_code(
    exchange_code: str,
) -> list[tuple[int, str]]:
    """
    Retrieve all tickers for a given exchange code.
    """

    logger.debug("Started")

    query = f"""
        SELECT t.id, t.yahoo_ticker, e.code AS exchange_code
        FROM securities.ticker AS t
        INNER JOIN securities.exchange AS e ON t.exchange_id = e.id
        WHERE e.code = '{exchange_code}'
        AND t.yahoo_ticker IS NOT NULL
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No tickers found for exchange code: {exchange_code}")

    yahoo_tickers = []

    for row in pl_df.iter_rows(named=True):
        ticker_id = row["id"]
        yahoo_ticker = row["yahoo_ticker"]

        if not isinstance(ticker_id, int):
            raise TypeError(f"Expected ticker_id to be an int, got {type(ticker_id)}")
        if not isinstance(yahoo_ticker, str):
            raise TypeError(
                f"Expected yahoo_ticker to be a str, got {type(yahoo_ticker)}"
            )

        yahoo_tickers.append((ticker_id, yahoo_ticker))

    logger.debug(f"Finished - Retrieved {len(yahoo_tickers)} rows")

    return yahoo_tickers


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

    # result = get_ticker_type_id_using_code("option")
    # result = get_data_vendor_id_using_name("Yahoo")
    # result = get_exchange_id_using_code("XCBO")
    # result = get_exchange_id_using_acronym("NASDAQ")
    # result = get_exchange_code_using_id(8)
    # result = get_currency_code_using_name("Australian Dollar")
    # result = get_ticker_using_id(187561)
    # result = get_ticker_id_using_exchange_code_and_ticker("XNAS", "AAPL")
    # result = get_ticker_id_using_yahoo_ticker("BHP.AX")
    # result = get_gics_sector_code_using_name("Information Technology")
    # result = get_gics_industry_code_using_name("Software")
    # result = get_gics_industry_group_code_using_name("Software & Services")
    # result = get_gics_sub_industry_code_using_name("Application Software")
    # result = get_gics_sector_id_using_name("Information Technology")
    # result = get_gics_industry_group_id_using_name("Software & Services")
    # result = get_gics_industry_id_using_name("Software")
    # result = get_gics_sub_industry_id_using_name("Application Software")
    # result = get_gics_sector_id_using_industry_group_id(10)
    # result = retrieve_ohlcv_using_dates("XNAS", "AAPL", "2023-01-01", "2023-10-01")
    # result = retrieve_ohlcv_using_last_n_days("XNAS", "AAPL", 30)
    result = retrieve_yahoo_tickers_using_exchange_code("XASX")
    logger.info(f"Finished - result = {result}")
    print(f"Finished - result = {result}")
