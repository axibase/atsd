-- Drop all data before test
DROP TABLE IF EXISTS TradeHistory;
DROP TABLE IF EXISTS UniversalHistory;
DROP TABLE IF EXISTS Instruments;
DROP TABLE IF EXISTS Metrics;
DROP TABLE IF EXISTS temporary_csv_data_table;
GO

-- Create Instruments table with auto-increment index
CREATE TABLE Instruments(
   Id INT IDENTITY(1,1),
   Name VARCHAR(20),
   CONSTRAINT Instruments_pk PRIMARY KEY (Id)
);
INSERT INTO Instruments (Name) VALUES ('IBM');
GO

-- Create Metrics table with auto-increment index
CREATE TABLE Metrics(
   Id INT IDENTITY(1,1),
   Name VARCHAR(20),
   CONSTRAINT Metrics_pk PRIMARY KEY (Id)
);
INSERT INTO Metrics (Name) VALUES ('Open');
INSERT INTO Metrics (Name) VALUES ('High');
INSERT INTO Metrics (Name) VALUES ('Low');
INSERT INTO Metrics (Name) VALUES ('Close');
INSERT INTO Metrics (Name) VALUES ('Volume');
GO

-- Create table to load IBM_adjusted.txt CSV file.
CREATE TABLE temporary_csv_data_table (
   [Date_str] text,
   [Time_str] text,
   [Open] DECIMAL(7,4),
   [High] DECIMAL(7,4),
   [Low]  DECIMAL(7,4),
   [Close] DECIMAL(7,4),
   [Volume] INT);
GO

-- Load CSV file
BULK INSERT temporary_csv_data_table
FROM '/data/IBM_adjusted.txt'
WITH(
	FORMAT = 'CSV',
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a');
GO

-- Create UniversalHistory table
CREATE TABLE UniversalHistory(
   [Instrument] INT NOT NULL FOREIGN KEY REFERENCES Instruments(Id), 
   [Metric] INT NOT NULL FOREIGN KEY REFERENCES Metrics(Id), 
   [Value] DECIMAL(12,4),
   [Time] DATETIME2(0) NOT NULL,
   CONSTRAINT UniversalHistory_pk PRIMARY KEY NONCLUSTERED (Instrument, Metric, Time)
);
GO

-- Load data from external table
-- Each OHLCV column is loaded with a separate INSERT INTO query

-- open
INSERT INTO UniversalHistory ([Instrument], [Metric], [Value], [Time])
   SELECT 
	1,
	1, 
	[Open],
	CAST(CONCAT(date_str, ' ', time_str) AS DATETIME2(0))
   FROM temporary_csv_data_table;
GO

-- high
INSERT INTO UniversalHistory ([Instrument], [Metric], [Value], [Time])
   SELECT 
	1,
	2, 
	[High],
	CAST(CONCAT(date_str, ' ', time_str) AS DATETIME2(0))
   FROM temporary_csv_data_table;
GO

-- low
INSERT INTO UniversalHistory ([Instrument], [Metric], [Value], [Time])
   SELECT 
	1,
	3, 
	[Low],
	CAST(CONCAT(date_str, ' ', time_str) AS DATETIME2(0))
   FROM temporary_csv_data_table;
GO

-- close
INSERT INTO UniversalHistory ([Instrument], [Metric], [Value], [Time])
   SELECT 
	1,
	4, 
	[Close],
	CAST(CONCAT(date_str, ' ', time_str) AS DATETIME2(0))
   FROM temporary_csv_data_table;
GO

-- volume
INSERT INTO UniversalHistory ([Instrument], [Metric], [Value], [Time])
   SELECT 
	1,
	5, 
	[Volume],
	CAST(CONCAT(date_str, ' ', time_str) AS DATETIME2(0))
   FROM temporary_csv_data_table;
GO

-- Delete csv table
DROP TABLE IF EXISTS temporary_csv_data_table;
GO

-- Enable tabular presentation of query results.
:setvar SQLCMDMAXVARTYPEWIDTH 21
:setvar SQLCMDMAXFIXEDTYPEWIDTH 21
:setvar SQLCMDCOLSEP |
GO

-- Retrieve compression type of the UniversalHistory table
SELECT 
	st.name, 
	sp.data_compression_desc 
FROM sys.partitions SP 
INNER JOIN sys.tables ST ON st.object_id = sp.object_id 
WHERE st.name = 'UniversalHistory' AND sp.index_id = 0;
GO

-- Retrieve row count and size of the UniversalHistory table
exec sp_spaceused 'UniversalHistory';
GO

-- Compress UniversalHistory table
ALTER TABLE UniversalHistory REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE);
GO

-- Retrieve compression type of the UniversalHistory table
SELECT 
	st.name, 
	sp.data_compression_desc 
FROM sys.partitions SP 
INNER JOIN sys.tables ST ON st.object_id = sp.object_id 
WHERE st.name = 'UniversalHistory' AND sp.index_id = 0;
GO

-- Retrieve row count and size of the UniversalHistory table
exec sp_spaceused 'UniversalHistory';
GO
