-- ALTER TABLE securities.exchange ADD COLUMN yahoo_exchange_suffix varchar(32) NULL;
-- Create a temporary TIMESTAMP column
-- ALTER TABLE securities.ticker ADD COLUMN ticker_exchange varchar(32) NULL;

-- Copy casted value over to the temporary column

WITH subquery AS (
    SELECT t.id, concat(t.ticker, e.yahoo_exchange_suffix) AS ticker_exchange
    FROM securities.ticker t, securities.exchange e WHERE t.exchange_id = e.id)

UPDATE securities.ticker
SET ticker_exchange = subquery.ticker_exchange
FROM subquery
WHERE securities.ticker.id = subquery.id;


