"""
Date: 8/05/2023
Author: Rob Bebbington

CRUD functions for polygon tables.
"""

import pandas as pd
import psycopg2
import psycopg2.extras


def read_ticker_types(engine):
    """
    Read the ticker_type table and return the rows as a dataframe
    Parameters:
        conn - database connection
    """

    table = "polygon.ticker_type"

    # create a list of columns from the dataframe
    table_columns = "code, description, asset_class_type, locale"

    select_stmt = f"SELECT {table_columns} FROM {table}"
    ticker_types = pd.read_sql_query(select_stmt, con=engine, index_col="code")
    print(f"{ticker_types.shape[0]} rows read from {table} table.")
    return ticker_types


def add_ticker_types(conn, ticker_type_data):
    """
    Adds a dataframe of ticker_types to the ticker_types table
    Parameters:
        conn - database connection
        ticker_type_data - dataframe of ticker types
    """

    table = "polygon.ticker_type"

    # create a list of columns from the dataframe
    table_columns = list(ticker_type_data.columns)
    columns = ",".join(table_columns)
    # create VALUES('%s', '%s',...) one '%s' per column
    values = f"VALUES({','.join(['%s' for _ in ticker_type_data])})"
    # create INSERT INTO table (columns) VALUES('%s',...)
    insert_stmt = f"INSERT INTO {table} ({columns}) {values}"
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        psycopg2.extras.execute_batch(cur, insert_stmt, ticker_type_data.values)
        conn.commit()
        print(f"{ticker_type_data.shape[0]} rows added to {table} table.")
    except psycopg2.Error as error:
        print("Error while inserting ticker_types to PostgreSQL", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")


def add_exchanges(conn, exchange_data):
    """
    Adds a dataframe of exchanges to the exchange table
    Parameters:
        conn - database connection
        exchange_data - dataframe of exchanges
    """

    table = "polygon.exchange"

    # create a list of columns from the dataframe
    table_columns = list(exchange_data.columns)
    columns = ",".join(table_columns)
    # create VALUES('%s', '%s',...) one '%s' per column
    values = f"VALUES({','.join(['%s' for _ in exchange_data])})"
    # create INSERT INTO table (columns) VALUES('%s',...)
    insert_stmt = f"INSERT INTO {table} ({columns}) {values}"
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        psycopg2.extras.execute_batch(cur, insert_stmt, exchange_data.values)
        conn.commit()
        print(f"{exchange_data.shape[0]} rows added to {table} table.")
    except psycopg2.Error as error:
        print("Error while inserting exchanges to PostgreSQL", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")


def add_tickers(conn, ticker_data):
    """
    Adds a dataframe of tickers to the tickers table
    Parameters:
        conn - database connection
        ticker_data - dataframe of tickers
    """

    table = "polygon.ticker"

    # Correct currency names

    # create a list of columns from the dataframe
    table_columns = list(ticker_data.columns)
    columns = ",".join(table_columns)
    # create VALUES('%s', '%s',...) one '%s' per column
    values = f"VALUES({','.join(['%s' for _ in ticker_data])})"
    # create INSERT INTO table (columns) VALUES('%s',...)
    insert_stmt = f"INSERT INTO {table} ({columns}) {values}"
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        psycopg2.extras.execute_batch(cur, insert_stmt, ticker_data.values)
        conn.commit()
        print(f"{ticker_data.shape[0]} rows added to {table} table.")
    except psycopg2.Error as error:
        print("Error while inserting tickers to PostgreSQL", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")


def add_ohlcv(conn, ohlcv_data):
    """
    Adds a dataframe of ohlcv values to the ohlcv table
    Parameters:
        conn - database connection
        ohlcv_data - dataframe of ohlcv values
    """

    table = "polygon.ohlcv"
    # print(ohlcv_data.shape)
    # print(ohlcv_data.head())
    # create a list of columns from the dataframe
    table_columns = list(ohlcv_data.columns)
    columns = ",".join(table_columns)
    # create VALUES('%s', '%s',...) one '%s' per column
    values = f"VALUES({','.join(['%s' for _ in ohlcv_data])})"
    # create INSERT INTO table (columns) VALUES('%s',...)
    insert_stmt = f"INSERT INTO {table} ({columns}) {values}"
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        psycopg2.extras.execute_batch(cur, insert_stmt, ohlcv_data.values)
        conn.commit()
        print(f"{ohlcv_data.shape[0]} rows added to {table} table.")
    except psycopg2.Error as error:
        print("Error while inserting ohlcv values to PostgreSQL", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")


def add_splits(conn, split_data):
    """
    Adds a dataframe of splits to the split table
    Parameters:
        conn - database connection
        split_data - dataframe of splits
    """

    table = "polygon.split"

    # create a list of columns from the dataframe
    table_columns = list(split_data.columns)
    columns = ",".join(table_columns)
    # create VALUES('%s', '%s',...) one '%s' per column
    values = f"VALUES({','.join(['%s' for _ in split_data])})"
    # create INSERT INTO table (columns) VALUES('%s',...)
    insert_stmt = f"INSERT INTO {table} ({columns}) {values}"
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        psycopg2.extras.execute_batch(cur, insert_stmt, split_data.values)
        conn.commit()
        print(f"{split_data.shape[0]} rows added to {table} table.")
    except psycopg2.Error as error:
        print("Error while inserting splits to PostgreSQL", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")


def add_dividends(conn, dividend_data):
    """
    Adds a dataframe of dividends to the dividend table
    Parameters:
        conn - database connection
        dividend_data - dataframe of splits
    """

    table = "polygon.dividend"

    # create a list of columns from the dataframe
    table_columns = list(dividend_data.columns)
    columns = ",".join(table_columns)
    # create VALUES('%s', '%s',...) one '%s' per column
    values = f"VALUES({','.join(['%s' for _ in dividend_data])})"
    # create INSERT INTO table (columns) VALUES('%s',...)
    insert_stmt = f"INSERT INTO {table} ({columns}) {values}"
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        psycopg2.extras.execute_batch(cur, insert_stmt, dividend_data.values)
        conn.commit()
        print(f"{dividend_data.shape[0]} rows added to {table} table.")
    except psycopg2.Error as error:
        print("Error while inserting dividends to PostgreSQL", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")


def read_tickers(engine, market):
    """
    Read the ticker_type table and return the rows as a dataframe
    Parameters:
        conn - database connection
    """

    table = "polygon.ticker"

    # create a list of columns from the dataframe
    table_columns = "ticker, name, market, currency_name"

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE market = '{market}'"
    tickers = pd.read_sql_query(select_stmt, con=engine, index_col="ticker")
    print(f"{tickers.shape[0]} rows read from {table} table.")
    return tickers
