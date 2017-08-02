
# ATSD Container Migration

These instructions describe how to migrate an Axibase Time Series Database instance running on **HBase-0.94** to a version running on the updated **HBase-1.2.5**.

The instructions apply only to ATSD installation running in standolone mode, such as ATSD container for Docker.

## Versioning

| **Code** | **ATSD Revision Number** | **Java Version** | **HBase Version** |
|---|---|---|---|
| Old | 16854 and earlier | 1.7 | 0.94.29 |
| New | 16855 and later | 1.8 | 1.2.5 |

## Requirements

### Installation Type

* Single-node ATSD installation in standalone mode (without HDFS). For examle, ATSD container for Docker. 
* ATSD revision 16000 and greater. Older ATSD revisions must be upgraded to revision 16000+.

### Security

* Java 8 installation requires root privileges.

### Disk Space

The migration procedure requires up to 30% of the reported `/opt/atsd` size to store migrated records before old data can be deleted. 

Determine the size of the ATSD installation directory.

```sh
du -hs /opt/atsd
24G	/opt/atsd
```

Check that free disk space is available on the file system containing the `/opt/atsd` directory.

```sh
df -h /opt/atsd
Filesystem      Size  Used Avail Use% Mounted on
/dev/md2       1008G  262G  736G  27% /
```

If the [backup](#backup) will be stored on the same file system, add it to the estimated disk space usage.

Calculate disk space requirements.

  | **Data** | **Size** |
  |---|---|
  | Original Data | 24G |
  | Backup | 24G |
  | Migrated Data | 7G (30% of 24G) |
  | Backup + Migrated | 31G |
  | Available | 736G |

> In the example above, 736G is sufficient to store 31G of backup and migrated data on the same file system.

Allocate additional disk space, if necessary.

## Check Record Count for Testing

Log in to the ATSD web interface.

Open the **SQL** tab.

Execute the following query to count rows for one of the key metrics in the ATSD server.

```sql
SELECT COUNT(*) FROM mymetric
```

The number of records should match the results after the migration.

## Prepare ATSD For Upgrade

Switch to 'axibase' user if necessary. Execute the remaining steps as the 'axibase' user.

```sh
su axibase
```

Stop ATSD.

```sh
/opt/atsd/bin/atsd-tsd.sh stop
```
  
Execute the `jps` command. Verify that the `Server` process is **not present** in the `jps` output.

> If the `Server` process continues running, follow the [safe ATSD shutdown](../restarting.md#stop-atsd) procedure.

Edit configuration file `/opt/atsd/atsd/conf/hadoop.properties`.

  - Remove the `hbase.regionserver.lease.period` setting, if present.

  - Add the `hbase.client.scanner.timeout.period` setting, if missing:

    ```properties
    hbase.zookeeper.quorum = localhost
    hbase.rpc.timeout = 120000
    hbase.client.scanner.timeout.period = 120000
    ```

Save the `hadoop.properties` file.  

## Check HBase Status

Check HBase for consistency.

  ```sh
  /opt/atsd/hbase/bin/hbase hbck
  ```

  The expected message is:
  
  ```
  ...
  0 inconsistencies detected.
  Status: OK
  ```

> Repair HBase if inconsistencies are reported.

Stop HBase.

  ```sh
  /opt/atsd/bin/atsd-hbase.sh stop
  ```

Execute the `jps` command and verify that the `HMaster` process is **not present** in the `jps` command output. 

## Backup

Copy the ATSD installation directory to a backup directory:

```sh
cp -R /opt/atsd /home/axibase/atsd-backup
```

## Install Java 8 on the ATSD server.

### Option 1. OpenJDK Installation From Repository

* Ubuntu, Debian

```sh
sudo apt-get install openjdk-8-jdk
```

In case of error `'Unable to locate package openjdk-8-jdk'`, install Java using Option 2.

* Red Hat Enterprise Linux, SLES, Centos, Oracle Linux

```sh
sudo yum install java-1.8.0-openjdk-devel
```

In case of error `'No package java-1.8.0-openjdk-devel available.'`, install Java using Option 2.

### Option 2. Oracle JDK Installation From Archive

Open the [Oracle Java 8 JDK Download](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) page.

Accept the license and copy the link to the latest file with the Java SE Development Kit for Linux x64, for example the `jdk-8u144-linux-x64.tar.gz` file.

Copy the download URL into the `wget` command and download the `tar.gz` file.

```sh
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz
```

Expand the archive into the `/opt/jdk` directory.

```sh
sudo mkdir /opt/jdk
sudo tar -xzf jdk-8u144-linux-x64.tar.gz -C /opt/jdk
```

Remove prior Java versions from alternatives

```sh
sudo update-alternatives --remove-all java
sudo update-alternatives --remove-all javac
```

Add Java 8 to alternatives

```sh
sudo update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_144/bin/java 100
sudo update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_144/bin/javac 100
```

Verify that Java 8 is set as the default executable.

```sh
java -version
javac -version
```

## Upgrade HBase

Delete the old HBase directory

```sh
rm -rf /opt/atsd/hbase
```

Download a pre-configured version of HBase-1.2.5  and unarchive it into ATSD installation directory:

```sh
wget -P /opt/atsd https://axibase.com/public/atsd-125-migration/hbase.tar.gz
tar -xf /opt/atsd/hbase.tar.gz -C /opt/atsd/
```

Update the `JAVA_HOME` to Java 8 in `/opt/atsd/hbase/conf/hbase-env.sh` file.

```sh
# Set valid path to java 8 home
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
```

Check available physical memory on the server.

```sh
cat /proc/meminfo | grep "MemTotal"
MemTotal:        1922136 kB
```

If the memory is greater than 4 gigabytes, increase HBase JVM heap size to 50% of available physical memory on the server in the `hbase-env.sh` file.

```sh
export HBASE_HEAPSIZE=4096
```

Upgrade HBase.

```sh
/opt/atsd/hbase/bin/hbase upgrade -check
```

Expected output:

```
...
INFO  [main] util.HFileV1Detector: Count of HFileV1: 0
INFO  [main] util.HFileV1Detector: Count of corrupted files: 0
INFO  [main] util.HFileV1Detector: Count of Regions with HFileV1: 0
INFO  [main] migration.UpgradeTo96: No HFileV1 found.
```

Start Zookeper and execute upgrade.

```sh
/opt/atsd/hbase/bin/hbase-daemon.sh start zookeeper
```

```sh
/opt/atsd/hbase/bin/hbase upgrade -execute
```

Expected output:

```sh
...
2017-08-01 09:32:44,047 INFO  migration.UpgradeTo96 - Successfully completed Namespace upgrade
2017-08-01 09:32:44,049 INFO  migration.UpgradeTo96 - Starting Znode upgrade
...
2017-08-01 09:32:44,083 INFO  migration.UpgradeTo96 - Successfully completed Znode upgrade
...
```

Stop Zookeeper:

```sh
/opt/atsd/hbase/bin/hbase-daemon.sh stop zookeeper
```

Start HBase.

```sh
/opt/atsd/hbase/bin/start-hbase.sh
```

Verify that the `jps` command output contains `HMaster` process.

Check that ATSD tables are available in HBase using HBase console. 

```sh
/opt/atsd/hbase/bin/hbase shell
```

```sh
hbase(main):001:0> list
  TABLE                  
  atsd_calendar                                           
  atsd_collection                                         
  atsd_config 
  ...
```

Execute a sample scan in HBase.

```sh
hbase(main):001:0> scan 'atsd_d', LIMIT => 1
  ROW                  COLUMN+CELL
  ...
  1 row(s) in 0.0560 seconds
  ...
  hbase(main):002:0> exit
```

Exit the HBase console.

## Configure Migration Job

Download the `migration.jar` file to the `/opt/atsd` directory.

```sh
wget -P /opt/atsd https://axibase.com/public/atsd-125-migration/migration.jar
```

Update the `JAVA_HOME` environment variable to Java 8.

```sh
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
```

Check that current Java version is 8.

```sh
java -version
```

Add `migration.jar` and HBase classes to classpath.

```sh
export CLASSPATH=$CLASSPATH:$(/opt/atsd/hbase/bin/hbase classpath):/opt/atsd/migration.jar
```

## Run Migration 

### Create Backup Tables

Launch the table backup task and confirm its execution.

```sh
java com.axibase.migration.admin.TableCloner -d
```

The task will create backups by appending a `'_backup'` suffix to the following tables:

* 'atsd_d_backup'
* 'atsd_li_backup'
* 'atsd_metric_backup'
* 'atsd_forecast_backup'
* 'atsd_delete_task_backup'

```
...
Table 'atsd_li' successfully deleted.
Snapshot 'atsd_metric_snapshot_1501582066133' of the table 'atsd_metric' created.
Table 'atsd_metric_backup' is cloned from snapshot 'atsd_metric_snapshot_1501582066133'. The original data are available in this table.
Snapshot 'atsd_metric_snapshot_1501582066133' deleted.
Table 'atsd_metric' successfully disabled.
Table 'atsd_metric' successfully deleted.
```

### Migrate Records from Backup Tables

1. Migrate data from the `'atsd_delete_task_backup'` table by launching the task and confirming its execution.

```sh
java com.axibase.migration.mapreduce.DeleteTaskMigration
```

```
...
17/08/01 10:14:27 INFO mapreduce.Job: Job job_1501581371115_0001 completed successfully
17/08/01 10:14:27 INFO mapreduce.Job: Counters: 62
	File System Counters
		FILE: Number of bytes read=6
...
```

2. Migrate data from the 'atsd_forecast' table.

```sh
java com.axibase.migration.mapreduce.ForecastMigration
```

3. Migrate data from the 'atsd_li' table.

```sh
java com.axibase.migration.mapreduce.LastInsertMigration
```

This migration task will write intermediate results into a temporary directory for diagnostics.

```sh
2017-08-02 13:34:59,622 INFO  [main] mapreduce.LastInsertMigration: Files from outputFolder 3293189048669746684 are loaded in table a_li. Start deleting outputFolder.
2017-08-02 13:34:59,623 WARN  [main] mapreduce.LastInsertMigration: Deleting outputFolder file:/home/axibase/copytable/3293189048669746684 failed!
2017-08-02 13:34:59,623 WARN  [main] mapreduce.LastInsertMigration: Data from outputFolder file:/home/axibase/copytable/3293189048669746684 not needed any more, and you can delete this outputFolder via hdfs cli.
2017-08-02 13:34:59,623 INFO  [main] mapreduce.LastInsertMigration: Last Insert table migration job took 10 seconds.
```

Delete the diagnostics folder:

```sh
rm -rf /home/axibase/copytable
```

4. Migrate data to the 'atsd_metric' table.

```sh
java com.axibase.migration.mapreduce.MetricMigration
```

5. Migrate data to the 'atsd_d' table.

```sh
java com.axibase.migration.mapreduce.DataMigrator
```

```
...
2017-08-02 13:38:49,026 INFO  [main] mapreduce.DataMigrator: HFiles loaded, data table migration job completed, elapsedTime: 1 minutes.
...
```

6. Migration is now complete.

## Start the New Version of ATSD

Remove old ATSD application files.

```sh
rm -rf /opt/atsd/atsd/bin/atsd*.jar
```

Download ATSD application files.

```sh
wget -P /opt/atsd/atsd/bin https://axibase.com/public/atsd-125-migration/atsd.16855.jar
wget -P /opt/atsd https://axibase.com/public/atsd-125-migration/scripts.tar.gz
```

Replace old script files.

```sh
tar -xf /opt/atsd/scripts.tar.gz -C /opt/atsd/
```

Set `JAVA_HOME` in `/opt/atsd/atsd/bin/start-atsd.sh` file:

```sh
# set valid path to java 8 home here!
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
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

1. Delete backup tables using the HBase shell.

Execute 'disable' and 'drop' commands for each `_backup` table:

* 'atsd_d_backup'
* 'atsd_li_backup'
* 'atsd_metric_backup'
* 'atsd_forecast_backup'
* 'atsd_delete_task_backup'

```sh
  /opt/atsd/hbase/bin/hbase shell
  hbase(main):001:0> disable 'atsd_forecast_backup'
  hbase(main):002:0> drop 'atsd_forecast_backup'
  ...
```

2. Delete the backup directory.

```sh
rm -rf /home/axibase/atsd-backup
```

3. Remove archives.

```sh
rm /opt/atsd/hadoop.tar.gz
rm /opt/atsd/hbase.tar.gz
rm /opt/atsd/scripts.tar.gz
```
