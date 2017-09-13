-- Prepare schema

DROP TABLE IF EXISTS TradeHistory;
DROP TABLE IF EXISTS UniversalHistory;
DROP TABLE IF EXISTS Instruments;
DROP TABLE IF EXISTS TradeFields;

CREATE TABLE Instruments(
   Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
   Name VARCHAR(20)
);

INSERT INTO Instruments (Name) VALUES ("IBM");

-- Table with metrics columns (not compressed)

DROP TABLE IF EXISTS UniversalHistory;
DROP TABLE IF EXISTS TradeHistory;

CREATE TABLE TradeHistory(
   Instrument INT NOT NULL REFERENCES Instruments(Id),
   Open DECIMAL(10,4),
   High DECIMAL(10,4),
   Low DECIMAL(10,4),
   Close DECIMAL(10,4),
   Volume DECIMAL(10,4),
   Time TIMESTAMP(3) NOT NULL
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

SELECT 
	SUM(data_length) "Data (not compressed)", 
	SUM(index_length) "Index (not compressed)", 
	SUM(data_length + index_length) "Total (not compressed)"
FROM 
   information_schema.TABLES 
WHERE 
   table_schema='axibase';

-- Table with metrics columns (compressed)

DROP TABLE IF EXISTS UniversalHistory;
DROP TABLE IF EXISTS TradeHistory;

CREATE TABLE TradeHistory(
   Instrument INT NOT NULL REFERENCES Instruments(Id), 
   Open DECIMAL(10,4),
   High DECIMAL(10,4),
   Low DECIMAL(10,4),
   Close DECIMAL(10,4),
   Volume DECIMAL(10,4),
   Time TIMESTAMP(3) NOT NULL
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

SELECT 
	SUM(data_length) "Data (compressed)", 
	SUM(index_length) "Index (compressed)", 
	SUM(data_length + index_length) "Total (compressed)"
FROM 
   information_schema.TABLES 
WHERE 
   table_schema='axibase';


