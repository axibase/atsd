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

-- Create TradeHistory table
CREATE TABLE TradeHistory(
   [Instrument] INT NOT NULL FOREIGN KEY REFERENCES Instruments(Id), 
   [Open] DECIMAL(7,4),
   [High] DECIMAL(7,4),
   [Low] DECIMAL(7,4),
   [Close] DECIMAL(7,4),
   [Volume] INT,
   [Time] DATETIME2(0) NOT NULL,
   CONSTRAINT TradeHistory_pk PRIMARY KEY NONCLUSTERED (Instrument, Time)
);
GO

-- Load records into TradeHistory from temporary_csv_data_table (INSERT SELECT)
INSERT INTO TradeHistory ([Instrument], [Time], [Open], [High], [Low], [Close], [Volume])
   SELECT 
	1, 
	CAST(CONCAT(date_str, ' ', time_str) AS DATETIME2(0)),
	[Open],
	[High],
	[Low],
	[Close],
	[Volume]
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

-- Retrieve compression type of the TradeHistory table
SELECT 
	st.name, 
	sp.data_compression_desc 
FROM sys.partitions SP 
INNER JOIN sys.tables ST ON st.object_id = sp.object_id 
WHERE st.name = 'TradeHistory' AND sp.index_id = 0;
GO

-- Retrieve row count and size of the TradeHistory table
exec sp_spaceused 'TradeHistory';
GO

-- Compress TradeHistory table
ALTER TABLE TradeHistory REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE);
GO

-- Retrieve compression type of the TradeHistory table
SELECT 
	st.name, 
	sp.data_compression_desc 
FROM sys.partitions SP 
INNER JOIN sys.tables ST ON st.object_id = sp.object_id 
WHERE st.name = 'TradeHistory' AND sp.index_id = 0;
GO

-- Retrieve row count and size of the TradeHistory table
exec sp_spaceused 'TradeHistory';
GO
