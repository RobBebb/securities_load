alter table equity.daily_price
alter column price_date type timestamp without time zone using price_date::TIMESTAMP