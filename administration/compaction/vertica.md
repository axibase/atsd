# Vertica Compression Test

## Overview

The following tests calculate the amount of disk space required to store 10+ million `time:value` samples in a Vertica database, version 7.1.1-0. 

## Results

| **Schema** | **Compressed** | **Data Size** | **Index Size** | **Total Size** | **Row Count** | **Bytes per Row** | **Bytes per Sample** |
|---|---:|---:|---:|---:|---:|---:|---:|
| Trade Table | Yes |  |  |  | 2,045,514 |  |  |
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

* **Trade Table** [schema](vertica-trade-table.sql) uses a named column for each input metric.
* **Universal Table** [schema](vertica-universal-table.sql) uses a single metric ID column for all input metrics.

The **Trade Table** schema requires less disk space however the underlying table can not be extended to store different sets of columns for different instrument types. As such, mutliple tables needs to be created to store data for various instrument types.

The **Universal Table** schema allows adding new metrics without altering the tables. This can be done by inserting a new  record to the `Metrics` table (a dictionary) and using foreign keys when inserting data into the data table.

### **Trade Table** Schema

* TradeHistory Table

```sql
DESCRIBE TradeHistory;


SELECT * FROM TradeHistory LIMIT 5;

```

* Instruments Table

```sql
DESCRIBE Instruments;


SELECT * FROM Instruments;

```

### **Universal Table** Schema

* UniversalHistory Table

```sql
DESCRIBE UniversalHistory;


SELECT * FROM UniversalHistory LIMIT 5;

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
cat vertica-trade-table.sql | \
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

```

```sh

```
