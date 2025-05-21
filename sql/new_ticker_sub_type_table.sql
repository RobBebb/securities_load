DROP TABLE IF EXISTS securities.ticker_sub_type;

CREATE TABLE securities.ticker_sub_type (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(32) UNIQUE NOT NULL,
    ticker_type_id integer DEFAULT NULL,
    ticker_type_code char(32) DEFAULT NULL,
    description varchar(255),
	start_date date DEFAULT NULL,
    end_date date DEFAULT NULL,
    created_date timestamp with time zone DEFAULT current_timestamp,
    last_updated_date timestamp with time zone,
    CONSTRAINT FK_ticker_sub_type_ticker_type 
    FOREIGN KEY(ticker_type_id)
    REFERENCES securities.ticker_type(id)
    ON DELETE SET NULL);

COMMENT ON TABLE securities.ticker_sub_type IS 'An finer identifier for a group of similar financial instruments within a ticker_type.';

INSERT INTO securities.ticker_sub_type (code, ticker_type_code, description) VALUES
    ('major', 'index', Null),
    ('additional', 'index', Null),
    ('primary sectors', 'index', Null),
    ('other', 'index', Null);

WITH subquery AS (
    SELECT t.id, t.code
    FROM  securities.ticker_type t, securities.ticker_sub_type s WHERE t.code = s.ticker_type_code
)
UPDATE securities.ticker_sub_type
SET ticker_type_id = subquery.id
FROM subquery
WHERE securities.ticker_sub_type.ticker_type_code = subquery.code;
