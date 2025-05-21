-- Create a temporary TIMESTAMP column
ALTER TABLE polygon.ohlcv ADD COLUMN create_time_holder TIMESTAMP without time zone NULL;

-- Copy casted value over to the temporary column
UPDATE polygon.ohlcv SET create_time_holder = ohlcv_date::TIMESTAMP;

-- Modify original column using the temporary column
ALTER TABLE polygon.ohlcv ALTER COLUMN ohlcv_date TYPE TIMESTAMP without time zone USING create_time_holder;

-- Drop the temporary column (after examining altered column values)
ALTER TABLE polygon.ohlcv DROP COLUMN create_time_holder;
