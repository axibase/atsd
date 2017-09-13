# MySQL Compression Test

## Overview

The following tests estimate the amount of disk space required to store 10+ million `time:value` samples in a MySQL database, version 5.7. The insertion tests are performed into two schema versions: 

* **Trade Table** which contains named numeric columns for each of the 5 metrics.
* **Universal Table** which contains a metric Id column and metric value column.

The **Trade Table** is most optimal if all instruments collect the same set of metrics. Adding a new metric requires altering the table populated with `NULL` values for instruments that do not collect the new measurement.

On the other hand, the **Universal Table** schema provides flexibility of adding new metrics without altering the tables. This can be done by adding a new metric record to the referenced metric table (dictionary) and using its id when inserting data into the trade data table. The **Universal Table** schema provides the level of flexibility comparable to schema-on-read architectures often implemented in non-relational databases such Axibase Time Series Database.

## Schemas

### DESCRIBE for **Trade Table** Schema

-- print schema

### DESCRIBE for **Universal Table** Schema

-- print schema

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
| Trade Table | Disabled | 123,342,434 | 123,342,434 | 123,342,434 | 17.20 |
| Trade Table | Enabled | 123,342,434 | 123,342,434 | 123,342,434 | 18.40 |
| Universal Table | Disabled | 123,342,434 | 123,342,434 | 123,342,434 | 18.40 |
| Universal Table | Enabled | 123,342,434 | 123,342,434 | 123,342,434 | 18.40 |

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
2045926 IBM_adjusted.txt
```

## Download SQL Scripts

```sh
curl -o /tmp/storage-testmysql-trade-table.sql \
 "https://raw.githubusercontent.com/axibase/atsd/administration/compaction/mysql-trade-table.sql"
 ```
 
```sh
curl -o /tmp/storage-test/mysql-universal-table.sql \
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
docker exec mysql-axibase-storage-test bash -c "mysql --user=axibase --password=axibase --database=axibase < /data/mysql-trade-table.sql"
```

View test results.

```sh
docker logs -f mysql-axibase-storage-test ?????
```

```
data index total
123 456 789
```

Also display row count in the target data table.

### Execute SQL scripts for the **Universal Table** Schema.

```sh
docker exec mysql-axibase-storage-test bash -c "mysql --user=axibase --password=axibase --database=axibase < /data/mysql-universal-table.sql"
```

View test results.

```sh
docker logs -f mysql-axibase-storage-test ?????
```

```
data index total
123 456 789
```

Also display row count in the target data table.
