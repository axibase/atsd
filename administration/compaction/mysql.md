# MySQL Compression Test

## Overview

The following tests calculate the amount of disk space required to store 10+ million `time:value` samples in a MySQL database, version 5.7.

## Results

| **Schema** | **Compressed** | **Data Size** | **Index Size** | **Total Size** | **Row Count** | **Bytes per Row** | **Bytes per Sample** |
|---|---:|---:|---:|---:|---:|---:|---:|
| Trade Table | No | 119,160,832 | 40,468,480 | 159,629,312 | 2,045,514 | 78.0 | 15.6 |
| Trade Table | Yes | 63,266,816 | 20,234,240 | 83,501,056 | 2,045,514 | 40.8 | 8.2 |
| Universal Table | No | 480,247,808 | 243,187,712 | 723,435,520 | 10,227,570 | 70.7 | 70.7 |
| Universal Table | Yes | 231,735,296 | 121,602,048 | 353,337,344 | 10,227,570 | 34.5 | 34.5 |

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

```txt
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

* **Trade Table** [schema](mysql-trade-table.sql) uses a named column for each input metric.
* **Universal Table** [schema](mysql-universal-table.sql) uses a single metric ID column for all input metrics.

The **Trade Table** schema requires less disk space however the underlying table can not be extended to store different sets of columns for different instrument types. As such, multiple tables need to be created to store data for various instrument types.

The **Universal Table** schema allows adding new metrics without altering the tables. This can be done by inserting a new record into the `Metrics` table (a dictionary) and using foreign keys when inserting data into the data table.

### **Trade Table** Schema

* TradeHistory Table

```sql
DESCRIBE TradeHistory;
+------------+--------------+------+-----+-------------------+-------+
| Field      | Type         | Null | Key | Default           | Extra |
+------------+--------------+------+-----+-------------------+-------+
| Instrument | int(11)      | NO   | MUL | NULL              |       |
| Open       | decimal(7,4) | YES  |     | NULL              |       |
| High       | decimal(7,4) | YES  |     | NULL              |       |
| Low        | decimal(7,4) | YES  |     | NULL              |       |
| Close      | decimal(7,4) | YES  |     | NULL              |       |
| Volume     | int(11)      | YES  |     | NULL              |       |
| Time       | timestamp    | NO   |     | CURRENT_TIMESTAMP |       |
+------------+--------------+------+-----+-------------------+-------+

SELECT * FROM TradeHistory LIMIT 5;
+------------+----------+----------+----------+----------+--------+---------------------+
| Instrument | Open     | High     | Low      | Close    | Volume | Time                |
+------------+----------+----------+----------+----------+--------+---------------------+
|          1 | 104.5000 | 104.5000 | 104.5000 | 104.5000 |  67000 | 1998-01-02 09:30:00 |
|          1 | 104.3800 | 104.5000 | 104.3800 | 104.3800 |  10800 | 1998-01-02 09:31:00 |
|          1 | 104.4400 | 104.5000 | 104.3800 | 104.5000 |  13300 | 1998-01-02 09:32:00 |
|          1 | 104.4400 | 104.5000 | 104.3800 | 104.3800 |  16800 | 1998-01-02 09:33:00 |
|          1 | 104.3800 | 104.5000 | 104.3800 | 104.3800 |   4801 | 1998-01-02 09:34:00 |
+------------+----------+----------+----------+----------+--------+---------------------+
```

* Instruments Table

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

### **Universal Table** Schema

* UniversalHistory Table

```sql
DESCRIBE UniversalHistory;
+------------+---------------+------+-----+-------------------+-------+
| Field      | Type          | Null | Key | Default           | Extra |
+------------+---------------+------+-----+-------------------+-------+
| Instrument | int(11)       | NO   | MUL | NULL              |       |
| Metric     | int(11)       | NO   |     | NULL              |       |
| Time       | timestamp     | NO   |     | CURRENT_TIMESTAMP |       |
| Value      | decimal(12,4) | YES  |     | NULL              |       |
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

* Instruments Table

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

* Metrics Table

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

## Executing Tests

### Download Input Data

Create directory `/tmp/test`.

```sh
mkdir /tmp/test
```

Download the dataset.

```sh
curl --compressed -o /tmp/test/IBM_adjusted.txt \
  "http://api.kibot.com/?action=history&symbol=IBM&interval=1&unadjusted=0&bp=1&user=guest"
```

Verify the row count:

```sh
wc -l IBM_adjusted.txt
```

```txt
2045514 IBM_adjusted.txt
```

### Launch MySQL Database Container

Start a MySQL 5.7 container. Mount `/tmp/test` directory to the container.

```elm
docker run --name mysql-axibase-storage-test \
    -e MYSQL_DATABASE=axibase \
    -e MYSQL_ROOT_PASSWORD=axibase \
    -v /tmp/test:/data \
    -d mysql/mysql-server:5.7
```

### Execute SQL scripts for the **Trade Table** Schema.

```sh
curl -o /tmp/test/mysql-trade-table.sql \
 "https://raw.githubusercontent.com/axibase/atsd/master/administration/compaction/mysql-trade-table.sql"
```

```sh
cat /tmp/test/mysql-trade-table.sql | \
 docker exec -i mysql-axibase-storage-test mysql \
  --user=root \
  --password=axibase \
  --database=axibase \
  --table | grep -E '\+|\|' --color=never
```

```sh
+--------+--------------+------------+------------+-------------+--------------+--------------+
| engine | table_name   | row_format | table_rows | data_length | index_length | total_length |
+--------+--------------+------------+------------+-------------+--------------+--------------+
| InnoDB | TradeHistory | Dynamic    |    2038732 |   119160832 |     40468480 |    159629312 |
+--------+--------------+------------+------------+-------------+--------------+--------------+

+--------+--------------+------------+------------+-------------+--------------+--------------+
| engine | table_name   | row_format | table_rows | data_length | index_length | total_length |
+--------+--------------+------------+------------+-------------+--------------+--------------+
| InnoDB | TradeHistory | Compressed |    2042141 |    63266816 |     20234240 |     83501056 |
+--------+--------------+------------+------------+-------------+--------------+--------------+

+-----------+---------------------+---------------------+
| row_count | min_time            | max_time            |
+-----------+---------------------+---------------------+
|   2045514 | 1998-01-02 09:30:00 | 2017-09-08 17:38:00 |
+-----------+---------------------+---------------------+
```

### Execute SQL scripts for the **Universal Table** Schema.

```sh
curl -o /tmp/test/mysql-universal-table.sql \
 "https://raw.githubusercontent.com/axibase/atsd/master/administration/compaction/mysql-universal-table.sql"
```

```sh
cat /tmp/test/mysql-universal-table.sql | \
 docker exec -i mysql-axibase-storage-test mysql \
  --user=root \
  --password=axibase \
  --database=axibase \
  --table | grep -E '\+|\|' --color=never
```

```sh
+--------+------------------+------------+------------+-------------+--------------+--------------+
| engine | table_name       | row_format | table_rows | data_length | index_length | total_length |
+--------+------------------+------------+------------+-------------+--------------+--------------+
| InnoDB | UniversalHistory | Dynamic    |    9943125 |   480247808 |    243187712 |    723435520 |
+--------+------------------+------------+------------+-------------+--------------+--------------+

+--------+------------------+------------+------------+-------------+--------------+--------------+
| engine | table_name       | row_format | table_rows | data_length | index_length | total_length |
+--------+------------------+------------+------------+-------------+--------------+--------------+
| InnoDB | UniversalHistory | Compressed |    9978432 |   231735296 |    121602048 |    353337344 |
+--------+------------------+------------+------------+-------------+--------------+--------------+

+-----------+---------------------+---------------------+
| row_count | min_time            | max_time            |
+-----------+---------------------+---------------------+
|  10227570 | 1998-01-02 09:30:00 | 2017-09-08 17:38:00 |
+-----------+---------------------+---------------------+
```
