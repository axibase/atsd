-- Prepare schema

DROP TABLE IF EXISTS TradeHistory;
DROP TABLE IF EXISTS UniversalHistory;
DROP TABLE IF EXISTS Instruments;
DROP TABLE IF EXISTS TradeFields;

CREATE TABLE Instruments(
   Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
   Name VARCHAR(20)
);

CREATE TABLE TradeFields(
   Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
   Name VARCHAR(20)
);

INSERT INTO Instruments (Name) VALUES ("IBM");

INSERT INTO TradeFields (Name) VALUES ("Open");
INSERT INTO TradeFields (Name) VALUES ("High");
INSERT INTO TradeFields (Name) VALUES ("Low");
INSERT INTO TradeFields (Name) VALUES ("Close");
INSERT INTO TradeFields (Name) VALUES ("Volume");

-- Table with foreign key to metrics (not compressed)

DROP TABLE IF EXISTS UniversalHistory;
DROP TABLE IF EXISTS TradeHistory;

CREATE TABLE UniversalHistory(
   Instrument INT NOT NULL REFERENCES Instruments(Id),
   TradeField INT NOT NULL REFERENCES TradeFields(Id),
   Time TIMESTAMP(3) NOT NULL,
   Value DECIMAL(10,4)
);

CREATE INDEX Idx_UniversalHistory ON UniversalHistory (Instrument, TradeField, Time);

LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE UniversalHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=1,
	value=@col3,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE UniversalHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=2,
	value=@col4,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE UniversalHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=3,
	value=@col5,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE UniversalHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=4,
	value=@col6,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE UniversalHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=5,
	value=@col7,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);

SELECT 
	"Disabled" AS "Compression",
	SUM(data_length) "Data", 
	SUM(index_length) "Index", 
	SUM(data_length + index_length) "Total"
FROM 
   information_schema.TABLES 
WHERE 
   table_schema='axibase';


-- Table with foreign key to metrics (compressed)

DROP TABLE IF EXISTS UniversalHistory;
DROP TABLE IF EXISTS TradeHistory;

CREATE TABLE UniversalHistory(
   Instrument INT NOT NULL REFERENCES Instruments(Id),
   TradeField INT NOT NULL REFERENCES TradeFields(Id),
   Time TIMESTAMP(3) NOT NULL,
   Value DECIMAL(10,4)
) ROW_FORMAT=COMPRESSED;

CREATE INDEX Idx_UniversalHistory ON UniversalHistory (Instrument, TradeField, Time);

LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE UniversalHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=1,
	value=@col3,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE UniversalHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=2,
	value=@col4,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE UniversalHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=3,
	value=@col5,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE UniversalHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=4,
	value=@col6,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE UniversalHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=5,
	value=@col7,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);

SELECT 
	"Enabled" AS "Compression",
	SUM(data_length) "Data", 
	SUM(index_length) "Index", 
	SUM(data_length + index_length) "Total"
FROM 
   information_schema.TABLES 
WHERE 
   table_schema='axibase';



