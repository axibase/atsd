DROP TABLE TradeHistory PURGE;
DROP TABLE TradeHistory_Compressed PURGE;
DROP TABLE UniversalHistory PURGE;
DROP TABLE Instruments PURGE;
DROP TABLE Metrics PURGE;
DROP TABLE data_ext PURGE;
DROP DIRECTORY data_dir;

CREATE TABLE Instruments(
   Id INTEGER GENERATED ALWAYS as IDENTITY NOT NULL,
   Name VARCHAR(20),
   CONSTRAINT Instruments_pk PRIMARY KEY (Id)
);

INSERT INTO Instruments (Name) VALUES ('IBM');

CREATE directory data_dir as '/data';

CREATE TABLE data_ext (
   date_str VARCHAR2(20),
   time_str VARCHAR2(20),
   open DECIMAL(7,4),
   high DECIMAL(7,4),
   low  DECIMAL(7,4),
   close DECIMAL(7,4),
   volume DECIMAL(8))
Organization external
(type oracle_loader
default directory data_dir
access parameters (records delimited by '\r\n'
fields terminated by ',')
location ('IBM_adjusted.txt'))
REJECT LIMIT 0;

CREATE TABLE TradeHistory(
   Instrument INT NOT NULL REFERENCES Instruments(Id), 
   Open DECIMAL(7,4),
   High DECIMAL(7,4),
   Low DECIMAL(7,4),
   Close DECIMAL(7,4),
   Volume DECIMAL(8),
   Time TIMESTAMP(0) NOT NULL,
   CONSTRAINT TradeHistory_pk PRIMARY KEY (Instrument, Time)
);

INSERT INTO TradeHistory (Instrument, Time, Open, High, Low, Close, Volume)
   SELECT 
	1, 
	TO_TIMESTAMP(date_str || ' ' || time_str, 'MM/dd/YYYY HH24:MI:SS'),
	open,
	high,
	low,
	close,
	volume
   FROM data_ext;

SET COLSEP |
COLUMN SEGMENT_NAME FORMAT A26

SELECT segment_name, bytes
 FROM dba_segments
 WHERE segment_type='TABLE' and segment_name='TRADEHISTORY';

SELECT segment_name, bytes
 FROM dba_segments
 WHERE segment_type='INDEX' and segment_name='TRADEHISTORY_PK';

CREATE TABLE TradeHistory_Compressed COMPRESS AS SELECT * FROM TradeHistory;
ALTER TABLE TradeHistory_Compressed ADD CONSTRAINT TradeHistory_Compressed_pk PRIMARY KEY (Instrument, Time);
ALTER TABLE TradeHistory_Compressed ADD CONSTRAINT TradeHistory_Compressed_fk FOREIGN KEY (Instrument) REFERENCES Instruments(Id);
ALTER INDEX TradeHistory_Compressed_pk REBUILD COMPRESS;

SELECT segment_name, bytes
 FROM dba_segments
 WHERE segment_type='TABLE' and segment_name='TRADEHISTORY_COMPRESSED';

SELECT segment_name, bytes
 FROM dba_segments
 WHERE segment_type='INDEX' and segment_name='TRADEHISTORY_COMPRESSED_PK';


SELECT 'TRADE_HISTORY' AS "TABLE_NAME", COUNT(*) ROWS_COUNT
  FROM TradeHistory;
