# Progress

## Tables

### Polygon

|Table|Extract|Ext Status|Add|Add Status|Load py|Load py Status|Airflow|Airflow Status
|---|---|---|---|---|---|---|---|---|
|exchange_type|N/A|N/A|create_polygon_tables|Done|
|asset_class|N/A|N/A|create_polygon_tables|Done|
|market|N/A|N/A|create_polygon_tables|Done|
|dividend_type|N/A|N/A|create_polygon_tables|Done|
|exchange|polygon_rest_functions<br />get_exchanges| Done | polygon_table_functions<br />add_exchanges|Done|polygon_load_exchange|Done|polygon_pipeline|Done|
|ticker_type|polygon_rest_functions<br />get_ticker_types| Done | polygon_table_functions<br />add_ticker_types|Done|polygon_load_ticker_type|Done|polygon_airflow_load_ticker_type|ToDo|
|ticker|polygon_rest_functions<br />get_tickers| Done | polygon_table_functions<br />add_tickers|Done|polygon_load_ticker|Done|polygon_airflow_load_ticker|ToDo|
|split|polygon_rest_functions<br />get_splits| Done | polygon_table_functions<br />add_splits|Done|polygon_load_split|Done|polygon_pipeline|Done|
|dividend|polygon_rest_functions<br />get_dividends| Done | polygon_table_functions<br />add_dividends|Done|polygon_load_dividend|Done|polygon_pipeline|Done|
|ohlcv|polygon_rest_functions<br />get_ohlcv| Done | polygon_table_functions<br />add_ohlcv|Done|polygon_load_ohlcv|Done|polygon_airflow_load_ohlcv|ToDo|

### Equity

|Table|Extract|Ext Status|Load|Load Status|
|---|---|---|---|---|
|currencies|N/A|N/A|create_equity_tables|Done|
|countries|N/A|N/A|create_equity_tables|Done|
|gics_sectors|N/A|N/A|create_equity_tables|Done|
|gics_industry_groups|N/A|N/A|create_equity_tables|Done|
|gics_industries|N/A|N/A|create_equity_tables|Done|
|gics_sub_industries|N/A|N/A|create_equity_tables|Done|
|gics|N/A|N/A|create_equity_tables|Done|
|exchange_type|N/A|N/A|create_equity_tables|Done|
|asset_class|N/A|N/A|create_equity_tables|Done|
|ticker_type|N/A|N/A|equity_load_ticker_type|Done|
|market|N/A|N/A|create_equity_tables|Done|
|dividend_type|N/A|N/A|create_equity_tables|Done|
|split|N/A|N/A|equity_load_split|Done|
|dividend|N/A|N/A|equity_load_dividend|Done|
|exchange|N/A|N/A|equity_load_exchange|Done|
|ticker|N/A|N/A|equity_load_tickers|Done|
|data_vendor|N/A|N/A|create_equity_tables|Done|
|daily_price|N/A|ToDo||Todo|

### Portfolio

|Table|Extract|Ext Status|Load|Load Status|
|---|---|---|---|---|
|broker|N/A|N/A|create_portfolio_tables|Done|
|watchlist_types|N/A|N/A|create_portfolio_tables|Done|
|account|N/A|N/A|create_portfolio_tables|Done|
|analyst|N/A|N/A|create_portfolio_tables|Done|
|newsletter|N/A|N/A|create_portfolio_tables|Done|
|action|N/A|N/A|create_portfolio_tables|Done|
|strategy|N/A|N/A|create_portfolio_tables|Done|
|order_status|N/A|N/A|create_portfolio_tables|Done|
|trade_status|N/A|N/A|create_portfolio_tables|Done|
|leg_status|N/A|N/A|create_portfolio_tables|Done|
|trade||ToDo||Todo|
|leg||ToDo||Todo|
|order||ToDo||Todo|
|transaction||ToDo||Todo|
|watchlists||ToDo||Todo|
