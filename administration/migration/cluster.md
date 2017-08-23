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

Make sure that enough disk space is available in HDFS. To review HDFS usage login into Cloudera Manager and open 

**Clusters > Cluster > HDFS > Status**.

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

Switch to the 'yarn' user.

```bash
sudo su yarn
```

### Initiate a Kerberos session.

Locate the `yarn.keytab` file.

```bash
find / -name "yarn.keytab" | xargs ls -la
-rw------- 1 yarn        hadoop        448 Jul 29 16:44 /run/cloudera-scm-agent/process/7947-yarn-RESOURCEMANAGER/yarn.keytab
```

Obtain the fully qualified hostname of the YARN ResourceManager server.

```bash
hostname -f
```

Authenticate with Kerberos using the `yarn.keytab` file and YARN ResourceManager full hostname.

```bash
kinit -k -t /run/cloudera-scm-agent/process/7947-yarn-RESOURCEMANAGER/yarn.keytab yarn/{yarn_rm_full_hostname}
```

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
export CLASSPATH=$CLASSPATH:$(hbase classpath):/tmp/migration/migration.jar
export HADOOP_CLASSPATH=/opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/lib/hbase/bin/../conf:$(hbase mapredcp):/tmp/migration/migration.jar
```

Modify Map-Reduce [settings](mr-settings.md) using parameters recommended by Axibase support based on the [Data Reporter](reporter.md) logs.

## Run Migration Map-Reduce Job

Run the job on the YARN ResourseManager server.

### Rename `atsd_d` Table

Run the `TableCloner` task to rename `atsd_d` table into `atsd_d_backup` table.

```sh
java com.axibase.migration.admin.TableCloner --table_name=atsd_d
```

### Migrate Records

Start the Map-Reduce job.
The job can take some time to complete. 
Launch it with the `nohup` command and save the output to a file to serve as a log.

```sh
nohup yarn com.axibase.migration.mapreduce.DataMigrator --forced --source=atsd_d_backup --destination=atsd_d &> /tmp/migration/migration.log &
```

The job will create an empty `atsd_d` table, convert data from the old `atsd_d_backup` table to the new format, and store converted data in the `atsd_d` table.

The `DataMigrator` job may take a long time to complete. 

Monitor the job progress in the ResourseManager web interface available in Cloudera Manager in **Clusters > Cluster > YARN > Web UI > ResourseManager Web UI**.

The Yarn interface will stop automatically once the `DataMigrator` job is finished.

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

Set current HDFS path to coprocessors `/hbase/lib/atsd-hbase.jar` in `/opt/atsd/atsd/conf/server.properties` file.

```bash
echo "coprocessors.jar=hdfs:///hbase/lib/atsd-hbase.jar" >> /opt/atsd/atsd/conf/server.properties
```


Upgrade jar files and startup scripts.

```sh
rm -f /opt/atsd/atsd/bin/*
curl -o /opt/atsd/atsd/bin/atsd.17140.jar https://axibase.com/public/atsd-125-migration/atsd.17140.jar
curl -o /opt/atsd/scripts.tar.gz https://axibase.com/public/atsd-125-migration/scripts.tar.gz
tar -xf /opt/atsd/scripts.tar.gz -C /opt/atsd/  atsd
rm /opt/atsd/scripts.tar.gz
rm -rf /opt/atsd/hbase
rm -rf /opt/atsd/collectors
```

Set `JAVA_HOME` in the `start-atsd.sh` file:

```sh
jp=`dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"`; sed -i "s,^export JAVA_HOME=.*,export JAVA_HOME=$jp,g" /opt/atsd/atsd/bin/start-atsd.sh
```

Set custom `JAVA_OPTS` in the `/opt/atsd/atsd/conf/atsd-env.sh` file:

```bash
JAVA_OPTS="-server -Xmx1024M -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath="$atsd_home"/logs"
```

## Deploy ATSD Coprocessors

### Put Coprocessors into HDFS

Login into NameNode Server.
 
Switch to the 'hbase' user.

```sh
sudo su hbase
```

Put `atsd-hbase.17140.jar` to the HDFS `hbase.dynamic.jars.dir`. 
It is set to `${hbase.rootdir}/lib` by default in HBase.

```
hadoop fs -ls /hbase/lib/       #   check existence
hadoop fs -mkdir /hbase/lib/    #   if not exists
curl -O https://axibase.com/public/atsd-125-migration/atsd-hbase.17140.jar
hadoop fs -put -f atsd-hbase.17140.jar /hbase/lib/atsd-hbase.jar
hadoop fs -ls /hbase/lib
    Found 1 items
    -rw-r--r--   3 hbase hbase     547320 2017-08-23 13:03 /hbase/lib/atsd-hbase.jar
```

### Remove Coprocessor Definitions

ATSD coprocessors that were added to HBase CoprocessorRegion Classes are now loaded automatically and therefore must be removed from 

   1. HBase settings 
   2. Each Region Server  

#### Remove Coprocessor from HBase settings

Open Cloudera Manager.

Select the **Clusters > Cluster > HBase-2**, and open the **Configuration** tab.

Search for the `hbase.coprocessor.region.classes` setting.

Remove all ATSD coprocessors and save settings:

![](./images/atsd-coprocessors.png)

#### Remove Coprocessor from Each Region Server

In order to locate ATSD coprocessors jar file execute on each Region Server:

```bash
sudo find /opt/cloudera/parcels/CDH-5.10.0-1.cdh5.10.0.p0.41/ -name "atsd*.jar"
```

Remove found files and restart HBase.

## Start ATSD

Login into ATSD Server.

Switch to the 'axibase' user.

```sh
su axibase
```

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
/usr/lib/hbase/bin/hbase shell
  hbase(main):001:0> disable 'atsd_d_backup'
  hbase(main):002:0> drop 'atsd_d_backup'
  hbase(main):003:0> exit
```

## Delete Temporary Migration Folder

```sh
rm -rf /tmp/migration
```
