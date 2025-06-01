import logging

import pytest
from dotenv import load_dotenv

from securities_load.securities.postgresql_database_functions import (
    connect,
    sqlalchemy_engine,
)
from securities_load.securities.securities_table_functions import (
    get_currency_code,
    get_exchange_code,
    get_exchange_id,
    get_exchange_id_by_acronym,
    get_gics_industry_code,
    get_gics_industry_group_code,
    get_gics_industry_group_id_from_name,
    get_gics_industry_id_from_name,
    get_gics_sector_code,
    get_gics_sector_id_from_industry_group_id,
    get_gics_sector_id_from_name,
    get_gics_sub_industry_code,
    get_gics_sub_industry_id_from_name,
    get_ticker_id,
    get_ticker_type_id,
    get_ticker_using_id,
    get_tickers_using_exchange_code,
    get_watchlist_id_from_code,
    retrieve_ohlcv_from_to,
    retrieve_ohlcv_last_n_days,
)


@pytest.fixture
def logger():
    module_logger = logging.getLogger(__name__)
    module_logger.info(f"test_securities_table_functions started")


@pytest.fixture
def engine(logger):
    load_dotenv()

    # Open a connection
    engine = sqlalchemy_engine()

    return engine


def test_get_ticker_type_id_successful(engine):
    assert get_ticker_type_id(engine, "stock") == 5


def test_get_ticker_type_id_not_found(engine):
    assert get_ticker_type_id(engine, "aaa") is None


def test_get_exchange_id_successful(engine):
    assert get_exchange_id(engine, "XASX") == 1


def test_get_exchange_id_not_found(engine):
    assert get_exchange_id(engine, "ASX") is None


def test_get_exchange_code_successful(engine):
    assert get_exchange_code(engine, 2) == "XNAS"


def test_get_exchange_code_not_found(engine):
    assert get_exchange_code(engine, 999) is None


def test_get_exchange_id_by_acronym_successful(engine):
    assert get_exchange_id_by_acronym(engine, "ASX") == 1


def test_get_exchange_id_by_acronym_successful_duplicate(engine):
    assert get_exchange_id_by_acronym(engine, "NYSE") == 3


def test_get_exchange_id_by_acronym_not_found(engine):
    assert get_exchange_id_by_acronym(engine, "XASX") is None


def test_get_currency_code_successful(engine):
    assert get_currency_code(engine, "Australian Dollar") == "AUD"


def test_get_currency_code_not_found(engine):
    assert get_currency_code(engine, "Australian Rand") is None


def test_get_ticker_using_id_successful(engine):
    assert get_ticker_using_id(engine, 5230) == ("AAPL", "XNAS")


def test_get_ticker_using_id_not_found(engine):
    assert get_ticker_using_id(engine, 99999) == ()


def test_get_ticker_id_successful(engine):
    assert get_ticker_id(engine, "XNYS", "AA") == 5218


def test_get_ticker_id_not_found(engine):
    assert get_ticker_id(engine, "XXXX", "AA") is None


def test_get_gics_sector_code_successful(engine):
    assert get_gics_sector_code(engine, "Materials") == "15"


def test_get_gics_sector_code_not_found(engine):
    assert get_gics_sector_code(engine, "Tech") is None


def test_get_gics_industry_group_code_successful(engine):
    assert get_gics_industry_group_code(engine, "Consumer Services") == "2530"


def test_get_gics_industry_group_code_not_found(engine):
    assert get_gics_industry_group_code(engine, "Consumer") is None


def test_get_gics_industry_code_successful(engine):
    assert get_gics_industry_code(engine, "Machinery") == "201060"


def test_get_gics_industry_code_not_found(engine):
    assert get_gics_industry_code(engine, "Technology") is None


def test_get_gics_sub_industry_code_successful(engine):
    assert get_gics_sub_industry_code(engine, "Coal & Consumable Fuels") == "10102050"


def test_get_gics_sub_industry_code_not_found(engine):
    assert get_gics_sub_industry_code(engine, "Apparel") is None


def test_get_gics_sector_id_from_name_successful(engine):
    assert get_gics_sector_id_from_name(engine, "Energy") == 1


def test_get_gics_sector_id_from_name_not_found(engine):
    assert get_gics_sector_id_from_name(engine, "Consumer") is None


def test_get_gics_industry_group_id_from_name_successful(engine):
    assert get_gics_industry_group_id_from_name(engine, "Transportation") == 5


def test_get_gics_industry_group_id_from_name_not_found(engine):
    assert get_gics_industry_group_id_from_name(engine, "Consumer") is None


def test_get_gics_industry_id_from_name_successful(engine):
    assert get_gics_industry_id_from_name(engine, "Industrial Conglomerates") == 12


def test_get_gics_industry_id_from_name_not_found(engine):
    assert get_gics_industry_id_from_name(engine, "Consumer") is None


def test_get_gics_sub_industry_id_from_name_successful(engine):
    assert get_gics_sub_industry_id_from_name(engine, "Industrial Gases") == 11


def test_get_gics_sub_industry_id_from_name_not_found(engine):
    assert get_gics_sub_industry_id_from_name(engine, "Consumer") is None


def test_get_gics_sector_id_from_industry_group_id_successful(engine):
    assert get_gics_sector_id_from_industry_group_id(engine, 8) == 4


def test_get_gics_sector_id_from_industry_group_id_not_found(engine):
    assert get_gics_sector_id_from_industry_group_id(engine, 99) is None


def test_get_watchlist_id_from_code_successful(engine):
    assert get_watchlist_id_from_code(engine, "AUS Indices") == 3


def test_get_watchlist_id_from_code_not_found(engine):
    assert get_watchlist_id_from_code(engine, "AUS") is None


def test_get_tickers_using_exchange_code_successful(engine):
    print(get_tickers_using_exchange_code(engine, "XASX"))


def test_get_tickers_using_exchange_code_not_found(engine):
    assert get_tickers_using_exchange_code(engine, "ZZZ") == []


def test_retrieve_ohlcv_last_n_days_successful(engine):
    assert len(retrieve_ohlcv_last_n_days(engine, "XNAS", "GOOGL", 5)) == 5


def test_retrieve_ohlcv_last_n_days_not_found(engine):
    assert len(retrieve_ohlcv_last_n_days(engine, "XNAS", "XXXX", 5)) == 0


# @pytest.mark.skip
def test_retrieve_ohlcv_from_to_successful(engine):
    assert (
        len(retrieve_ohlcv_from_to(engine, "XNAS", "GOOGL", "2024-09-01", "2024-09-30"))
        == 20
    )


# @pytest.mark.xfail
def test_retrieve_ohlcv_from_to_not_found(engine):
    assert (
        len(retrieve_ohlcv_from_to(engine, "XNAS", "XXXX", "2026-01-01", "2026-01-25"))
        == 0
    )


# pytest markers
# @pytest.mark.skip
# @pytest.mark.skipif
# @pytest.mark.xfail
