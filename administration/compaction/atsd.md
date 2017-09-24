# ATSD Compression Test

## Overview

The following test calculates the amount of disk space required to store 10+ million `time:value` samples in Axibase Time Series Database, version 17380. 

## Results

| **Schema** | **Compressed** | **Total Size** | **Sample Count** | **Bytes per Sample** |
|---|---|---:|---:|---:|
| Universal Table | Yes | 19,590,510 | 10,227,570 | 1.9 |

## Dataset

The dataset represents 20+ years of historical minute stock trade data available from the [Kibot](http://www.kibot.com/buy.aspx) company.

The minutely trade statistics are available for IBM stock traded on the New York Stock Exchange. The recording starts on February 1st, 1998 and lasts until the last trading day. 

The data is provided in the commonly used OHLCV [format](http://www.kibot.com/support.aspx#data_format).

```csv
Date,Time,Open,High,Low,Close,Volume
01/02/1998,09:30,104.5,104.5,104.5,104.5,67000
...
09/08/2017,17:38,142.45,142.45,142.45,142.45,3556
```

The records be downloaded from the following url: [http://api.kibot.com/?action=history&symbol=IBM&interval=1&unadjusted=0&bp=1&user=guest](http://api.kibot.com/?action=history&symbol=IBM&interval=1&unadjusted=0&bp=1&user=guest).

The file contains over 2 million lines. The OHLC metrics contain values with up to four decimal places. The volume metric is an integer. The dates are recorded in the `US/Eastern` timezone.

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

## Schema

The database automatically manages schema for the inserted data.

## Compression Algorithms

The storage efficiency in ATSD is a product of standard compressions algorithms such as GZIP or LZO and built-in codec. For the purpose of this test, the standard algorithm is set to GZIP (default value) and the ATSD codec is enabled.

## Executing Tests

### Download Input Data

Download the dataset.

```sh
curl -o IBM_adjusted.txt \
  "http://api.kibot.com/?action=history&symbol=IBM&interval=1&unadjusted=0&bp=1&user=guest"
```

Verify the row count:

```sh
wc -l IBM_adjusted.txt
```

```
2045514 IBM_adjusted.txt
```

### Launch ATSD Container

Start container with a pre-configured administrator account and port 8443 open for access.

```properties
docker run -d --name=atsd_test -p 8443:8443 \
    -e ADMIN_USER_NAME=axibase -e ADMIN_USER_PASSWORD=axibase axibase/atsd:latest
```

Watch the startup log until the the list of open ports is displayed.

```sh
docker logs -f atsd_test
```

```
[ATSD] Waiting for ATSD to accept requests on port 8088 ... ( 5 / 60 )
[ATSD] ATSD user interface:
[ATSD] http://127.0.0.1:8088
[ATSD] https://127.0.0.1:8443
[ATSD] http://172.17.0.2:8088
[ATSD] https://172.17.0.2:8443
[ATSD] ATSD start completed. Time: 2017-09-20 22-11-07.
[ATSD] Administrator account 'axibase' created.
```

### Download Test Files

Download CSV parser.

```sh
curl -o stock-parser.xml \
 "https://raw.githubusercontent.com/axibase/atsd/master/administration/compaction/stock-parser.xml
```

Download the test script.

```sh
curl -o atsd-test.sh \
 "https://raw.githubusercontent.com/axibase/atsd/master/administration/compaction/atsd-test.sh
```

```sh
chmod +x atsd-test.sh
```

### Start Test

Execute the test script by specifying the ATSD container name. 

> If the public port in the `docker run` command above is not 8443, change the `ATSD_PORT` variable in the script header.

```sh
./atsd-test.sh atsd_test
```

### Results

```
Connecting to https://localhost:8443 as 'axibase'. Container: atsd_test

============

CSV parser imported

============

Uploading data file IBM_adjusted.txt

{"startTime":1505942746237,"endTime":1505942989383,"processed":2045514,"source":"172.17.0.1","parser":"stock-parser","errorMessage":null,"taskStatus":"COMPLETED","type":"upload","fileName":"csv-upload-5523224067655787056.csv","fileCount":1,"fileSize":100890306}

Data file uploaded IBM_adjusted.txt

============

Initiating data compaction
Compaction task in progress...
Compaction task in progress...
Compaction task in progress...
Compaction task in progress...
Compaction task in progress...
Compaction task in progress...
Compaction task in progress...
Compaction task in progress...
Compaction task in progress...
Compaction task complete.

============

Data size on disk, in bytes: 19590510

============

Line count in the input file: 2045514
'time:value' samples in the file: 10227570

============

Row count in the database: 2045514
'time:value' samples in the database: 10227570

============

Disk used, bytes per sample: 1.91546085727108198721
Disk used, bytes per row:    9.57730428635540993608
```
