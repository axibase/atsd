SET @@GLOBAL.innodb_stats_on_metadata=1;

DROP DATABASE IF EXISTS axibase;
CREATE DATABASE axibase;
USE axibase;

CREATE TABLE Instruments(
   Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
   Name VARCHAR(20)
);

INSERT INTO Instruments (Name) VALUES ("IBM");

CREATE TABLE TradeHistory(
   Instrument INT NOT NULL REFERENCES Instruments(Id), 
   Open DECIMAL(12,4),
   High DECIMAL(12,4),
   Low DECIMAL(12,4),
   Close DECIMAL(12,4),
   Volume DECIMAL(12,4),
   Time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX Idx_TradeHistory ON TradeHistory (Instrument, Time);

LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE TradeHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	Open=@col3,
	High=@col4,
	Low=@col5,
	Close=@col6,
	Volume=@col7,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);

ANALYZE TABLE TradeHistory \G;

SELECT 
	engine,
	table_name,
	row_format,
	table_rows,
	data_length, 
	index_length, 
	data_length + index_length AS "total_length"
FROM 
   information_schema.TABLES 
WHERE 
   table_schema='axibase' AND table_name = 'TradeHistory';

DROP DATABASE IF EXISTS axibase;
CREATE DATABASE axibase;
USE axibase;

CREATE TABLE Instruments(
   Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
   Name VARCHAR(20)
) ROW_FORMAT=COMPRESSED;

INSERT INTO Instruments (Name) VALUES ("IBM");

CREATE TABLE TradeHistory(
   Instrument INT NOT NULL REFERENCES Instruments(Id), 
   Open DECIMAL(12,4),
   High DECIMAL(12,4),
   Low DECIMAL(12,4),
   Close DECIMAL(12,4),
   Volume DECIMAL(12,4),
   Time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ROW_FORMAT=COMPRESSED;

CREATE INDEX Idx_TradeHistory ON TradeHistory (Instrument, Time);

LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE TradeHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	Open=@col3,
	High=@col4,
	Low=@col5,
	Close=@col6,
	Volume=@col7,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);

ANALYZE TABLE TradeHistory \G;

SELECT 
	engine,
	table_name,
	row_format,
	table_rows,
	data_length, 
	index_length, 
	data_length + index_length AS "total_length"
FROM 
   information_schema.TABLES 
WHERE 
   table_schema='axibase' AND table_name = 'TradeHistory';

SELECT COUNT(*) AS "row_count", min(time) AS "min_time", max(time) AS "max_time" FROM TradeHistory;
