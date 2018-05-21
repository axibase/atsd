# PostgreSQL Compression Test

## Overview

The following tests calculate the amount of disk space required to store 10+ million `time:value` samples in a PostgreSQL database, version 9.6.

## Results

| **Schema** |  **Data Size** | **Index Size** | **Total Size** | **Row Count** | **Bytes per Row** | **Bytes per Sample** |
|---|---:|---:|---:|---:|---:|---:|
| Trade Table | 156,082,176 | 64,544,768 | 220,626,944 | 2,045,514 | 107.9 | 21.6 |
| Universal Table | 533,659,648 | 322,625,536 | 856,285,184 | 10,227,570 | 83.7 | 83.7 |

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

The file contains over 2 million lines. The OHLC metrics contain values with up to four decimal places. The volume metric is an integer. The dates are recorded in the `US/Eastern` time zone.

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

* **Trade Table** [schema](postgres-trade-table.sql) uses a named column for each input metric.
* **Universal Table** [schema](postgres-universal-table.sql) uses a single metric ID column for all input metrics.

The **Trade Table** schema requires less disk space however the underlying table can not be extended to store different sets of columns for different instrument types. As such, multiple tables need to be created to store data for various instrument types.

The **Universal Table** schema allows adding new metrics without altering the tables. This can be done by inserting a new record into the `Metrics` table (a dictionary) and using foreign keys when inserting data into the data table.

### **Trade Table** Schema

* trade_history Table

```sql
\d trade_history
+------------+--------------------------------+-----------+
|   Column   |              Type              | Modifiers |
+------------+--------------------------------+-----------+
| instrument | integer                        | not null  |
| open       | numeric(7,4)                   |           |
| high       | numeric(7,4)                   |           |
| low        | numeric(7,4)                   |           |
| close      | numeric(7,4)                   |           |
| volume     | integer                        |           |
| time       | timestamp(0) without time zone | not null  |
+------------+--------------------------------+-----------+

SELECT * FROM trade_history LIMIT 5;
+------------+----------+----------+----------+----------+--------+---------------------+
| instrument |   open   |   high   |   low    |  close   | volume |        time         |
+------------+----------+----------+----------+----------+--------+---------------------+
|          1 | 104.5000 | 104.5000 | 104.5000 | 104.5000 |  67000 | 1998-01-02 09:30:00 |
|          1 | 104.3800 | 104.5000 | 104.3800 | 104.3800 |  10800 | 1998-01-02 09:31:00 |
|          1 | 104.4400 | 104.5000 | 104.3800 | 104.5000 |  13300 | 1998-01-02 09:32:00 |
|          1 | 104.4400 | 104.5000 | 104.3800 | 104.3800 |  16800 | 1998-01-02 09:33:00 |
|          1 | 104.3800 | 104.5000 | 104.3800 | 104.3800 |   4801 | 1998-01-02 09:34:00 |
+------------+----------+----------+----------+----------+--------+---------------------+
```

* instruments Table

```sql
\d instruments
+--------+-----------------------+----------------------------------------------------------+
| Column |         Type          |                        Modifiers                         |
+--------+-----------------------+----------------------------------------------------------+
| id     | integer               | not null default nextval('instruments_id_seq'::regclass) |
| name   | character varying(20) |                                                          |
+--------+-----------------------+----------------------------------------------------------+

SELECT * FROM instruments;
+----+------+
| id | name |
+----+------+
|  1 | IBM  |
+----+------+
```

### **Universal Table** Schema

* universal_history Table

```sql
\d universal_history
+------------+--------------------------------+-----------+
|   Column   |              Type              | Modifiers |
+------------+--------------------------------+-----------+
| instrument | integer                        | not null  |
| metric     | integer                        | not null  |
| time       | timestamp(0) without time zone | not null  |
| value      | numeric(12,4)                  |           |
+------------+--------------------------------+-----------+

SELECT * FROM universal_history LIMIT 5;
+------------+--------+---------------------+----------+
| instrument | metric |        time         |  value   |
+------------+--------+---------------------+----------+
|          1 |      1 | 1998-01-02 09:30:00 | 104.5000 |
|          1 |      1 | 1998-01-02 09:31:00 | 104.3800 |
|          1 |      1 | 1998-01-02 09:32:00 | 104.4400 |
|          1 |      1 | 1998-01-02 09:33:00 | 104.4400 |
|          1 |      1 | 1998-01-02 09:34:00 | 104.3800 |
+------------+--------+---------------------+----------+
```

* instruments Table

```sql
\d instruments
+--------+-----------------------+----------------------------------------------------------+
| Column |         Type          |                        Modifiers                         |
+--------+-----------------------+----------------------------------------------------------+
| id     | integer               | not null default nextval('instruments_id_seq'::regclass) |
| name   | character varying(20) |                                                          |
+--------+-----------------------+----------------------------------------------------------+

SELECT * FROM instruments;
+----+------+
| id | name |
+----+------+
|  1 | IBM  |
+----+------+
```

* metrics Table

```sql
\d metrics
+--------+-----------------------+------------------------------------------------------+
| Column |         Type          |                      Modifiers                       |
+--------+-----------------------+------------------------------------------------------+
| id     | integer               | not null default nextval('metrics_id_seq'::regclass) |
| name   | character varying(20) |                                                      |
+--------+-----------------------+------------------------------------------------------+

SELECT * FROM metrics;
+----+--------+
| id |  name  |
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
2045926 IBM_adjusted.txt
```

### Launch PostgreSQL Database Container

Start a PostgreSQL 9.6 container. Mount `/tmp/test` directory to the container.

```bash
docker run --name postgres \
   -e POSTGRES_USER=axibase \
   -e POSTGRES_PASSWORD=axibase \
   -v /tmp/test:/data  \
   -d  postgres:9.6
```

### Execute SQL scripts for the **Trade Table** Schema

```sh
curl -o /tmp/test/postgres-trade-table.sql \
 "https://raw.githubusercontent.com/axibase/atsd/master/administration/compaction/postgres-trade-table.sql"
```

```sh
docker exec -i postgres \
    sh -c "dropdb -U axibase --if-exists axibase && createdb -U axibase axibase" && \
    cat /tmp/test/postgres-trade-table.sql | \
    docker exec -i postgres psql -U axibase -q -P "footer=off" -P "border=2"
```

```sh
+---------------+------------------+-----------------+------------------------+
|  table_name   | pg_relation_size | pg_indexes_size | pg_total_relation_size |
+---------------+------------------+-----------------+------------------------+
| trade_history |        156082176 |        64544768 |              220626944 |
+---------------+------------------+-----------------+------------------------+

+-----------+---------------------+---------------------+
| row_count |      min_time       |      max_time       |
+-----------+---------------------+---------------------+
|   2045514 | 1998-01-02 09:30:00 | 2017-09-08 17:38:00 |
+-----------+---------------------+---------------------+
```

### Execute SQL scripts for the **Universal Table** Schema

```sh
curl -o /tmp/test/postgres-universal-table.sql \
 "https://raw.githubusercontent.com/axibase/atsd/master/administration/compaction/postgres-universal-table.sql"
```

```sh
docker exec -i postgres \
    sh -c "dropdb -U axibase --if-exists axibase && createdb -U axibase axibase" && \
    cat /tmp/test/postgres-universal-table.sql | \
    docker exec -i postgres psql -U axibase -q -P "footer=off" -P "border=2"
```

```sh
+-------------------+------------------+-----------------+------------------------+
|    table_name     | pg_relation_size | pg_indexes_size | pg_total_relation_size |
+-------------------+------------------+-----------------+------------------------+
| universal_history |        533659648 |       322625536 |              856285184 |
+-------------------+------------------+-----------------+------------------------+

+-----------+---------------------+---------------------+
| row_count |      min_time       |      max_time       |
+-----------+---------------------+---------------------+
|  10227570 | 1998-01-02 09:30:00 | 2017-09-08 17:38:00 |
+-----------+---------------------+---------------------+
```
