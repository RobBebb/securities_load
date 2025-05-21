# System Design

## Options

### Database Design

#### Symbol format

e.g. SPY250520C00510000

SPY - Root Symbol - SPDR S&P 500 ETF
250520 - Expiration Date - 20th May 2025
C - Option Type - Call
00510000 - Strike Price - $510

- Root Symbol: The underlying stock or ETF symbol, up to 6 characters.
- Expiration Date: A 6-digit date in the format yymmdd.
- Option Type: Indicated by either "P" for put options or "C" for call options.
- Strike Price: The price multiplied by 1000, padded with zeros to 8 digits.

#### Yahoo Data

##### Static

- contractSymbol - ticker.ticker
- expiries - ticker.expiry_date
- strike - ticker.strike
- contractSize (REGULAR)
- currency (USD) - ticker.currency_code
- calls / puts - ticker.call_put
- ticker.underlying_ticker
- ticker.exchange_id CBOE
- ticker_type_id option

##### Daily

- lastTradeDate - option_data.last_trade_date
- lastPrice - option_data.last_price
- bid - option_data.bid
- ask - option_data.ask
- change option_data.change
- percentChange - option_data.percent_change
- volume - option_data.volume
- openInterest - option_data.open_interest
- impliedVolatility - option_data.implied_volatility
- inTheMoney (True) - option_data.in_the_money

### Processing

- Get watchlist_ticker.id for watchlist_ticker.code = 'Options to Download'
- get watchlist_ticker.ticker_id's for watchlist_ticker.id
- loop through watchlist_ticker.ticker_id's
  - get ticker.ticker for watchlist_ticker.ticker.id
  - get yahoo ticker.expires for ticker
    - loop though yahoo ticker.expires
      - get yahoo.option_chains for yahoo ticker.expires
      - loop thgrough yahoo.option_chains
        - insert or update ticker with yahoo static data
        - insert or update option_data with yahoo daily data

### To Do

- Write SQL to create option_data table
- Create option_data table in dev
- Create option_data table in prod

- get_watchlist_id_from_code - existing
- retrieve_watchlist_ticker_ids_for_watchlist_id - new function
- get_yahoo_symbol_using_ticker_id - new function
- retrieve_option_expires_from_yahoo - new function
- retrieve_option_chains_from_yahoo - new function
- add_or_update_option_ticker - new function
- add_or_update_option_data - new function
- load_option_data_from_yahoo - new file
- run_load_option_data_from_yahoo - new file
