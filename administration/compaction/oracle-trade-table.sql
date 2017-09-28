-- Drop all data before test
DROP TABLE TradeHistory CASCADE CONSTRAINTS PURGE;
DROP TABLE TradeHistory_Compressed CASCADE CONSTRAINTS PURGE;
DROP TABLE UniversalHistory CASCADE CONSTRAINTS PURGE;
DROP TABLE Instruments CASCADE CONSTRAINTS PURGE;
DROP TABLE Metrics CASCADE CONSTRAINTS PURGE;
DROP TABLE tempotary_csv_data_table PURGE;
DROP DIRECTORY data_dir;

-- Create Instruments table with auto-increment index
CREATE TABLE Instruments(
   Id NUMBER(7) GENERATED ALWAYS as IDENTITY NOT NULL,
   Name VARCHAR(20),
   CONSTRAINT Instruments_pk PRIMARY KEY (Id)
);

INSERT INTO Instruments (Name) VALUES ('IBM');

-- Create external table using csv-formatted file IBM_adjusted.txt as storage.
-- Oracle would write access logs to directory containing storage file, so decalre it explicitly
CREATE directory data_dir as '/data';

CREATE TABLE tempotary_csv_data_table (
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

-- Load data from external table
INSERT INTO TradeHistory (Instrument, Time, Open, High, Low, Close, Volume)
   SELECT 
	1, 
	TO_TIMESTAMP(date_str || ' ' || time_str, 'MM/dd/YYYY HH24:MI:SS'),
	open,
	high,
	low,
	close,
	volume
   FROM tempotary_csv_data_table;

-- Remove external table
DROP TABLE tempotary_csv_data_table;

-- Change query output table style
SET COLSEP '|'
COLUMN SEGMENT_NAME FORMAT A26

-- Get table and index size
SELECT segment_name, bytes
 FROM dba_segments
 WHERE segment_type='TABLE' and segment_name='TRADEHISTORY';

SELECT segment_name, bytes
 FROM dba_segments
 WHERE segment_type='INDEX' and segment_name='TRADEHISTORY_PK';

-- Get rows count
SELECT 
  'TRADEHISTORY' AS "TABLE_NAME",
  COUNT(*) ROWS_COUNT
FROM TradeHistory;

-- Create compressed table with data from TradeHistory table
CREATE TABLE TradeHistory_Compressed COMPRESS AS SELECT * FROM TradeHistory;
ALTER TABLE TradeHistory_Compressed ADD CONSTRAINT TradeHistory_Compressed_fk FOREIGN KEY (Instrument) REFERENCES Instruments(Id);

-- Add compressed index
ALTER TABLE TradeHistory_Compressed ADD CONSTRAINT TradeHistory_Compressed_pk PRIMARY KEY (Instrument, Time);
ALTER INDEX TradeHistory_Compressed_pk REBUILD COMPRESS;

-- Get compressed table and index size
SELECT segment_name, bytes
 FROM dba_segments
 WHERE segment_type='TABLE' and segment_name='TRADEHISTORY_COMPRESSED';

SELECT segment_name, bytes
 FROM dba_segments
 WHERE segment_type='INDEX' and segment_name='TRADEHISTORY_COMPRESSED_PK';

-- Get rows count
SELECT 
  'TRADEHISTORY_COMPRESSED' AS "TABLE_NAME",
  COUNT(*) ROWS_COUNT
FROM TradeHistory_Compressed;
