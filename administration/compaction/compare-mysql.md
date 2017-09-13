# ATSD - MySQL compression comparison

## Comparison results

| Database | Size after data input, Mb |
| -------- | --------------------- |
| ATSD | |
| MySQL (metrics columns / not compressed) | 139.3 |
| MySQL (metrics columns / compressed) | 71.18 |
| MySQL (foreign key to metrics / not compressed) | 750.63 |
| MySQL (foreign key to metrics / compressed) | 364.33 |

## Test description

* Install MySQL docker image

```
docker run --name mysql \ 
    -e MYSQL_ROOT_PASSWORD=root_password \
    -e MYSQL_DATABASE=mysqldb \
    -e MYSQL_USER=user \
    -e MYSQL_PASSWORD=password \
    -e MYSQL_ROOT_HOST=172.17.0.1 \
    --publish 3306:3306 -d mysql/mysql-server:5.7
```

MYSQL_ROOT_HOST option is required to allow external connections to the docker container. *172.17.0.1* is a default docker gateway.

* Create **Companies** and **Metrics** tables

```sql
CREATE TABLE Companies(
   Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
   Name VARCHAR(20)
);

CREATE TABLE Metrics(
   Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
   Name VARCHAR(20)
);
```

* Insert sample data

```sql
INSERT INTO Companies (Name) VALUES ("IBM");

INSERT INTO Metrics (Name) VALUES ("open_price");
INSERT INTO Metrics (Name) VALUES ("highest_price");
INSERT INTO Metrics (Name) VALUES ("lowest_price");
INSERT INTO Metrics (Name) VALUES ("close_price");
INSERT INTO Metrics (Name) VALUES ("volume");
```

## Table with metrics columns (not compressed)

* Drop any data table if exists (**TradeHistoryPlain** or **TradeHistory**)

```sql
DROP TABLE TradeHistoryPlain;
DROP TABLE TradeHistory;
```

* Create data table and index

```sql
CREATE TABLE TradeHistoryPlain(
   Company INT NOT NULL, 
   FOREIGN KEY (Company) REFERENCES Companies(Id),
   Open_price DECIMAL(10,4),
   Highest_price DECIMAL(10,4),
   Lowest_price DECIMAL(10,4),
   Close_price DECIMAL(10,4),
   Volume DECIMAL(10,4),
   Time TIMESTAMP(3) NOT NULL,
   PRIMARY KEY (Company, Time)
);

CREATE INDEX idx_tradehistoryplain ON TradeHistoryPlain (Company, Time DESC);
```

* Insert [dataset](http://api.kibot.com/?action=history&symbol=IBM&interval=1&unadjusted=0&bp=1&user=guest) using csv upload query (specify data file path on a local machine in a query)

```sql
LOAD DATA LOCAL INFILE '/home/user/IBM_adjusted.txt'
INTO TABLE TradeHistoryPlain
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	company=1,
	open_price=@col3,
	highest_price=@col4,
	lowest_price=@col5,
	close_price=@col6,
	volume=@col7,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
```

* Measure disk space used in MySQL 

```sql
SELECT    
   table_schema "Data Base Name", 
   SUM(data_length)/1024/1024 "data_length in MB", 
   SUM(index_length)/1024/1024  "index_length in MB",  
   SUM(data_length + index_length)/1024/1024  "Data Base Size in MB", 
   SUM( data_free )/ 1024 / 1024 "Free Space in MB" 
FROM 
   information_schema.TABLES 
WHERE 
   table_schema='mysqldb';
```

## Table with metrics columns (compressed)

* Drop any data table if exists (**TradeHistoryPlain** or **TradeHistory**)

```sql
DROP TABLE TradeHistoryPlain;
DROP TABLE TradeHistory;
```

* Create data table and index with **ROW_FORMAT=COMPRESSED** option

```sql
CREATE TABLE TradeHistoryPlain(
   Company INT NOT NULL, 
   FOREIGN KEY (Company) REFERENCES Companies(Id),
   Open_price DECIMAL(10,4),
   Highest_price DECIMAL(10,4),
   Lowest_price DECIMAL(10,4),
   Close_price DECIMAL(10,4),
   Volume DECIMAL(10,4),
   Time TIMESTAMP(3) NOT NULL,
   PRIMARY KEY (Company, Time)
) ROW_FORMAT=COMPRESSED;

CREATE INDEX idx_tradehistoryplain ON TradeHistoryPlain (Company, Time DESC);
```

* Upload data and measure disk space as described [above](#table-with-metrics-columns-not-compressed)

## Table with foreign key to metrics (not compressed)

* Drop any data table if exists (**TradeHistoryPlain** or **TradeHistory**)

```sql
DROP TABLE TradeHistoryPlain;
DROP TABLE TradeHistory;
```

* Create data table and index

```sql
CREATE TABLE TradeHistory(
   Company INT NOT NULL,
   Metric INT NOT NULL,
   FOREIGN KEY (Company) REFERENCES Companies(Id),
   FOREIGN KEY (Metric) REFERENCES Metrics(Id),
   Time TIMESTAMP(3) NOT NULL,
   Value DECIMAL(10,4),   
   PRIMARY KEY (Company, Metric, Time)
);

CREATE INDEX idx_tradehistory ON TradeHistory (Company, Metric, Time DESC);
```

* Upload data for each metric

```sql
LOAD DATA LOCAL INFILE '/home/alexey/Downloads/IBM_adjusted.txt'
INTO TABLE TradeHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	company=1,
	metric=1,
	value=@col3,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/home/alexey/Downloads/IBM_adjusted.txt'
INTO TABLE TradeHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	company=1,
	metric=2,
	value=@col4,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/home/alexey/Downloads/IBM_adjusted.txt'
INTO TABLE TradeHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	company=1,
	metric=3,
	value=@col5,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/home/alexey/Downloads/IBM_adjusted.txt'
INTO TABLE TradeHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	company=1,
	metric=4,
	value=@col6,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
	
LOAD DATA LOCAL INFILE '/home/alexey/Downloads/IBM_adjusted.txt'
INTO TABLE TradeHistory
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
SET 
	company=1,
	metric=5,
	value=@col7,
	Time=CONCAT(DATE_FORMAT(STR_TO_DATE(@col1, '%m/%d/%Y'), '%Y-%m-%d'), ' ', @col2);
```

* Measure disk space used in MySQL 

```sql
SELECT    
   table_schema "Data Base Name", 
   SUM(data_length)/1024/1024 "data_length in MB", 
   SUM(index_length)/1024/1024  "index_length in MB",  
   SUM(data_length + index_length)/1024/1024  "Data Base Size in MB", 
   SUM( data_free )/ 1024 / 1024 "Free Space in MB" 
FROM 
   information_schema.TABLES 
WHERE 
   table_schema='mysqldb';
```

## Table with foreign key to metrics (compressed)

* Drop any data table if exists (**TradeHistoryPlain** or **TradeHistory**)

```sql
DROP TABLE TradeHistoryPlain;
DROP TABLE TradeHistory;
```

* Create data table and index with **ROW_FORMAT=COMPRESSED** option

```sql
CREATE TABLE TradeHistory(
   Company INT NOT NULL,
   Metric INT NOT NULL,
   FOREIGN KEY (Company) REFERENCES Companies(Id),
   FOREIGN KEY (Metric) REFERENCES Metrics(Id),
   Time TIMESTAMP(3) NOT NULL,
   Value DECIMAL(10,4),   
   PRIMARY KEY (Company, Metric, Time)
) ROW_FORMAT=COMPRESSED;

CREATE INDEX idx_tradehistory ON TradeHistory (Company, Metric, Time DESC);
```

 * Upload data and measure disk space as described [above](#table-with-foreign-key-to-metrics-not-compressed)