WITH subquery AS (
    SELECT e.id, e.code
    FROM  securities.exchange e, securities.ticker t WHERE t.exchange_id = e.id
)
UPDATE securities.ticker
SET ticker_exchange = CONCAT(ticker, '.', subquery.code)
FROM subquery
WHERE exchange_id = subquery.id;
