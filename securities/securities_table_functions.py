import logging

import pandas as pd
import psycopg2
import psycopg2.extras

logger = logging.getLogger(__name__)


def get_ticker_type_id(conn, code: str) -> int:
    """
    Read the ticker_type table and return the id
    Parameters:
        conn - database connection
        code - code for the ticker_type
        Returns:
        ticker_type_id if found
        0 if not found
    """
    logger.debug(f"Started with code {code}")

    table = "securities.ticker_type"

    # create a list of columns from the dataframe
    table_columns = "id"
    ticker_type_id = 0

    cur = conn.cursor()

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE code = '{code}'"
    cur.execute(select_stmt)
    ticker_types = cur.fetchall()
    for row in ticker_types:
        ticker_type_id = row[0]
        logger.debug(f"id for ticker_type code {code} is {ticker_type_id}.")
        break
    return ticker_type_id


def get_data_vendor_id(conn, name: str) -> int:
    """
    Read the ticker_type table and return the id
    Parameters:
        conn - database connection
        name - name of the data vendor
        Returns:
        ticker_type_id if found
        0 if not found
    """
    logger.debug(f"Started with name {name}")

    table = "securities.data_vendor"

    # create a list of columns from the dataframe
    table_columns = "id"
    ticker_type_id = 0

    cur = conn.cursor()

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE name = '{name}'"
    cur.execute(select_stmt)
    data_vendors = cur.fetchall()
    for row in data_vendors:
        data_vendors_id = row[0]
        logger.debug(f"id for data vendor name {name} is {data_vendors_id}.")
        break
    return data_vendors_id


def get_exchange_id_by_acronym(conn, acronym: str) -> int:
    """
    Read the exchange table using the acronym and return the id. Where there are
    duplicates the first found will be returned.
    Parameters:
        conn - database connection
        acronym - acronym for the exchange e.g. ASX
    Returns:
        exchangeId if found
        0 if not found
    """
    logger.debug(f"Started with acronym {acronym}")

    table = "securities.exchange"

    # create a list of columns from the dataframe
    table_columns = "id"
    exchange_id = 0

    cur = conn.cursor()

    select_stmt = (
        f"SELECT {table_columns} FROM {table} WHERE acronym = '{acronym}' ORDER BY id"
    )
    cur.execute(select_stmt)
    exchanges = cur.fetchall()
    for row in exchanges:
        exchange_id = row[0]
        logger.debug(f"id for exchange acronym {acronym} is {exchange_id}.")
        break
    return exchange_id


def get_exchange_id(conn, code: str) -> int:
    """
    Read the exchange table and return the id
    Parameters:
        conn - database connection
        code - code for the exchange
    Returns:
        exchangeId if found
        0 if not found
    """
    logger.debug(f"Started with code {code}")

    table = "securities.exchange"

    # create a list of columns from the dataframe
    table_columns = "id"
    exchange_id = 0

    cur = conn.cursor()

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE code = '{code}'"
    cur.execute(select_stmt)
    exchanges = cur.fetchall()
    for row in exchanges:
        exchange_id = row[0]
        logger.debug(f"id for exchange code {code} is {exchange_id}.")
        break
    return exchange_id


def get_exchange_code(conn, id: int) -> str:
    """
    Read the exchange table using the id and return the code.
    Parameters:
        conn - database connection
        id - internal identifier for the exchange
    Returns:
        Exchange code if found
        "" if not found
    """
    logger.debug(f"Started with acronym {id}")

    table = "securities.exchange"

    # create a list of columns from the dataframe
    table_columns = "code"
    exchange_code = ""

    cur = conn.cursor()

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE id = '{id}'"
    cur.execute(select_stmt)
    exchanges = cur.fetchall()
    for row in exchanges:
        exchange_code = row[0].strip()
        logger.debug(f"code for exchange id {id} is {exchange_code}.")
        break
    return exchange_code


def get_currency_code(conn, name: str) -> str:
    """
    Read the currency table and return the id
    Parameters:
        conn - database connection
        name - name for the currency
    """
    logger.debug(f"Started with name {name}")

    table = "securities.currency"

    # create a list of columns from the dataframe
    table_columns = "code"
    currency_code = ""

    cur = conn.cursor()

    select_stmt = (
        f"SELECT {table_columns} FROM {table} WHERE UPPER(currency) = UPPER('{name}')"
    )
    cur.execute(select_stmt)
    currencies = cur.fetchall()
    for row in currencies:
        currency_code = row[0].strip()
        logger.debug(f"Code for currency name {name} is {currency_code}.")
        break
    return currency_code


def get_ticker_using_id(conn, id: int) -> tuple:
    """
    Read the ticker table and return ticker
    Parameters:
        conn - database connection
        ticker_id - id of the instrument
    """
    logger.debug("Started")

    table = "securities.ticker"

    # create a list of columns from the dataframe
    table_columns = "ticker, exchange_id"

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE id = {id}"

    try:
        cur = conn.cursor()
        cur.execute(select_stmt)
        tickers = cur.fetchall()
    except (Exception, psycopg2.Error) as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()

    if tickers:
        for row in tickers:
            ticker = row[0]
            exchange_id = row[1]
            exchange_code = get_exchange_code(conn, exchange_id)
            logger.debug(
                f"ticker for id {id} is {ticker} and exchange code is {exchange_code}"
            )
            return (ticker, exchange_code.strip())

    logger.debug(f"Ticker_id {id} cannot be found in {table}")
    return ()


def get_ticker_id(conn, exchange_code: str, ticker: str) -> int:
    """
    Read the ticker table and return ticker_id
    Parameters:
        conn - database connection
        ticker - name of the instrument
    """
    logger.debug("Started")

    table = "securities.ticker"

    # create a list of columns from the dataframe
    table_columns = "id"
    ticker_id = 0
    exchange_id = get_exchange_id(conn, exchange_code)
    select_stmt = f"SELECT {table_columns} FROM {table} WHERE ticker = '{ticker}' AND exchange_id = '{exchange_id}'"

    try:
        cur = conn.cursor()
        cur.execute(select_stmt)
        tickers = cur.fetchall()
    except (Exception, psycopg2.Error) as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()

    if tickers:
        for row in tickers:
            ticker_id = row[0]
            logger.debug(f"ticker_id for ticker {ticker} is {ticker_id}.")
            return ticker_id
    logger.debug(f"Ticker {ticker} cannot be found in {table}")
    return ticker_id


def get_ticker_id_using_yahoo_ticker(conn, yahoo_ticker: str) -> int:
    """
    Read the ticker table and return ticker_id
    Parameters:
        conn - database connection
        yahoo_ticker - name of the instrument
    """
    logger.debug("Started")

    table = "securities.ticker"

    # create a list of columns from the dataframe
    table_columns = "id"

    select_stmt = (
        f"SELECT {table_columns} FROM {table} WHERE yahoo_ticker = '{yahoo_ticker}'"
    )

    try:
        cur = conn.cursor()
        cur.execute(select_stmt)
        tickers = cur.fetchall()
    except (Exception, psycopg2.Error) as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()

    if tickers:
        for row in tickers:
            ticker_id = row[0]
            logger.debug(f"ticker_id for ticker {yahoo_ticker} is {ticker_id}.")
            return ticker_id

    logger.debug(f"Ticker {yahoo_ticker} cannot be found in {table}")
    return 0


def get_tickers_using_exchange_code(conn, exchange_code: str) -> list:
    """
    Read the ticker table and return ticker_id
    Parameters:
        conn - database connection
        exchange - name of the instrument
    """
    logger.debug("Started")

    exchange_id = get_exchange_id(conn, exchange_code)

    table = "securities.ticker"

    # create a list of columns from the dataframe
    table_columns = "id, yahoo_ticker"

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE exchange_id = {exchange_id} AND yahoo_ticker is not null"

    try:
        cur = conn.cursor()
        cur.execute(select_stmt)
        tickers = cur.fetchall()
    except (Exception, psycopg2.Error) as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()

    yahoo_tickers = []

    if tickers:
        for row in tickers:
            ticker_id = row[0]
            yahoo_ticker = row[1]
            ticker = (ticker_id, yahoo_ticker)
            yahoo_tickers.append(ticker)

    return yahoo_tickers


def get_gics_sector_code(conn, sector_name: str) -> str:
    """Get the sector code from the sector name.

    Args:
        conn (connection): postgreSQL connection
        sector_name (str): The sector name whose code will be found.

    Returns:
        str: The code of the sector
    """
    logger.debug("Started")
    table = "securities.gics_sector"

    # create a list of columns to get from the table
    table_columns = "code"

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE name = '{sector_name}'"

    try:
        cur = conn.cursor()
        cur.execute(select_stmt)
        codes = cur.fetchall()
    except (Exception, psycopg2.Error) as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()

    if codes:
        for row in codes:
            code = row[0]
            return code

    logger.debug(f"Sector_name {sector_name} cannot be found in {table}")
    return ""


def get_gics_industry_group_code(conn, industry_group_name: str) -> str:
    logger.debug("Started")
    table = "securities.gics_industry_group"

    # create a list of columns to get from the table
    table_columns = "code"

    select_stmt = (
        f"SELECT {table_columns} FROM {table} WHERE name = '{industry_group_name}'"
    )

    try:
        cur = conn.cursor()
        cur.execute(select_stmt)
        codes = cur.fetchall()
    except (Exception, psycopg2.Error) as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()

    if codes:
        for row in codes:
            code = row[0]
            return code

    logger.debug(
        f"Industry_group_name {industry_group_name} cannot be found in {table}"
    )
    return ""


def get_gics_industry_code(conn, industry_name: str) -> str:
    logger.debug("Started")
    table = "securities.gics_industry"

    # create a list of columns to get from the table
    table_columns = "code"

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE name = '{industry_name}'"

    try:
        cur = conn.cursor()
        cur.execute(select_stmt)
        codes = cur.fetchall()
    except (Exception, psycopg2.Error) as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()

    if codes:
        for row in codes:
            code = row[0]
            return code

    logger.debug(f"Industry_name {industry_name} cannot be found in {table}")
    return ""


def get_gics_sub_industry_code(conn, sub_industry_name: str) -> str:
    logger.debug("Started")
    table = "securities.gics_sub_industry"

    # create a list of columns to get from the table
    table_columns = "code"

    select_stmt = (
        f"SELECT {table_columns} FROM {table} WHERE name = '{sub_industry_name}'"
    )

    try:
        cur = conn.cursor()
        cur.execute(select_stmt)
        codes = cur.fetchall()
    except (Exception, psycopg2.Error) as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()

    if codes:
        for row in codes:
            code = row[0]
            return code

    logger.debug(f"Sub_industry_name {sub_industry_name} cannot be found in {table}")
    return ""


def get_gics_sector_id_from_name(conn, sector_name: str) -> int:
    """Get the sector code from the sector name.

    Args:
        conn (connection): postgreSQL connection
        sector_name (str): The sector name whose code will be found.

    Returns:
        str: The id of the sector
    """
    table = "securities.gics_sector"
    id = 0

    # create a list of columns to get from the table
    table_columns = "id"

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE name = '{sector_name}'"

    try:
        cur = conn.cursor()
        cur.execute(select_stmt)
        ids = cur.fetchall()
        for row in ids:
            id = row[0]
            break
    except (Exception, psycopg2.Error) as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()
        # logger.debug(f"Sector name is {sector_name}. Sector id is {str(id)}")
        return id


def get_gics_industry_group_id_from_name(conn, industry_group_name: str) -> int:
    logger.debug("Started")
    table = "securities.gics_industry_group"
    id = 0
    # create a list of columns to get from the table
    table_columns = "id"

    select_stmt = (
        f"SELECT {table_columns} FROM {table} WHERE name = '{industry_group_name}'"
    )

    try:
        cur = conn.cursor()
        cur.execute(select_stmt)
        ids = cur.fetchall()
        for row in ids:
            id = row[0]
            break
    except (Exception, psycopg2.Error) as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()
        return id


def get_gics_industry_id_from_name(conn, industry_name: str) -> int:
    logger.debug("Started")
    table = "securities.gics_industry"
    id = 0
    # create a list of columns to get from the table
    table_columns = "id"

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE name = '{industry_name}'"

    try:
        cur = conn.cursor()
        cur.execute(select_stmt)
        ids = cur.fetchall()
        for row in ids:
            id = row[0]
            break
    except (Exception, psycopg2.Error) as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()
        return id


def get_gics_sub_industry_id_from_name(conn, sub_industry_name: str) -> int:
    logger.debug("Started")
    table = "securities.gics_sub_industry"
    id = 0

    # create a list of columns to get from the table
    table_columns = "id"

    select_stmt = (
        f"SELECT {table_columns} FROM {table} WHERE name = '{sub_industry_name}'"
    )

    try:
        cur = conn.cursor()
        cur.execute(select_stmt)
        ids = cur.fetchall()
        for row in ids:
            id = row[0]
            break
    except (Exception, psycopg2.Error) as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()
        return id


def get_gics_sector_id_from_industry_group_id(conn, industry_group_id: int) -> int:
    logger.debug("Started")
    table = "securities.gics_industry_group"
    sector_id = 0
    # create a list of columns to get from the table
    table_columns = "sector_id"

    select_stmt = (
        f"SELECT {table_columns} FROM {table} WHERE id = '{industry_group_id}'"
    )

    try:
        cur = conn.cursor()
        cur.execute(select_stmt)
        sector_ids = cur.fetchall()
        for row in sector_ids:
            sector_id = row[0]
            break
    except (Exception, psycopg2.Error) as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()
        return sector_id

    # if sector_ids:
    #     for row in sector_ids:
    #         sector_id = row[0]
    #         return sector_id

    # logger.debug(
    #     f"Industry_group_name {industry_group_id} cannot be found in {table}"
    # )
    # return 0


def add_tickers(conn, ticker_list: pd.DataFrame) -> None:
    """
    Adds a tickers to the ticker table
    Parameters:
        conn - database connection
        ticker_list - dataframe of tickers
    """
    logger.debug("Started")

    table = "securities.ticker"

    # create a list of columns from the dataframe
    table_columns = list(ticker_list.columns)
    columns = ",".join(table_columns)
    # create VALUES('%s', '%s',...) one '%s' per column
    values = f"VALUES({','.join(['%s' for _ in ticker_list])})"
    # create INSERT INTO table (columns) VALUES('%s',...)
    insert_stmt = f"INSERT INTO {table} ({columns}) {values}"
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        psycopg2.extras.execute_batch(cur, insert_stmt, ticker_list.values)
        conn.commit()
        logger.info(f"{ticker_list.shape[0]} rows added to {table} table.")
    except psycopg2.Error as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()


def add_or_update_tickers(conn, ticker_list: pd.DataFrame) -> None:
    """
    Adds a tickers to the ticker table
    Parameters:
        conn - database connection
        ticker_list - dataframe of tickers
    """
    logger.debug("Started")

    table = "securities.ticker"

    # create a list of columns from the dataframe
    table_columns = list(ticker_list.columns)
    columns = ",".join(table_columns)
    # create VALUES('%s', '%s',...) one '%s' per column
    values = ", ".join(["%s" for _ in table_columns])
    # column names to use for update when there is a conflict
    conflict_columns = ", ".join(["EXCLUDED." + column for column in table_columns])
    # create INSERT INTO table (columns) VALUES('%s',...)
    insert_stmt = f"INSERT INTO {table} ({columns}) VALUES ({values}) ON CONFLICT (exchange_id, ticker) DO UPDATE SET ({columns}, last_updated_date) = ({conflict_columns}, CURRENT_TIMESTAMP)"
    # print(insert_stmt)
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        psycopg2.extras.execute_batch(cur, insert_stmt, ticker_list.values)
        conn.commit()
        logger.info(f"{ticker_list.shape[0]} rows added to {table} table.")
    except (Exception, psycopg2.Error) as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()


def add_or_update_watchlist_tickers(conn, watchlist_ticker_list: pd.DataFrame) -> None:
    """
    Adds watchlists to the watchlist_ticker table
    Parameters:
        conn - database connection
        watchlist_ticker_list - dataframe of watchlists
    """
    logger.debug("Started")

    table = "securities.watchlist_ticker"

    # create a list of columns from the dataframe
    table_columns = list(watchlist_ticker_list.columns)
    columns = ",".join(table_columns)
    # create VALUES('%s', '%s',...) one '%s' per column
    values = ", ".join(["%s" for _ in table_columns])
    # column names to use for update when there is a conflict
    conflict_columns = ", ".join(["EXCLUDED." + column for column in table_columns])
    # create INSERT INTO table (columns) VALUES('%s',...)
    insert_stmt = f"INSERT INTO {table} ({columns}) VALUES ({values}) ON CONFLICT (watchlist_group_name, watchlist_name, ticker_id) DO UPDATE SET ({columns}, last_updated_date) = ({conflict_columns}, CURRENT_TIMESTAMP)"
    # print(insert_stmt)

    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        psycopg2.extras.execute_batch(cur, insert_stmt, watchlist_ticker_list.values)
        conn.commit()
        logger.info(f"{watchlist_ticker_list.shape[0]} rows added to {table} table.")
    except (Exception, psycopg2.Error) as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()


def add_or_update_ohlcvs(conn, daily_price_list: pd.DataFrame) -> None:
    """
    Adds a tickers to the ticker table
    Parameters:
        conn - database connection
        daily_price_list - dataframe of tickers
    """
    logger.debug("Started")

    table = "securities.ohlcv"

    # create a list of columns from the dataframe
    table_columns = list(daily_price_list.columns)
    columns = ",".join(table_columns)
    # create VALUES('%s', '%s',...) one '%s' per column
    values = ", ".join(["%s" for _ in table_columns])
    # column names to use for update when there is a conflict
    conflict_columns = ", ".join(["EXCLUDED." + column for column in table_columns])
    # create INSERT INTO table (columns) VALUES('%s',...)
    insert_stmt = f"INSERT INTO {table} ({columns}) VALUES ({values}) ON CONFLICT (data_vendor_id, ticker_id, date) DO UPDATE SET ({columns}, last_updated_date) = ({conflict_columns}, CURRENT_TIMESTAMP)"
    # print(insert_stmt)
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        psycopg2.extras.execute_batch(cur, insert_stmt, daily_price_list.values)
        conn.commit()
        logger.info(f"{daily_price_list.shape[0]} rows added to {table} table.")
    except (Exception, psycopg2.Error) as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()


def get_watchlist_id_from_code(conn, code: str) -> int:
    logger.debug("Started")
    table = "securities.watchlist"
    id = 0

    # create a list of columns to get from the table
    table_columns = "id"

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE code = '{code}'"

    try:
        cur = conn.cursor()
        cur.execute(select_stmt)
        ids = cur.fetchall()
        for row in ids:
            id = row[0]
            break
    except (Exception, psycopg2.Error) as error:
        logger.exception("")
    finally:
        if conn:
            cur.close()
        return id
