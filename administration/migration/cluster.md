
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

Log in to the ATSD web interface and open the **SQL** tab. Execute the following query to count rows for one of the key metrics in the ATSD server.

```sql
SELECT COUNT(*) FROM mymetric
```

The number of records should match the results after the migration.

## Prepare ATSD For Upgrade

Stop ATSD.

```sh
/opt/atsd/atsd/bin/stop-atsd.sh
```

Execute the `jps` command. Verify that the `Server` process is **not present** in the `jps` output.

> If the `Server` process continues running, follow the [safe ATSD shutdown](../restarting.md#stop-atsd) procedure.

Remove deprecated settings.

```
sed -i '/^hbase.regionserver.lease.period/d' /opt/atsd/atsd/conf/hadoop.properties
```

## Prepare `atsd_d` Table Survey

Follow [this](data_table_survey.md) instruction in order to prepare and report `atsd_d` table survey. This survey is used to make correct memory settings for migration map-reduce job.

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