"""
Date: 6/05/2023
Author: Rob Bebbington

Functions to access polygon.io.
"""
from datetime import datetime as dt
import os
import logging
from dotenv import load_dotenv
import pandas as pd
from dateutil.relativedelta import relativedelta
from polygon import RESTClient
from polygon import exceptions
from polygon.rest.models import (
    Exchange,
    TickerTypes,
    Ticker,
    GroupedDailyAgg,
    Split,
    Dividend,
)


def get_exchanges():
    """
    Gets a list of exchanges
    Returns a dataframe.
    docs
    https://polygon.io/docs/stocks/get_v3_reference_exchanges
    https://polygon-api-client.readthedocs.io/en/latest/Reference.html#get-exchanges
    """

    # client = RESTClient("XXXXXX") # hardcoded api_key is used
    key = os.environ["POLYGON"]
    try:
        client = RESTClient(api_key=key)  # POLYGON_API_KEY environment variable is used
    except exceptions.AuthError as error:
        print("Empty or invalid polygon API key", error)
        return

    # create a list of columns names for the dataframe
    dataframe_columns = [
        "acronym",
        "asset_class",
        "exchange_id",
        "locale",
        "mic",
        "name",
        "operating_mic",
        "participant_id",
        "type",
        "url",
    ]
    # add the column names to the dataframe
    exchange_data = pd.DataFrame(columns=dataframe_columns)

    try:
        # get the exchanges from polygon
        exchanges = client.get_exchanges()
        for exchange in exchanges:
            # verify this is an exchange
            if isinstance(exchange, Exchange):
                # Create a list of fields
                row = [
                    exchange.acronym,
                    exchange.asset_class,
                    exchange.id,
                    exchange.locale,
                    exchange.mic,
                    exchange.name,
                    exchange.operating_mic,
                    exchange.participant_id,
                    exchange.type,
                    exchange.url,
                ]
                # add the list to the dataframe as a row
                exchange_data.loc[len(exchange_data)] = row
        print(f"{exchange_data.shape[0]} exchanges read from polygon.")
        return exchange_data
    except exceptions.BadResponse as error:
        print("Non-200 response from polygon API", error)


def get_ticker_types():
    """
    Gets a list of ticker types.
    Returns a dataframe.
    docs
    https://polygon.io/docs/stocks/get_v3_reference_tickers_types
    https://polygon-api-client.readthedocs.io/en/latest/Reference.html#get-ticker-types"""

    # client = RESTClient("XXXXXX") # hardcoded api_key is used
    key = os.environ["POLYGON"]
    try:
        client = RESTClient(api_key=key)  # POLYGON_API_KEY environment variable is used
    except exceptions.AuthError as error:
        print("Empty or invalid polygon API key", error)
        return

    # create a list of columns names for the dataframe
    dataframe_columns = ["code", "description", "asset_class_type", "locale"]
    # add the column names to the dataframe
    ticker_type_data = pd.DataFrame(columns=dataframe_columns)

    try:
        # get the exchanges from polygon
        ticker_types = client.get_ticker_types()

        for ticker_type in ticker_types:
            # verify this is an ticker_type
            if isinstance(ticker_type, TickerTypes):
                # Create a list of fields
                row = [
                    ticker_type.code,
                    ticker_type.description,
                    ticker_type.asset_class,
                    ticker_type.locale,
                ]
                # add the list to the dataframe as a row
                ticker_type_data.loc[len(ticker_type_data)] = row
        print(f"{ticker_type_data.shape[0]} ticker_types read from polygon.")
        return ticker_type_data
    except exceptions.BadResponse as error:
        print("Non-200 response from polygon API", error)


def get_tickers():
    """
    Gets a list of tickers
    Returns a dataframe.
    docs
    https://polygon.io/docs/stocks/get_v3_reference_tickers
    https://polygon-api-client.readthedocs.io/en/latest/Reference.html#list-tickers"""
    print(get_tickers)
    # client = RESTClient("XXXXXX") # hardcoded api_key is used
    key = os.environ["POLYGON"]
    try:
        client = RESTClient(api_key=key)  # POLYGON_API_KEY environment variable is used
    except exceptions.AuthError as error:
        print("Empty or invalid polygon API key", error)
        return

    # tickers = []
    # for ticker in client.list_tickers(market="stocks", type="CS", active=True, limit=1000):
    #     tickers.append(ticker)
    # print(tickers)
    # print(f"Ticker: {tickers[0]}")

    # create a list of columns names for the dataframe
    dataframe_columns = [
        "active",
        "cik",
        "composite_figi",
        "currency_name",
        "last_updated_utc",
        "locale",
        "market",
        "name",
        "primary_exchange",
        "share_class_figi",
        "ticker",
        "type",
    ]

    # add the column names to the dataframe
    ticker_data = pd.DataFrame(columns=dataframe_columns)

    try:
        # get the tickers from polygon
        # tickers = client.list_tickers(market="stocks", type='ETF', active=True, limit=100)
        # tickers = client.list_tickers()
        for ticker in client.list_tickers():
            # for ticker in tickers:
            # verify this is an exchange
            if isinstance(ticker, Ticker):
                # Create a list of fields
                row = [
                    ticker.active,
                    ticker.cik,
                    ticker.composite_figi,
                    ticker.currency_name,
                    ticker.last_updated_utc,
                    ticker.locale,
                    ticker.market,
                    ticker.name,
                    ticker.primary_exchange,
                    ticker.share_class_figi,
                    ticker.ticker,
                    ticker.type,
                ]
                # add the list to the dataframe as a row
                ticker_data.loc[len(ticker_data)] = row
        print(f"{ticker_data.shape[0]} tickers read from polygon.")
        ticker_data.loc[ticker_data.currency_name == 'United States Dollar', 'currency_name'] = 'US Dollar'
        ticker_data.loc[ticker_data.currency_name == 'USD', 'currency_name'] = 'US Dollar'
        ticker_data.loc[ticker_data.currency_name == 'usd', 'currency_name'] = 'US Dollar'
        ticker_data.loc[ticker_data.currency_name == 'Japanese Yen', 'currency_name'] = 'Yen'
        ticker_data.loc[ticker_data.currency_name == 'Great Britian Pound', 'currency_name'] = 'Pound Sterling'
        ticker_data.loc[ticker_data.currency_name == 'Great Britain Pound', 'currency_name'] = 'Pound Sterling'
        ticker_data.loc[ticker_data.currency_name == 'Australian dollar', 'currency_name'] = 'Australian Dollar'
        ticker_data.drop_duplicates(subset=['primary_exchange', 'ticker'], keep='last', inplace=True)
        return ticker_data
    except exceptions.BadResponse as error:
        print("Non-200 response from polygon API", error)
        

def get_ohlcv(days=1):
    """
    Get the daily open, high, low, and close (OHLC) for the entire
    stocks/equities markets for one day.
    Returns a dataframe.
    Parameters:
    days - the number of days in the past to look for based on the ohlcv date
    docs
    https://polygon.io/docs/stocks/get_v2_aggs_grouped_locale_us_market_stocks__date
    https://polygon-api-client.readthedocs.io/en/latest/Aggs.html#get-grouped-daily-aggs
    """
    logging.info(f'days is {days}')
    # client = RESTClient("XXXXXX") # hardcoded api_key is used
    key = os.environ["POLYGON"]
    try:
        client = RESTClient(api_key=key)  # POLYGON_API_KEY environment variable is used
    except exceptions.AuthError as error:
        print("Empty or invalid polygon API key", error)
        return

    # create a list of columns names for the dataframe
    dataframe_columns = [
        "ticker",
        "close",
        "high",
        "low",
        "transactions",
        "open",
        "otc",
        "polygon_timestamp",
        "volume",
        "volume_weighted_average_price",
        "ohlcv_date",
    ]

    # add the column names to the dataframe
    ohlcv_data = pd.DataFrame(columns=dataframe_columns)

    now = dt.utcnow()

    # end_date = f"{now.year}-{now.month}-{now.day}"
    # print(end_date)

    ohlcv_date = now - relativedelta(days=days)
    ohlcv_string_date = ohlcv_date.strftime("%Y-%m-%d")
    logging.info(f'ohlcv date is {ohlcv_date}.')
    print(ohlcv_date)

    try:
        # get the ohlcv from polygon
        grouped = client.get_grouped_daily_aggs(
            ohlcv_string_date,
        )
        for agg in grouped:
            # verify this is an groupedDailyAgg
            if isinstance(agg, GroupedDailyAgg):
                # Create a list of fields
                row = [
                    agg.ticker,
                    agg.close,
                    agg.high,
                    agg.low,
                    agg.transactions,
                    agg.open,
                    agg.otc,
                    dt.fromtimestamp(int(agg.timestamp) / 1000),
                    agg.volume,
                    agg.vwap,
                    ohlcv_date,
                ]

                # add the list to the dataframe as a row
                ohlcv_data.loc[len(ohlcv_data)] = row
        print(f"{ohlcv_data.shape[0]} ohlcv rows read from polygon.")
        return ohlcv_data
    except exceptions.BadResponse as error:
        print("Non-200 response from polygon API", error)


def get_ohlcv_by_date(ohlcv_date=dt.utcnow()):
    """
    Get the daily open, high, low, and close (OHLC) for the entire
    stocks/equities markets for one day.
    Returns a dataframe.
    Parameters:
    days - the number of days in the past to look for based on the ohlcv date
    docs
    https://polygon.io/docs/stocks/get_v2_aggs_grouped_locale_us_market_stocks__date
    https://polygon-api-client.readthedocs.io/en/latest/Aggs.html#get-grouped-daily-aggs
    """

    # client = RESTClient("XXXXXX") # hardcoded api_key is used
    key = os.environ["POLYGON"]
    try:
        client = RESTClient(api_key=key)  # POLYGON_API_KEY environment variable is used
    except exceptions.AuthError as error:
        print("Empty or invalid polygon API key", error)
        return

    # create a list of columns names for the dataframe
    dataframe_columns = [
        "ticker",
        "close",
        "high",
        "low",
        "transactions",
        "open",
        "otc",
        "polygon_timestamp",
        "volume",
        "volume_weighted_average_price",
        "ohlcv_date",
    ]

    # add the column names to the dataframe
    ohlcv_data = pd.DataFrame(columns=dataframe_columns)

    ohlcv_string_date = ohlcv_date.strftime("%Y-%m-%d")
    print(f"get_ohlcv_by_date date is {ohlcv_date}")

    try:
        # get the ohlcv from polygon
        grouped = client.get_grouped_daily_aggs(
            ohlcv_string_date,
        )
        for agg in grouped:
            # verify this is an groupedDailyAgg
            if isinstance(agg, GroupedDailyAgg):
                # Create a list of fields
                row = [
                    agg.ticker,
                    agg.close,
                    agg.high,
                    agg.low,
                    agg.transactions,
                    agg.open,
                    agg.otc,
                    dt.fromtimestamp(int(agg.timestamp) / 1000),
                    agg.volume,
                    agg.vwap,
                    ohlcv_date,
                ]
                # add the list to the dataframe as a row
                ohlcv_data.loc[len(ohlcv_data)] = row
        print(f"{ohlcv_data.shape[0]} ohlcv rows read from polygon.")
        return ohlcv_data
    except exceptions.BadResponse as error:
        print("Non-200 response from polygon API", error)


def get_splits(days=28):
    """
    Get splits for the entire stocks/equities markets from days in the past to
    current execution date.
    Returns a dataframe.
    Parameters:
    days - the number of days in the past to look for based on the execution date
    docs
    https://polygon.io/docs/stocks/get_v3_reference_splits
    https://polygon-api-client.readthedocs.io/en/latest/Reference.html#list-splits"""

    # client = RESTClient("XXXXXX") # hardcoded api_key is used
    key = os.environ["POLYGON"]
    try:
        client = RESTClient(api_key=key)  # POLYGON_API_KEY environment variable is used
    except exceptions.AuthError as error:
        print("Empty or invalid polygon API key", error)
        return

    # create a list of columns names for the dataframe
    dataframe_columns = ["execution_date", "split_from", "split_to", "ticker"]

    # add the column names to the dataframe
    split_data = pd.DataFrame(columns=dataframe_columns)

    now = dt.utcnow()

    # end_date = f"{now.year}-{now.month}-{now.day}"
    # print(end_date)

    execution_date = now - relativedelta(days=days)
    execution_date = execution_date.strftime("%Y-%m-%d")
    print(execution_date)

    try:
        # get the splits from polygon
        for split in client.list_splits(execution_date_gte=execution_date, limit=1000):
            # verify this is a split
            if isinstance(split, Split):
                # Create a list of fields
                row = [
                    split.execution_date,
                    split.split_from,
                    split.split_to,
                    split.ticker,
                ]
                # add the list to the dataframe as a row
                split_data.loc[len(split_data)] = row
        print(f"{split_data.shape[0]} splits read from polygon.")
        return split_data
    except exceptions.BadResponse as error:
        print("Non-200 response from polygon API", error)


def get_dividends(days=28):
    """
    Get dividends for the entire stocks/equities markets for days in the past
    to current record date.
    Returns a dataframe.
    Parameters:
    days - the number of days in the past to look for based on the record date
    docs
    https://polygon.io/docs/stocks/get_v3_reference_dividends
    https://polygon-api-client.readthedocs.io/en/latest/Reference.html#list-dividends
    """

    # client = RESTClient("XXXXXX") # hardcoded api_key is used
    key = os.environ["POLYGON"]
    try:
        client = RESTClient(api_key=key)  # POLYGON_API_KEY environment variable is used
    except exceptions.AuthError as error:
        print("Empty or invalid polygon API key", error)
        return

    # create a list of columns names for the dataframe
    dataframe_columns = [
        "cash_amount",
        "currency",
        "declaration_date",
        "dividend_type",
        "ex_dividend_date",
        "frequency",
        "pay_date",
        "record_date",
        "ticker",
    ]

    # add the column names to the dataframe
    dividend_data = pd.DataFrame(columns=dataframe_columns)

    now = dt.utcnow()

    # end_date = f"{now.year}-{now.month}-{now.day}"
    # print(end_date)

    record_date = now - relativedelta(days=days)
    record_date = record_date.strftime("%Y-%m-%d")
    print(record_date)

    try:
        # get the dividends from polygon
        for dividend in client.list_dividends(record_date_gte=record_date, limit=1000):
            # verify this is a dividend
            if isinstance(dividend, Dividend):
                # Create a list of fields
                row = [
                    dividend.cash_amount,
                    dividend.currency,
                    dividend.declaration_date,
                    dividend.dividend_type,
                    dividend.ex_dividend_date,
                    dividend.frequency,
                    dividend.pay_date,
                    dividend.record_date,
                    dividend.ticker,
                ]
                # add the list to the dataframe as a row
                dividend_data.loc[len(dividend_data)] = row
        print(f"{dividend_data.shape[0]} dividends read from polygon.")
        return dividend_data
    except exceptions.BadResponse as error:
        print("Non-200 response from polygon API", error)


if __name__ == "__main__":
    load_dotenv()
    get_splits()
