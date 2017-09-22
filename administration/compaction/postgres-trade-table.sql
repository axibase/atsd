CREATE TABLE temp (date text, time text, open text, high text, low text, close text, volume text);
COPY temp FROM '/data/IBM_adjusted.txt' DELIMITER ',' CSV;

CREATE TABLE instruments (
   id SERIAL NOT NULL PRIMARY KEY,
   name VARCHAR(20)
);

INSERT INTO instruments (name) VALUES ('IBM');

CREATE TABLE trade_history (
   instrument INT NOT NULL REFERENCES instruments(id), 
   open DECIMAL(12,4),
   high DECIMAL(12,4),
   low DECIMAL(12,4),
   close DECIMAL(12,4),
   volume DECIMAL(12,4),
   time TIMESTAMP(0) NOT NULL
);

CREATE INDEX idx_trade_history ON trade_history (instrument, time);

INSERT INTO trade_history (instrument, open, high, low, close, volume, time)
	SELECT 
		1, 
		CAST(open AS DECIMAL(12,4)),
		CAST(high AS DECIMAL(12,4)),
		CAST(low AS DECIMAL(12,4)),
		CAST(close AS DECIMAL(12,4)),
		CAST(volume AS DECIMAL(12,4)),
		to_timestamp(CONCAT(date, ' ', time), 'MM/dd/YYY HH24:MI:SS')
	FROM temp;

VACUUM FULL trade_history;

SELECT 
	'trade_history' as "table_name",
	pg_relation_size('public.trade_history'),
	pg_indexes_size('public.trade_history'),
	pg_total_relation_size('public.trade_history');

SELECT 
	COUNT(*) AS "row_count",
	min(time) AS "min_time", 
	max(time) AS "max_time"
FROM trade_history;
