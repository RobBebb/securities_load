from unittest.mock import MagicMock, patch

import pytest

from securities_load.securities.polar_table_functions import (
    get_ticker_type_id_using_code,
)


@patch(
    "securities_load.securities.polar_table_functions.get_uri", return_value="mock_uri"
)
@patch("securities_load.securities.polar_table_functions.pl.read_database_uri")
def test_get_ticker_type_id_success(mock_read_db, mock_get_uri):
    # Mock DataFrame with id column
    mock_df = MagicMock()
    mock_df.is_empty.return_value = False
    mock_df.__getitem__.return_value = [123]
    mock_read_db.return_value = mock_df

    result = get_ticker_type_id_using_code("option")
    assert result == 123
    mock_read_db.assert_called_once()
    mock_get_uri.assert_called_once()


@patch(
    "securities_load.securities.polar_table_functions.get_uri", return_value="mock_uri"
)
@patch("securities_load.securities.polar_table_functions.pl.read_database_uri")
def test_get_ticker_type_id_no_result(mock_read_db, mock_get_uri):
    # Mock DataFrame as empty
    mock_df = MagicMock()
    mock_df.is_empty.return_value = True
    mock_read_db.return_value = mock_df

    with pytest.raises(ValueError, match="No ticker type found for code: option"):
        get_ticker_type_id_using_code("option")


@patch(
    "securities_load.securities.polar_table_functions.get_uri", return_value="mock_uri"
)
@patch("securities_load.securities.polar_table_functions.pl.read_database_uri")
def test_get_ticker_type_id_id_not_int(mock_read_db, mock_get_uri):
    # Mock DataFrame with id column as str
    mock_df = MagicMock()
    mock_df.is_empty.return_value = False
    mock_df.__getitem__.return_value = ["not-an-int"]
    mock_read_db.return_value = mock_df

    with pytest.raises(TypeError, match="Expected id to be an int"):
        get_ticker_type_id_using_code("option")


@patch(
    "securities_load.securities.polar_table_functions.get_uri", return_value="mock_uri"
)
@patch("securities_load.securities.polar_table_functions.pl.read_database_uri")
def test_get_ticker_type_id_db_exception(mock_read_db, mock_get_uri):
    # Simulate exception in read_database_uri
    mock_read_db.side_effect = Exception("db error")

    with pytest.raises(Exception, match="db error"):
        get_ticker_type_id_using_code("option")
    with pytest.raises(Exception, match="db error"):
        get_ticker_type_id_using_code("option")
        get_ticker_type_id_using_code("option")
