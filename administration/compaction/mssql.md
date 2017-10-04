# Microsoft SQL Server Compression Test

## Overview

The following tests calculate the amount of disk space required to store 10+ million `time:value` samples in a Microsoft SQL Server 2017 (RTM) - 14.0.1000.169 database. 

## Results

| **Schema** | **Compressed** | **Data Size** | **Index Size** | **Total Size** | **Row Count** | **Bytes per Row** | **Bytes per Sample** |
|---|---:|---:|---:|---:|---:|---:|---:|
| Trade Table | No | 118,013,952 | 79,101,952 | 197,115,904 | 2,045,514 | 96.3 | 19.3 |
| Trade Table | Yes | 46,080,000 | 49,872,896 | 95,952,896 | 2,045,514 | 46.9 | 9.4 |
| Universal Table | No | 476,053,504 | 439,107,584 | 915,161,088 | 10,227,570 | 89.5 | 89.5 |
| Universal Table | Yes | 148,013,056 | 290,766,848 | 438,779,904 | 10,227,570 | 42.9 | 42.9 |

## Dataset

The dataset represents 20+ years of historical minute stock trade data available from the [Kibot](http://www.kibot.com/buy.aspx) company.

The one minute trade statistics are available for IBM stock traded on the New York Stock Exchange. The recording starts on February 1st, 1998 and lasts until the last trading day. 

The data is provided in the commonly used OHLCV [format](http://www.kibot.com/support.aspx#data_format).

```csv
Date,Time,Open,High,Low,Close,Volume
01/02/1998,09:30,104.5,104.5,104.5,104.5,67000
...
09/08/2017,17:38,142.45,142.45,142.45,142.45,3556
```

The records be downloaded from the following url: [http://api.kibot.com/?action=history&symbol=IBM&interval=1&unadjusted=0&bp=1&user=guest](http://api.kibot.com/?action=history&symbol=IBM&interval=1&unadjusted=0&bp=1&user=guest).

The file contains over 2 million lines. The OHLC metrics contain values with up to four decimal places. The volume metric is an integer. The dates are recorded in `US/Eastern` time.

Each row consists of 5 metrics for a given 1-minute interval:

```
09/08/2017,15:42,142.53,142.5399,142.49,142.49,10031
...
time   = 09/08/2017 15:42
open   = 142.53
high   = 142.5399
low    = 142.49
close  = 142.49
volume = 10031
```

## Schema Alternatives

The tests are performed using two schema options: 

* **Trade Table** [schema](mssql-trade-table.sql) uses a named column for each input metric.
* **Universal Table** [schema](mssql-universal-table.sql) uses a single metric ID column for all input metrics.

The **Trade Table** schema requires less disk space however the underlying table can not be extended to store different sets of columns for different instrument types. As such, mutliple tables needs to be created to store data for various instrument types.

The **Universal Table** schema allows adding new metrics without altering the tables. This can be done by inserting a new  record to the `Metrics` table (a dictionary) and using foreign keys when inserting data into the data table.

### **Trade Table** Schema

* TradeHistory Table

```sql
SELECT 
    COLUMN_NAME, 
    IS_NULLABLE, 
    DATA_TYPE, 
    NUMERIC_PRECISION, 
    NUMERIC_SCALE, 
    DATETIME_PRECISION 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'TradeHistory';

COLUMN_NAME          |IS_NULLABLE|DATA_TYPE            |NUMERIC_PRECISION|NUMERIC_SCALE|DATETIME_PRECISION
---------------------|-----------|---------------------|-----------------|-------------|------------------
Instrument           |NO         |int                  |               10|            0|              NULL
Open                 |YES        |decimal              |                7|            4|              NULL
High                 |YES        |decimal              |                7|            4|              NULL
Low                  |YES        |decimal              |                7|            4|              NULL
Close                |YES        |decimal              |                7|            4|              NULL
Volume               |YES        |int                  |               10|            0|              NULL
Time                 |NO         |datetime2            |             NULL|         NULL|                 0

SELECT TOP 5 * FROM TradeHistory;

Instrument |Open     |High     |Low      |Close    |Volume     |Time                                  
-----------|---------|---------|---------|---------|-----------|--------------------------------------
          1|  99.0000|  99.0000|  99.0000|  99.0000|       6600|                   1998-03-11 14:59:00
          1|  99.0000|  99.0600|  99.0000|  99.0600|       2400|                   1998-03-11 15:00:00
          1|  99.1200|  99.1900|  99.0600|  99.1900|      18300|                   1998-03-11 15:01:00
          1|  99.0600|  99.2500|  99.0600|  99.2500|      12700|                   1998-03-11 15:02:00
          1|  99.3100|  99.3700|  99.1200|  99.2500|      13600|                   1998-03-11 15:03:00
```

* Instruments Table

```sql
SELECT 
    COLUMN_NAME, 
    IS_NULLABLE, 
    DATA_TYPE, 
    NUMERIC_PRECISION, 
    NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Instruments';

COLUMN_NAME          |IS_NULLABLE|DATA_TYPE            |NUMERIC_PRECISION|NUMERIC_SCALE
---------------------|-----------|---------------------|-----------------|-------------
Id                   |NO         |int                  |               10|            0
Name                 |YES        |varchar              |             NULL|         NULL

SELECT * FROM Instruments;

Id       |Name                
---------|--------------------
        1|IBM                 
```

### **Universal Table** Schema

* UniversalHistory Table

```sql
SELECT 
    COLUMN_NAME, 
    IS_NULLABLE, 
    DATA_TYPE, 
    NUMERIC_PRECISION, 
    NUMERIC_SCALE, 
    DATETIME_PRECISION 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'UniversalHistory';

COLUMN_NAME          |IS_NULLABLE|DATA_TYPE            |NUMERIC_PRECISION|NUMERIC_SCALE|DATETIME_PRECISION
---------------------|-----------|---------------------|-----------------|-------------|------------------
Instrument           |NO         |int                  |               10|            0|              NULL
Metric               |NO         |int                  |               10|            0|              NULL
Value                |YES        |decimal              |               12|            4|              NULL
Time                 |NO         |datetime2            |             NULL|         NULL|                 0

SELECT TOP 5 * FROM UniversalHistory;

Instrument |Metric     |Value         |Time                                  
-----------|-----------|--------------|--------------------------------------
          1|          1|      104.5000|                   1998-01-02 09:30:00
          1|          1|      104.3800|                   1998-01-02 09:31:00
          1|          1|      104.4400|                   1998-01-02 09:32:00
          1|          1|      104.4400|                   1998-01-02 09:33:00
          1|          1|      104.3800|                   1998-01-02 09:34:00
```

* Instruments Table

```sql
SELECT 
    COLUMN_NAME, 
    IS_NULLABLE, 
    DATA_TYPE, 
    NUMERIC_PRECISION, 
    NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Instruments';

COLUMN_NAME          |IS_NULLABLE|DATA_TYPE            |NUMERIC_PRECISION|NUMERIC_SCALE
---------------------|-----------|---------------------|-----------------|-------------
Id                   |NO         |int                  |               10|            0
Name                 |YES        |varchar              |             NULL|         NULL

SELECT * FROM Instruments;

Id       |Name                
---------|--------------------
        1|IBM                 
```

* Metrics Table

```sql
SELECT 
    COLUMN_NAME, 
    IS_NULLABLE, 
    DATA_TYPE, 
    NUMERIC_PRECISION, 
    NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Metrics';

COLUMN_NAME          |IS_NULLABLE|DATA_TYPE            |NUMERIC_PRECISION|NUMERIC_SCALE
---------------------|-----------|---------------------|-----------------|-------------
Id                   |NO         |int                  |               10|            0
Name                 |YES        |varchar              |             NULL|         NULL

SELECT * FROM Metrics;

Id         |Name                
-----------|--------------------
          1|Open                
          2|High                
          3|Low                 
          4|Close               
          5|Volume              
```

## Executing Tests

### Download Input Data

Create directory `/tmp/test`.

```sh
mkdir /tmp/test
```

Download the dataset.

```sh
curl -o /tmp/test/IBM_adjusted.txt \
  "http://api.kibot.com/?action=history&symbol=IBM&interval=1&unadjusted=0&bp=1&user=guest"
```

Verify the row count:

```sh
wc -l IBM_adjusted.txt
```

```
2045514 IBM_adjusted.txt
```

### Launch Microsoft SQL Server Database Container

Start a Microsoft SQL Server 2017 (RTM) - 14.0.1000.169 container.
Mount `/tmp/test` directory to the container and start using following command.

```properties
docker run --name=mssql \
  -e 'ACCEPT_EULA=Y' \
  -e 'SA_PASSWORD=Axibase123' \
  -v /tmp/test:/data \
  -d microsoft/mssql-server-linux:2017-latest
```

### Execute SQL scripts for the **Trade Table** Schema.

```sh
curl -o /tmp/test/mssql-trade-table.sql \
 "https://raw.githubusercontent.com/axibase/atsd/master/administration/compaction/mssql-trade-table.sql"
```

```sh
cat /tmp/test/mssql-trade-table.sql |\
 docker exec -i mssql /opt/mssql-tools/bin/sqlcmd -U sa -P Axibase123 | \
 grep '|' --color=never
```

```sh
name                 |data_compression_desc
---------------------|---------------------
TradeHistory         |NONE                 

name                 |rows                |reserved          |data              |index_size        |unused            
---------------------|--------------------|------------------|------------------|------------------|------------------
TradeHistory         |2045514             |192592 KB         |115248 KB         |77248 KB          |96 KB             

name                 |data_compression_desc
---------------------|---------------------
TradeHistory         |PAGE                 

name                 |rows                |reserved          |data              |index_size        |unused            
---------------------|--------------------|------------------|------------------|------------------|------------------
TradeHistory         |2045514             |93968 KB          |45008 KB          |48704 KB          |256 KB            

```

### Execute SQL scripts for the **Universal Table** Schema.

```sh
curl -o /tmp/test/mssql-universal-table.sql \
 "https://raw.githubusercontent.com/axibase/atsd/master/administration/compaction/mssql-universal-table.sql"
```

```sh
cat /tmp/test/mssql-universal-table.sql |\
 docker exec -i mssql /opt/mssql-tools/bin/sqlcmd -U sa -P Axibase123 | \
 grep '|' --color=never
```

```sh
name                 |data_compression_desc
---------------------|---------------------
UniversalHistory     |NONE                 

name                 |rows                |reserved          |data              |index_size        |unused            
---------------------|--------------------|------------------|------------------|------------------|------------------
UniversalHistory     |10227570            |894096 KB         |464896 KB         |428816 KB         |384 KB
            
name                 |data_compression_desc
---------------------|---------------------
UniversalHistory     |PAGE                

name                 |rows                |reserved          |data              |index_size        |unused            
---------------------|--------------------|------------------|------------------|------------------|------------------
UniversalHistory     |10227570            |428752 KB         |144544 KB         |283952 KB         |256 KB            
```
