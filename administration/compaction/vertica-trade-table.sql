-- Drop all data before test
DROP TABLE IF EXISTS temporary_csv_data_table CASCADE;
DROP TABLE IF EXISTS UniversalHistory CASCADE;
DROP TABLE IF EXISTS TradeHistory CASCADE;
DROP TABLE IF EXISTS Instruments CASCADE;
DROP TABLE IF EXISTS Metrics CASCADE;

-- Create Instruments table with auto-increment index
CREATE TABLE Instruments(
   id auto_increment,
   name VARCHAR(20),
   PRIMARY KEY(id)
);

INSERT INTO Instruments (name) VALUES ('IBM');

-- Create table to load IBM_adjusted.txt CSV file.
CREATE TABLE temporary_csv_data_table(
	date_str VARCHAR,
	time_str VARCHAR,
	open NUMERIC(7,4),
	high NUMERIC(7,4),
	low NUMERIC(7,4),
	close NUMERIC(7,4),
	volume INT);

-- Load CSV file
COPY temporary_csv_data_table FROM '/data/IBM_adjusted.txt' DELIMITER ',' ENCLOSED BY '"' ABORT ON ERROR;

-- Create TradeHistory table
CREATE TABLE TradeHistory(
	instrument INT REFERENCES Instruments(id),
	time TIMESTAMP(0),
	open NUMERIC(7,4),
	high NUMERIC(7,4),
	low NUMERIC(7,4),
	close NUMERIC(7,4),
	volume INT,
	PRIMARY KEY(instrument, time));

-- Create GZIP-compressed projection for TradeHistory table
CREATE PROJECTION TradeHistory_proj(
	instrument ENCODING GZIP_COMP,
	time ENCODING GZIP_COMP,
	open ENCODING GZIP_COMP,
	high ENCODING GZIP_COMP,
	low ENCODING GZIP_COMP,
	close ENCODING GZIP_COMP,
	volume ENCODING GZIP_COMP)
  AS SELECT * FROM TradeHistory ORDER BY instrument, time;

-- Load records into TradeHistory from temporary_csv_data_table (INSERT SELECT)
INSERT INTO TradeHistory(instrument, time, open, high, low, close, volume)
   SELECT 
	1,
	TO_TIMESTAMP(date_str || ' ' || time_str, 'MM/DD/YYYY HH24:MI:SS'),
	open,
	high,
	low,
	close,
	volume
   FROM temporary_csv_data_table;

COMMIT;

-- flush all data from memory storage (wos) to disk (ros)
SELECT DO_TM_TASK('moveout', 'TradeHistory');

-- Delete csv table
DROP TABLE temporary_csv_data_table CASCADE;

-- Enable tabular presentation of query results.
\pset border 2
\pset footer false

-- Retrieve row count and size of the TradeHistory table
SELECT 
	ANCHOR_TABLE_NAME,
	ROW_COUNT,
	SUM(USED_BYTES) AS "table_size"
  FROM column_storage 
  WHERE ANCHOR_TABLE_NAME='TradeHistory' 
  GROUP BY ANCHOR_TABLE_NAME, ROW_COUNT;

