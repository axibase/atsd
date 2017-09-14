# MySQL Compression Test

## Overview

The following tests estimate the amount of disk space required to store 10+ million `time:value` samples in a MySQL database, version 5.7. The insertion tests are performed into two schema versions: 

* **Trade Table** which contains named numeric columns for each of the 5 metrics.
* **Universal Table** which contains a metric Id column and metric value column.

The **Trade Table** is most optimal if all instruments collect the same set of metrics. Adding a new metric requires altering the table populated with `NULL` values for instruments that do not collect the new measurement.

On the other hand, the **Universal Table** schema provides flexibility of adding new metrics without altering the tables. This can be done by adding a new metric record to the referenced metric table (dictionary) and using its id when inserting data into the trade data table. The **Universal Table** schema provides the level of flexibility comparable to schema-on-read architectures often implemented in non-relational databases such Axibase Time Series Database.

## Schemas

### DESCRIBE for **Trade Table** Schema

```
+------------+---------------+------+-----+----------------------+--------------------------------+
| Field      | Type          | Null | Key | Default              | Extra                          |
+------------+---------------+------+-----+----------------------+--------------------------------+
| Instrument | int(11)       | NO   | MUL | NULL                 |                                |
| Open       | decimal(10,4) | YES  |     | NULL                 |                                |
| High       | decimal(10,4) | YES  |     | NULL                 |                                |
| Low        | decimal(10,4) | YES  |     | NULL                 |                                |
| Close      | decimal(10,4) | YES  |     | NULL                 |                                |
| Volume     | decimal(10,4) | YES  |     | NULL                 |                                |
| Time       | timestamp(3)  | NO   |     | CURRENT_TIMESTAMP(3) | on update CURRENT_TIMESTAMP(3) |
+------------+---------------+------+-----+----------------------+--------------------------------+
```

### DESCRIBE for **Universal Table** Schema

```
+------------+---------------+------+-----+----------------------+--------------------------------+
| Field      | Type          | Null | Key | Default              | Extra                          |
+------------+---------------+------+-----+----------------------+--------------------------------+
| Instrument | int(11)       | NO   | MUL | NULL                 |                                |
| TradeField | int(11)       | NO   |     | NULL                 |                                |
| Time       | timestamp(3)  | NO   |     | CURRENT_TIMESTAMP(3) | on update CURRENT_TIMESTAMP(3) |
| Value      | decimal(10,4) | YES  |     | NULL                 |                                |
+------------+---------------+------+-----+----------------------+--------------------------------+
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
| Trade Table | Disabled | 126,533,632 | 42,565,632 | 169,099,264 | 82.67 |
| Trade Table | Enabled | 63,283,200 | 22,339,584 | 85,622,784 | 41.86 |
| Universal Table | Disabled | 480,280,576 | 257,933,312 | 738,213,888 | 360,89 |
| Universal Table | Enabled | 213,417,984 | 121,610,240 | 335,028,224 | 163.79 |

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
curl -o mysql-trade-table.sql \
 "https://raw.githubusercontent.com/axibase/atsd/administration/compaction/mysql-trade-table.sql"
 ```
 
```sh
curl -o mysql-universal-table.sql \
 "https://raw.githubusercontent.com/axibase/atsd/administration/compaction/mysql-universal-table.sql"
```

### Launch MySQL Database Container

Start a MySQL 5.7 container. Mount `/tmp/storage-test` directory to the container.

```properties
docker run --name mysql-axibase-storage-test \
    -e MYSQL_DATABASE=axibase \
    -e MYSQL_ROOT_PASSWORD=axibase \
    -e MYSQL_USER=axibase \
    -e MYSQL_PASSWORD=axibase \
    -v /tmp/storage-test:/data \
    -d mysql/mysql-server:5.7
```

### Execute SQL scripts for the **Trade Table** Schema.

```sh
cat mysql-trade-table.sql | docker exec -i mysql-axibase-storage-test mysql --user=axibase --password=axibase --database=axibase --table
```

```sh
+-------------+-----------+----------+-----------+
| Compression | Data      | Index    | Total     |
+-------------+-----------+----------+-----------+
| Disabled    | 126533632 | 42565632 | 169099264 |
+-------------+-----------+----------+-----------+
+-------------+----------+----------+----------+
| Compression | Data     | Index    | Total    |
+-------------+----------+----------+----------+
| Enabled     | 63283200 | 22339584 | 85622784 |
+-------------+----------+----------+----------+
```

Target data table row count

```sh
echo "SELECT COUNT(*) FROM TradeHistory;" | docker exec -i mysql-axibase-storage-test mysql --user=axibase --password=axibase --database=axibase --table
```

```sh
+----------+
| COUNT(*) |
+----------+
|  2045514 |
+----------+
```

### Execute SQL scripts for the **Universal Table** Schema.

```sh
cat mysql-universal-table.sql | docker exec -i mysql-axibase-storage-test mysql --user=axibase --password=axibase --database=axibase --table
```

```sh
+-------------+-----------+-----------+-----------+
| Compression | Data      | Index     | Total     |
+-------------+-----------+-----------+-----------+
| Disabled    | 480280576 | 257933312 | 738213888 |
+-------------+-----------+-----------+-----------+
+-------------+-----------+-----------+-----------+
| Compression | Data      | Index     | Total     |
+-------------+-----------+-----------+-----------+
| Enabled     | 213417984 | 121610240 | 335028224 |
+-------------+-----------+-----------+-----------+
```

Target data table row count

```sh
echo "SELECT COUNT(*) FROM UniversalHistory;" | docker exec -i mysql-axibase-storage-test mysql --user=axibase --password=axibase --database=axibase --table
```

```sh
+----------+
| COUNT(*) |
+----------+
| 10227570 |
+----------+
```
