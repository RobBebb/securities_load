import logging
from datetime import date, timedelta

import pandas as pd
import yfinance as yf

from securities_load.securities.postgresql_database_functions import (
    connect,
    sqlalchemy_engine,
)
from securities_load.securities.securities_table_functions import (
    add_or_update_option_data,
    add_or_update_tickers,
    get_data_vendor_id,
    get_exchange_id,
    get_ticker_id,
    get_ticker_type_id,
    get_yahoo_ticker_using_ticker_id,
    retrieve_ticker_ids_for_watchlist_code,
)

logger = logging.getLogger(__name__)


def load_option_data_from_yahoo() -> None:
    """
    Get the tickers and load them into the equity ticker table"""

    logger.debug("Started")

    pd.options.mode.copy_on_write = True

    # Open a connection
    conn = connect()
    engine = sqlalchemy_engine()

    YAHOO_CODE = "Yahoo"
    WATCHLIST_CODE = "Options to Download"
    EXCHANGE_CODE = "XCBO"
    TICKER_TYPE_CODE = "option"

    exchange_id = get_exchange_id(engine, EXCHANGE_CODE)
    if exchange_id is None:
        logger.error(f"No exchange_id found for EXCHANGE_CODE: {EXCHANGE_CODE}!")
        return

    ticker_type_id = get_ticker_type_id(engine, TICKER_TYPE_CODE)
    if ticker_type_id is None:
        logger.error(
            f"No ticker_type_id found for TICKER_TYPE_CODE: {TICKER_TYPE_CODE}!"
        )
        return

    data_vendor_id = get_data_vendor_id(engine, YAHOO_CODE)
    if data_vendor_id is None:
        logger.error(f"No data_vendor_id found for YAHOO_CODE: {YAHOO_CODE}!")
        return

    # Get all the ticker ids for the watchlist code
    ticker_ids = retrieve_ticker_ids_for_watchlist_code(engine, WATCHLIST_CODE)

    if ticker_ids is None:
        logger.error(f"No ticker ids found for WATCHLIST_CODE: {WATCHLIST_CODE}!")
        return

    # Loop through the ticker ids.
    for id in ticker_ids:
        # Get the yahoo ticker_id
        yahoo_ticker = get_yahoo_ticker_using_ticker_id(engine, id)
        if yahoo_ticker is None:
            logger.error(f"No Yahoo ticker found for ticker id: {id}!")
            continue

        # Set up a yahoo finance ticker object
        yf_ticker = yf.Ticker(yahoo_ticker)
        logger.debug(f"Prcessing ticker: {yahoo_ticker}")

        # Get all the expiry dates for the ticker
        expiries = yf_ticker.options

        # Loop through thwe expiry dates
        for expiry in expiries:
            logger.debug(f"Prcessing ticker: {yahoo_ticker}, expiry: {expiry}")
            try:
                opt = yf_ticker.option_chain(expiry)
                # Extract the call and put dataframes
                calls = opt.calls
                puts = opt.puts
            except Exception as e:
                logger.error(
                    f"Error processing {yahoo_ticker} for expiry {expiry}: {e}"
                )
                continue

            # Process and clean the call tickers
            if calls is not None:
                call_ticker_df = calls[["contractSymbol", "strike", "currency"]]
                columns = ["ticker", "strike", "currency_code"]
                call_ticker_df.columns = columns
                call_ticker_df["expiry_date"] = expiry
                call_ticker_df["underlying_ticker"] = id
                call_ticker_df["call_put"] = "C"
                call_ticker_df["exchange_id"] = exchange_id
                call_ticker_df["ticker_type_id"] = ticker_type_id
                # Add the tickers for all the strikes to the database
                add_or_update_tickers(conn, call_ticker_df)
                conn.close()

                conn = connect()
                # Process and clean the call data
                call_data_df = calls[
                    [
                        "contractSymbol",
                        "lastTradeDate",
                        "lastPrice",
                        "bid",
                        "ask",
                        "change",
                        "percentChange",
                        "volume",
                        "openInterest",
                        "impliedVolatility",
                        "inTheMoney",
                    ]
                ]
                columns = [
                    "option_symbol",
                    "last_trade_date",
                    "last_price",
                    "bid",
                    "ask",
                    "change",
                    "percent_change",
                    "volume",
                    "open_interest",
                    "implied_volatility",
                    "in_the_money",
                ]
                call_data_df.columns = columns
                call_data_df["data_vendor_id"] = data_vendor_id
                call_data_df["date"] = date.today() - timedelta(days=1)
                call_data_df["in_the_money"] = call_data_df["in_the_money"].replace(
                    {True: "T"}
                )
                call_data_df["in_the_money"] = call_data_df["in_the_money"].replace(
                    {False: "F"}
                )
                call_data_df["volume"] = call_data_df["volume"].fillna(0)
                call_data_df["percent_change"] = call_data_df["percent_change"].fillna(
                    0
                )
                call_data_df.set_index("option_symbol", inplace=True)
                # Loop through the call data getting the ticker_id for the tickers added above
                for index, row in call_data_df.iterrows():
                    # Get the ticker id for the ticker
                    option_ticker_id = get_ticker_id(engine, EXCHANGE_CODE, index)
                    if option_ticker_id is None:
                        logger.error(
                            f"No option_ticker_id found for call index {index}"
                        )
                        continue
                    call_data_df.loc[index, "ticker_id"] = option_ticker_id

                call_data_df.reset_index(inplace=True, drop=True)

                # Add the call data to the database
                add_or_update_option_data(conn, call_data_df)
                conn.close()

            if puts is not None:
                conn = connect()
                # Process and clean the put tickers
                put_ticker_df = puts[["contractSymbol", "strike", "currency"]]
                columns = ["ticker", "strike", "currency_code"]
                put_ticker_df.columns = columns
                put_ticker_df["expiry_date"] = expiry
                put_ticker_df["underlying_ticker"] = id
                put_ticker_df["call_put"] = "P"
                put_ticker_df["exchange_id"] = exchange_id
                put_ticker_df["ticker_type_id"] = ticker_type_id

                # Add the tickers for all the strikes to the database
                add_or_update_tickers(conn, put_ticker_df)
                conn.close()

                conn = connect()
                # Process and clean the put data
                put_data_df = puts[
                    [
                        "contractSymbol",
                        "lastTradeDate",
                        "lastPrice",
                        "bid",
                        "ask",
                        "change",
                        "percentChange",
                        "volume",
                        "openInterest",
                        "impliedVolatility",
                        "inTheMoney",
                    ]
                ]
                columns = [
                    "option_symbol",
                    "last_trade_date",
                    "last_price",
                    "bid",
                    "ask",
                    "change",
                    "percent_change",
                    "volume",
                    "open_interest",
                    "implied_volatility",
                    "in_the_money",
                ]
                put_data_df.columns = columns
                put_data_df["data_vendor_id"] = data_vendor_id
                put_data_df["date"] = date.today() - timedelta(days=1)
                put_data_df["in_the_money"] = put_data_df["in_the_money"].replace(
                    {True: "T"}
                )
                put_data_df["in_the_money"] = put_data_df["in_the_money"].replace(
                    {False: "F"}
                )
                put_data_df["volume"] = put_data_df["volume"].fillna(0)
                put_data_df["percent_change"] = put_data_df["percent_change"].fillna(0)
                put_data_df.set_index("option_symbol", inplace=True)
                # print("Adding put_data_df")
                # print("put_data_df", put_data_df.head(100))
                # Loop through the put data getting the ticker_id for the tickers added above
                for index, row in put_data_df.iterrows():
                    # Get the ticker id for the ticker
                    option_ticker_id = get_ticker_id(engine, EXCHANGE_CODE, index)
                    if option_ticker_id is None:
                        logger.error(f"No option_ticker_id found for put index {index}")
                        continue
                    put_data_df.loc[index, "ticker_id"] = option_ticker_id
                    # print("index", index)
                    # print("ticker_id", option_ticker_id)
                # print("data_df", put_data_df.head())
                # print("Adding put_data_df 2")
                # print("put_data_df 2", put_data_df.head(100))
                put_data_df.reset_index(inplace=True, drop=True)
                # print("data_df", put_data_df.head())
                # Add the put data to the database
                # print("Adding put_data_df")
                # print("put_data_df", put_data_df.head(100))
                add_or_update_option_data(conn, put_data_df)

    # Close the connection
    conn.close()
    logger.debug("Finished")
