# Microsoft SQL Server Compression Test

## Overview

The following tests calculate the amount of disk space required to store 10+ million `time:value` samples in a Microsoft SQL Server 2017 (RC2) 14.0.900.75 database. 

## Results

| **Schema** | **Compressed** | **Data Size** | **Index Size** | **Total Size** | **Row Count** | **Bytes per Row** | **Bytes per Sample** |
|---|---:|---:|---:|---:|---:|---:|---:|
| Trade Table | No | 122,314,752 | 671,744 | 122,986,496 | 2,045,514 | 60.1 | 12.0 |
| Trade Table | Yes | 47,988,736 | 139,264 | 48,128,000 | 2,045,514 | 23.6 | 4.7 |
| Universal Table | No |  |  |  | 10,227,570 |  |  |
| Universal Table | Yes |  |  |  | 10,227,570 |  |  |

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
sp_help TradeHistory

Column_name          |Type                 |Computed             |Length     |Prec |Scale|Nullable             |TrimTrailingBlanks   |FixedLenNullInSource |Collation            
---------------------|---------------------|---------------------|-----------|-----|-----|---------------------|---------------------|---------------------|---------------------
Instrument           |decimal              |no                   |          5|7    |0    |no                   |(n/a)                |(n/a)                |NULL                 
Open                 |decimal              |no                   |          5|7    |4    |yes                  |(n/a)                |(n/a)                |NULL                 
High                 |decimal              |no                   |          5|7    |4    |yes                  |(n/a)                |(n/a)                |NULL                 
Low                  |decimal              |no                   |          5|7    |4    |yes                  |(n/a)                |(n/a)                |NULL                 
Close                |decimal              |no                   |          5|7    |4    |yes                  |(n/a)                |(n/a)                |NULL                 
Volume               |decimal              |no                   |          5|8    |0    |yes                  |(n/a)                |(n/a)                |NULL                 
Time                 |datetime2            |no                   |          6|19   |0    |no                   |(n/a)                |(n/a)                |NULL                 

SELECT TOP 5 * FROM TradeHistory;

Instrument|Open     |High     |Low      |Close    |Volume    |Time                                  
----------|---------|---------|---------|---------|----------|--------------------------------------
         1| 104.5000| 104.5000| 104.5000| 104.5000|     67000|                   1998-01-02 09:30:00
         1| 104.3800| 104.5000| 104.3800| 104.3800|     10800|                   1998-01-02 09:31:00
         1| 104.4400| 104.5000| 104.3800| 104.5000|     13300|                   1998-01-02 09:32:00
         1| 104.4400| 104.5000| 104.3800| 104.3800|     16800|                   1998-01-02 09:33:00
         1| 104.3800| 104.5000| 104.3800| 104.3800|      4801|                   1998-01-02 09:34:00
```

* Instruments Table

```sql
sp_help Instruments;

Column_name          |Type                 |Computed             |Length     |Prec |Scale|Nullable             |TrimTrailingBlanks   |FixedLenNullInSource |Collation            
---------------------|---------------------|---------------------|-----------|-----|-----|---------------------|---------------------|---------------------|---------------------
Id                   |decimal              |no                   |          5|7    |0    |no                   |(n/a)                |(n/a)                |NULL                 
Name                 |varchar              |no                   |         20|     |     |yes                  |no                   |yes                  |SQL_Latin1_General_CP

SELECT * FROM Instruments;

Id       |Name                
---------|--------------------
        1|IBM                 
```

### **Universal Table** Schema

* UniversalHistory Table

```sql
DESCRIBE UniversalHistory;

SELECT * FROM UniversalHistory FETCH FIRST 5 ROWS ONLY;

```

* Instruments Table

```sql
DESCRIBE Instruments;

SELECT * FROM Instruments;

```

* Metrics Table

```sql
DESCRIBE Metrics;

SELECT * FROM Metrics;

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

Start a Microsoft SQL Server 2017 (RC2) 14.0.900.75 container.
Mount `/tmp/test` directory to the container and start using following command.

```properties
docker run --name=mssql \
  -e 'ACCEPT_EULA=Y' \
  -e 'SA_PASSWORD=Axibase123' \
  -v /tmp/test:/data \
  -d microsoft/mssql-server-linux
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
TradeHistory         |2045514             |120200 KB         |119448 KB         |656 KB            |96 KB             

name                 |data_compression_desc
---------------------|---------------------
TradeHistory         |PAGE                 

name                 |rows                |reserved          |data              |index_size        |unused            
---------------------|--------------------|------------------|------------------|------------------|------------------
TradeHistory         |2045514             |47048 KB          |46864 KB          |136 KB            |48 KB             

```

### Execute SQL scripts for the **Universal Table** Schema.

```sh
curl -o /tmp/test/mssql-universal-table.sql \
 "https://raw.githubusercontent.com/axibase/atsd/master/administration/compaction/mssql-universal-table.sql"
```

```sh

```

```sh

```
