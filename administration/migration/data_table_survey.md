# Prepare `atsd_d` Table Survey

## The Survey Purpose 
The migration is a map-reduce job which transforms data in the `atsd_d` table. During migration all data for the same metric, entity and date should be collected in memory and processed. This amount of data can be large especially if there are a lot of series with the same metric and entity, and different tags. The memory allocated to mappers during migration should be enough to retain that amount of data. 

DataTableReporter class estimates physical memory required to store processed data during migration. 
It estimates size of java objects created by a mapper for each combination (metric, entity, date), and reports maximal size for each region of 'atsd_d' table. This estimations are quite less than actual needs of mappers in physical memory, but they can be used to choose right memory settings.

## Check That Map-Reduce Services Are Launched

The DataTableReporter is implemented as map-reduce job, so this instruction refers to server where the Yarn ResourceManager is running. Check that ResourceManager, NodeManagers and HistoryServer are launched. 
Also check that `yarn.log-aggregation-enable` property is set to `true` in the `yarn-site.xml` file.

## Prepare to Run Map-Reduce Job
Download jar file with the DataTableReporter class.

```sh
curl -o /opt/atsd/reporter/reporter.jar https://axibase.com/public/atsd-cdh-migration/reporter.jar
```

Set HBase configuration folder `/usr/lib/hbase/conf`, and classes used to support HBase interaction during map-reduce job, and reporter.jar in `HADOOP_CLASSPATH`.

```sh
export HADOOP_CLASSPATH=/usr/lib/hbase/conf:$(hbase mapredcp):/opt/atsd/reporter/reporter.jar
```

Run `echo $HADOOP_CLASSPATH` and check that HBase classes are in output.

Initiate Kerberos session if Kerberos is used. Use the `axibase.keytab` file which you have generated for the `axibase` principal. (View the [keytab generation](../../installation/cloudera.md#generate-keytab-file-for-axibase-principal) section for explanations.)

```sh
kinit -k -t axibase.keytab axibase
```

## Run Map-Reduce Job
As reporter job can take a while you can run it with `nohup` command, and save output in a file.

```sh
nohup yarn com.axibase.reporter.mapreduce.DataTableReporter &> /opt/atsd/reporter/reporter.log &
```

View `reporter.log` to monitor job progress. When job will be comleted the log will contain information about job counters, and files where job results are stored:

```sh
less /opt/atsd/reporter/reporter.log
``` 

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
17/08/09 12:15:57 INFO mapreduce.DataTableReporter: hdfs://nurswgvml303.axibase.com:8020/user/axibase/data_table_report/000009/summary
17/08/09 12:15:57 INFO mapreduce.DataTableReporter: hdfs://nurswgvml303.axibase.com:8020/user/axibase/data_table_report/000009/maximum-per-region
```

Here there are several custom counters:

* ANNOTATIONS_COUNT - the number of annotations (messages) stored in the `atsd_d` table.
* ROWS_AFTER_MIGRATION - the number of rows in the `atsd_d` table with new data layout. 
* ROWS_READ - the number of rows in the current `atsd_d` table, it should be equal to the value of the  `Map input records` counter.
* SAMPLES_COUNT - the total number of all `(timestamp, value)` samples for all series in the `atsd_d` table.
* VERSIONED_VALUES_COUNT - the total number of samples which have several versions of values for the same timestamp.
* VERSIONS_COUNT - the total number of all versions for all series samples.

Also you see estimated maximum physical memory required by the migration mapper to store it's objects. This maximum reported for each region in the `atsd_d` table. In the above listing:

* Region hashed name is `427ae8f2fc8926a7fefe3c984f6027cf`.
* Mapper need `25` MiB of heap memory to store objects while processing data from the region.
  (In fact this estimation is much less then actual memory requirement.)
  And this memory required for some combination of metric, entity, and date.
* The metric identifier is `121`.
* The metric name is `high-cardinality-for-scan-metric`.
* The entity identifier is `4`.
* The entity name is `high-cardinality-for-scan-entity`.
* Timestamp in seconds for the date is `1479427200`.
* The date is `2016-11-18`.
* Number of rows in current `atsd_d` table with given combination of the metric, entity, and date equals to `5784`.
* Maximal estimated size of row among these 5784 rows is `84` KiB.
* There are `5761` different series for given combination of metric, entity, and date. These series differs by tags, so there are `5761` different combinations of tags.
* Total number of time series samples for given metric, entity , and date is `11520`.
* There are no annotations, and no versioned samples.
* The `atsd_d` table stores data for the metric, the entity, and the date in rows from specifed `start key` inclusive to `stop key` exclusive.

## Send Survey to Axibase Support
The last two lines of the log file point to two files `summary`, and `maximum-per-region` where the DataTableReporter class stores result.
Copy these files to local file system, use appropriate paths to files :

```sh
hdfs dfs -copyToLocal hdfs://nurswgvml303.axibase.com:8020/user/axibase/data_table_report/000009/summary /opt/atsd/reporter/
hdfs dfs -copyToLocal hdfs://nurswgvml303.axibase.com:8020/user/axibase/data_table_report/000009/maximum-per-region /opt/atsd/reporter/
```

Send `maximum-per-region`, `summary`, and `reporter.log` files to axibase support
`support-atsd@axibase.com` in order to let support team help you choose correct memory settings for migration map-reduce task.

The reporter folder can be deleted.

```sh
rm -rf /opt/atsd/repoter
```
