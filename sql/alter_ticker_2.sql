-- Create a temporary TIMESTAMP column
ALTER TABLE securities.ticker ADD COLUMN ticker_sub_type_id integer NULL,
    ADD CONSTRAINT fk_ticker_ticker_sub_type
        FOREIGN KEY(ticker_sub_type_id)
        REFERENCES securities.ticker_sub_type(id)
        ON DELETE NO ACTION;