DROP VIEW IF EXISTS securities.vw_us_option_data;
CREATE OR REPLACE VIEW securities.vw_us_option_data AS
SELECT
    t.ticker AS ticker,
    t.expiry_date AS expiry_date,
    t.strike AS strike,
    t.call_put AS call_put,
    o.date as date,
    o.bid as bid,
    o.ask as ask,
    o.volume as volume,
    o.open_interest as open_interest,
    o.implied_volatility as implied_volatility,
    o.percent_change as percent_change,
    o.in_the_money as in_the_money,
    o.last_trade_date as last_trade_date,
    o.last_price as last_price
FROM
    securities.ticker t
    INNER JOIN securities.exchange e ON t.exchange_id = e.id
    INNER JOIN securities.option_data o ON t.id = o.ticker_id
    INNER JOIN securities.ticker_type tt ON t.ticker_type_id = tt.id
    AND e.code = 'XCBO'
    AND tt.code = 'option'
    ORDER BY t.ticker, t.expiry_date, t.strike, t.call_put, o.date;
