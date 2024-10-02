import logging

import pytest
from dotenv import load_dotenv

from securities_load.securities.postgresql_database_functions import connect
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
)

load_dotenv()

# Open a connection
conn = connect()

module_logger = logging.getLogger(__name__)

module_logger.info(f"test_securities_table_functions started")


@pytest.fixture
def setup_connection():
    pass


def test_get_ticker_type_id_successful():
    assert get_ticker_type_id(conn, "stock") == 5


def test_get_ticker_type_id_not_found():
    assert get_ticker_type_id(conn, "aaa") == 0


def test_get_exchange_id_successful():
    assert get_exchange_id(conn, "XASX") == 1


def test_get_exchange_id_not_found():
    assert get_exchange_id(conn, "ASX") == 0


def test_get_exchange_code_successful():
    assert get_exchange_code(conn, 2) == "XNAS"


def test_get_exchange_code_not_found():
    assert get_exchange_code(conn, 999) == ""


def test_get_exchange_id_by_acronym_successful():
    assert get_exchange_id_by_acronym(conn, "ASX") == 1


def test_get_exchange_id_by_acronym_successful_duplicate():
    assert get_exchange_id_by_acronym(conn, "NYSE") == 3


def test_get_exchange_id_by_acronym_not_found():
    assert get_exchange_id_by_acronym(conn, "XASX") == 0


def test_get_currency_code_successful():
    assert get_currency_code(conn, "Australian Dollar") == "AUD"


def test_get_currency_code_not_found():
    assert get_currency_code(conn, "Australian Rand") == ""


def test_get_ticker_using_id_successful():
    assert get_ticker_using_id(conn, 5230) == ("AAPL", "XNAS")


def test_get_ticker_using_id_not_found():
    assert get_ticker_using_id(conn, 99999) == ()


def test_get_ticker_id_successful():
    assert get_ticker_id(conn, "XNYS", "AA") == 5218


def test_get_ticker_id_not_found():
    assert get_ticker_id(conn, "XXXX", "AA") == 0


def test_get_gics_sector_code_successful():
    assert get_gics_sector_code(conn, "Materials") == "15"


def test_get_gics_sector_code_not_found():
    assert get_gics_sector_code(conn, "Tech") == ""


def test_get_gics_industry_group_code_successful():
    assert get_gics_industry_group_code(conn, "Consumer Services") == "2530"


def test_get_gics_industry_group_code_not_found():
    assert get_gics_industry_group_code(conn, "Consumer") == ""


def test_get_gics_industry_code_successful():
    assert get_gics_industry_code(conn, "Machinery") == "201060"


def test_get_gics_industry_code_not_found():
    assert get_gics_industry_code(conn, "Technology") == ""


def test_get_gics_sub_industry_code_successful():
    assert get_gics_sub_industry_code(conn, "Coal & Consumable Fuels") == "10102050"


def test_get_gics_sub_industry_code_not_found():
    assert get_gics_sub_industry_code(conn, "Apparel") == ""


def test_get_gics_sector_id_from_name_successful():
    assert get_gics_sector_id_from_name(conn, "Energy") == 1


def test_get_gics_sector_id_from_name_not_found():
    assert get_gics_sector_id_from_name(conn, "Consumer") == 0


def test_get_gics_industry_group_id_from_name_successful():
    assert get_gics_industry_group_id_from_name(conn, "Transportation") == 5


def test_get_gics_industry_group_id_from_name_not_found():
    assert get_gics_industry_group_id_from_name(conn, "Consumer") == 0


def test_get_gics_industry_id_from_name_successful():
    assert get_gics_industry_id_from_name(conn, "Industrial Conglomerates") == 12


def test_get_gics_industry_id_from_name_not_found():
    assert get_gics_industry_id_from_name(conn, "Consumer") == 0


def test_get_gics_sub_industry_id_from_name_successful():
    assert get_gics_sub_industry_id_from_name(conn, "Industrial Gases") == 11


def test_get_gics_sub_industry_id_from_name_not_found():
    assert get_gics_sub_industry_id_from_name(conn, "Consumer") == 0


def test_get_gics_sector_id_from_industry_group_id_successful():
    assert get_gics_sector_id_from_industry_group_id(conn, 8) == 4


def test_get_gics_sector_id_from_industry_group_id_not_found():
    assert get_gics_sector_id_from_industry_group_id(conn, 99) == 0


def test_get_watchlist_id_from_code_successful():
    assert get_watchlist_id_from_code(conn, "AUS Indices") == 3


def test_get_watchlist_id_from_code_not_found():
    assert get_watchlist_id_from_code(conn, "AUS") == 0


def test_get_tickers_using_exchange_code_successful():
    print(get_tickers_using_exchange_code(conn, "XASX"))


def test_get_tickers_using_exchange_code_not_found():
    assert get_tickers_using_exchange_code(conn, "ZZZ") == 0
