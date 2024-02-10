"""
Date: 14/10/2023
Author: Rob Bebbington

CRUD functions for equity tables.
"""

import psycopg2
import psycopg2.extras
import pandas as pd


def add_ticker_types(conn):
    """
    Adds ticker_types to the ticker_types table
    Parameters:
        conn - database connection
    """

    table = "equity.ticker_type"

    # create a list of columns from the dataframe
    columns = "code, description, asset_class_type, locale"
    # create VALUES('%s', '%s',...) one '%s' per column
    values = (
        "SELECT code, description, asset_class_type, locale FROM polygon.ticker_type"
    )
    # what to do on conflict
    conflict = """ON CONFLICT (code)
        DO UPDATE SET (description, asset_class_type, locale, last_updated_date)
        = (EXCLUDED.description, EXCLUDED.asset_class_type, EXCLUDED.locale,
        CURRENT_TIMESTAMP)"""
    # create INSERT INTO table (columns) VALUES('%s',...)
    insert_stmt = f"INSERT INTO {table} ({columns}) {values} {conflict};"
    print(insert_stmt)
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        cur.execute(insert_stmt)
        conn.commit()
        print(f"rows added to {table} table.")
    except psycopg2.Error as error:
        print("Error while inserting ticker_types to PostgreSQL", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")


def get_ticker_id(conn, ticker):
    """
    Read the ticker table and return ticker_id
    Parameters:
        conn - database connection
        ticker - name of the instrument
    """

    table = "equity.ticker"

    # create a list of columns from the dataframe
    table_columns = "id"

    cur = conn.cursor()

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE ticker = {ticker}"
    cur.execute(select_stmt)
    tickers = cur.fetchall()
    for row in tickers:
        ticker_id = row[0]
        print(f"ticker_id for ticker {ticker} is {ticker_id}.")
        break
    return ticker_id


def add_tickers(conn):
    """
    Adds a tickers to the ticker table
    Parameters:
        conn - database connection
    """

    table = "equity.ticker"

    # create a list of columns from the dataframe
    columns = """active, cik, composite_figi, currency_name, delisted_utc,
        last_updated_utc, locale, market, name, primary_exchange, share_class_figi,
        ticker, type"""
    # create VALUES('%s', '%s',...) one '%s' per column
    values = """SELECT active, cik, composite_figi, currency_name, delisted_utc,
        last_updated_utc, locale, market, name, primary_exchange, share_class_figi,
        ticker, type FROM polygon.ticker"""
    # what to do on conflict
    conflict = """ON CONFLICT (ticker)
        DO UPDATE SET (active, cik, composite_figi, currency_name, delisted_utc,
        last_updated_utc, locale, market, name, primary_exchange, share_class_figi,
        type, last_updated_date)
        = (EXCLUDED.active, EXCLUDED.cik, EXCLUDED.composite_figi,
        EXCLUDED.currency_name, EXCLUDED.delisted_utc, EXCLUDED.last_updated_utc,
        EXCLUDED.locale, EXCLUDED.market, EXCLUDED.name, EXCLUDED.primary_exchange,
        EXCLUDED.share_class_figi, EXCLUDED.type, CURRENT_TIMESTAMP)"""
    # create INSERT INTO table (columns) VALUES('%s',...)
    insert_stmt = f"INSERT INTO {table} ({columns}) {values} {conflict};"
    print(insert_stmt)
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        cur.execute(insert_stmt)
        conn.commit()
        print("rows added to {table} table.")
    except psycopg2.Error as error:
        print("Error while inserting ticker_types to PostgreSQL", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")


def add_exchanges(conn):
    """
    Adds exchanges to the exchange table
    Parameters:
        conn - database connection
    """

    table = "equity.exchange"

    # create a list of columns from the dataframe
    columns = """acronym, asset_class, polygon_exchange_id, locale, mic, name,
        operating_mic, participant_id, type, url"""
    # create VALUES('%s', '%s',...) one '%s' per column
    values = """SELECT acronym, asset_class, exchange_id, locale, mic, name,
        operating_mic, participant_id, type, url FROM polygon.exchange"""
    # create INSERT INTO table (columns) VALUES('%s',...)
    conflict = """ON CONFLICT (name)
        DO UPDATE SET (acronym, asset_class, locale, mic, name, operating_mic,
        participant_id, type, url, last_updated_date)
        = (EXCLUDED.acronym, EXCLUDED.asset_class, EXCLUDED.locale,
        EXCLUDED.mic, EXCLUDED.name, EXCLUDED.operating_mic,
        EXCLUDED.participant_id, EXCLUDED.type, EXCLUDED.url,
        CURRENT_TIMESTAMP)"""
    insert_stmt = f"INSERT INTO {table} ({columns}) {values} {conflict};"
    # what to do on conflict
    print(insert_stmt)
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        cur.execute(insert_stmt)
        conn.commit()
        print("rows added to {table} table.")
    except psycopg2.Error as error:
        print("Error while inserting exchanges to PostgreSQL", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")


def get_exchange_id(conn, mic):
    """
    Read the exchange table and return the id
    Parameters:
        conn - database connection
        mic - mic for the exchange
    """

    table = "equity.exchange"

    # create a list of columns
    table_columns = "id"

    cur = conn.cursor()

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE mic = {mic}"
    cur.execute(select_stmt)
    exchanges = cur.fetchall()
    for row in exchanges:
        exchange_id = row[0]
        print(f"id for exchange {mic} is {exchange_id}.")
        break
    return exchange_id


def get_data_vendor_id(conn, name):
    """
    Read the data_vendor table and return the id
    Parameters:
        conn - database connection
        name - name of the data vendor
    """

    table = "equity.data_vendor"

    # create a list of columns
    table_columns = "id"

    cur = conn.cursor()

    select_stmt = f"SELECT {table_columns} FROM {table} WHERE name = {name}"
    cur.execute(select_stmt)
    data_vendors = cur.fetchall()
    for row in data_vendors:
        data_vendor_id = row[0]
        print(f"id for data_vendor {name} is {data_vendor_id}.")
        break
    return data_vendor_id


def add_splits(conn):
    """
    Adds splits to the split table
    Parameters:
        conn - database connection
    """

    table = "equity.split"

    # create a list of columns from the dataframe
    columns = """execution_date, split_from, split_to, ticker_id,
        ticker"""
    # create VALUES('%s', '%s',...) one '%s' per column
    values = """SELECT execution_date, split_from, split_to, t.id,
        s.ticker FROM polygon.split s
        LEFT JOIN equity.ticker t
        on s.ticker = t.ticker"""
    # create INSERT INTO table (columns) VALUES('%s',...)
    conflict = """ON CONFLICT ON CONSTRAINT unique_split
        DO UPDATE SET (execution_date, split_from, split_to,
        ticker, last_updated_date)
        = (EXCLUDED.execution_date, EXCLUDED.split_from, EXCLUDED.split_to,
        EXCLUDED.ticker, CURRENT_TIMESTAMP)"""
    insert_stmt = f"INSERT INTO {table} ({columns}) {values} {conflict};"
    # what to do on conflict
    print(insert_stmt)
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        cur.execute(insert_stmt)
        conn.commit()
        print("rows added to {table} table.")
    except psycopg2.Error as error:
        print("Error while inserting splits to PostgreSQL", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")


def add_dividends(conn):
    """
    Adds dividends to the dividend table
    Parameters:
        conn - database connection
    """

    table = "equity.dividend"

    # create a list of columns from the dataframe
    columns = """cash_amount, currency, declaration_date, dividend_type,
        ex_dividend_date, frequency, pay_date, record_date, ticker_id,
        ticker"""
    # create VALUES('%s', '%s',...) one '%s' per column
    values = """SELECT cash_amount, d.currency, declaration_date, dividend_type,
        ex_dividend_date, frequency, pay_date, record_date, t.id,
        d.ticker FROM polygon.dividend d
        LEFT JOIN equity.ticker t
        ON d.ticker = t.ticker"""
    # create INSERT INTO table (columns) VALUES('%s',...)
    conflict = """ON CONFLICT ON CONSTRAINT unique_dividend
        DO UPDATE SET (cash_amount, currency, declaration_date, dividend_type,
        ex_dividend_date, frequency, pay_date, record_date, ticker_id,
        ticker, last_updated_date)
        = (EXCLUDED.cash_amount, EXCLUDED.currency, EXCLUDED.declaration_date,
        EXCLUDED.dividend_type, EXCLUDED.ex_dividend_date, EXCLUDED.frequency,
        EXCLUDED.pay_date, EXCLUDED.record_date, EXCLUDED.ticker_id,
        EXCLUDED.ticker, CURRENT_TIMESTAMP)"""
    insert_stmt = f"INSERT INTO {table} ({columns}) {values} {conflict};"
    # what to do on conflict
    print(insert_stmt)
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        cur.execute(insert_stmt)
        conn.commit()
        print("rows added to {table} table.")
    except psycopg2.Error as error:
        print("Error while inserting dividends to PostgreSQL", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")


def add_daily_prices(conn):
    """
    Adds daily_prices to the daily_price table
    Parameters:
        conn - database connection
    """

    table = "equity.daily_price"

    # create a list of columns
    columns = """data_vendor_id, ticker_id, ticker, polygon_timestamp, open_price,
        high_price, low_price, close_price, volume,
        volume_weighted_average_price, transactions, otc, price_date"""
    # create VALUES('%s', '%s',...) one '%s' per column. 1 is the data_vendor_id for polygon
    values = """SELECT 1, t.id, o.ticker, o.polygon_timestamp, open, high, low,
        close, volume, volume_weighted_average_price, transactions, otc, ohlcv_date
        FROM polygon.ohlcv o
        LEFT JOIN equity.ticker t
        ON o.ticker = t.ticker"""
    # create INSERT INTO table (columns) VALUES('%s',...)
    conflict = """ON CONFLICT ON CONSTRAINT unique_daily_price
        DO UPDATE SET (polygon_timestamp, open_price, high_price, low_price, close_price, volume,
        volume_weighted_average_price, transactions, otc, last_updated_date, price_date)
        = (EXCLUDED.polygon_timestamp, EXCLUDED.open_price,
        EXCLUDED.high_price, EXCLUDED.low_price, EXCLUDED.close_price,
        EXCLUDED.volume, EXCLUDED.volume_weighted_average_price,
        EXCLUDED.transactions, EXCLUDED.otc, CURRENT_TIMESTAMP, EXCLUDED.price_date)"""
    insert_stmt = f"INSERT INTO {table} ({columns}) {values} {conflict};"
    # what to do on conflict
    print(insert_stmt)
    try:
        cur = conn.cursor()
        # add the rows from the dataframe to the table
        cur.execute(insert_stmt)
        conn.commit()
        print("rows added to {table} table.")
    except psycopg2.Error as error:
        print("Error while inserting daily_price to PostgreSQL", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")


def retrieve_ticker_data_from_to(conn, ticker, start_date, end_date):
    """
    Read the equity.daily_price table and return the ohlcv data for the specified period
    Parameters:
        conn - database connection
        ticker - symbol for the stock
        start_date - earliest date to get data for
        end_date - latest date to get data for
    """

    tables = """equity.ticker AS t
        INNER JOIN equity.daily_price AS dp
        ON dp.ticker_id = t.id"""

    # create a list of columns
    table_columns = """dp.price_date,
        dp.open_price AS Open,
        dp.high_price AS High,
        dp.low_price AS Low,
        dp.close_price AS Close,
        dp.volume AS Volume"""

    condition = """t.ticker = %(ticker)s
        and dp.price_date >= %(start_date)s
        and dp.price_date <= %(end_date)s"""

    params={'ticker':ticker, 'start_date':start_date, 'end_date':end_date}
    select_stmt = f"""SELECT {table_columns}
        FROM {tables}
        WHERE {condition}
        ORDER BY dp.price_date ASC"""
    # print(select_stmt)
    df = pd.read_sql_query(select_stmt, params=params, con=conn, index_col='price_date')
    return df


def retrieve_ticker_data_last_n_days(conn, ticker, days=2):
    """
    Read the equity.daily_price table and return the ohlcv data for the specified period
    Parameters:
        conn - database connection
        ticker - symbol for the stock
        days - number of days to get data for
    """

    tables = """equity.ticker AS t
        INNER JOIN equity.daily_price AS dp
        ON dp.ticker_id = t.id"""

    # create a list of columns
    table_columns = """dp.price_date,
        dp.open_price AS Open,
        dp.high_price AS High,
        dp.low_price AS Low,
        dp.close_price AS Close,
        dp.volume AS Volume"""

    condition = "t.ticker = %(ticker)s"

    params={'ticker':ticker}
    select_stmt = f"""SELECT {table_columns}
        FROM {tables}
        WHERE {condition}
        ORDER BY dp.price_date DESC
        FETCH FIRST {days} ROWS ONLY"""
    # print(select_stmt)
    df = pd.read_sql_query(select_stmt, params=params, con=conn, index_col='price_date')
    return df
