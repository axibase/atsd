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

-- Create Metrics table with auto-increment index
CREATE TABLE Metrics(
   Id auto_increment,
   Name VARCHAR(20),
   PRIMARY KEY(id)
);

INSERT INTO Metrics (Name) VALUES ('Open');
INSERT INTO Metrics (Name) VALUES ('High');
INSERT INTO Metrics (Name) VALUES ('Low');
INSERT INTO Metrics (Name) VALUES ('Close');
INSERT INTO Metrics (Name) VALUES ('Volume');

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

-- Create UniversalHistory table
CREATE TABLE UniversalHistory(
   Instrument INT REFERENCES Instruments(id),
   Metric INT REFERENCES Metrics(id),
   Time TIMESTAMP(0),
   Value NUMERIC(12,4),
   PRIMARY KEY(Instrument, Metric, Time)
);

-- Create GZIP-compressed projection for UniversalHistory table
CREATE PROJECTION UniversalHistory_proj(
	instrument ENCODING GZIP_COMP,
	metric ENCODING GZIP_COMP,
	time ENCODING GZIP_COMP,
	value ENCODING GZIP_COMP)
  AS SELECT * FROM UniversalHistory ORDER BY instrument, metric, time;

-- Load data from external table
-- Each OHLCV column is loaded with a separate INSERT INTO query

-- open
INSERT INTO UniversalHistory(instrument, metric, time, value)
   SELECT 
	1,
	1,
	TO_TIMESTAMP(date_str || ' ' || time_str, 'MM/DD/YYYY HH24:MI:SS'),
	open
   FROM temporary_csv_data_table;

-- high
INSERT INTO UniversalHistory(instrument, metric, time, value)
   SELECT 
	1,
	2,
	TO_TIMESTAMP(date_str || ' ' || time_str, 'MM/DD/YYYY HH24:MI:SS'),
	high
   FROM temporary_csv_data_table;

-- low
INSERT INTO UniversalHistory(instrument, metric, time, value)
   SELECT 
	1,
	3,
	TO_TIMESTAMP(date_str || ' ' || time_str, 'MM/DD/YYYY HH24:MI:SS'),
	low
   FROM temporary_csv_data_table;

-- close
INSERT INTO UniversalHistory(instrument, metric, time, value)
   SELECT 
	1,
	4,
	TO_TIMESTAMP(date_str || ' ' || time_str, 'MM/DD/YYYY HH24:MI:SS'),
	close
   FROM temporary_csv_data_table;

-- volume
INSERT INTO UniversalHistory(instrument, metric, time, value)
   SELECT 
	1,
	5,
	TO_TIMESTAMP(date_str || ' ' || time_str, 'MM/DD/YYYY HH24:MI:SS'),
	volume
   FROM temporary_csv_data_table;

COMMIT;

-- Flush all data from memory storage (wos) to disk (ros)
SELECT DO_TM_TASK('moveout', 'UniversalHistory');

-- Delete csv table
DROP TABLE temporary_csv_data_table CASCADE;

-- Enable tabular presentation of query results.
\pset border 2
\pset footer false

-- Retrieve row count and size of the UniversalHistory table
SELECT 
	ANCHOR_TABLE_NAME,
	ROW_COUNT,
	SUM(USED_BYTES) AS "table_size"
  FROM column_storage 
  WHERE ANCHOR_TABLE_NAME='UniversalHistory' 
  GROUP BY ANCHOR_TABLE_NAME, ROW_COUNT;
