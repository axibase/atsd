# ATSD Cluster Migration

These instructions describe how to upgrade an Axibase Time Series Database instance running on the Cloudera cluster. For non-distributed installations, refer to the following [migration guide](README.md).

## Versioning

| **Code** | **ATSD Revision Number** | **Java Version** | **Cloudera Manager Version**| **CDH Version** |
|---|---|---|---|---|
| Old | 16854 and earlier | 1.7 | 5.1 - 5.11| 5.1 - 5.9 |
| New | 16855 and later   | 1.8 | 5.12     | 5.10    |

## Requirements

### Disk Space

The migration procedure requires 30% of the currently used disk space in ATSD tables to store migrated records before old data can be deleted.

Make sure that enough disk space is available in HDFS. To review HDFS usage login into Cloudera Manager and open **Clusters > Cluster > HDFS-2 > Status**.
![](./images/hdfs-status.png)

### Memory

The migration job requires at least 4 GB of RAM available on each data node.

## Check Record Count for Testing

Login into ATSD and open the **SQL** tab.

Execute the following query to count rows for one of the key metrics in the ATSD server.

```sql
SELECT COUNT(*) FROM mymetric
```

The number of records should match the results after the migration.

## Prepare ATSD For Upgrade

Stop ATSD.

```sh
/opt/atsd/atsd/bin/stop-atsd.sh
```

## Install Java 8

[Install Java 8](install-java-8.md) on the ATSD server.

## Backup

Backup ATSD tables in HBase prior to migration by copying `/hbase` directory in HDFS.

## Upgrade Cloudera Cluster

* Upgrade Cloudera Manager to version 5.12.

* Upgrade CDH to version 5.10.

* Start HDFS, HBase, YARN and HistoryServer services.

## Configure Migration Map-Reduce Job

Log in to the server where YARN ResourceManager is running.

Download the `migration.jar` file to the temporary `/tmp/migration/` directory.

```sh
mkdir /tmp/migration 
curl -o /tmp/migration/migration.jar https://axibase.com/public/atsd-125-migration/migration.jar
```

Check that current Java version is 8.

```sh
java -version
```

Add `migration.jar`, HBase configuration files, and HBase classes used by the Map-Reduce job to Java and Hadoop classpaths.

```sh
export CLASSPATH=$CLASSPATH:/usr/lib/hbase/conf:$(hbase mapredcp):/tmp/migration/migration.jar
export HADOOP_CLASSPATH=/usr/lib/hbase/conf:$(hbase mapredcp):/tmp/migration/migration.jar
```

### Initiate Kerberos Session

Copy the `/opt/atsd/atsd/conf/axibase.keytab` file [generated](../../installation/cloudera.md#generate-keytab-file-for-axibase-principal) for the `axibase` principal from the ATSD server to the `/tmp/migration/` directory on the YARN ResourceManager server.

Initiate a Kerberos session.

```sh
kinit -k -t /tmp/migration/axibase.keytab axibase
```

## Run Migration Map-Reduce Job

### Rename `atsd_d` Table

Run `TableCloner` task to rename `atsd_d` table into `atsd_d_backup` table.

```sh
java com.axibase.migration.admin.TableCloner --table_name=atsd_d
```

### Migrate Records

Start the Map-Reduce job.
The job can take some time to complete. 
Launch it with the `nohup` command and save the output to a file to serve as a log.

```sh
nohup yarn com.axibase.migration.mapreduce.DataMigrator -r &> /tmp/migration/migration.log &
```

The job will create an empty `atsd_d` table, convert data from the old `atsd_d_backup` table to the new format, and store converted data in the `atsd_d` table.

The `DataMigrator` job may take a long time to complete. You can monitor the job progress in the ResourseManager web interface in Cloudera Manager. The Yarn interface will stop automatically once the `DataMigrator` job is finished.

Once the job is complete, the `migration.log` file should contain the following line:

```
17/08/01 10:44:31 INFO mapreduce.DataMigrator: HFiles loaded, data table migration job completed, elapsedTime: 45 minutes.
```

## Configure ATSD

Login into ATSD Server.

Switch to the 'axibase' user.

```sh
su axibase
```

Remove deprecated settings.

```sh
sed -i '/^hbase.regionserver.lease.period/d' /opt/atsd/atsd/conf/hadoop.properties
```

Upgrade jar files and startup scripts.

```sh
rm -f /opt/atsd/atsd/bin/*
curl -o /opt/atsd/atsd/bin/atsd.16944.jar https://axibase.com/public/atsd-cdh-migration/atsd.16944.jar
curl -o /opt/atsd/scripts.tar.gz https://axibase.com/public/atsd-cdh-migration/scripts.tar.gz
tar -xf /opt/atsd/scripts.tar.gz -C /opt/atsd/bin
rm /opt/atsd/scripts.tar.gz
rm -f /opt/atsd/hbase/lib/*
curl -o /opt/atsd/hbase/lib/atsd-hbase.16944.jar https://axibase.com/public/atsd-cdh-migration/atsd-hbase.16944.jar
```

Set `JAVA_HOME` in the `start-atsd.sh` file:

```sh
jp=`dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"`; sed -i "s,^export JAVA_HOME=.*,export JAVA_HOME=$jp,g" /opt/atsd/atsd/atsd/bin/start-atsd.sh
```

## Deploy ATSD Coprocessors

### Copy Comprocessors into HBase

Copy `/opt/atsd/hbase/lib/atsd.jar` to the `/usr/lib/hbase/lib/` directory on each HBase Region Server.

### Enable ATSD Coprocessors

Open Cloudera Manager.

Select the **Clusters > Cluster > HBase-2**, and open the **Configuration** tab.

Search for the `hbase.coprocessor.region.classes` setting.

Delete `com.axibase.tsd.hbase.coprocessor.CompactRawDataEndpoint` coprocessor.

Check that following ATSD coprocessors are added to HBase CoprocessorRegion Classes.

* com.axibase.tsd.hbase.coprocessor.DeleteDataEndpoint
* com.axibase.tsd.hbase.coprocessor.MessagesStatsEndpoint

![](./images/atsd-coprocessors.png)

## Start ATSD

Start ATSD.

```sh
/opt/atsd/atsd/bin/start-atsd.sh
```

Review the start log for any errors:

```sh
tail -f /opt/atsd/atsd/logs/atsd.log
```

You should see a **ATSD start completed** message at the end of the `start.log`.

## Check Migration Results

Login into ATSD, open the **SQL** tab.

Execute the query and compare the row count.

```sql
SELECT COUNT(*) FROM mymetric
```

The number of records should match the results prior to migration.

## Delete the `atsd_d_backup` Table

```sh
  /opt/atsd/hbase/bin/hbase shell
  hbase(main):001:0> disable 'atsd_d_backup'
  hbase(main):002:0> drop 'atsd_d_backup'
  hbase(main):003:0> exit
```

## Delete Temporary Migration Folder

```sh
rm -rf /tmp/migration
```
