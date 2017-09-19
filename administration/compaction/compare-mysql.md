# MySQL Compression Test

## Overview

The following tests estimate the amount of disk space required to store 10+ million `time:value` samples in a MySQL database, version 5.7. The insertion tests are performed into two schema versions: 

* **Trade Table** which contains named numeric columns for each of the 5 metrics.
* **Universal Table** which contains a metric Id column and metric value column.

The **Trade Table** is most optimal if all instruments collect the same set of metrics. Adding a new metric requires altering the table populated with `NULL` values for instruments that do not collect the new measurement.

On the other hand, the **Universal Table** schema provides flexibility of adding new metrics without altering the tables. This can be done by adding a new metric record to the referenced metric table (dictionary) and using its id when inserting data into the trade data table. The **Universal Table** schema provides the level of flexibility comparable to schema-on-read architectures often implemented in non-relational databases such Axibase Time Series Database.

## Schemas

### DESCRIBE for **Trade Table** Schema

* Instruments

```sql
DESCRIBE Instruments;
+-------+-------------+------+-----+---------+----------------+
| Field | Type        | Null | Key | Default | Extra          |
+-------+-------------+------+-----+---------+----------------+
| Id    | int(11)     | NO   | PRI | NULL    | auto_increment |
| Name  | varchar(20) | YES  |     | NULL    |                |
+-------+-------------+------+-----+---------+----------------+

SELECT * FROM Instruments;
+----+------+
| Id | Name |
+----+------+
|  1 | IBM  |
+----+------+
```

* TradeHistory

```sql
DESCRIBE TradeHistory;
+------------+---------------+------+-----+-------------------+-------+
| Field      | Type          | Null | Key | Default           | Extra |
+------------+---------------+------+-----+-------------------+-------+
| Instrument | int(11)       | NO   | MUL | NULL              |       |
| Open       | decimal(10,4) | YES  |     | NULL              |       |
| High       | decimal(10,4) | YES  |     | NULL              |       |
| Low        | decimal(10,4) | YES  |     | NULL              |       |
| Close      | decimal(10,4) | YES  |     | NULL              |       |
| Volume     | decimal(10,4) | YES  |     | NULL              |       |
| Time       | timestamp     | NO   |     | CURRENT_TIMESTAMP |       |
+------------+---------------+------+-----+-------------------+-------+

SELECT * FROM TradeHistory LIMIT 5;
+------------+----------+----------+----------+----------+------------+---------------------+
| Instrument | Open     | High     | Low      | Close    | Volume     | Time                |
+------------+----------+----------+----------+----------+------------+---------------------+
|          1 | 104.5000 | 104.5000 | 104.5000 | 104.5000 | 67000.0000 | 1998-01-02 09:30:00 |
|          1 | 104.3800 | 104.5000 | 104.3800 | 104.3800 | 10800.0000 | 1998-01-02 09:31:00 |
|          1 | 104.4400 | 104.5000 | 104.3800 | 104.5000 | 13300.0000 | 1998-01-02 09:32:00 |
|          1 | 104.4400 | 104.5000 | 104.3800 | 104.3800 | 16800.0000 | 1998-01-02 09:33:00 |
|          1 | 104.3800 | 104.5000 | 104.3800 | 104.3800 |  4801.0000 | 1998-01-02 09:34:00 |
+------------+----------+----------+----------+----------+------------+---------------------+
```

### DESCRIBE for **Universal Table** Schema

* Instruments

```sql
DESCRIBE Instruments;
+-------+-------------+------+-----+---------+----------------+
| Field | Type        | Null | Key | Default | Extra          |
+-------+-------------+------+-----+---------+----------------+
| Id    | int(11)     | NO   | PRI | NULL    | auto_increment |
| Name  | varchar(20) | YES  |     | NULL    |                |
+-------+-------------+------+-----+---------+----------------+

SELECT * FROM Instruments;
+----+------+
| Id | Name |
+----+------+
|  1 | IBM  |
+----+------+
```

* Metrics

```sql
DESCRIBE Metrics;
+-------+-------------+------+-----+---------+----------------+
| Field | Type        | Null | Key | Default | Extra          |
+-------+-------------+------+-----+---------+----------------+
| Id    | int(11)     | NO   | PRI | NULL    | auto_increment |
| Name  | varchar(20) | YES  |     | NULL    |                |
+-------+-------------+------+-----+---------+----------------+

SELECT * FROM Metrics;
+----+--------+
| Id | Name   |
+----+--------+
|  1 | Open   |
|  2 | High   |
|  3 | Low    |
|  4 | Close  |
|  5 | Volume |
+----+--------+
```

* UniversalHistory

```sql
DESCRIBE UniversalHistory;
+------------+---------------+------+-----+-------------------+-------+
| Field      | Type          | Null | Key | Default           | Extra |
+------------+---------------+------+-----+-------------------+-------+
| Instrument | int(11)       | NO   | MUL | NULL              |       |
| Metric     | int(11)       | NO   |     | NULL              |       |
| Time       | timestamp     | NO   |     | CURRENT_TIMESTAMP |       |
| Value      | decimal(10,4) | YES  |     | NULL              |       |
+------------+---------------+------+-----+-------------------+-------+

SELECT * FROM UniversalHistory LIMIT 5;
+------------+--------+---------------------+----------+
| Instrument | Metric | Time                | Value    |
+------------+--------+---------------------+----------+
|          1 |      1 | 1998-01-02 09:30:00 | 104.5000 |
|          1 |      1 | 1998-01-02 09:31:00 | 104.3800 |
|          1 |      1 | 1998-01-02 09:32:00 | 104.4400 |
|          1 |      1 | 1998-01-02 09:33:00 | 104.4400 |
|          1 |      1 | 1998-01-02 09:34:00 | 104.3800 |
+------------+--------+---------------------+----------+
```

## Dataset

The dataset represents 20+ years of historical minute stock trade data made available from [Kibot](http://www.kibot.com/buy.aspx) company.

The one minute trade statistics are available for IBM stock traded on the New York Stock Exchange starting from February 1st, 1998 in the commonly used OHLCV [format](http://www.kibot.com/support.aspx#data_format).

```csv
Date,Time,Open,High,Low,Close,Volume
01/02/1998,09:30,104.5,104.5,104.5,104.5,67000
...
09/08/2017,17:38,142.45,142.45,142.45,142.45,3556
```

The records be downloaded at the following url: [http://api.kibot.com/?action=history&symbol=IBM&interval=1&unadjusted=0&bp=1&user=guest](http://api.kibot.com/?action=history&symbol=IBM&interval=1&unadjusted=0&bp=1&user=guest).

The file contains over 2 million lines. The price metrics OHLC contain values with up to four decimal places whereas the volume metric is an integer. The dates are recorded in the `US/Eastern` timezone.

Each row consists of 5 metrics for the given 1-minute interval:

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

## Results

| **Schema** | **Compression** | **Data Size** | **Index Size** | **Total Size** | **Bytes per Sample** |
|---|---:|---:|---:|---:|---:|
| Trade Table | Disabled | 129,662,976 | 40,468,480 | 170,131,456 | 83.17 |
| Trade Table | Enabled | 63,266,816 | 20,234,240 | 83,501,056 | 40.82 |
| Universal Table | Disabled | 468,697,088 | 243,187,712 | 711,884,800 | 348.02 |
| Universal Table | Enabled | 228,589,568 | 121,602,048 | 350,191,616 | 171.20 |

## Executing Tests

### Download Data

Create directory `/tmp/storage-test`.

```sh
mkdir /tmp/storage-test
```

Download the dataset.

```sh
curl -o /tmp/storage-test/IBM_adjusted.txt \
  "http://api.kibot.com/?action=history&symbol=IBM&interval=1&unadjusted=0&bp=1&user=guest"
```

Verify the row count:

```sh
wc -l IBM_adjusted.txt
```

```
2045514 IBM_adjusted.txt
```

## Download SQL Scripts

```sh
curl -o mysql-trade-table-raw.sql \
 "https://raw.githubusercontent.com/axibase/atsd/administration/compaction/mysql-trade-table.sql"
 
curl -o trade-table.sh \
 "https://raw.githubusercontent.com/axibase/atsd/administration/compaction/mysql-universal-table.sql"
```

### Launch MySQL Database Container

Start a MySQL 5.7 container. Mount `/tmp/storage-test` directory to the container.

```properties
docker run --name mysql-axibase-storage-test \
    -e MYSQL_DATABASE=axibase \
    -e MYSQL_ROOT_PASSWORD=axibase \
    -v /tmp/storage-test:/data \
    -d mysql/mysql-server:5.7
```

### Execute SQL scripts for the **Trade Table** Schema.

```sh
cat mysql-trade-table.sql | \
 docker exec -i mysql-axibase-storage-test mysql \
  --user=root \
  --password=axibase \
  --database=axibase \
  --table | grep -E '\+|\|' --color=never
```

```sh
mysql: [Warning] Using a password on the command line interface can be insecure.
+--------+--------------+------------+------------+-------------+--------------+--------------+
| engine | table_name   | row_format | table_rows | data_length | index_length | total_length |
+--------+--------------+------------+------------+-------------+--------------+--------------+
| InnoDB | TradeHistory | Dynamic    |    2037812 |   129662976 |     40468480 |    170131456 |
+--------+--------------+------------+------------+-------------+--------------+--------------+
+--------+--------------+------------+------------+-------------+--------------+--------------+
| engine | table_name   | row_format | table_rows | data_length | index_length | total_length |
+--------+--------------+------------+------------+-------------+--------------+--------------+
| InnoDB | TradeHistory | Compressed |    2031025 |    63266816 |     20234240 |     83501056 |
+--------+--------------+------------+------------+-------------+--------------+--------------+
+-----------+---------------------+---------------------+
| row_count | min_time            | max_time            |
+-----------+---------------------+---------------------+
|   2045514 | 1998-01-02 09:30:00 | 2017-09-08 17:38:00 |
+-----------+---------------------+---------------------+
```

### Execute SQL scripts for the **Universal Table** Schema.

```sh
cat mysql-universal-table.sql | \
 docker exec -i mysql-axibase-storage-test mysql \
  --user=root \
  --password=axibase \
  --database=axibase \
  --table | grep -E '\+|\|' --color=never
```

```sh
mysql: [Warning] Using a password on the command line interface can be insecure.
+--------+------------------+------------+------------+-------------+--------------+--------------+
| engine | table_name       | row_format | table_rows | data_length | index_length | total_length |
+--------+------------------+------------+------------+-------------+--------------+--------------+
| InnoDB | UniversalHistory | Dynamic    |    9943788 |   468697088 |    243187712 |    711884800 |
+--------+------------------+------------+------------+-------------+--------------+--------------+
+--------+------------------+------------+------------+-------------+--------------+--------------+
| engine | table_name       | row_format | table_rows | data_length | index_length | total_length |
+--------+------------------+------------+------------+-------------+--------------+--------------+
| InnoDB | UniversalHistory | Compressed |    9947969 |   228589568 |    121602048 |    350191616 |
+--------+------------------+------------+------------+-------------+--------------+--------------+
+-----------+---------------------+---------------------+
| row_count | min_time            | max_time            |
+-----------+---------------------+---------------------+
|  10227570 | 1998-01-02 09:30:00 | 2017-09-08 17:38:00 |
+-----------+---------------------+---------------------+
```
