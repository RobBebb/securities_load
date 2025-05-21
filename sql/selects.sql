-- SELECT *
-- FROM securities.vw_ticker
-- WHERE ticker = 'AAPL'
-- AND exchange_code = 'XNAS';

-- 'XASX' = ASX
-- 'XNAS' = NASDAQ
SELECT *
FROM securities.vw_ohlcv
-- WHERE exchange_code = 'XASX'
WHERE exchange_code = 'XASX'
AND ticker = 'RAD'
ORDER BY date DESC;
