-- The polygon schema has the data loaded directly from polygon website.
-- The data will then be cleaned and relevant columns extracted to the equity schema.

DROP TABLE IF EXISTS polygon.exchange;
DROP TABLE IF EXISTS polygon.dividend_type;
DROP TABLE IF EXISTS polygon.ticker_type;
DROP TABLE IF EXISTS polygon.asset_class;
DROP TABLE IF EXISTS polygon.market;
DROP TABLE IF EXISTS polygon.exchange_type;
DROP TABLE IF EXISTS polygon.ohlcv;
DROP TABLE IF EXISTS polygon.dividend;
DROP TABLE IF EXISTS polygon.split;
DROP TABLE IF EXISTS polygon.ticker;

DROP SCHEMA IF EXISTS polygon;

CREATE SCHEMA IF NOT EXISTS polygon AUTHORIZATION securities;

CREATE TABLE polygon.exchange_type (
    type varchar(32) NOT NULL,
    description varchar(255));

COMMENT ON TABLE polygon.exchange_type IS 'Represents the type of exchange';

INSERT INTO polygon.exchange_type (type, description) VALUES
    ('exchange', 'A marketplace where stocks, bonds and other securities are bought and sold.'),
    ('TRF', 'Trade Reporting Facility provides a mechanism for the reporting of transactions effected otherwise than on an exchange.'),
    ('SIP', 'Securities Information Processor consolidates best prices across exchanges.'),
    ('ORF', 'Operational readiness float exchanges.');

CREATE TABLE polygon.asset_class (
    type varchar(32) NOT NULL,
    description varchar(255));

COMMENT ON TABLE polygon.asset_class IS 'An identifier for a group of similar financial instruments.';

INSERT INTO polygon.asset_class (type, description) VALUES
    ('crypto', Null),
    ('fx', Null),
    ('indices', Null),
    ('options', Null),
    ('stocks', Null),
    ('etp', Null);

CREATE TABLE polygon.ticker_type (
    code varchar(32) NOT NULL,
    description varchar(255),
    asset_class_type varchar(32),
    locale varchar(32));

COMMENT ON TABLE polygon.ticker_type IS 'The type of the tickers.';

COMMENT ON COLUMN polygon.ticker_type.code IS 'A code used by Polygon.io to refer to this ticker type.';
COMMENT ON COLUMN polygon.ticker_type.description IS 'A short description of this ticker type.';
COMMENT ON COLUMN polygon.ticker_type.asset_class_type IS 'An identifier for a group of similar financial instruments. (stocks, options, crypto, fx, indices)';
COMMENT ON COLUMN polygon.ticker_type.locale IS 'An identifier for a geographical location. (us, global)';

CREATE TABLE polygon.market (
    type varchar(32) NOT NULL,
    description varchar(255));

COMMENT ON TABLE polygon.market IS 'The type of market.';

COMMENT ON COLUMN polygon.market.type IS 'A code used by to refer to this market type.';
COMMENT ON COLUMN polygon.market.description IS 'A short description of this market type.';

INSERT INTO polygon.market (type, description) VALUES
    ('crypto', Null),
    ('fx', Null),
    ('indices', Null),
    ('otc', Null),
    ('stocks', Null);

CREATE TABLE polygon.dividend_type (
    type char(2) NOT NULL,
    description varchar(255));

COMMENT ON TABLE polygon.dividend_type IS 'The type of market.';

COMMENT ON COLUMN polygon.dividend_type.type IS 'A code used by to refer to this dividend type.';
COMMENT ON COLUMN polygon.dividend_type.description IS 'A short description of this dividend type.';

INSERT INTO polygon.dividend_type (type, description) VALUES
    ('CD', 'Dividend on consistent schedule'),
    ('SC', 'Special cash dividend'),
    ('LT', 'Long-Term capital gain distribution'),
    ('ST', 'Short-Term capital gain distribution');

CREATE TABLE polygon.split (
    execution_date timestamp NULL,
    split_from integer NULL,
    split_to integer NULL,
    ticker varchar(32) NULL);

COMMENT ON TABLE polygon.split IS 'Split contains data for a historical stock split, including the ticker symbol, the execution date, and the factors of the split ratio.';

COMMENT ON COLUMN polygon.split.execution_date IS 'The execution date of the stock split. On this date the stock split was applied.';
COMMENT ON COLUMN polygon.split.split_from IS 'The second number in the split ratio. For example: In a 2-for-1 split, split_from would be 1.';
COMMENT ON COLUMN polygon.split.split_to IS 'The first number in the split ratio. For example: In a 2-for-1 split, split_to would be 2.';
COMMENT ON COLUMN polygon.split.ticker IS 'The ticker symbol of the stock split.';

CREATE TABLE polygon.dividend (
    cash_amount numeric(19,4) NULL,
    currency varchar(50) NULL,
    declaration_date timestamp NULL,
    dividend_type varchar(32) NULL,
    ex_dividend_date timestamp NULL,
    frequency integer NULL,
    pay_date timestamp NULL,
    record_date timestamp NULL,
    ticker varchar(32) NULL);

COMMENT ON COLUMN polygon.dividend.cash_amount IS 'The cash amount of the dividend per share owned.';
COMMENT ON COLUMN polygon.dividend.currency IS 'The currency in which the dividend is paid.';
COMMENT ON COLUMN polygon.dividend.declaration_date IS 'The date that the dividend was announced.';
COMMENT ON COLUMN polygon.dividend.dividend_type IS 'The type of dividend. Dividends that have been paid and/or are expected to be paid on consistent schedules are denoted as CD. Special Cash dividends that have been paid that are infrequent or unusual, and/or can not be expected to occur in the future are denoted as SC. Long-Term and Short-Term capital gain distributions are denoted as LT and ST, respectively.';
COMMENT ON COLUMN polygon.dividend.ex_dividend_date IS 'The date that the stock first trades without the dividend, determined by the exchange.';
COMMENT ON COLUMN polygon.dividend.frequency IS 'The number of times per year the dividend is paid out. Possible values are 0 (one-time), 1 (annually), 2 (bi-annually), 4 (quarterly), and 12 (monthly).';
COMMENT ON COLUMN polygon.dividend.pay_date IS 'The date that the dividend is paid out.';
COMMENT ON COLUMN polygon.dividend.record_date IS 'The date that the stock must be held to receive the dividend, set by the company.';
COMMENT ON COLUMN polygon.dividend.ticker IS 'The ticker symbol of the dividend.';

CREATE TABLE polygon.exchange (
    acronym varchar(32) NULL,
    asset_class varchar(32) NULL,
    exchange_id integer NULL,
    locale varchar(32) NULL,
    mic varchar(32) NULL,
    name varchar(255) NULL,
    operating_mic varchar(32) NULL,
    participant_id varchar(32) NULL,
    type varchar(32) NULL,
    url varchar(255) NULL);

COMMENT ON COLUMN polygon.exchange.acronym IS 'A commonly used abbreviation for this exchange.';
COMMENT ON COLUMN polygon.exchange.asset_class IS 'An identifier for a group of similar financial instruments. (stocks, options, crypto, fx)';
COMMENT ON COLUMN polygon.exchange.exchange_id IS 'A unique identifier used by Polygon.io for this exchange.';
COMMENT ON COLUMN polygon.exchange.locale IS 'An identifier for a geographical location. (us, global)';
COMMENT ON COLUMN polygon.exchange.mic IS 'The Market Identifer Code of this exchange (see ISO 10383).';
COMMENT ON COLUMN polygon.exchange.name IS 'Name of this exchange.';
COMMENT ON COLUMN polygon.exchange.operating_mic IS 'The MIC of the entity that operates this exchange.';
COMMENT ON COLUMN polygon.exchange.participant_id IS 'The ID used by SIP"s to represent this exchange.';
COMMENT ON COLUMN polygon.exchange.type IS 'Represents the type of exchange. (exchange, TRF, SIP)';
COMMENT ON COLUMN polygon.exchange.url IS 'A link to this exchange"s website, if one exists.';

CREATE TABLE polygon.ohlcv (
    ticker varchar(32) NOT NULL,
    close numeric(19,4) NULL,
    high numeric(19,4) NULL,
    low numeric(19,4) NULL,
    transactions integer NULL,
    open numeric(19,4) NULL,
    otc boolean NULL,
    ohlcv_date timestamp NULL,
    volume numeric(19,0) NULL,
    volume_weighted_average_price numeric(19,4) NULL);

COMMENT ON COLUMN polygon.ohlcv.ticker IS 'The exchange symbol that this item is traded under.';
COMMENT ON COLUMN polygon.ohlcv.close IS 'The close price for the symbol in the given time period.';
COMMENT ON COLUMN polygon.ohlcv.high IS 'The highest price for the symbol in the given time period.';
COMMENT ON COLUMN polygon.ohlcv.low IS 'The lowest price for the symbol in the given time period.';
COMMENT ON COLUMN polygon.ohlcv.transactions IS 'The number of transactions in the aggregate window.';
COMMENT ON COLUMN polygon.ohlcv.open IS 'The open price for the symbol in the given time period.';
COMMENT ON COLUMN polygon.ohlcv.otc IS 'Whether or not this aggregate is for an OTC ticker. This field will be left off if false.';
COMMENT ON COLUMN polygon.ohlcv.ohlcv_date IS 'The Unix Msec timestamp for the start of the aggregate window converted to a timestamp.';
COMMENT ON COLUMN polygon.ohlcv.volume IS 'The trading volume of the symbol in the given time period.';
COMMENT ON COLUMN polygon.ohlcv.volume_weighted_average_price IS 'The volume weighted average price.';

CREATE TABLE polygon.ticker (
    active boolean NULL,
    cik varchar(32) NULL,
    composite_figi varchar(32) NULL,
    currency_name varchar(50) NULL,
    delisted_utc timestamp NULL,
    last_updated_utc timestamp NULL,
    locale varchar(32) NULL,
    market varchar(32) NULL,
    name varchar (255) NULL,
    primary_exchange varchar(32) NULL,
    share_class_figi varchar(32) NULL,
    ticker varchar(32) NULL,
    type varchar(32) NULL);

COMMENT ON COLUMN polygon.ticker.active IS 'Whether or not the asset is actively traded. False means the asset has been delisted.';
COMMENT ON COLUMN polygon.ticker.cik IS 'The CIK number for this ticker.';
COMMENT ON COLUMN polygon.ticker.composite_figi IS 'The composite OpenFIGI number for this ticker. Find more information here';
COMMENT ON COLUMN polygon.ticker.currency_name IS 'The name of the currency that this asset is traded with.';
COMMENT ON COLUMN polygon.ticker.delisted_utc IS 'The last date that the asset was traded.';
COMMENT ON COLUMN polygon.ticker.last_updated_utc IS 'The information is accurate up to this time.';
COMMENT ON COLUMN polygon.ticker.locale IS 'The information is accurate up to this time. (us, global)';
COMMENT ON COLUMN polygon.ticker.market IS 'The market type of the asset.';
COMMENT ON COLUMN polygon.ticker.name IS 'The name of the asset. For stocks/equities this will be the companies registered name. For crypto/fx this will be the name of the currency or coin pair.';
COMMENT ON COLUMN polygon.ticker.primary_exchange IS 'The ISO code of the primary listing exchange for this asset.';
COMMENT ON COLUMN polygon.ticker.share_class_figi IS 'The share Class OpenFIGI number for this ticker. Find more information here';
COMMENT ON COLUMN polygon.ticker.ticker IS 'The exchange symbol that this item is traded under.';
COMMENT ON COLUMN polygon.ticker.type IS 'The type of the asset.';




