-- The portfolio schema contains tables related to a portfolio.
-- It contains full details of the trade plan and orders associated with it.
DROP TABLE IF EXISTS portfolio.watchlist;
DROP TABLE IF EXISTS portfolio.transaction;
DROP TABLE IF EXISTS portfolio.order;
DROP TABLE IF EXISTS portfolio.leg;
DROP TABLE IF EXISTS portfolio.trade;
DROP TABLE IF EXISTS portfolio.leg_status;
DROP TABLE IF EXISTS portfolio.trade_status;
DROP TABLE IF EXISTS portfolio.order_status;
DROP TABLE IF EXISTS portfolio.strategy;
DROP TABLE IF EXISTS portfolio.action;
DROP TABLE IF EXISTS portfolio.newsletter;
DROP TABLE IF EXISTS portfolio.analyst;
DROP TABLE IF EXISTS portfolio.account;
DROP TABLE IF EXISTS portfolio.broker;
DROP TABLE IF EXISTS portfolio.watchlist_type;

DROP SCHEMA IF EXISTS portfolio;

CREATE SCHEMA IF NOT EXISTS portfolio AUTHORIZATION securities;

CREATE TABLE portfolio.watchlist_type (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name varchar(255) NOT NULL UNIQUE,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp);

COMMENT ON TABLE portfolio.watchlist_type IS 'Used to define the category for a watchlist. e.g. Index, Investment style (for ETPs), Portfolio';

DELETE FROM portfolio.watchlist_type;
INSERT INTO portfolio.watchlist_type (name) VALUES
    ('Index'),
    ('Portfolio'),
    ('Sector'),
    ('Summary');

CREATE TABLE portfolio.broker (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) NOT NULL,
    name varchar(255),
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp);

COMMENT ON TABLE portfolio.broker IS 'An entity through which you can buy and sell securities.';

DELETE FROM portfolio.broker;
INSERT INTO portfolio.broker (code, name) VALUES
    ('IB', 'Interactive Brokers'),
    ('Commsec', 'Commonwealth Securities'),
    ('ABC', 'ABC Bullion'),
    ('Swyft', 'Swyft');

CREATE TABLE portfolio.account (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) NOT NULL,
    broker_id integer NULL, 
    description varchar(255),
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp,
    CONSTRAINT fk_broker
        FOREIGN KEY(broker_id)
        REFERENCES portfolio.broker(id)
        ON DELETE SET NULL);

COMMENT ON TABLE portfolio.account IS 'An account at a broker.';

DELETE FROM portfolio.account;
INSERT INTO portfolio.account (code, broker_id, description)
	SELECT 'Rob and Sue', id, Null FROM portfolio.broker where code = 'Commsec';
INSERT INTO portfolio.account (code, broker_id, description)
	SELECT 'Superbebbs', id, Null FROM portfolio.broker where code = 'Commsec';
INSERT INTO portfolio.account (code, broker_id, description)
	SELECT 'Rob', id, Null FROM portfolio.broker where code = 'IB';
INSERT INTO portfolio.account (code, broker_id, description)
	SELECT 'Bullion', id, Null FROM portfolio.broker where code = 'ABC';
INSERT INTO portfolio.account (code, broker_id, description)
	SELECT 'Crypto', id, Null FROM portfolio.broker where code = 'Swyft';

CREATE TABLE portfolio.analyst (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) NOT NULL,
    name varchar(255),
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp);

COMMENT ON TABLE portfolio.analyst IS 'An entity that gives stock recommendation.';

DELETE FROM portfolio.analyst;
INSERT INTO portfolio.analyst (code, name) VALUES
    ('Stock Earnings', Null),
    ('InvestorPLace', Null),
    ('Fat Tail Investment Research', Null);

CREATE TABLE portfolio.newsletter (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) NOT NULL,
    analyst_id integer NULL, 
    description varchar(255),
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp,
    CONSTRAINT fk_analyst
        FOREIGN KEY(analyst_id)
        REFERENCES portfolio.analyst(id)
        ON DELETE SET NULL);

COMMENT ON TABLE portfolio.newsletter IS 'A stock recommendation newsletter.';

DELETE FROM portfolio.newsletter;
INSERT INTO portfolio.newsletter (code, analyst_id, description)
	SELECT 'Weekly Winners', id, Null FROM portfolio.analyst where code = 'Stock Earnings';
INSERT INTO portfolio.newsletter (code, analyst_id, description)
	SELECT 'Innovation Investor', id, Null FROM portfolio.analyst where code = 'InvestorPLace';        
INSERT INTO portfolio.newsletter (code, analyst_id, description)
	SELECT 'Exponential Stock Investor', id, Null FROM portfolio.analyst where code = 'Fat Tail Investment Research';

CREATE TABLE portfolio.action (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) NOT NULL,
    description varchar(255),
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp);

COMMENT ON TABLE portfolio.action IS 'The type of order being submitted.';

DELETE FROM portfolio.action;
INSERT INTO portfolio.action (code, description) VALUES
    ('Buy to Open', Null),
    ('Sell to Open', Null),
    ('Buy to Close', Null),
    ('Sell to Close', Null),
    ('Buy to Cover', Null),
    ('Sell Short', Null);

CREATE TABLE portfolio.strategy (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(64) NOT NULL,
    description varchar(255),
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp);

COMMENT ON TABLE portfolio.strategy IS 'The strategy being used for the trade.';

DELETE FROM portfolio.strategy;
INSERT INTO portfolio.strategy (code, description) VALUES
    ('Bear Call Spread (Credit Call Spread)', Null),
    ('Bear Put Spread', Null),
    ('Bear Spread Spread (Double Bear Spread, Combination Bear Spread)', Null),
    ('Bull Call Spread (Debit Call Spread)', Null),
    ('Bull Put Spread (Credit Put Spread)', Null),
    ('Buying Index Calls', Null),
    ('Buying Index Puts', Null),
    ('Cash-Backed Call (Cash-Secured Call)', Null),
    ('Cash-Secured Put', Null),
    ('Collar (Protective Collar)', Null),
    ('Covered Call (Buy/Write)', Null),
    ('Covered Put', Null),
    ('Covered Ratio Spread', Null),
    ('Covered Strangle (Covered Combination)', Null),
    ('Double Bear Spread', Null),
    ('Long Call', Null),
    ('Long Call Butterfly', Null),
    ('Long Call Calendar Spread (Call Horizontal)', Null),
    ('Long Call Condor', Null),
    ('Long Condor', Null),
    ('Long Iron Butterfly', Null),
    ('Long Put', Null),
    ('Long Put Butterfly', Null),
    ('Long Put Calendar Spread (Put Horizontal)', Null),
    ('Long Put Condor', Null),
    ('Long Ratio Call Spread', Null),
    ('Long Ratio Put Spread', Null),
    ('Long Stock', Null),
    ('Long Straddle', Null),
    ('Long Strangle (Long Combination)', Null),
    ('Naked Call (Uncovered Call, Short Call)', Null),
    ('Naked Put (Uncovered Put, Short Put)', Null),
    ('Protective Put (Married Put)', Null),
    ('Short Call Butterfly', Null),
    ('Short Call Calendar Spread (Short Call Time Spread)', Null),
    ('Short Condor (Iron Condor)', Null),
    ('Short Iron Butterfly', Null),
    ('Short Put Butterfly', Null),
    ('Short Put Calendar Spread (Short Put Time Spread)', Null),
    ('Short Ratio Call Spread', Null),
    ('Short Ratio Put Spread', Null),
    ('Short Stock', Null),
    ('Short Straddle', Null),
    ('Short Strangle', Null),
    ('Synthetic Long Put', Null),
    ('Synthetic Long Stock', Null),
    ('Synthetic Short Stock', Null);

CREATE TABLE portfolio.order_status (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) NOT NULL,
    description varchar(255),
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp);

COMMENT ON TABLE portfolio.order_status IS 'Represents the current stage of the order';

DELETE FROM portfolio.order_status;
INSERT INTO portfolio.order_status (code, description) VALUES
    ('Not ordered', 'The order has not been submitted to the exchange.'),
    ('Ordered', 'The order has been submitted but has not been filled.'),
    ('Open', 'The order has been filled.'),
    ('Closed', 'The order has been finalised.');

CREATE TABLE portfolio.trade_status (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) NOT NULL,
    description varchar(255),
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp);

COMMENT ON TABLE portfolio.trade_status IS 'Represents the current stage of the trade. A trade can one or several legs (especially for options)';

DELETE FROM portfolio.trade_status;
INSERT INTO portfolio.trade_status (code, description) VALUES
    ('Not ready to order', 'Still working out the details of the trade'),
    ('Ready to order', 'The trade is ready to be submitted'),
    ('Ordered', 'The trade has been submitted'),
    ('Open', 'At least part of the trade has been filled'),
    ('Finalised', 'The trade has been finalised. All legs are closed');

CREATE TABLE portfolio.leg_status (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) NOT NULL,
    description varchar(255),
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp);

COMMENT ON TABLE portfolio.leg_status IS 'Represents the current stage of a leg of a trade.';

DELETE FROM portfolio.leg_status;
INSERT INTO portfolio.leg_status (code, description) VALUES
    ('Not ready to order', 'Still working out the details of the leg.'),
    ('Ready to order', 'The leg is ready to be submitted'),
    ('Ordered', 'The leg has been submitted'),
    ('Open', 'The leg has been filled'),
    ('Closed', 'The leg has been finalised.');

CREATE TABLE portfolio.trade (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    strategy_id integer NOT NULL,
    trade_status_id integer NOT NULL,
    description varchar(255) NULL,
    entry_reason varchar(255) NULL,
    exit_criteria varchar(255) NULL,
    newsletter_id integer NULL,
    newsletter_date date NULL,
    newsletter_time time NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp, 
    CONSTRAINT fk_strategy
        FOREIGN KEY(strategy_id)
        REFERENCES portfolio.strategy(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_trade_status
        FOREIGN KEY(trade_status_id)
        REFERENCES portfolio.trade_status(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_newsletter
        FOREIGN KEY(newsletter_id)
        REFERENCES portfolio.newsletter(id)
        ON DELETE SET NULL);

COMMENT ON TABLE portfolio.trade IS 'The trading plan.';

CREATE TABLE portfolio.leg (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    trade_id integer NOT NULL,
    ticker_id integer NOT NULL,
    leg_status_id integer NOT NULL,
    action_id integer NOT NULL,
    limit_price numeric(19,4) NULL,
    quantity numeric(19,0) NULL,
    description varchar(255) NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp,
    CONSTRAINT fk_trade
        FOREIGN KEY(trade_id)
        REFERENCES portfolio.trade(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_leg_status
        FOREIGN KEY(leg_status_id)
        REFERENCES portfolio.leg_status(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_action
        FOREIGN KEY(action_id)
        REFERENCES portfolio.action(id)
        ON DELETE SET NULL);

COMMENT ON TABLE portfolio.leg IS 'A trade is made up of one or more legs';

CREATE TABLE portfolio.order (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    leg_id integer NOT NULL,
    ticker_id integer NOT NULL,
    order_status_id integer NOT NULL,
    action_id integer NOT NULL,
    limit_price numeric(19,4) NULL,
    quantity numeric(19,0) NULL,
    order_date date NULL,
    order_time time NULL,
    description varchar(255) NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp,
    CONSTRAINT fk_leg
        FOREIGN KEY(leg_id)
        REFERENCES portfolio.leg(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_order_status
        FOREIGN KEY(order_status_id)
        REFERENCES portfolio.order_status(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_action
        FOREIGN KEY(action_id)
        REFERENCES portfolio.action(id)
        ON DELETE SET NULL);

COMMENT ON TABLE portfolio.order IS 'An order placed with a broker';

CREATE TABLE portfolio.transaction (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    order_id integer NOT NULL,
    ticker_id integer NOT NULL,
    action_id integer NOT NULL,
    unit_price numeric(19,4) NULL,
    quantity numeric(19,0) NULL,
    stock_total numeric(19,4) NULL,
    commission numeric(19,4) NULL,
    tax numeric(19,4) NULL,
    transaction_date date NULL,
    transaction_time time NULL,
    description varchar(255) NULL,
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp,
    CONSTRAINT fk_order
        FOREIGN KEY(order_id)
        REFERENCES portfolio.order(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_action
        FOREIGN KEY(action_id)
        REFERENCES portfolio.action(id)
        ON DELETE SET NULL);

COMMENT ON TABLE portfolio.transaction IS 'The actual transactions that take place to fill an order';

CREATE TABLE portfolio.watchlist (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    watchlist_type_id integer NOT NULL,
    name VARCHAR(250) NOT NULL UNIQUE,
    description VARCHAR(1000) NOT NULL DEFAULT '',
    created_date timestamp DEFAULT current_timestamp,
    last_updated_date timestamp DEFAULT current_timestamp,
    CONSTRAINT fk_watchlist_type
        FOREIGN KEY(watchlist_type_id) 
        REFERENCES portfolio.watchlist_type(id)
        ON DELETE SET NULL);

COMMENT ON TABLE portfolio.watchlist IS 'Used to group a set of securities together. Securities may be in multiple watchlists.';
