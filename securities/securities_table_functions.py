import logging

import pandas as pd
import psycopg2
import psycopg2.extras
from sqlalchemy import Engine, text

logger = logging.getLogger(__name__)


def retrieve_ohlcv_from_to(
    engine: Engine, exchange_code: str, ticker: str, start_date: str, end_date: str
) -> pd.DataFrame:
    """
    Read the securities.ohlcv table and return the ohlcv data for the specified period
    Parameters:
        engine - database engine
        exchange_code - primary exchange for the ticker
        ticker - symbol for the stock
        start_date - earliest date to get data for
        end_date - latest date to get data for
    """

    # engine = sqlalchemy_engine()
    # print("Got engine")
    # print(f"Exchange_code is: {exchange_code}")
    exchange_id = get_exchange_id(engine, exchange_code)
    print(f"Exchange_id is: {exchange_id}")
    if exchange_id is None:
        raise KeyError(f"No exchange id found for exchange code {exchange_code}!")

    tables = """securities.ticker AS t
        INNER JOIN securities.ohlcv AS o
        ON o.ticker_id = t.id"""

    # create a list of columns
    table_columns = """o.date,
        o.open AS Open,
        o.high AS High,
        o.low AS Low,
        o.close AS Close,
        o.volume AS Volume"""

    condition = """t.ticker = %(ticker)s
        and t.exchange_id = %(exchange_id)s
        and o.date >= %(start_date)s
        and o.date <= %(end_date)s"""

    params = {
        "exchange_id": exchange_id,
        "ticker": ticker,
        "start_date": start_date,
        "end_date": end_date,
    }
    select_stmt = f"""SELECT {table_columns}
        FROM {tables}
        WHERE {condition}
        ORDER BY o.date ASC"""
    # print(select_stmt)
    df = pd.read_sql_query(select_stmt, params=params, con=engine)
    df["Datetime"] = pd.to_datetime(
        df["date"].astype("string") + " 00:00:00", format="%Y-%m-%d %H:%M:%S"
    )
    df = df.set_index("Datetime")
    return df


def retrieve_ohlcv_last_n_days(
    engine: Engine, exchange_code: str, ticker: str, days: int = 2
) -> pd.DataFrame:
    """
    Read the securities.ohlcv table and return the ohlcv data for the specified period
    Parameters:
        engine - database engine
        exchange_code - primary exchange for the ticker
        ticker - symbol for the stock
        days - number of days to get data for
    """

    exchange_id = get_exchange_id(engine, exchange_code)
    if exchange_id is None:
        raise KeyError(f"No exchange id found for exchange code {exchange_code}!")

    tables = """securities.ticker AS t
        INNER JOIN securities.ohlcv AS o
        ON o.ticker_id = t.id"""

    # create a list of columns
    table_columns = """o.date,
        o.open AS Open,
        o.high AS High,
        o.low AS Low,
        o.close AS Close,
        o.volume AS Volume"""

    condition = """t.ticker = %(ticker)s
        and t.exchange_id = %(exchange_id)s
    """

    params = {
        "exchange_id": exchange_id,
        "ticker": ticker,
    }
    select_stmt = f"""SELECT {table_columns}
        FROM {tables}
        WHERE {condition}
        ORDER BY o.date DESC
        FETCH FIRST {days} ROWS ONLY"""
    # print(select_stmt)
    df = pd.read_sql_query(select_stmt, params=params, con=engine)
    df["Datetime"] = pd.to_datetime(
        df["date"].astype("string") + " 00:00:00", format="%Y-%m-%d %H:%M:%S"
    )
    df = df.set_index("Datetime")
    return df


def get_ticker_type_id(engine: Engine, code: str) -> int | None:
    """
    Read the ticker_type table and return the id
    Parameters:
        engine - database engine
        code - code for the ticker_type
        Returns:
        ticker_type_id if found
        0 if not found
    """
    logger.debug(f"Started with code {code}")

    table = "securities.ticker_type"
    table_columns = "id"
    condition = "code = :code"
    data = {"code": code}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0] if result is not None else result


def get_data_vendor_id(engine: Engine, name: str) -> int | None:
    """
    Read the ticker_type table and return the id
    Parameters:
        engine - database connection
        name - name of the data vendor
        Returns:
        ticker_type_id if found
        0 if not found
    """
    logger.debug(f"Started with name {name}")

    table = "securities.data_vendor"

    # create a list of columns from the dataframe
    table_columns = "id"
    condition = "name = :name"
    data = {"name": name}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0] if result is not None else result


def get_exchange_id_by_acronym(engine: Engine, acronym: str) -> int | None:
    """
    Read the exchange table using the acronym and return the id. Where there are
    duplicates the first found will be returned.
    Parameters:
        engine - database connection
        acronym - acronym for the exchange e.g. ASX
    Returns:
        exchangeId if found
        0 if not found
    """
    logger.debug(f"Started with acronym {acronym}")

    table = "securities.exchange"

    # create a list of columns from the dataframe
    table_columns = "id"
    condition = "acronym = :acronym"
    data = {"acronym": acronym}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition} ORDER BY id"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0] if result is not None else result


def get_exchange_id(engine: Engine, code: str) -> int | None:
    """
    Read the exchange table and return the id
    Parameters:
        engine - SQLAlchemy engine
        code - code for the exchange
    Returns:
        exchangeId if found
        None if not found
    """
    # logger.debug(f"Started with code {code}")

    # engine = sqlalchemy_engine()
    # print("Got engine")
    # print(f"Exchange_code is: {code}")

    table = "securities.exchange"
    table_columns = "id"
    condition = "code = :code"
    data = {"code": code}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0] if result is not None else result


def get_exchange_code(engine: Engine, id: int) -> str | None:
    """
    Read the exchange table using the id and return the code.
    Parameters:
        engine - database connection
        id - internal identifier for the exchange
    Returns:
        Exchange code if found
        "" if not found
    """
    logger.debug(f"Started with acronym {id}")

    table = "securities.exchange"

    # create a list of columns from the dataframe
    table_columns = "code"
    condition = "id = :id"
    data = {"id": id}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0].strip() if result is not None else result


def get_currency_code(engine: Engine, name: str) -> str | None:
    """
    Read the currency table and return the id
    Parameters:
        engine - database engine
        name - name for the currency
    """
    logger.debug(f"Started with name {name}")

    table = "securities.currency"

    # create a list of columns from the dataframe
    table_columns = "code"
    condition = "UPPER(currency) = UPPER(:name)"
    data = {"name": name}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0].strip() if result is not None else result


def get_ticker_using_id(engine: Engine, id: int) -> tuple:
    """
    Read the ticker table and return ticker
    Parameters:
        engine - database connection
        ticker_id - id of the instrument
    """
    logger.debug("Started")

    table = """securities.ticker AS t 
        INNER JOIN securities.exchange AS e 
        on t.exchange_id = e.id"""

    # create a list of columns from the dataframe
    table_columns = "t.ticker, e.code"
    condition = "t.id = :id"
    data = {"id": id}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return (result[0], result[1].strip()) if result is not None else ()


def get_ticker_id(engine: Engine, exchange_code: str, ticker: str) -> int | None:
    """
    Read the ticker table and return ticker_id
    Parameters:
        engine - database connection
        ticker - name of the instrument
    """
    # logger.debug("Started")

    table = "securities.ticker"

    # create a list of columns from the dataframe
    table_columns = "id"
    exchange_id = get_exchange_id(engine, exchange_code)
    condition = "ticker = :ticker AND exchange_id = :exchange_id"
    data = {"ticker": ticker, "exchange_id": exchange_id}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0] if result is not None else result


def get_ticker_id_using_yahoo_ticker(engine: Engine, yahoo_ticker: str) -> int | None:
    """
    Read the ticker table and return ticker_id
    Parameters:
        engine - database connection
        yahoo_ticker - name of the instrument
    """
    logger.debug("Started")

    table = "securities.ticker"

    # create a list of columns from the dataframe
    table_columns = "id"
    condition = "yahoo_ticker = :yahoo_ticker"
    data = {"yahoo_ticker": yahoo_ticker}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0] if result is not None else result


def get_tickers_using_exchange_code(engine: Engine, exchange_code: str) -> list | None:
    """
    Read the ticker table and return ticker_id
    Parameters:
        engine - database connection
        exchange - name of the instrument
    """
    logger.debug("Started")

    exchange_id = get_exchange_id(engine, exchange_code)

    table = "securities.ticker"

    # create a list of columns from the dataframe
    table_columns = "id, yahoo_ticker"
    condition = "exchange_id = :exchange_id"
    data = {"exchange_id": exchange_id}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition} AND yahoo_ticker is not null"
    sql = text(select_stmt)

    with engine.connect() as connection:
        tickers = connection.execute(sql, data).fetchall()

    yahoo_tickers = []

    if tickers:
        for row in tickers:
            ticker_id = row[0]
            yahoo_ticker = row[1]
            ticker = (ticker_id, yahoo_ticker)
            yahoo_tickers.append(ticker)

    return yahoo_tickers


def get_gics_sector_code(engine: Engine, sector_name: str) -> str | None:
    """Get the sector code from the sector name.

    Args:
        engine (connection): postgreSQL connection
        sector_name (str): The sector name whose code will be found.

    Returns:
        str: The code of the sector
    """
    logger.debug("Started")
    table = "securities.gics_sector"

    # create a list of columns to get from the table
    table_columns = "code"
    condition = "name = :sector_name"
    data = {"sector_name": sector_name}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0] if result is not None else result


def get_gics_industry_group_code(
    engine: Engine, industry_group_name: str
) -> str | None:
    logger.debug("Started")
    table = "securities.gics_industry_group"

    # create a list of columns to get from the table
    table_columns = "code"
    condition = "name = :industry_group_name"
    data = {"industry_group_name": industry_group_name}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0] if result is not None else result


def get_gics_industry_code(engine: Engine, industry_name: str) -> str | None:
    logger.debug("Started")
    table = "securities.gics_industry"

    # create a list of columns to get from the table
    table_columns = "code"
    condition = "name = :industry_name"
    data = {"industry_name": industry_name}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0] if result is not None else result


def get_gics_sub_industry_code(engine: Engine, sub_industry_name: str) -> str | None:
    logger.debug("Started")
    table = "securities.gics_sub_industry"

    # create a list of columns to get from the table
    table_columns = "code"
    condition = "name = :sub_industry_name"
    data = {"sub_industry_name": sub_industry_name}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0] if result is not None else result


def get_gics_sector_id_from_name(engine: Engine, sector_name: str) -> int | None:
    """Get the sector code from the sector name.

    Args:
        engine (connection): postgreSQL connection
        sector_name (str): The sector name whose code will be found.

    Returns:
        str: The id of the sector
    """
    table = "securities.gics_sector"

    # create a list of columns to get from the table
    table_columns = "id"
    condition = "name = :sector_name"
    data = {"sector_name": sector_name}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0] if result is not None else result


def get_gics_industry_group_id_from_name(
    engine: Engine, industry_group_name: str
) -> int | None:
    logger.debug("Started")
    table = "securities.gics_industry_group"
    # create a list of columns to get from the table
    table_columns = "id"
    condition = "name = :industry_group_name"
    data = {"industry_group_name": industry_group_name}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0] if result is not None else result


def get_gics_industry_id_from_name(engine: Engine, industry_name: str) -> int | None:
    logger.debug("Started")
    table = "securities.gics_industry"
    # create a list of columns to get from the table
    table_columns = "id"
    condition = "name = :industry_name"
    data = {"industry_name": industry_name}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0] if result is not None else result


def get_gics_sub_industry_id_from_name(
    engine: Engine, sub_industry_name: str
) -> int | None:
    logger.debug("Started")
    table = "securities.gics_sub_industry"

    # create a list of columns to get from the table
    table_columns = "id"
    condition = "name = :sub_industry_name"
    data = {"sub_industry_name": sub_industry_name}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0] if result is not None else result


def get_gics_sector_id_from_industry_group_id(
    engine: Engine, industry_group_id: int
) -> int | None:
    logger.debug("Started")
    table = "securities.gics_industry_group"
    # create a list of columns to get from the table
    table_columns = "sector_id"
    condition = "id = :industry_group_id"
    data = {"industry_group_id": industry_group_id}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0] if result is not None else result


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
        logger.exception(error)
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
        logger.exception(error)
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
    print(f"Watchlist ticker list is: {watchlist_ticker_list}")
    print(f"Watchlist ticker list shape is: {watchlist_ticker_list.shape}")
    # create a list of columns from the dataframe
    table_columns = list(watchlist_ticker_list.columns)
    print(f"Table columns are: {table_columns}")
    columns = ",".join(table_columns)
    print(f"Columns are: {columns}")
    # create VALUES('%s', '%s',...) one '%s' per column
    values = ", ".join(["%s" for _ in table_columns])
    print(f"Values are: {values}")
    # column names to use for update when there is a conflict
    conflict_columns = ", ".join(["EXCLUDED." + column for column in table_columns])
    print(f"Conflict columns are: {conflict_columns}")
    # create INSERT INTO table (columns) VALUES('%s',...)
    insert_stmt = f"INSERT INTO {table} ({columns}) VALUES ({values}) ON CONFLICT (watchlist_id, ticker_id) DO UPDATE SET ({columns}, last_updated_date) = ({conflict_columns}, CURRENT_TIMESTAMP)"
    print(f"Insert statement is: {insert_stmt}")
    print(f"Watchlist ticker list is: {watchlist_ticker_list}")
    print(f"Watchlist ticker list values are: {watchlist_ticker_list.values}")
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        psycopg2.extras.execute_batch(cur, insert_stmt, watchlist_ticker_list.values)
        conn.commit()
        logger.info(f"{watchlist_ticker_list.shape[0]} rows added to {table} table.")
    except (Exception, psycopg2.Error) as error:
        logger.exception(error)
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
        logger.exception(error)
    finally:
        if conn:
            cur.close()


def get_watchlist_id_from_code(engine: Engine, code: str) -> int | None:
    logger.debug("Started")
    table = "securities.watchlist"

    # create a list of columns to get from the table
    table_columns = "id"
    condition = "code = :code"
    data = {"code": code}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        return result[0] if result is not None else result


def retrieve_ticker_ids_for_watchlist_code(engine: Engine, code: str) -> list | None:
    """
    Read the watchlist_ticker and the ticker table and return ticker.yahoo_symbol
    Parameters:
        engine - database connection
        watchlist_code - name of the watchlist
    """
    logger.info("Started")

    # Get the watchlist.id for the watchlist.code
    watchlist_id = get_watchlist_id_from_code(engine, code)

    # Get all the ticker_ids in the watchlist_ticker table the watchlist.id

    table = "securities.watchlist_ticker"

    # create a list of columns to get from the table
    table_columns = "ticker_id"
    condition = "watchlist_id = :watchlist_id"
    data = {"watchlist_id": watchlist_id}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        tickers = connection.execute(sql, data).fetchall()

    ticker_ids = []

    if tickers:
        for row in tickers:
            ticker_id = row[0]
            ticker_ids.append(ticker_id)

    logger.info(f"Tickers retrieved is {len(tickers)}")

    return ticker_ids


def get_yahoo_ticker_using_ticker_id(engine: Engine, id: int) -> str | None:
    """
    Read the ticker table and return the yahoo_ticker
    Parameters:
        engine - database connection
        id - id of the instrument
    """
    logger.debug("Started")

    table = "securities.ticker"

    # create a list of columns from the dataframe
    table_columns = "yahoo_ticker, ticker"
    condition = "id = :id"
    data = {"id": id}

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
    sql = text(select_stmt)

    with engine.connect() as connection:
        result = connection.execute(sql, data).fetchone()
        if result is None:
            raise KeyError(f"No Yahoo ticker found for ticker id {id}!")
        if result[0] is None:
            if result[1] is None:
                raise KeyError(f"No Yahoo ticker found for ticker id {id}!")
            else:
                return result[1]
        else:
            return result[0]


def add_or_update_option_data(conn, option_data: pd.DataFrame) -> None:
    """
    Adds rows to the option data table
    Parameters:
        conn - database connection
        option_data - dataframe of option data
    """
    logger.debug("Started")

    table = "securities.option_data"

    # create a list of columns from the dataframe
    table_columns = list(option_data.columns)
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
        psycopg2.extras.execute_batch(cur, insert_stmt, option_data.values)
        conn.commit()
        logger.info(f"{option_data.shape[0]} rows added to {table} table.")
    except (Exception, psycopg2.Error) as error:
        logger.exception(error)
        logger.debug(f"option_data: {option_data}")
    finally:
        if conn:
            cur.close()
