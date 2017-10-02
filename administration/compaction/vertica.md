# Vertica Compression Test

## Overview

The following tests calculate the amount of disk space required to store 10+ million `time:value` samples in a Vertica database, version 7.1.1-0. 

## Results

| **Schema** | **Compressed** | **Total Size** | **Row Count** | **Bytes per Row** | **Bytes per Sample** |
|---|---:|---:|---:|---:|---:|
| Trade Table | Yes | 24,230,537 | 2,045,514 | 11.8 | 2.4 |
| Universal Table | Yes | 56,604,757 | 10,227,570 | 27.7 | 5.6 |

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

* **Trade Table** [schema](vertica-trade-table.sql) uses a named column for each input metric.
* **Universal Table** [schema](vertica-universal-table.sql) uses a single metric ID column for all input metrics.

The **Trade Table** schema requires less disk space however the underlying table can not be extended to store different sets of columns for different instrument types. As such, mutliple tables needs to be created to store data for various instrument types.

The **Universal Table** schema allows adding new metrics without altering the tables. This can be done by inserting a new  record to the `Metrics` table (a dictionary) and using foreign keys when inserting data into the data table.

### **Trade Table** Schema

* TradeHistory Table

```sql
\d TradeHistory;

+--------+--------------+------------+--------------+------+---------+----------+-------------+------------------------+
| Schema |    Table     |   Column   |     Type     | Size | Default | Not Null | Primary Key |      Foreign Key       |
+--------+--------------+------------+--------------+------+---------+----------+-------------+------------------------+
| public | TradeHistory | instrument | int          |    8 |         | t        | t           | public.Instruments(id) |
| public | TradeHistory | "time"     | timestamp(0) |    8 |         | t        | t           |                        |
| public | TradeHistory | open       | numeric(7,4) |    8 |         | f        | f           |                        |
| public | TradeHistory | high       | numeric(7,4) |    8 |         | f        | f           |                        |
| public | TradeHistory | low        | numeric(7,4) |    8 |         | f        | f           |                        |
| public | TradeHistory | close      | numeric(7,4) |    8 |         | f        | f           |                        |
| public | TradeHistory | volume     | int          |    8 |         | f        | f           |                        |
+--------+--------------+------------+--------------+------+---------+----------+-------------+------------------------+

SELECT column_name, encodings, compressions FROM column_storage WHERE ANCHOR_TABLE_NAME='TradeHistory';

+-------------+--------------+--------------+
| column_name |  encodings   | compressions |
+-------------+--------------+--------------+
| instrument  | Uncompressed | gzip         |
| time        | Uncompressed | gzip         |
| open        | Uncompressed | gzip         |
| high        | Uncompressed | gzip         |
| low         | Uncompressed | gzip         |
| close       | Uncompressed | gzip         |
| volume      | Uncompressed | gzip         |
| epoch       | Int_Delta    | none         |
+-------------+--------------+--------------+

SELECT * FROM TradeHistory LIMIT 5;

+------------+---------------------+----------+----------+----------+----------+--------+
| instrument |        time         |   open   |   high   |   low    |  close   | volume |
+------------+---------------------+----------+----------+----------+----------+--------+
|          1 | 1998-01-02 09:30:00 | 104.5000 | 104.5000 | 104.5000 | 104.5000 |  67000 |
|          1 | 1998-01-02 09:31:00 | 104.3800 | 104.5000 | 104.3800 | 104.3800 |  10800 |
|          1 | 1998-01-02 09:32:00 | 104.4400 | 104.5000 | 104.3800 | 104.5000 |  13300 |
|          1 | 1998-01-02 09:33:00 | 104.4400 | 104.5000 | 104.3800 | 104.3800 |  16800 |
|          1 | 1998-01-02 09:34:00 | 104.3800 | 104.5000 | 104.3800 | 104.3800 |   4801 |
+------------+---------------------+----------+----------+----------+----------+--------+
```

* Instruments Table

```sql
\d Instruments;

+--------+-------------+--------+-------------+------+---------+----------+-------------+-------------+
| Schema |    Table    | Column |    Type     | Size | Default | Not Null | Primary Key | Foreign Key |
+--------+-------------+--------+-------------+------+---------+----------+-------------+-------------+
| public | Instruments | id     | int         |    8 |         | t        | t           |             |
| public | Instruments | name   | varchar(20) |   20 |         | f        | f           |             |
+--------+-------------+--------+-------------+------+---------+----------+-------------+-------------+

SELECT column_name, encodings, compressions FROM column_storage WHERE ANCHOR_TABLE_NAME='Instruments';

+-------------+--------------+--------------+
| column_name |  encodings   | compressions |
+-------------+--------------+--------------+
| id          | Uncompressed | int delta    |
| name        | String       | lzo          |
| epoch       | Int_Delta    | none         |
+-------------+--------------+--------------+

SELECT * FROM Instruments;

+----+------+
| id | name |
+----+------+
|  1 | IBM  |
+----+------+
```

### **Universal Table** Schema

* UniversalHistory Table

```sql
\d UniversalHistory;

+--------+------------------+------------+---------------+------+---------+----------+-------------+------------------------+
| Schema |      Table       |   Column   |     Type      | Size | Default | Not Null | Primary Key |      Foreign Key       |
+--------+------------------+------------+---------------+------+---------+----------+-------------+------------------------+
| public | UniversalHistory | Instrument | int           |    8 |         | t        | t           | public.Instruments(id) |
| public | UniversalHistory | Metric     | int           |    8 |         | t        | t           | public.Metrics(Id)     |
| public | UniversalHistory | "Time"     | timestamp(0)  |    8 |         | t        | t           |                        |
| public | UniversalHistory | Value      | numeric(12,4) |    8 |         | f        | f           |                        |
+--------+------------------+------------+---------------+------+---------+----------+-------------+------------------------+

SELECT column_name, encodings, compressions FROM column_storage WHERE ANCHOR_TABLE_NAME='UniversalHistory';

+-------------+--------------+--------------+
| column_name |  encodings   | compressions |
+-------------+--------------+--------------+
| instrument  | Uncompressed | gzip         |
| metric      | Uncompressed | gzip         |
| time        | Uncompressed | gzip         |
| value       | Uncompressed | gzip         |
| epoch       | Int_Delta    | none         |
+-------------+--------------+--------------+

SELECT * FROM UniversalHistory LIMIT 5;

+------------+--------+---------------------+----------+
| Instrument | Metric |        Time         |  Value   |
+------------+--------+---------------------+----------+
|          1 |      1 | 1998-01-02 09:30:00 | 104.5000 |
|          1 |      1 | 1998-01-02 09:31:00 | 104.3800 |
|          1 |      1 | 1998-01-02 09:32:00 | 104.4400 |
|          1 |      1 | 1998-01-02 09:33:00 | 104.4400 |
|          1 |      1 | 1998-01-02 09:34:00 | 104.3800 |
+------------+--------+---------------------+----------+
```

* Instruments Table

```sql
\d Instruments;

+--------+-------------+--------+-------------+------+---------+----------+-------------+-------------+
| Schema |    Table    | Column |    Type     | Size | Default | Not Null | Primary Key | Foreign Key |
+--------+-------------+--------+-------------+------+---------+----------+-------------+-------------+
| public | Instruments | id     | int         |    8 |         | t        | t           |             |
| public | Instruments | name   | varchar(20) |   20 |         | f        | f           |             |
+--------+-------------+--------+-------------+------+---------+----------+-------------+-------------+

SELECT column_name, encodings, compressions FROM column_storage WHERE ANCHOR_TABLE_NAME='Instruments';

+-------------+--------------+--------------+
| column_name |  encodings   | compressions |
+-------------+--------------+--------------+
| id          | Uncompressed | int delta    |
| name        | String       | lzo          |
| epoch       | Int_Delta    | none         |
+-------------+--------------+--------------+

SELECT * FROM Instruments;

+----+------+
| id | name |
+----+------+
|  1 | IBM  |
+----+------+
```

* Metrics Table

```sql
\d Metrics;

+--------+---------+--------+-------------+------+---------+----------+-------------+-------------+
| Schema |  Table  | Column |    Type     | Size | Default | Not Null | Primary Key | Foreign Key |
+--------+---------+--------+-------------+------+---------+----------+-------------+-------------+
| public | Metrics | Id     | int         |    8 |         | t        | t           |             |
| public | Metrics | Name   | varchar(20) |   20 |         | f        | f           |             |
+--------+---------+--------+-------------+------+---------+----------+-------------+-------------+

SELECT column_name, encodings, compressions FROM column_storage WHERE ANCHOR_TABLE_NAME='Metrics';

+-------------+--------------+--------------+
| column_name |  encodings   | compressions |
+-------------+--------------+--------------+
| Id          | Uncompressed | int delta    |
| Name        | String       | lzo          |
| epoch       | Int_Delta    | none         |
+-------------+--------------+--------------+


SELECT * FROM Metrics;

+----+--------+
| Id |  Name  |
+----+--------+
|  1 | Open   |
|  2 | High   |
|  3 | Low    |
|  4 | Close  |
|  5 | Volume |
+----+--------+
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

### Launch Vertica Database Container

Start a Vertica v7.1.1-0 container. Mount `/tmp/test` directory to the container.

```properties
docker run --name=vertica -v /tmp/test:/data -d sumitchawla/vertica
```

### Execute SQL scripts for the **Trade Table** Schema.

```sh
curl -o /tmp/test/vertica-trade-table.sql \
 "https://raw.githubusercontent.com/axibase/atsd/master/administration/compaction/vertica-trade-table.sql"
```

```sh
cat /tmp/test/vertica-trade-table.sql | \
  docker exec -i vertica /opt/vertica/bin/vsql docker dbadmin -q | \
  grep -E '\+|\|' --color=never
```

```sh
+-------------------+-----------+------------+
| ANCHOR_TABLE_NAME | ROW_COUNT | table_size |
+-------------------+-----------+------------+
| TradeHistory      |   2045514 |   24230537 |
+-------------------+-----------+------------+
```

### Execute SQL scripts for the **Universal Table** Schema.

```sh
curl -o /tmp/test/vertica-universal-table.sql \
 "https://raw.githubusercontent.com/axibase/atsd/master/administration/compaction/vertica-universal-table.sql"
```

```sh
cat /tmp/test/vertica-universal-table.sql | \
  docker exec -i vertica /opt/vertica/bin/vsql docker dbadmin -q | \
  grep -E '\+|\|' --color=never
```

```sh
+-------------------+-----------+------------+
| ANCHOR_TABLE_NAME | ROW_COUNT | table_size |
+-------------------+-----------+------------+
| UniversalHistory  |  10227570 |   56604757 |
+-------------------+-----------+------------+
```
