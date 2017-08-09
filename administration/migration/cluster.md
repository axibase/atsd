
# ATSD Cluster Migration

These instructions describe how to migrate an Axibase Time Series Database instance running on **HBase-1.0.0-cdh5.5.2** to a version running on the **HBase-1.2.5**.

The instructions apply to ATSD connected to an HBase cluster. For host-base installations, refer to the following [migration guide](README.md).

## Versioning

| **Code** | **ATSD Revision Number** | **Java Version** | **HBase Version** | **HDFS Version** |
|---|---|---|---|---|
| Old | 16854 and earlier | 1.7 | 1.0.0-cdh5.5.2 | 2.6.0-cdh5.5.2 |
| New | 16855 and later | 1.8 | 1.2.5 | 2.6.4 |


## Requirements

### Disk Space

It is suggested to make backup of all ATSD data before migration. Migration procedure also needs more disk size before old data can be deleted. This additional size can be up to 30% of disk size used to store old data.

## Check Record Count for Testing

Log in to the ATSD web interface.

Open the **SQL** tab.

Execute the following query to count rows for one of the key metrics in the ATSD server.

```sql
SELECT COUNT(*) FROM mymetric
```

The number of records should match the results after the migration.

## Prepare ATSD For Upgrade

Stop ATSD.

```sh
/opt/atsd/bin/atsd-tsd.sh stop
```

Execute the `jps` command. Verify that the `Server` process is **not present** in the `jps` output.

> If the `Server` process continues running, follow the [safe ATSD shutdown](../restarting.md#stop-atsd) procedure.

Remove deprecated settings.

```
sed -i '/^hbase.regionserver.lease.period/d' /opt/atsd/atsd/conf/hadoop.properties
```

## Inspect the `atsd_d` table

The migration is a map-reduce job which transforms data in the `atsd_d` table. During migration all data for the same metric, entity and date should be collected in memory and processed. This amount of data can be large especially if there are a lot of series with the same metric and entity, and different tags. The memory allocated to mappers during migration should be enough to retain that amount of data. 

DataTableReporter class estimates physical memory required to store processed data during migration. 
It estimates size of java objects created by a mapper for each combination (metric, entity, date), and reports maximal size for each region of 'atsd_d' table. This estimations are quite less than actual needs of mappers in physical memory, but they can be used to choose right memory settings.

The DataTableReporter is implemented as map-reduce job, so the Yarn services should be started.
Start Yarn and HistoryServer, and check that `yarn.log-aggregation-enable` property is set to `true` in the `yarn-site.xml` file.

Download jar file with the DataTableReporter class.

```sh
curl https://axibase.com/public/atsd-125-migration/reporter.jar
```

Set required classes in `HADOOP_CLASSPATH`.

```sh
export HADOOP_CLASSPATH=$(hbase classpath):reporter.jar
```

Initiate Kerberos session if Kerberos is used.

```sh
kinit -k -t axibase.keytab axibase
```

As reporter job can take a while you can run it with nohup command, and save output in a file.
```sh
nohup yarn com.axibase.reporter.mapreduce.DataTableReporter &> data_table_reporter.log &
```

View reporter's log file to monitor job progress. When job will be comleted the log will contain information about job counters, and files where job results are stored:

```sh
less data_table_reporter.log
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

Also you see information about estimated maximum physical memory required by the migration mapper to store it's objects. In the above listing:

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

The last two lines of the log file point to two files `summary`, and `maximum-per-region` where the DataTableReporter class stores result.
Copy these files to local file system, use appropriate paths to files :

```sh
hdfs dfs -copyToLocal hdfs://nurswgvml303.axibase.com:8020/user/axibase/data_table_report/000009/summary /home/axibase/
hdfs dfs -copyToLocal hdfs://nurswgvml303.axibase.com:8020/user/axibase/data_table_report/000009/maximum-per-region /home/axibase/
```

Send `maximum-per-region`, `summary`, and `data_table_reporter.log` files to axibase support
`support-atsd@axibase.com` in order to let support team help you choose correct memory settings for migration map-reduce task.

## Check HBase Status

Check HBase for consistency.

```sh
/opt/atsd/hbase/bin/hbase hbck
```

The expected message is:

```
0 inconsistencies detected.
Status: OK
```

> Follow [recovery](../corrupted-file-recovery.md#repair-hbase) procedures if inconsistencies are reported.

Stop HBase.

```sh
/opt/atsd/bin/atsd-hbase.sh stop
```

## Check HDFS Status

Check HDFS for consistency.

```sh
/opt/atsd/hadoop/bin/hadoop fsck /hbase/
```

The expected message is:

  ```
  The filesystem under path '/hbase/' is HEALTHY.
  ```

> If corrupted files are reported, follow the [recovery](../corrupted-file-recovery.md#repair-hbase) procedure.

Stop HDFS.

```sh
/opt/atsd/bin/atsd-dfs.sh stop
```

## Backup

Make full backup of all ATSD data.

## Install Java 8

[Install Java 8](install-java-8.md) on the ATSD server as described.

Switch back to the 'axibase' user.

```sh
su axibase
```

Execute the remaining steps as the 'axibase' user.

## Upgrade Hadoop

Start HDFS.

## Upgrade HBase

Start all HBase services.

## Customize Map-Reduce Settings

## Start Map-Reduce Services

Start Yarn servers:

```sh
/opt/atsd/hadoop/sbin/start-yarn.sh
```

Start Job History server:

```sh
/opt/atsd/hadoop/sbin/mr-jobhistory-daemon.sh --config /opt/atsd/hadoop/etc/hadoop/ start historyserver
```

## Configure Migration Job

Download the `migration.jar` file to the `/opt/atsd` directory.

```sh
curl -o /opt/atsd/migration.jar https://axibase.com/public/atsd-125-migration/migration.jar
```

Check that current Java version is 8.

```sh
java -version
```

Add `migration.jar` and HBase classes to classpath.

```sh
export CLASSPATH=$CLASSPATH:$(/opt/atsd/hbase/bin/hbase classpath):/opt/atsd/migration.jar
```

Set `HADOOP_CLASSPATH` for the Map-Reduce job.

```sh
export HADOOP_CLASSPATH=$(/opt/atsd/hbase/bin/hbase classpath):/opt/atsd/migration.jar
```

## Run Migration Map-Reduce Job

### Create Backup Table

Launch the table backup task and confirm its execution. This command creates backup `atsd_d_backup` of the `atsd_d` table. The program will not copy table's data and just clones table's meta information, so both - original table and backup will use the same data.

```sh
java com.axibase.migration.admin.TableCloner --table_name=atsd_d
```

### Migrate Records from Backup Table

Run migration map-reduce job. The job will create new empty `atsd_d` table with new schema, converts data from `atsd_d_backup` table to new format, and store converted data in the `atsd_d` table.


```sh
nohup yarn com.axibase.migration.mapreduce.DataMigrator -r &> data_migration.log &
```

As the job will be completed the `data_migration.log` file should contain the line: 

```
...
17/08/01 10:44:31 INFO mapreduce.DataMigrator: HFiles loaded, data table migration job completed, elapsedTime: 45 minutes.
...
```

The `DataMigrator` job may take a long time to complete. You can monitor the job progress in the Yarn web interface at http://ATSD_HOSTNAME:8050/. The Yarn interface will be automatically terminated once the `DataMigrator` is finished.

Migration is now complete.

Stop Map-Reduce servers.

```sh
/opt/atsd/hadoop/sbin/mr-jobhistory-daemon.sh --config /opt/atsd/hadoop/etc/hadoop/ stop historyserver
```

```sh
/opt/atsd/hadoop/sbin/stop-yarn.sh
```

## Start the New Version of ATSD

Remove old ATSD application files.

```sh
rm -rf /opt/atsd/atsd/bin/atsd*.jar
```

Download ATSD application files.

```sh
curl -o /opt/atsd/atsd/bin/atsd.16855.jar https://axibase.com/public/atsd-125-migration/atsd.16855.jar
curl -o /opt/atsd/scripts.tar.gz https://axibase.com/public/atsd-125-migration/scripts.tar.gz
```

Replace old script files.

```sh
tar -xf /opt/atsd/scripts.tar.gz -C /opt/atsd/
```

Set `JAVA_HOME` in `/opt/atsd/atsd/bin/start-atsd.sh` file:

```sh
jp=`dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"`; sed -i "s,^export JAVA_HOME=.*,export JAVA_HOME=$jp,g" /opt/atsd/atsd/atsd/bin/start-atsd.sh
```

Start ATSD.

```sh
/opt/atsd/bin/atsd-tsd.sh start
```

## Check Migration Results

Log in to the ATSD web interface.

Open the **SQL** tab.

Execute the query and compare the row count.

```sql
SELECT COUNT(*) FROM mymetric
```

The number of records should match the results prior to migration.

## Delete Backups

1. Delete the `atsd_d_backup` table using the HBase shell.

```sh
  /opt/atsd/hbase/bin/hbase shell
  hbase(main):001:0> disable 'atsd_d_backup'
  hbase(main):002:0> drop 'atsd_d_backup'
  hbase(main):003:0> exit
```

2. Remove archives.

```sh
rm /opt/atsd/hadoop.tar.gz
rm /opt/atsd/hbase.tar.gz
rm /opt/atsd/scripts.tar.gz
```