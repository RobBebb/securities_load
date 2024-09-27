"""
Date: 15/9/2024
Author: Rob Bebbington

Get the dividend data from the local polygon schema and load it into the securities schema.
"""

import logging

import psycopg2

# import psycopg2.extras
# import pandas as pd
module_logger = logging.getLogger(__name__)


def add_dividends(conn):
    """
    Adds dividends to the dividend table
    Parameters:
        conn - database connection
    """

    module_logger.debug("Started")

    table = "securities.dividend"

    # create a list of columns from the dataframe
    columns = """cash_amount, currency, declaration_date, type,
        ex_dividend_date, frequency, pay_date, record_date, ticker_id,
        ticker"""
    # create VALUES('%s', '%s',...) one '%s' per column
    values = """SELECT cash_amount, d.currency, declaration_date, dividend_type,
        ex_dividend_date, frequency, pay_date, record_date, t.id,
        d.ticker FROM polygon.dividend d
        LEFT JOIN securities.ticker t
        ON d.ticker = t.ticker"""
    # create INSERT INTO table (columns) VALUES('%s',...)
    conflict = """ON CONFLICT ON CONSTRAINT unique_dividend
        DO UPDATE SET (cash_amount, currency, declaration_date, type,
        ex_dividend_date, frequency, pay_date, record_date, ticker_id,
        ticker, last_updated_date)
        = (EXCLUDED.cash_amount, EXCLUDED.currency, EXCLUDED.declaration_date,
        EXCLUDED.type, EXCLUDED.ex_dividend_date, EXCLUDED.frequency,
        EXCLUDED.pay_date, EXCLUDED.record_date, EXCLUDED.ticker_id,
        EXCLUDED.ticker, CURRENT_TIMESTAMP)"""
    insert_stmt = f"INSERT INTO {table} ({columns}) {values} {conflict};"

    module_logger.debug(f"Insert statement: {insert_stmt}")
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        cur.execute(insert_stmt)
        conn.commit()
        module_logger.info(f"Insert to table {table} successful.")
    except psycopg2.Error as error:
        module_logger.error(f"Error while inserting tickers to {table}", error)
    finally:
        if conn:
            cur.close()


def add_splits(conn):
    """
    Adds splits to the split table
    Parameters:
        conn - database connection
    """

    module_logger.debug("Started")

    table = "securities.split"

    # create a list of columns from the dataframe
    columns = """execution_date, split_from, split_to, ticker_id,
        ticker"""
    # create VALUES('%s', '%s',...) one '%s' per column
    values = """SELECT execution_date, split_from, split_to, t.id,
        s.ticker FROM polygon.split s
        LEFT JOIN securities.ticker t
        on s.ticker = t.ticker"""
    # create INSERT INTO table (columns) VALUES('%s',...)
    conflict = """ON CONFLICT ON CONSTRAINT unique_split
        DO UPDATE SET (execution_date, split_from, split_to,
        ticker, last_updated_date)
        = (EXCLUDED.execution_date, EXCLUDED.split_from, EXCLUDED.split_to,
        EXCLUDED.ticker, CURRENT_TIMESTAMP)"""
    insert_stmt = f"INSERT INTO {table} ({columns}) {values} {conflict};"

    module_logger.debug(f"Insert statement: {insert_stmt}")

    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        cur.execute(insert_stmt)
        conn.commit()
        module_logger.info(f"Insert to table {table} successful.")
    except psycopg2.Error as error:
        module_logger.error(f"Error while inserting tickers to {table}", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")


def add_index_tickers(conn):
    """
    Adds a tickers to the ticker table
    Parameters:
        conn - database connection
    """
    module_logger.debug("Started")

    ticker_type_id = get_ticker_type_id(conn, "index")

    table = "securities.ticker"

    # create a list of columns from the dataframe
    columns = """ticker, figi, name, delisted_utc, ticker_type_id"""
    # create VALUES('%s', '%s',...) one '%s' per column
    values = (
        f"SELECT ticker, composite_figi, name, delisted_utc, {ticker_type_id}"
        " FROM polygon.ticker WHERE market = 'indices'"
    )
    # what to do on conflict
    conflict = (
        "ON CONFLICT (exchange_id, ticker) "
        "DO UPDATE SET (figi, name, delisted_utc, ticker_type_id, last_updated_date) "
        f"= (EXCLUDED.figi, EXCLUDED.name, EXCLUDED.delisted_utc, {ticker_type_id}, "
        "CURRENT_TIMESTAMP)"
    )

    # create INSERT INTO table (columns) VALUES('%s',...)
    insert_stmt = f"INSERT INTO {table} ({columns}) {values} {conflict};"
    # print(insert_stmt)
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        cur.execute(insert_stmt)
        conn.commit()
        module_logger.info(f"Insert to table {table} successful.")
    except psycopg2.Error as error:
        module_logger.error(f"Error while inserting tickers to {table}", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")


def add_stock_tickers(conn):
    """
    Adds a tickers to the ticker table
    Parameters:
        conn - database connection
    """
    module_logger.debug("Started")

    ticker_type_id = get_ticker_type_id(conn, "stock")
    currency_code = get_currency_code(conn, "US Dollar")

    table = "securities.ticker"

    # create a list of columns from the dataframe
    columns = """exchange_id, ticker, figi, name, currency_code, delisted_utc, ticker_type_id"""
    # create VALUES('%s', '%s',...) one '%s' per column
    values = (
        f"SELECT e.id, ticker, composite_figi, t.name, '{currency_code}', delisted_utc, {ticker_type_id}"
        " FROM polygon.ticker t"
        " LEFT JOIN securities.exchange e ON e.code = t.primary_exchange"
        " WHERE market = 'stocks' AND type = 'CS'"
    )
    # what to do on conflict
    conflict = (
        "ON CONFLICT (exchange_id, ticker) "
        "DO UPDATE SET (figi, name, currency_code, delisted_utc, ticker_type_id, last_updated_date) "
        "= (EXCLUDED.figi, EXCLUDED.name, EXCLUDED.currency_code, EXCLUDED.delisted_utc, EXCLUDED.ticker_type_id, CURRENT_TIMESTAMP)"
    )

    # create INSERT INTO table (columns) VALUES('%s',...)
    insert_stmt = f"INSERT INTO {table} ({columns}) {values} {conflict};"
    # print(insert_stmt)
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        cur.execute(insert_stmt)
        conn.commit()
        module_logger.info(f"Insert to table {table} successful.")
    except psycopg2.Error as error:
        module_logger.error(f"Error while inserting tickers to {table}", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")


def add_etp_tickers(conn):
    """
    Adds a tickers to the ticker table
    Parameters:
        conn - database connection
    """
    module_logger.debug("Started")

    ticker_type_id = get_ticker_type_id(conn, "etp")
    currency_code = get_currency_code(conn, "US Dollar")

    table = "securities.ticker"

    # create a list of columns from the dataframe
    columns = """ticker, figi, name, currency_code, exchange_id, delisted_utc, ticker_type_id"""
    # create VALUES('%s', '%s',...) one '%s' per column
    values = (
        f"SELECT ticker, composite_figi, t.name, '{currency_code}', e.id, delisted_utc, {ticker_type_id}"
        " FROM polygon.ticker t"
        " LEFT JOIN securities.exchange e on e.code = t.primary_exchange"
        " WHERE market = 'stocks' AND type IN ('ETF', 'ETN', 'ETS', 'ETV')"
    )
    # what to do on conflict
    conflict = (
        "ON CONFLICT (exchange_id, ticker) "
        "DO UPDATE SET (figi, name, currency_code, delisted_utc, ticker_type_id, last_updated_date) "
        f"= (EXCLUDED.figi, EXCLUDED.name, '{currency_code}', EXCLUDED.delisted_utc, {ticker_type_id}, CURRENT_TIMESTAMP)"
    )

    # create INSERT INTO table (columns) VALUES('%s',...)
    insert_stmt = f"INSERT INTO {table} ({columns}) {values} {conflict};"
    # print(insert_stmt)
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        cur.execute(insert_stmt)
        conn.commit()
        module_logger.info(f"Insert to table {table} successful.")
    except psycopg2.Error as error:
        module_logger.error(f"Error while inserting tickers to {table}", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")


def get_ticker_type_id(conn, code):
    """
    Read the ticker_type table and return the id
    Parameters:
        conn - database connection
        code - code for the ticker_type
    """
    module_logger.debug(f"Started with code {code}")

    table = "securities.ticker_type"

    # create a list of columns from the dataframe
    table_columns = "id"

    cur = conn.cursor()

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE code = '{code}'"
    cur.execute(select_stmt)
    ticker_types = cur.fetchall()
    for row in ticker_types:
        ticker_type_id = row[0]
        module_logger.debug(f"id for ticker_type code {code} is {ticker_type_id}.")
        break
    return ticker_type_id


def get_exchange_id(conn, code):
    """
    Read the exchange table and return the id
    Parameters:
        conn - database connection
        code - code for the exchange
    """
    module_logger.debug(f"Started with code {code}")

    table = "securities.exchange"

    # create a list of columns from the dataframe
    table_columns = "id"

    cur = conn.cursor()

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE code = '{code}'"
    cur.execute(select_stmt)
    exchanges = cur.fetchall()
    for row in exchanges:
        exchange_id = row[0]
        module_logger.debug(f"id for exchange code {code} is {exchange_id}.")
        break
    return exchange_id


def get_currency_code(conn, name):
    """
    Read the currency table and return the id
    Parameters:
        conn - database connection
        name - name for the currency
    """
    module_logger.debug(f"Started with name {name}")

    table = "securities.currency"

    # create a list of columns from the dataframe
    table_columns = "code"

    cur = conn.cursor()

    select_stmt = (
        f"SELECT {table_columns} FROM {table} WHERE UPPER(currency) = UPPER('{name}')"
    )
    cur.execute(select_stmt)
    currencies = cur.fetchall()
    for row in currencies:
        currency_code = row[0]
        module_logger.debug(f"Code for currency name {name} is {currency_code}.")
        break
    return currency_code


def add_ohlcvs(conn):
    """
    Adds daily_prices to the ohlcv table
    Parameters:
        conn - database connection
    """
    module_logger.debug("Started")

    table = "securities.ohlcv"

    # create a list of columns
    columns = """data_vendor_id, ticker_id, date, open,
        high, low, close, volume,
        volume_weighted_average_price, transactions"""
    # create VALUES('%s', '%s',...) one '%s' per column. 1 is the data_vendor_id for polygon
    values = """SELECT 2, t.id, ohlcv_date, open, high, low,
        close, volume, volume_weighted_average_price, transactions
        FROM polygon.ohlcv o
        LEFT JOIN securities.ticker t
        ON o.ticker = t.ticker"""
    # create INSERT INTO table (columns) VALUES('%s',...)
    conflict = """ON CONFLICT ON CONSTRAINT unique_ohlcv
        DO UPDATE SET (open, high, low, close, volume,
        volume_weighted_average_price, transactions, last_updated_date)
        = (EXCLUDED.open,
        EXCLUDED.high, EXCLUDED.low, EXCLUDED.close,
        EXCLUDED.volume, EXCLUDED.volume_weighted_average_price,
        EXCLUDED.transactions, CURRENT_TIMESTAMP)"""
    insert_stmt = f"INSERT INTO {table} ({columns}) {values} {conflict};"
    # what to do on conflict
    print(insert_stmt)
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        cur.execute(insert_stmt)
        conn.commit()
        module_logger.info(f"Insert to table {table} successful.")
    except psycopg2.Error as error:
        module_logger.error(f"Error while inserting tickers to {table}", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")
