-- Prepare schema

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

-- Table with metrics columns (not compressed)

DROP TABLE IF EXISTS TradeHistoryPlain;
DROP TABLE IF EXISTS TradeHistory;

CREATE TABLE TradeHistoryPlain(
   Instrument INT NOT NULL, 
   FOREIGN KEY (Instrument) REFERENCES Instruments(Id),
   Open DECIMAL(10,4),
   High DECIMAL(10,4),
   Low DECIMAL(10,4),
   Close DECIMAL(10,4),
   Volume DECIMAL(10,4),
   Time TIMESTAMP(3) NOT NULL
);

CREATE INDEX Idx_TradeHistoryPlain ON TradeHistoryPlain (Instrument, Time);

LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE TradeHistoryPlain
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
   SUM(data_length + index_length)/1024/1024  "Table with metrics columns size (not compressed) in MB"
FROM 
   information_schema.TABLES 
WHERE 
   table_schema='mysqldb';

-- Table with metrics columns (compressed)

DROP TABLE IF EXISTS TradeHistoryPlain;
DROP TABLE IF EXISTS TradeHistory;

CREATE TABLE TradeHistoryPlain(
   Instrument INT NOT NULL, 
   FOREIGN KEY (Instrument) REFERENCES Instruments(Id),
   Open DECIMAL(10,4),
   High DECIMAL(10,4),
   Low DECIMAL(10,4),
   Close DECIMAL(10,4),
   Volume DECIMAL(10,4),
   Time TIMESTAMP(3) NOT NULL
) ROW_FORMAT=COMPRESSED;

CREATE INDEX Idx_TradeHistoryPlain ON TradeHistoryPlain (Instrument, Time);

LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE TradeHistoryPlain
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
   SUM(data_length + index_length)/1024/1024  "Table with metrics columns size (compressed) in MB"
FROM 
   information_schema.TABLES 
WHERE 
   table_schema='mysqldb';

-- Table with foreign key to metrics (not compressed)

DROP TABLE IF EXISTS TradeHistoryPlain;
DROP TABLE IF EXISTS TradeHistory;

CREATE TABLE TradeHistory(
   Instrument INT NOT NULL,
   TradeField INT NOT NULL,
   FOREIGN KEY (Instrument) REFERENCES Instruments(Id),
   FOREIGN KEY (TradeField) REFERENCES TradeFields(Id),
   Time TIMESTAMP(3) NOT NULL,
   Value DECIMAL(10,4)
);

CREATE INDEX Idx_TradeHistory ON TradeHistory (Instrument, TradeField, Time);

LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE TradeHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=1,
	value=@col3,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE TradeHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=2,
	value=@col4,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE TradeHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=3,
	value=@col5,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE TradeHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=4,
	value=@col6,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE TradeHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=5,
	value=@col7,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);

SELECT
   SUM(data_length + index_length)/1024/1024  "Table with foreign key to metrics size (not compressed) in MB"
FROM 
   information_schema.TABLES 
WHERE 
   table_schema='mysqldb';

-- Table with foreign key to metrics (compressed)

DROP TABLE IF EXISTS TradeHistoryPlain;
DROP TABLE IF EXISTS TradeHistory;

CREATE TABLE TradeHistory(
   Instrument INT NOT NULL,
   TradeField INT NOT NULL,
   FOREIGN KEY (Instrument) REFERENCES Instruments(Id),
   FOREIGN KEY (TradeField) REFERENCES TradeFields(Id),
   Time TIMESTAMP(3) NOT NULL,
   Value DECIMAL(10,4)
) ROW_FORMAT=COMPRESSED;

CREATE INDEX Idx_TradeHistory ON TradeHistory (Instrument, TradeField, Time);

LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE TradeHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=1,
	value=@col3,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE TradeHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=2,
	value=@col4,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE TradeHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=3,
	value=@col5,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE TradeHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=4,
	value=@col6,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/data/IBM_adjusted.txt'
INTO TABLE TradeHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	Instrument=1,
	TradeField=5,
	value=@col7,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);

SELECT
   SUM(data_length + index_length)/1024/1024  "Table with foreign key to metrics size (not compressed) in MB"
FROM 
   information_schema.TABLES 
WHERE 
   table_schema='mysqldb';


