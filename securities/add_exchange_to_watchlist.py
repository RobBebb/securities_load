"""
This file will add the exchange to the watchlist. It will read the watchlist from a csv file, transform it and then write it back to a csv file.
"""

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import text

from securities_load.securities.postgresql_database_functions import (
    connect,
    sqlalchemy_engine,
)
from securities_load.securities.securities_table_functions import (
    get_exchange_code,
)


def add_exchange_to_watchlist(csv_file, currency) -> None:
    """
    The input file must be a csv file in the following format:
        watchlist_type,watchlist_name,exchange_code,stock_symbol

    It must have the above column heading and all columns must be comma separated.
    e.g.
    watchlist_type,watchlist_name,exchange_code,stock_symbol
    Stocks in Index,S&P 500 stocks,,MSFT

    The output file will have 'with_exchange' added to the end of the file.

    The exchange_code will be lloked up based on the stock_symbol name in the file
    and the currency that has been passed in.
    """

    engine = sqlalchemy_engine()
    # Read file into a DataFrame: df
    file = csv_file
    # file = '/home/ubuntuuser/karra/securities_load/data/stocks_in_indices.csv'
    df = pd.read_csv(file, sep=",", header=0)
    for index, row in df.iterrows():
        ticker = row["stock_symbol"]
        currency_code = currency
        table = "securities.ticker"
        # create a list of columns from the dataframe
        table_columns = "exchange_id"

        condition = "ticker = :ticker AND currency_code = :currency_code"
        data = {"ticker": ticker, "currency_code": currency_code}

        select_stmt = f"SELECT {table_columns} FROM {table} WHERE {condition}"
        sql = text(select_stmt)
        # print(ticker)
        with engine.connect() as connection:
            result = connection.execute(sql, data).fetchone()
        if result is None:
            print(f"Ticker {ticker} not found in the database.")
            continue

        exchange_code = get_exchange_code(engine, result[0])  # type: ignore
        df.loc[index, "exchange_code"] = exchange_code  # type: ignore

        output_file = file.split(".csv")[0] + "_with_exchange.csv"
        df.to_csv(output_file, index=False)
