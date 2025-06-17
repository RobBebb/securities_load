DROP VIEW IF EXISTS securities.vw_watchlist_ticker;
CREATE OR REPLACE VIEW securities.vw_watchlist_ticker AS
SELECT
    type.code AS watchlist_type,
    w.code AS watchlist,
    tt.code AS ticker_type,
    e.code AS exchange,
    t.ticker AS ticker,
    t.name as name
FROM
    securities.watchlist_ticker wt
    INNER JOIN securities.watchlist w ON w.id = wt.watchlist_id
    INNER JOIN securities.watchlist_type type ON type.id = w.watchlist_type_id
    INNER JOIN securities.ticker t ON t.id = wt.ticker_id
    INNER JOIN securities.exchange e on e.id = t.exchange_id
    INNER JOIN securities.ticker_type tt on tt.id = t.ticker_type_id
    ORDER BY type.code, w.code, tt.code, e.code, t.ticker;
