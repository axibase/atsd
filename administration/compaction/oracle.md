# Oracle Compression Test

## Overview

The following tests calculate the amount of disk space required to store 10+ million `time:value` samples in a Oracle EE 12c 12.2.0.1 database. 

## Results

| **Schema** | **Compressed** | **Data Size** | **Index Size** | **Total Size** | **Row Count** | **Bytes per Row** | **Bytes per Sample** |
|---|---:|---:|---:|---:|---:|---:|---:|
| Trade Table | No | 92,274,688 | 45,088,768 | 137,363,456 | 2,045,514 | 67.2 | 13.4 |
| Trade Table | Yes | 53,477,376 | 42,991,616 | 96,468,992 | 2,045,514 | 47.2 | 9.4 |
| Universal Table | No | 276,824,064 | 260,046,848 | 536,870,912 | 10,227,570 | 52.5 | 52.5 |
| Universal Table | Yes | 184,549,376 | 218,103,808 | 402,653,184 | 10,227,570 | 39.3 | 39.3 |

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

* **Trade Table** [schema](oracle-trade-table.sql) uses a named column for each input metric.
* **Universal Table** [schema](oracle-universal-table.sql) uses a single metric ID column for all input metrics.

The **Trade Table** schema requires less disk space however the underlying table can not be extended to store different sets of columns for different instrument types. As such, mutliple tables needs to be created to store data for various instrument types.

The **Universal Table** schema allows adding new metrics without altering the tables. This can be done by inserting a new  record to the `Metrics` table (a dictionary) and using foreign keys when inserting data into the data table.

### **Trade Table** Schema

* TradeHistory Table

```sql
DESCRIBE TradeHistory;

 Name				     Null?    Type
 ----------------------------------- -------- ------------------------
 INSTRUMENT			     NOT NULL NUMBER(7)
 OPEN					      NUMBER(7,4)
 HIGH					      NUMBER(7,4)
 LOW					      NUMBER(7,4)
 CLOSE					      NUMBER(7,4)
 VOLUME 				      NUMBER(8)
 TIME				     NOT NULL TIMESTAMP(0)


SELECT * FROM TradeHistory FETCH FIRST 5 ROWS ONLY;

INSTRUMENT|	 OPEN|	    HIGH|	LOW|	 CLOSE|    VOLUME|TIME
----------|----------|----------|----------|----------|----------|----------------------
	 1|	104.5|	   104.5|     104.5|	 104.5|     67000|02-JAN-98 09.30.00 AM
	 1|    104.38|	   104.5|    104.38|	104.38|     10800|02-JAN-98 09.31.00 AM
	 1|    104.44|	   104.5|    104.38|	 104.5|     13300|02-JAN-98 09.32.00 AM
	 1|    104.44|	   104.5|    104.38|	104.38|     16800|02-JAN-98 09.33.00 AM
	 1|    104.38|	   104.5|    104.38|	104.38|      4801|02-JAN-98 09.34.00 AM

```

* Instruments Table

```sql
DESCRIBE Instruments;

 Name			 Null?	  Type
 ----------------------- -------- ----------------
 ID			 NOT NULL NUMBER(7)
 NAME				  VARCHAR2(20)


SELECT * FROM Instruments;

	ID|NAME
----------|--------------------
	 1|IBM
```

### **Universal Table** Schema

* UniversalHistory Table

```sql
DESCRIBE UniversalHistory;

Name				     Null?    Type
 ----------------------------------- -------- ------------------------
 INSTRUMENT			     NOT NULL NUMBER(7)
 METRIC 			     NOT NULL NUMBER(7)
 TIME				     NOT NULL TIMESTAMP(0)
 VALUE					      NUMBER(12,4)


SELECT * FROM UniversalHistory FETCH FIRST 5 ROWS ONLY;

INSTRUMENT|    METRIC|TIME									 |     VALUE
----------|----------|---------------------------------------------------------------------------|----------
	 1|	    1|02-JAN-98 09.30.00 AM							 |     104.5
	 1|	    1|02-JAN-98 09.31.00 AM							 |    104.38
	 1|	    1|02-JAN-98 09.32.00 AM							 |    104.44
	 1|	    1|02-JAN-98 09.33.00 AM							 |    104.44
	 1|	    1|02-JAN-98 09.34.00 AM							 |    104.38
```

* Instruments Table

```sql
DESCRIBE Instruments;

Name				     Null?    Type
 ----------------------------------- -------- ------------------------
 ID				     NOT NULL NUMBER(7)
 NAME					      VARCHAR2(20)

SELECT * FROM Instruments;

	ID|NAME
----------|--------------------
	 1|IBM
```

* Metrics Table

```sql
DESCRIBE Metrics;

Name				     Null?    Type
 ----------------------------------- -------- ------------------------
 ID				     NOT NULL NUMBER(7)
 NAME					      VARCHAR2(20)


SELECT * FROM Metrics;

	ID|NAME
----------|--------------------
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

### Launch Oracle Database Container

Build a Oracle EE 12c 12.2.0.1 container as described [here](https://github.com/oracle/docker-images/tree/master/OracleDatabase). 
Mount `/tmp/test` directory to the container and start using following command.

```properties
docker run --name oracle \
  -e ORACLE_SID=axibase \
  -e ORACLE_PWD=axibase \
  -v /tmp/test:/data \
  -d oracle/database:12.2.0.1-ee
```

### Execute SQL scripts for the **Trade Table** Schema.

```sh
curl -o /tmp/test/oracle-trade-table.sql \
 "https://raw.githubusercontent.com/axibase/atsd/master/administration/compaction/oracle-trade-table.sql"
```

```sh
docker exec -u root oracle bash -c "chmod 777 /data" && \
 cat /tmp/test/oracle-trade-table.sql | \
 docker exec -i oracle sqlplus -S system/axibase | grep '|' --color=never
```

```sh
SEGMENT_NAME		  |	BYTES
--------------------------|----------
TRADEHISTORY		  |  92274688

SEGMENT_NAME		  |	BYTES
--------------------------|----------
TRADEHISTORY_PK 	  |  45088768

TABLE_NAME  |ROWS_COUNT
------------|----------
TRADEHISTORY|	2045514


SEGMENT_NAME		  |	BYTES
--------------------------|----------
TRADEHISTORY_COMPRESSED   |  53477376

SEGMENT_NAME		  |	BYTES
--------------------------|----------
TRADEHISTORY_COMPRESSED_PK|  42991616

TABLE_NAME	       |ROWS_COUNT
-----------------------|----------
TRADEHISTORY_COMPRESSED|   2045514
```

### Execute SQL scripts for the **Universal Table** Schema.

```sh
curl -o /tmp/test/oracle-universal-table.sql \
 "https://raw.githubusercontent.com/axibase/atsd/master/administration/compaction/oracle-universal-table.sql"
```

```sh
docker exec -u root oracle bash -c "chmod 777 /data" && \
 cat /tmp/test/oracle-universal-table.sql | \
 docker exec -i oracle sqlplus -S system/axibase | grep '|' --color=never
```

```sh
SEGMENT_NAME		      |     BYTES
------------------------------|----------
UNIVERSALHISTORY	      | 276824064

SEGMENT_NAME		      |     BYTES
------------------------------|----------
UNIVERSALHISTORY_PK	      | 260046848

TABLE_NAME	|ROWS_COUNT
----------------|----------
UNIVERSALHISTORY|  10227570



SEGMENT_NAME		      |     BYTES
------------------------------|----------
UNIVERSALHISTORY_COMPRESSED   | 184549376

SEGMENT_NAME		      |     BYTES
------------------------------|----------
UNIVERSALHISTORY_COMPRESSED_PK| 218103808

TABLE_NAME		   |ROWS_COUNT
---------------------------|----------
UNIVERSALHISTORY_COMPRESSED|  10227570
```
