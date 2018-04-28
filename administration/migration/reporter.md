# Data Reporter

## Overview

The DataTableReporter is a Map-Reduce job that identifies the largest daily rows in the 'atsd_d' table in order to estimate the RAM required for the migration Map-Reduce job. The number of records can be particularly high in series with many tag combinations under the same metric and entity (high-cardinality series).

The reporter scans the 'atsd_d' table and estimates the physical memory required to process the data during the migration.

The reporter makes no changes to the data.

## Running Reporter

Execute the below steps on the server running YARN Resource Manager on the target cluster.

### Check Services

* Login into Cloudera Manager.

* Open **Hosts > All Hosts**, expand the **Roles**.

  * Verify that ResourceManager, NodeManager, and HistoryServer services are running on the cluster.

* Open **Clusters > Cluster > YARN (MR2 Included) > Configuration**.

  * Search for the 'yarn.log-aggregation-enable' property and verify that it is checked.

![](./images/cloudera-log-aggregation-settings.jpeg)

### Prepare Map-Reduce Job

Login to the server where YARN ResourceManager is running.

Set the `HADOOP_CLASSPATH` setting to include Java libraries and HBase connection settings.

Locate the path to the HBase configuration directory:

```sh
hbase classpath | cut -f 1 -d ":"
```

```sh
# CDH 5.5 Package installation.
/usr/lib/hbase/conf

# CDH 5.10 Parcels installation.
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/bin/../conf
```

Copy  the HBase configuration directory and set `HADOOP_CLASSPATH`:

```sh
export HADOOP_CLASSPATH=/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/bin/../conf:$(hbase mapredcp):/tmp/reporter/reporter.jar
```

Check that the HBase configuration directory and HBase classes are present in the output.

```sh
echo $HADOOP_CLASSPATH
```

```txt
/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/bin/../conf:/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/jars/protobuf-java-2.5.0.jar:/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/jars/hbase-hadoop-compat-1.2.0-cdh5.10.0.jar:/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/jars/hbase-prefix-tree-1.2.0-cdh5.10.0.jar:/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/jars/guava-12.0.1.jar:/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/jars/netty-all-4.0.23.Final.jar:/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/jars/htrace-core-3.2.0-incubating.jar:/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/jars/hbase-common-1.2.0-cdh5.10.0.jar:/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/jars/hbase-client-1.2.0-cdh5.10.0.jar:/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/jars/hbase-protocol-1.2.0-cdh5.10.0.jar:/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/jars/zookeeper-3.4.5-cdh5.10.0.jar:/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/jars/metrics-core-2.2.0.jar:/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/jars/hbase-server-1.2.0-cdh5.10.0.jar:/tmp/reporter/reporter.jar
```

Create a temporary directory and download the DataTableReporter jar file.

```sh
mkdir /tmp/reporter
curl -o /tmp/reporter/reporter.jar https://axibase.com/public/atsd-125-migration/reporter_5.10_v2.jar
```

### Initiate Kerberos Session

Copy the `/opt/atsd/atsd/conf/axibase.keytab` file [generated](../../installation/cloudera.md#generate-keytab-file-for-axibase-principal) for the `axibase` principal from the ATSD server to the `/tmp/reporter/` directory on the YARN ResourceManager server.

Initiate a Kerberos session.

```sh
kinit -k -t /tmp/reporter/axibase.keytab axibase
```

## Run Map-Reduce Job

The reporter can take some time to complete. Launch it with the `nohup` command and save the output to a file to serve as a log.

```sh
nohup yarn com.axibase.reporter.mapreduce.DataTableReporter &> /tmp/reporter/reporter.log &
```

View the log file in order to monitor the job progress. 

```sh
tail -F /tmp/reporter/reporter.log
```

When the job is completed, the log will display a summary:

```sh
...
17/08/09 12:15:55 INFO mapreduce.Job: Job job_1502265066318_0006 completed successfully
17/08/09 12:15:55 INFO mapreduce.Job: Counters: 55
...
	Map-Reduce Framework
		Map input records=4534313
...
	com.axibase.reporter.mapreduce.DataTableReporter$JobStatics
		ANNOTATIONS_COUNT=56
		ROWS_AFTER_MIGRATION=1435293
		ROWS_READ=4534313
		SAMPLES_COUNT=196354701
		VERSIONED_VALUES_COUNT=0
		VERSIONS_COUNT=0
	File Input Format Counters
		Bytes Read=0
	File Output Format Counters
		Bytes Written=183403
17/08/09 12:15:55 INFO mapreduce.DataTableReporter: Map-reduce job success!
17/08/09 12:15:55 INFO mapreduce.DataTableReporter: Start processing results of the map-reduce jab.
...
17/08/09 12:15:55 INFO reporter.ResultHandler: ---------------------------------
maximum in region: 427ae8f2fc8926a7fefe3c984f6027cf
size in MB: 25
metric ID: 121
metric name: high-cardinality-for-scan-metric
entity ID: 4
entity name: high-cardinality-for-scan-entity
timestamp in seconds: 1479427200
date: 2016-11-18
rows read: 5784
max row size in KB: 84
series count (tags combinations): 5761
samples count: 11520
annotations count: 0
versioned values count: 0
versions count: 0
start key: \x00\x00y\x00\x00\x04X.D\x80...
stop key: \x00\x00y\x00\x00\x04X/\x96\x00...
...
17/08/09 12:15:57 INFO client.ConnectionManager$HConnectionImplementation: Closing zookeeper sessionid=0x15dc5f8cb520260
17/08/09 12:15:57 INFO zookeeper.ClientCnxn: EventThread shut down
17/08/09 12:15:57 INFO zookeeper.ZooKeeper: Session: 0x15dc5f8cb520260 closed
17/08/09 12:15:57 INFO mapreduce.DataTableReporter: Results are written to files:
17/08/09 12:15:57 INFO mapreduce.DataTableReporter: hdfs://nurswgvml303.axibase.com:8020/user/axibase/data_table_report/000009/summary.log
17/08/09 12:15:57 INFO mapreduce.DataTableReporter: hdfs://nurswgvml303.axibase.com:8020/user/axibase/data_table_report/000009/maximum-per-region.log
```

## Collect Results

The last two lines of the log identify two files: `summary.log`, and `maximum-per-region.log` where the DataTableReporter class has stored its reports.

Copy these files from HDFS to the local file system.

```sh
hdfs dfs -copyToLocal hdfs://nurswgvml303.axibase.com:8020/user/axibase/data_table_report/000009/summary.log /tmp/reporter/
hdfs dfs -copyToLocal hdfs://nurswgvml303.axibase.com:8020/user/axibase/data_table_report/000009/maximum-per-region.log /tmp/reporter/
```

Email the `reporter.log`, `summary.log`, and `maximum-per-region.log` files to `support-atsd@axibase.com` for review and calculation of resources required for the subsequent migration.

### Report Result Files

The report contains the following summary counters:

* `ANNOTATIONS_COUNT` - The number of annotations (text columns) stored in the `atsd_d` table.
* `ROWS_AFTER_MIGRATION` - The estimated number of daily rows in the `atsd_d` table to be created after migration. 
* `ROWS_READ` - The number of hourly rows currently present in the `atsd_d` table. Equal to `Map input records` counter.
* `SAMPLES_COUNT` - The total number of `timestamp=value` samples for all series in the `atsd_d` table.
* `VERSIONED_VALUES_COUNT` - The total number of samples which have several versions of values for the same timestamp.
* `VERSIONS_COUNT` - The total number of all versions for all series samples.

The report includes memory required by the mapper. This maximum is reported for each region in the `atsd_d` table, for example:

* Region hashed name is `427ae8f2fc8926a7fefe3c984f6027cf`.
* Mapper needs `25` MB of heap memory to store objects while processing data from the region.
* The metric identifier is `121`.
* The metric name is `high-cardinality-for-scan-metric`.
* The entity identifier is `4`.
* The entity name is `high-cardinality-for-scan-entity`.
* Timestamp in seconds for the date is `1479427200`.
* The day is `2016-11-18`.
* Number of rows in current `atsd_d` table with given combination of the metric, entity, and date equals to `5784`.
* Maximum estimated size of a row among these 5784 rows is `84` KB.
* There are `5761` different series for the given combination of metric, entity, and day. These series differ by tags, so there are `5761` different combinations of tags.
* Total number of time series samples for the given metric, entity , and day are `11520`.
* There are no annotations and non-versioned samples.
* The `atsd_d` table stores data for the displayed metric, the entity, and the day in rows from the specified `start key` (inclusive) to `stop key` (exclusive).

