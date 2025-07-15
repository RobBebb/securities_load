import datetime
import logging

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


def get_ticker_sub_type_id_using_code(code: str) -> int:
    """
    Get the ticker sub_type ID for a given ticker type code.
    """

    logger.debug("Started")

    query = f"SELECT id FROM securities.ticker_sub_type WHERE code = '{code}'"

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No ticker sub type found for code: {code}")

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


def retrieve_close_using_currency_tickers_dates(
    currency_code: str, tickers: list[str], start_date: str, end_date: str
) -> pl.DataFrame:
    """
    Retrieve close data for a given currency and list of tickers between specified start and end dates.
    This data is returned in a polars dataframe in long format with columns: date, ticker, close.
    """

    logger.debug("Started")

    # Convert the list into a string for the SQL query. Single quotes must be used for SQL.
    tickers_string = "'" + "', '".join(tickers) + "'"

    query = f"""
        SELECT o.date, t.ticker, o.close
        FROM securities.ticker AS t
        INNER JOIN securities.ohlcv AS o 
        ON t.id = o.ticker_id
        WHERE t.currency_code = '{currency_code}' AND t.ticker IN ({tickers_string})
        AND date >= '{start_date}'
        AND date <= '{end_date}'
        ORDER BY t.ticker, o.date
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(
            f"No close data found for tickers: {tickers} between {start_date} and {end_date}"
        )

    logger.debug(f"Finished - Retrieved {len(pl_df)} rows")

    return pl_df


def retrieve_close_using_ticker_ids_and_dates(
    ticker_ids: list[int], start_date: str, end_date: str
) -> pl.DataFrame:
    """
    Retrieve close data for a list of tickers between specified start and end dates.
    This data is returned in a polars dataframe in long format with columns: date, ticker, close.
    """

    logger.debug("Started")

    # Convert the list into a string for the SQL query. Single quotes must be used for SQL.
    ticker_ids_string = "'" + "', '".join(map(str, ticker_ids)) + "'"
    query = f"""
        SELECT o.date, t.id, t.ticker, o.close
        FROM securities.ticker AS t
        INNER JOIN securities.ohlcv AS o 
        ON t.id = o.ticker_id
        WHERE t.id IN ({ticker_ids_string})
        AND date >= '{start_date}'
        AND date <= '{end_date}'
        ORDER BY t.ticker, o.date
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(
            f"No close data found for tickers: {ticker_ids} between {start_date} and {end_date}"
        )

    logger.debug(f"Finished - Retrieved {len(pl_df)} rows")

    return pl_df


def get_ticker_ids_using_currency_code_and_tickers(
    currency_code: str, tickers: list[str]
) -> list[int]:
    """
    Get the ticker IDs for a given currency code and list of tickers.
    """

    logger.debug("Started")

    tickers_string = "'" + "', '".join(tickers) + "'"

    query = f"""
        SELECT t.id
        FROM securities.ticker AS t
        WHERE t.currency_code = '{currency_code}' AND t.ticker IN ({tickers_string})
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(
            f"No ticker found for currency code: {currency_code} and tickers: {tickers}"
        )

    # Convert to a seriesand change to a list
    ids = pl_df["id"].to_list()

    logger.debug(f"Finished - ids = {ids}")

    return ids


def retrieve_watchlists_using_watchlist_type(
    watchlist_type: str,
) -> list[tuple[int, str, str]]:
    """
    Retrieves the watchlists of the specified watchlist type.
    """

    logger.debug("Started")

    query = f"""
        SELECT w.id, w.code, w.description
        FROM securities.watchlist w
        INNER JOIN securities.watchlist_type wt ON w.watchlist_type_id = wt.id
        WHERE wt.code = '{watchlist_type}'
        ORDER BY w.code
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No watchlists found for watchlist type: {watchlist_type}")

    watchlists = []

    for row in pl_df.iter_rows(named=True):
        watchlist_id = row["id"]
        watchlist_code = row["code"]
        watchlist_description = row["description"]

        if not isinstance(watchlist_id, int):
            raise TypeError(
                f"Expected watchlist_id to be an int, got {type(watchlist_id)}"
            )
        if not isinstance(watchlist_code, str):
            raise TypeError(
                f"Expected watchlist_code to be a str, got {type(watchlist_code)}"
            )
        if not isinstance(watchlist_description, str):
            raise TypeError(
                f"Expected watchlist_description to be a str, got {type(watchlist_description)}"
            )

        watchlists.append((watchlist_id, watchlist_code, watchlist_description))

    logger.debug(f"Finished - Retrieved {len(watchlists)} rows")

    return watchlists


def retrieve_tickers_using_watchlist_code(
    watchlist_code: str,
) -> list[tuple[int, str, str]]:
    """
    Retrieves the tickers of the specified watchlist.
    """

    logger.debug("Started")

    query = f"""
        SELECT t.id, t.ticker, t.name
        FROM securities.ticker t
        INNER JOIN securities.watchlist_ticker wt ON wt.ticker_id = t.id
        INNER JOIN securities.watchlist w ON w.id = wt.watchlist_id
        WHERE w.code = '{watchlist_code}'
        ORDER BY t.ticker
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No tickers found for watchlist type: {watchlist_code}")

    tickers = []

    for row in pl_df.iter_rows(named=True):
        ticker_id = row["id"]
        ticker = row["ticker"]
        ticker_name = row["name"]

        if not isinstance(ticker_id, int):
            raise TypeError(f"Expected ticker_id to be an int, got {type(ticker_id)}")
        if not isinstance(ticker, str):
            raise TypeError(f"Expected ticker to be a str, got {type(ticker)}")
        if not isinstance(ticker_name, str):
            raise TypeError(
                f"Expected ticker_name to be a str, got {type(ticker_name)}"
            )

        tickers.append((ticker_id, ticker, ticker_name))

    logger.debug(f"Finished - Retrieved {len(tickers)} rows")

    return tickers


def retrieve_unique_country_alpha_3_from_exchanges() -> pl.DataFrame:
    """
    Input: None
    Output: pl.DataFrame containing country_alpha_3
    This is simply a polars df of unique values in the one column country_alpha_3.
    """

    logger.debug("Started")

    query = """
        SELECT distinct country_alpha_3
        FROM securities.exchange
        ORDER BY 1
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError("No country_alpha_3 found.")

    logger.debug(f"Finished - Retrieved {pl_df.shape}")

    return pl_df


def retrieve_exchange_ids_using_country_alpha_3(
    country_alpha_3: str,
) -> pl.DataFrame:
    """
    Input: country_alpha_3: str
    Output: pl.DataFrame
    Use the country_alpha_3 value passed in to get a polars df containing id, code and acronym.
    """

    logger.debug("Started")

    query = f"""
        SELECT id, code, acronym
        FROM securities.exchange
        WHERE country_alpha_3 = '{country_alpha_3}'
        ORDER BY acronym
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No tickers found for country_alpha_3: {country_alpha_3}")

    logger.debug(f"Finished - Retrieved {pl_df.shape}")

    return pl_df


def retrieve_ticker_types() -> pl.DataFrame:
    """
    Input: None
    Output: pl.DataFrame
    This is simply a polars df of ticker_type ids and codes.
    """

    logger.debug("Started")

    query = """
        SELECT id, code
        FROM securities.ticker_type
        ORDER BY code
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError("No ticker_types found.")

    logger.debug(f"Finished - Retrieved {pl_df.shape}")

    return pl_df


def retrieve_tickers_using_exchanges_and_ticker_types(
    exchange_ids: list[int], ticker_type_id: int
) -> pl.DataFrame:
    """
    Input: exchange_ids: list[int], ticker_type_id: int
    Output: pl.DataFrame
    Use the exchange_ids and ticker_type_id passed in get a polars df containing id, ticker, name and exchange_id.
    """

    logger.debug("Started")

    exchanges = ", ".join(map(str, exchange_ids))

    query = f"""
        SELECT id, ticker, name
        FROM securities.ticker
        WHERE exchange_id IN ({exchanges})
        AND ticker_type_id = {ticker_type_id}
        ORDER BY ticker
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(
            f"No tickers found for exchanges: {exchanges} and ticker type: {ticker_type_id}"
        )

    logger.debug(f"Finished - Retrieved {pl_df.shape}")

    return pl_df


def retrieve_ohlcv_using_ticker_id_and_dates(
    ticker_id: int, start_date: str, end_date: str
) -> pl.DataFrame:
    """
    Input: ticker_id: int, start: str, end: str
    Output: pl.DataFrame
    Use the ticker_id, start and end value passed in to get a polars df containing ohlcv data.
    """

    logger.debug("Started")

    query = f"""
        SELECT date AS Date,
        open AS Open,
        high AS High,
        low AS Low,
        close AS Close,
        volume AS Volume
        FROM securities.ohlcv o
        WHERE ticker_id = {ticker_id}
        AND date >= '{start_date}'
        AND date <= '{end_date}'
        ORDER BY date
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

    logger.debug(f"Finished - Retrieved {pl_df.shape} rows")

    return pl_df


def get_latest_ohlcv_using_ticker_id(ticker_id: int) -> pl.DataFrame:
    """
    Input: ticker_id: int
    Output: dataframe
    Use the ticker_id, start and end value passed in to get a polars df containing ohlcv data.
    """

    logger.debug("Started")

    query = f"""
        SELECT date AS Date,
        open AS Open,
        high AS High,
        low AS Low,
        close AS Close,
        volume AS Volume
        FROM securities.ohlcv o1
        WHERE date = (SELECT MAX(date) FROM securities.ohlcv o2 WHERE o1.ticker_id=o2.ticker_id)
        AND ticker_id = {ticker_id}
        """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No OHLCV data found for ticker_id: {ticker_id}")

    logger.debug(f"Finished - Retrieved {pl_df.shape} rows")

    return pl_df


def retrieve_expiry_dates_using_ticker_id(ticker_id: int) -> pl.DataFrame:
    """
    Input: ticker_id: int
    Output: pl.DataFrame
    Use the ticker_id, start and end value passed in to get a polars df containing ohlcv data.
    """

    logger.debug("Started")

    today = datetime.datetime.now()

    query = f"""
        SELECT DISTINCT DATE(expiry_date) AS expiry
        FROM securities.ticker
        WHERE underlying_ticker = '{ticker_id}'
        AND expiry_date >= '{today}'
        ORDER BY expiry ASC
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(f"No expiry dates found for ticker_id: {ticker_id}")

    logger.debug(f"Finished - Retrieved {pl_df.shape} rows")

    return pl_df


def retrieve_options_using_ticker_id_and_expiry_date(
    underlying_ticker_id: int, expiry_date: str
) -> pl.DataFrame:
    """
    Input: ticker_id: int, expiry_date: datetime
    Output: pl.DataFrame
    Use the ticker_id and expiry_date passed in to get a polars df containing the option information data.
    """

    logger.debug("Started")

    query = f"""
        SELECT id, ticker, call_put, strike, expiry_date
        FROM securities.ticker
        WHERE underlying_ticker = '{underlying_ticker_id}'
        AND expiry_date ='{expiry_date}'
        ORDER BY call_put, strike
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(
            f"No options found for ticker_id: {underlying_ticker_id} expiry_date: {expiry_date}"
        )

    logger.debug(f"Finished - Retrieved {pl_df.shape} rows")

    return pl_df


def retrieve_last_option_prices_using_stock_ticker_id_and_expiry_date_and_last_date(
    stock_ticker_id: int, expiry_date: str, last_date: str
) -> pl.DataFrame:
    """
    Input: ticker_id: int, last_date: datetime
    Output: pl.DataFrame
    Use the ticker_id and expiry_date passed in to get a polars df containing the option information data.
    """

    logger.debug("Started")

    query = f"""
        SELECT t.id,
        t.ticker,
        t.call_put,
        t.strike,
        t.expiry_date,
        o.date,
        o.last_trade_date,
        o.last_price,
        o.bid,
        o.ask,
        o.change,
        o.percent_change,
        o.volume,
        o.open_interest,
        o.implied_volatility,
        o.in_the_money
        FROM securities.option_data o
        INNER JOIN securities.ticker t on t.id = o.ticker_id
        WHERE
        o.date = '{last_date}'
        AND
        t.expiry_date = '{expiry_date}'
        AND
        t.underlying_ticker = '{stock_ticker_id}'
        ORDER BY t.call_put, t.expiry_date, t.strike
        """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(
            f"No options found for stock_ticker_id: {stock_ticker_id} last_date: {last_date}"
        )

    logger.debug(f"Finished - Retrieved {pl_df.shape} rows")

    return pl_df


def retrieve_close_using_exchanges_tickers_dates(
    exchanges: list[str], tickers: list[str], start_date: str, end_date: str
) -> pl.DataFrame:
    """
    Retrieve close data for a given currency and list of tickers between specified start and end dates.
    This data is returned in a polars dataframe in long format with columns: date, ticker, close.
    """

    logger.debug("Started")

    # Convert the list into a string for the SQL query. Single quotes must be used for SQL.
    tickers_string = "'" + "', '".join(tickers) + "'"
    exchanges_string = "'" + "', '".join(exchanges) + "'"

    query = f"""
        SELECT o.date, t.ticker, o.close
        FROM securities.ticker AS t
        INNER JOIN securities.ohlcv AS o 
        ON t.id = o.ticker_id
        INNER JOIN securities.exchange AS e
        ON t.exchange_id = e.id
        WHERE e.code IN '{exchanges_string}' AND t.ticker IN ({tickers_string})
        AND date >= '{start_date}'
        AND date <= '{end_date}'
        ORDER BY t.ticker, o.date
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(
            f"No close data found for tickers: {tickers} between {start_date} and {end_date}"
        )

    logger.debug(f"Finished - Retrieved {len(pl_df)} rows")

    return pl_df


def retrieve_ohlcv_using_ticker_ids_and_dates(
    ticker_ids: list[int], start_date: str, end_date: str
) -> pl.DataFrame:
    """
    Retrieve ohlcv data for a list of tickers between specified start and end dates.
    This data is returned in a polars dataframe in long format with columns: date, ticker, close.
    """

    logger.debug("Started")

    # Convert the list into a string for the SQL query. Single quotes must be used for SQL.
    ticker_ids_string = "'" + "', '".join(map(str, ticker_ids)) + "'"
    query = f"""
        SELECT t.id, t.ticker, o.date, o.open, o.high, o.low, o.close, o.volume
        FROM securities.ticker AS t
        INNER JOIN securities.ohlcv AS o 
        ON t.id = o.ticker_id
        WHERE t.id IN ({ticker_ids_string})
        AND date >= '{start_date}'
        AND date <= '{end_date}'
        ORDER BY t.ticker, o.date
    """

    try:
        pl_df = pl.read_database_uri(query=query, uri=get_uri())
    except Exception as e:
        logger.exception(f"Error {e} from executing query: {query}")
        raise e

    if pl_df.is_empty():
        raise ValueError(
            f"No close data found for tickers: {ticker_ids} between {start_date} and {end_date}"
        )

    logger.debug(f"Finished - Retrieved {len(pl_df)} rows")

    return pl_df


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
    # result = retrieve_yahoo_tickers_using_exchange_code("XASX")
    # result = retrieve_close_using_currency_tickers_dates(
    #     "USD", ["AAPL", "MSFT", "GOOGL"], "2023-01-01", "2023-10-01"
    # )
    # result = retrieve_watchlists_using_watchlist_type("Dashboard")
    # result = retrieve_tickers_using_watchlist_code('US Overview')
    # result = retrieve_unique_country_alpha_3_from_exchanges()
    # result = retrieve_exchange_id_using_country_alpha_3("USA")
    # result = retrieve_ticker_types()
    # result = retrieve_tickers_using_exchanges_and_ticker_types([2, 3, 6], 5)
    # result = retrieve_ohlcv_using_ticker_id_and_dates(5219, "2023-01-01", "2023-10-01")
    # result = retrieve_expiry_dates_using_ticker_id(5230)
    # result = retrieve_options_using_ticker_id_and_expiry_date(5230, "2025-05-30")
    # result = get_latest_ohlcv_using_ticker_id(5230)
    # result = (
    #     retrieve_last_option_prices_using_stock_ticker_id_and_expiry_date_and_last_date(
    #         5230, "2025-07-03", "2025-06-24"
    #     )
    # )
    # result = retrieve_close_using_ticker_ids_and_dates(
    #     [5219, 5230], "2023-01-01", "2023-10-01"
    # )
    result = retrieve_ohlcv_using_ticker_ids_and_dates(
        [5219, 5230], "2024-01-01", "2025-06-27"
    )
    logger.info(f"Finished - result = {result}")
    print(f"Finished - result = {result}")
