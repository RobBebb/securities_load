DROP TABLE IF EXISTS securities.option_data;

CREATE TABLE securities.option_data (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    data_vendor_id integer NOT NULL,
    ticker_id integer NULL,
    date date NOT NULL,
    last_trade_date timestamp with time zone,
    last_price numeric(19,4) NULL,
    bid numeric(19,4) NULL,
    ask numeric(19,4) NULL,
    change numeric(19,4) NULL,
    percent_change numeric(12,6) NULL,
    volume bigint NULL,
    open_interest bigint NULL,
    implied_volatility numeric(12,6) NULL,
	in_the_money char(1) NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
	CONSTRAINT fk_option_data_data_vendor
        FOREIGN KEY(data_vendor_id)
        REFERENCES securities.data_vendor(id)
        ON DELETE NO ACTION,
    CONSTRAINT fk_option_data_ticker
        FOREIGN KEY(ticker_id)
        REFERENCES securities.ticker(id)
        ON DELETE CASCADE,
	CONSTRAINT unique_option_data 
		UNIQUE (data_vendor_id, ticker_id, date));

COMMENT ON COLUMN securities.option_data.last_trade_date IS 'Timestamp (ISO 8601) of the most recent trade for this option, including timezone (e.g. UTC).';
COMMENT ON COLUMN securities.option_data.last_price IS 'The price at which the option last traded.';
COMMENT ON COLUMN securities.option_data.bid IS 'TThe current highest price that a buyer is willing to pay for the option.';
COMMENT ON COLUMN securities.option_data.ask IS 'The current lowest price that a seller is willing to accept for the option.';
COMMENT ON COLUMN securities.option_data.change IS 'The absolute change in the option’s price since the previous trading session’s close.';
COMMENT ON COLUMN securities.option_data.percent_change IS 'The percentage change in price relative to the previous close.';
COMMENT ON COLUMN securities.option_data.volume IS 'The volume weighted average price.';
COMMENT ON COLUMN securities.option_data.open_interest IS 'The total number of outstanding option contracts that have not been exercised or closed.';
COMMENT ON COLUMN securities.option_data.implied_volatility IS 'The market’s forecast of the underlying asset’s volatility, expressed as a decimal (e.g. 0.25 = 25%).';
COMMENT ON COLUMN securities.option_data.in_the_money IS 'Boolean indicating whether the option is currently “in the money” (T) or not (F).';

CREATE INDEX IF NOT EXISTS ix_option_data_ticker_id ON securities.option_data(ticker_id);