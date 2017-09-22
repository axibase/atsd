CREATE TABLE temp (date text, time text, open text, high text, low text, close text, volume text);
COPY temp FROM '/data/IBM_adjusted.txt' DELIMITER ',' CSV;

CREATE TABLE instruments (
   id SERIAL NOT NULL PRIMARY KEY,
   name VARCHAR(20)
);

INSERT INTO instruments (name) VALUES ('IBM');

CREATE TABLE metrics(
   id SERIAL NOT NULL PRIMARY KEY,
   name VARCHAR(20)
);

INSERT INTO metrics (name) VALUES ('Open');
INSERT INTO metrics (name) VALUES ('High');
INSERT INTO metrics (name) VALUES ('Low');
INSERT INTO metrics (name) VALUES ('Close');
INSERT INTO metrics (name) VALUES ('Volume');

CREATE TABLE universal_history(
   instrument INT NOT NULL REFERENCES instruments(id),
   metric INT NOT NULL REFERENCES metrics(id),
   time TIMESTAMP(0) NOT NULL,
   Value DECIMAL(12,4)
);

CREATE INDEX idx_universal_history ON universal_history (instrument, metric, time);

INSERT INTO universal_history (instrument, metric, value, time)
	SELECT 
		1, 
		1,
		CAST(open AS DECIMAL(12,4)),
		to_timestamp(CONCAT(date, ' ', time), 'MM/dd/YYY HH24:MI:SS')
	FROM temp;

INSERT INTO universal_history (instrument, metric, value, time)
	SELECT 
		1, 
		2,
		CAST(high AS DECIMAL(12,4)),
		to_timestamp(CONCAT(date, ' ', time), 'MM/dd/YYY HH24:MI:SS')
	FROM temp;

INSERT INTO universal_history (instrument, metric, value, time)
	SELECT 
		1, 
		3,
		CAST(low AS DECIMAL(12,4)),
		to_timestamp(CONCAT(date, ' ', time), 'MM/dd/YYY HH24:MI:SS')
	FROM temp;

INSERT INTO universal_history (instrument, metric, value, time)
	SELECT 
		1, 
		4,
		CAST(close AS DECIMAL(12,4)),
		to_timestamp(CONCAT(date, ' ', time), 'MM/dd/YYY HH24:MI:SS')
	FROM temp;

INSERT INTO universal_history (instrument, metric, value, time)
	SELECT 
		1, 
		5,
		CAST(volume AS DECIMAL(12,4)),
		to_timestamp(CONCAT(date, ' ', time), 'MM/dd/YYY HH24:MI:SS')
	FROM temp;

VACUUM FULL universal_history;

SELECT 
	'universal_history' as "table_name",
	pg_relation_size('public.universal_history'),
	pg_indexes_size('public.universal_history'),
	pg_total_relation_size('public.universal_history');

SELECT 
	COUNT(*) AS "row_count",
	min(time) AS "min_time", 
	max(time) AS "max_time"
FROM universal_history;
