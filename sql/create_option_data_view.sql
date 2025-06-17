DROP VIEW IF EXISTS securities.vw_option_data;
CREATE OR REPLACE VIEW securities.vw_option_data AS
SELECT
    t.ticker AS ticker,
    o.date as date,
    o.last_price as last_price,
    o.bid as bid,
    o.ask as ask,
    o.volume as volume,
    o.open_interest as open_interest
FROM
    securities.ticker t
    INNER JOIN securities.option_data o ON t.id = o.ticker_id
ORDER by ticker;