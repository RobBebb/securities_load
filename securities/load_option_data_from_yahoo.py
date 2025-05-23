import logging
from datetime import date, timedelta

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

    # Open a connection
    conn = connect()
    engine = sqlalchemy_engine()
    YAHOO_CODE = "Yahoo"
    WATCHLIST_CODE = "Options to Download"
    EXCHANGE_CODE = "XCBO"
    TICKER_TYPE_CODE = "option"

    exchange_id = get_exchange_id(engine, EXCHANGE_CODE)
    # print("exchange_id", exchange_id)

    ticker_type_id = get_ticker_type_id(engine, TICKER_TYPE_CODE)
    # print("ticker_type_id", ticker_type_id)

    data_vendor_id = get_data_vendor_id(engine, YAHOO_CODE)
    # print("data_vendor_id", data_vendor_id)

    # watchlist_id = get_watchlist_id_from_code(engine, WATCHLIST_CODE)
    # print("watchlist_id", watchlist_id)

    # Get all the ticker ids for the watchlist code
    ticker_ids = retrieve_ticker_ids_for_watchlist_code(engine, WATCHLIST_CODE)
    # print("ticker_ids", ticker_ids)

    # Loop through the ticker ids.
    if ticker_ids is None:
        raise KeyError(f"No ticker ids found for watchlist code {WATCHLIST_CODE}!")

    # Loop through the ticker ids.
    for id in ticker_ids:
        # Get the yahoo ticker_id
        yahoo_ticker = get_yahoo_ticker_using_ticker_id(engine, id)
        # print("yahoo_ticker", yahoo_ticker)
        if yahoo_ticker is None:
            raise KeyError(f"No Yahoo ticker found for ticker id {id}!")
        # Ser up a yahoo finance ticker object
        yf_ticker = yf.Ticker(yahoo_ticker)
        message = f"Prcessing ticker: {yahoo_ticker}"
        logger.info(message)
        # print(message)
        # Get all the expiry dates for the ticker
        expiries = yf_ticker.options
        # print("Available expiries:", expiries)
        # Loop through thwe expiry dates
        for expiry in expiries:
            # print("Expiry:", expiry)
            # Get the option chain for the expiry date for the ticker
            message = f"Prcessing expiry: {expiry}"
            logger.info(message)
            try:
                opt = yf_ticker.option_chain(expiry)
                # Extract the call and put dataframes
                calls = opt.calls
                puts = opt.puts
                # print("Calls DataFrame:")
                # print(calls)
                # print("Puts DataFrame:")
                # print(puts)
            except Exception as e:
                logger.error(
                    f"Error processing {yahoo_ticker} for expiry {expiry}: {e}"
                )
                # print(f"Error processing {yahoo_ticker} for expiry {expiry}: {e}")

            # Process and clean the call tickers
            call_ticker_list = calls[["contractSymbol", "strike", "currency"]]
            columns = ["ticker", "strike", "currency_code"]
            call_ticker_list.columns = columns
            call_ticker_list["expiry_date"] = expiry
            call_ticker_list["underlying_ticker"] = id
            call_ticker_list["call_put"] = "C"
            call_ticker_list["exchange_id"] = exchange_id
            call_ticker_list["ticker_type_id"] = ticker_type_id
            # print("Ticker List:")
            # print(call_ticker_list)
            # Add the tickers for all the strikes to the database
            # print("Adding call_tickers")
            if call_ticker_list is not None:
                add_or_update_tickers(conn, call_ticker_list)
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
            call_data_df["percent_change"] = call_data_df["percent_change"].fillna(0)
            call_data_df.set_index("option_symbol", inplace=True)
            # Loop through the call data getting the ticker_id for the tickers added above
            for index, row in call_data_df.iterrows():
                # Get the ticker id for the ticker
                message = f"Prcessing index: {index}"
                logger.info(message)
                option_ticker_id = get_ticker_id(engine, EXCHANGE_CODE, index)
                if option_ticker_id is None:
                    print(f"No option ticker id found for index {index}!")
                    continue
                call_data_df.loc[index, "ticker_id"] = option_ticker_id
                # print("index", index)
                # print("ticker_id", option_ticker_id)
            # print("data_df", call_data_df.head())
            call_data_df.reset_index(inplace=True, drop=True)
            # print("data_df", call_data_df.head())
            # Add the call data to the database
            # print("Adding call_data_df")
            add_or_update_option_data(conn, call_data_df)
            conn.close()
            conn = connect()
            # Process and clean the put tickers
            put_ticker_list = puts[["contractSymbol", "strike", "currency"]]
            columns = ["ticker", "strike", "currency_code"]
            put_ticker_list.columns = columns
            put_ticker_list["expiry_date"] = expiry
            put_ticker_list["underlying_ticker"] = id
            put_ticker_list["call_put"] = "P"
            put_ticker_list["exchange_id"] = exchange_id
            put_ticker_list["ticker_type_id"] = ticker_type_id
            # print("Ticker List:")
            # print(put_ticker_list)
            # Add the tickers for all the strikes to the database
            # print("Adding put_tickers")
            if put_ticker_list is not None:
                add_or_update_tickers(conn, put_ticker_list)

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
                    print(f"No option ticker id found for index {index}!")
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
