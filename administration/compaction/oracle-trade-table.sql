-- Drop all data before test
DROP TABLE TradeHistory CASCADE CONSTRAINTS PURGE;
DROP TABLE TradeHistory_Compressed CASCADE CONSTRAINTS PURGE;
DROP TABLE UniversalHistory CASCADE CONSTRAINTS PURGE;
DROP TABLE UniversalHistory_Compressed CASCADE CONSTRAINTS PURGE;
DROP TABLE Instruments CASCADE CONSTRAINTS PURGE;
DROP TABLE Metrics CASCADE CONSTRAINTS PURGE;
DROP TABLE temporary_csv_data_table PURGE;
DROP DIRECTORY data_dir;

-- Create Instruments table with auto-increment index
CREATE TABLE Instruments(
   Id NUMBER(7) GENERATED ALWAYS as IDENTITY NOT NULL,
   Name VARCHAR(20),
   CONSTRAINT Instruments_pk PRIMARY KEY (Id)
);

INSERT INTO Instruments (Name) VALUES ('IBM');


-- Create a directory from which IBM_adjusted.txt will be loaded.
CREATE directory data_dir as '/data';

-- Create external table to load IBM_adjusted.txt CSV file.
CREATE TABLE temporary_csv_data_table (
   date_str VARCHAR2(20),
   time_str VARCHAR2(20),
   open NUMBER(7,4),
   high NUMBER(7,4),
   low  NUMBER(7,4),
   close NUMBER(7,4),
   volume NUMBER(8))
Organization external
(type oracle_loader
default directory data_dir
access parameters (records delimited by '\r\n'
fields terminated by ',')
location ('IBM_adjusted.txt'))
REJECT LIMIT 0;

-- Create TradeHistory table
CREATE TABLE TradeHistory(
   Instrument NUMBER(7) NOT NULL REFERENCES Instruments(Id), 
   Open NUMBER(7,4),
   High NUMBER(7,4),
   Low NUMBER(7,4),
   Close NUMBER(7,4),
   Volume NUMBER(8),
   Time TIMESTAMP(0) NOT NULL,
   CONSTRAINT TradeHistory_pk PRIMARY KEY (Instrument, Time)
);

-- Load records into TradeHistory from temporary_csv_data_table (INSERT SELECT)
INSERT INTO TradeHistory (Instrument, Time, Open, High, Low, Close, Volume)
   SELECT 
	1, 
	TO_TIMESTAMP(date_str || ' ' || time_str, 'MM/dd/YYYY HH24:MI:SS'),
	open,
	high,
	low,
	close,
	volume
   FROM temporary_csv_data_table;

-- Delete external csv table
DROP TABLE temporary_csv_data_table;

-- Enable tabular presentation of query results.
SET COLSEP '|'
COLUMN SEGMENT_NAME FORMAT A26

-- Retrieve table size in bytes
SELECT segment_name, bytes
 FROM dba_segments
 WHERE segment_type='TABLE' and segment_name='TRADEHISTORY';

-- Retrieve index size in bytes
SELECT segment_name, bytes
 FROM dba_segments
 WHERE segment_type='INDEX' and segment_name='TRADEHISTORY_PK';

-- Retrieve row count in the TradeHistory table
SELECT 
  'TRADEHISTORY' AS "TABLE_NAME",
  COUNT(*) ROWS_COUNT
FROM TradeHistory;

-- Create compressed table containing all records from TradeHistory table
CREATE TABLE TradeHistory_Compressed COMPRESS AS SELECT * FROM TradeHistory;

-- Enable keys and index in the compressed table
ALTER TABLE TradeHistory_Compressed ADD CONSTRAINT TradeHistory_Compressed_fk FOREIGN KEY (Instrument) REFERENCES Instruments(Id);
ALTER TABLE TradeHistory_Compressed ADD CONSTRAINT TradeHistory_Compressed_pk PRIMARY KEY (Instrument, Time);
ALTER INDEX TradeHistory_Compressed_pk REBUILD COMPRESS;

-- Retrieve table size in bytes
SELECT segment_name, bytes
 FROM dba_segments
 WHERE segment_type='TABLE' and segment_name='TRADEHISTORY_COMPRESSED';

-- Retrieve index size in bytes
SELECT segment_name, bytes
 FROM dba_segments
 WHERE segment_type='INDEX' and segment_name='TRADEHISTORY_COMPRESSED_PK';

-- Retrieve row count in the compressed TradeHistory_Compressed table
SELECT 
  'TRADEHISTORY_COMPRESSED' AS "TABLE_NAME",
  COUNT(*) ROWS_COUNT
FROM TradeHistory_Compressed;
