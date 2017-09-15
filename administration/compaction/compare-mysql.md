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
```

### DESCRIBE for **Universal Table** Schema

```
+------------+---------------+------+-----+-------------------+-------+
| Field      | Type          | Null | Key | Default           | Extra |
+------------+---------------+------+-----+-------------------+-------+
| Instrument | int(11)       | NO   | MUL | NULL              |       |
| Metric     | int(11)       | NO   |     | NULL              |       |
| Time       | timestamp     | NO   |     | CURRENT_TIMESTAMP |       |
| Value      | decimal(10,4) | YES  |     | NULL              |       |
+------------+---------------+------+-----+-------------------+-------+
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
| Trade Table | Disabled | 114,982,912 | 36,257,792 | 151,240,704 | 73.94 |
| Trade Table | Enabled | 57,491,456 | 18,661,376 | 76,152,832 | 37.23 |
| Universal Table | Disabled | 461,389,824 | 240,041,984 | 701,431,808 | 342,91 |
| Universal Table | Enabled | 226,525,184 | 120,553,472 | 347,078,656 | 169.68 |

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
 "https://raw.githubusercontent.com/axibase/atsd/administration/compaction/mysql-trade-table-raw.sql"
 
curl -o mysql-trade-table-compressed.sql \
 "https://raw.githubusercontent.com/axibase/atsd/administration/compaction/mysql-trade-table-compressed.sql"
 
curl -o trade-table.sh \
 "https://raw.githubusercontent.com/axibase/atsd/administration/compaction/trade-table.sh"
 
chmod +x trade-table.sh
```
 
```sh
curl -o mysql-universal-table-raw.sql \
 "https://raw.githubusercontent.com/axibase/atsd/administration/compaction/mysql-universal-table-raw.sql"
 
curl -o mysql-universal-table-compressed.sql \
 "https://raw.githubusercontent.com/axibase/atsd/administration/compaction/mysql-universal-table-compressed.sql"
 
curl -o universal-table.sh \
 "https://raw.githubusercontent.com/axibase/atsd/administration/compaction/universal-table.sh"
 
chmod +x universal-table.sh
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
./trade-table.sh 
```

```sh
Database size provided by storage engine
mysql: [Warning] Using a password on the command line interface can be insecure.
+----------------+------------+-----------+----------+-----------+
| Storage engine | Row format | Data      | Index    | Total     |
+----------------+------------+-----------+----------+-----------+
| InnoDB         | Dynamic    | 114982912 | 36257792 | 151240704 |
+----------------+------------+-----------+----------+-----------+

Database file size
180355072 /var/lib/mysql/axibase/TradeHistory.ibd

Database size provided by storage engine
mysql: [Warning] Using a password on the command line interface can be insecure.
+----------------+------------+----------+----------+----------+
| Storage engine | Row format | Data     | Index    | Total    |
+----------------+------------+----------+----------+----------+
| InnoDB         | Compressed | 57491456 | 18661376 | 76152832 |
+----------------+------------+----------+----------+----------+

Database file size
92274688 /var/lib/mysql/axibase/TradeHistory.ibd
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
./universal-table.sh 
```

```sh
Database size provided by storage engine
mysql: [Warning] Using a password on the command line interface can be insecure.
+----------------+------------+-----------+-----------+-----------+
| Storage engine | Row format | Data      | Index     | Total     |
+----------------+------------+-----------+-----------+-----------+
| InnoDB         | Dynamic    | 461389824 | 240041984 | 701431808 |
+----------------+------------+-----------+-----------+-----------+

Database file size
729808896 /var/lib/mysql/axibase/UniversalHistory.ibd

Database size provided by storage engine
mysql: [Warning] Using a password on the command line interface can be insecure.
+----------------+------------+-----------+-----------+-----------+
| Storage engine | Row format | Data      | Index     | Total     |
+----------------+------------+-----------+-----------+-----------+
| InnoDB         | Compressed | 226525184 | 120553472 | 347078656 |
+----------------+------------+-----------+-----------+-----------+

Database file size
360710144 /var/lib/mysql/axibase/UniversalHistory.ibd
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
