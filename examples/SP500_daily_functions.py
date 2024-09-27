"""
Date: 2/05/2023
Author: Rob Bebbington

Get the daily historic data from Yahoo Finance and insert them into our database
for the symbols in the database.
"""

from datetime import datetime as dt
import psycopg2
import psycopg2.extras
import yfinance as yf


def obtain_list_of_db_tickers(conn):
    """
    Obtains a list of the ticker symbols in the database
    """
    try:
        cur = conn.cursor()
        cur.execute("SELECT id, ticker from equity.symbol")
        conn.commit()
        data = cur.fetchall()
        return [(d[0], d[1]) for d in data]
    except psycopg2.Error as error1:
        print("Error while getting tickers from PostgreSQL", error1)
    finally:
        if conn:
            cur.close()
            print("PostgreSQL cursor is closed")


def get_daily_historic_data_yahoo_finance(ticker, start, end):
    """
    Use yfinance to get daily stock data from a ticker.
    """

    obj = yf.Ticker(ticker)
    data = obj.history(start=start, end=end)  # data returned as a Pandas dataframe
    return data


def insert_daily_data_into_db(conn, data_vendor_id, symbol_id, daily_data):
    """
    Takes a pandas dataframe of daily data and adds it to the PostgreSQL
    database.
    Append the vendor ID, symbol ID, created_date, last_updated_date to the data.
    Appends the dataframe index as a column and removes the time zone.
    Deletes columns that are not needed.
    """

    daily_data["data_vendor_id"] = data_vendor_id
    daily_data["symbol_id"] = symbol_id
    daily_data["created_date"] = dt.utcnow()
    daily_data["last_updated_date"] = dt.utcnow()
    daily_data["index_date"] = daily_data.index
    daily_data["price_date"] = daily_data["index_date"].dt.tz_localize(None)
    daily_data.drop(["Dividends", "Stock Splits", "index_date"], axis=1, inplace=True)
    # print(daily_data.head())

    table = "equity.daily_price"

    # create (col1, col2,...)
    table_columns = [
        "open_price",
        "high_price",
        "low_price",
        "close_price",
        "volume",
        "data_vendor_id",
        "symbol_id",
        "created_date",
        "last_updated_date",
        "price_date",
    ]
    columns = ",".join(table_columns)
    # print(f'columns: {columns}')

    # create VALUES('%s', '%s',...) one '%s' per column
    values = f"VALUES({','.join(['%s' for _ in daily_data])})"
    # print(f'values: {values}')

    # create INSERT INTO table (columns) VALUES('%s',...)
    insert_stmt = f"INSERT INTO {table} ({columns}) {values}"
    # print(f'insert_stmt {insert_stmt}')

    # print(f'daily_data.values: {daily_data.values}')

    try:
        cur = conn.cursor()
        psycopg2.extras.execute_batch(cur, insert_stmt, daily_data.values)
        conn.commit()
    except psycopg2.Error as error:
        print("Error while inserting tickers to PostgreSQL", error)
    finally:
        if conn:
            cur.close()
            # print("PostgreSQL cursor is closed")
