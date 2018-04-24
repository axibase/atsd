
# ATSD Container Migration

These instructions describe how to migrate an Axibase Time Series Database instance running on **HBase-0.94** to a version running on the updated **HBase-1.2.5**.

The instructions apply only to ATSD installed in a Docker container. For host-base installations, refer to the following [migration guide](README.md).

## Versioning

| **Code** | **ATSD Revision Number** | **Java Version** | **HBase Version** | **HDFS Version** |
|---|---|---|---|---|
| Old | 16999 and earlier | 1.7 | 0.94.29 | 1.0.3 |
| New | 17000 and later | 1.8 | 1.2.5 | 2.6.4 |

## Requirements

### Installation Type

* ATSD Docker container installation.
* ATSD revision 16000 and greater. Older ATSD revisions must be upgraded to revision 16000+.

### Security

* Java 8 installation requires root privileges.
* Login into the container as root:

```elm
docker exec -it -u root atsd bash
```

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

## Install Java 8

[Install Oracle JDK 8](install-java-8.md#oracle-jdk) on the ATSD server as described. You need to be logged in as root to upgrade Java.

Exit from the root session and re-login into the container as the 'axibase' user.

```sh
exit
```

```elm
docker exec -it -u axibase atsd bash
```

Execute the remaining steps as the 'axibase' user.

## Prepare ATSD For Upgrade

Change to ATSD installation directory.

```sh
cd /opt/atsd
```

Stop ATSD.

```sh
/opt/atsd/bin/atsd-tsd.sh stop
```

Execute the `jps` command. Verify that the `Server` process is **not present** in the `jps` output.

> If the `Server` process continues running, follow the [safe ATSD shutdown](../restarting.md#stop-atsd) procedure.

Remove deprecated settings.

```sh
sed -i '/^hbase.regionserver.lease.period/d' /opt/atsd/atsd/conf/hadoop.properties
```

## Check HBase Status

Check HBase for consistency.

```sh
/opt/atsd/hbase/bin/hbase hbck
```

The expected message is:

```txt
  0 inconsistencies detected.
  Status: OK
```

> Follow recovery procedures if inconsistencies are reported.

Stop HBase.

```sh
  /opt/atsd/bin/atsd-hbase.sh stop
```

Execute the `jps` command and verify that the `HMaster` process is **not present** in the output.

```txt
jps
1200 DataNode
1308 SecondaryNameNode
5324 Jps
1092 NameNode
```

> If one of the above processes continues running, follow the [safe HBase shutdown](../restarting.md#stop-hbase) procedure.

## Check HDFS Status

Check HDFS for consistency.

```sh
  /opt/atsd/hadoop/bin/hadoop fsck /hbase/
```

The expected message is:

```txt
  The filesystem under path '/hbase/' is HEALTHY.
```

> If corrupted files are reported, follow the recovery procedure.

Stop HDFS.

```sh
  /opt/atsd/bin/atsd-dfs.sh stop
```

Execute the `jps` command and verify that the `NameNode`, `SecondaryNameNode`, and `DataNode` processes are **not  present** in the `jps` command output.

## Backup

Copy the ATSD installation directory to a backup directory:

```sh
cp -R /opt/atsd /home/axibase/atsd-backup
```

## Upgrade Hadoop

Delete the old Hadoop directory

```sh
rm -rf /opt/atsd/hadoop
```

Download a pre-configured Hadoop-2.6.4 archive and unpack it in the ATSD installation directory.

```sh
curl -o /opt/atsd/hadoop.tar.gz https://axibase.com/public/atsd-125-migration/hadoop.tar.gz
tar -xf /opt/atsd/hadoop.tar.gz -C /opt/atsd/
```

Get path to the Java 8 home.

```sh
dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"
...
/usr/lib/jvm/java-8-openjdk-amd64
```

Update the `JAVA_HOME` variable to Java 8 in the `/opt/atsd/hadoop/etc/hadoop/hadoop-env.sh` file.

```sh
jp=`dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"`; sed -i "s,^export JAVA_HOME=.*,export JAVA_HOME=$jp,g" /opt/atsd/hadoop/etc/hadoop/hadoop-env.sh
```

Upgrade Hadoop.

```sh
/opt/atsd/hadoop/sbin/hadoop-daemon.sh start namenode -upgradeOnly
```

Review the log file.

```sh
tail /opt/atsd/hadoop/logs/hadoop-*-namenode-*.log
```

The expected output:

```sh
2017-07-26 16:16:16,974 INFO org.apache.hadoop.util.ExitUtil: Exiting with status 0
2017-07-26 16:16:16,959 INFO org.apache.hadoop.ipc.Server: IPC Server Responder: starting
2017-07-26 16:16:16,962 INFO org.apache.hadoop.ipc.Server: IPC Server listener on 8020: starting
2017-07-26 16:16:16,986 INFO org.apache.hadoop.hdfs.server.blockmanagement.CacheReplicationMonitor: Starting CacheReplicationMonitor with interval 30000 milliseconds
2017-07-26 16:16:16,986 INFO org.apache.hadoop.hdfs.server.blockmanagement.CacheReplicationMonitor: Rescanning after 1511498 milliseconds
2017-07-26 16:16:16,995 INFO org.apache.hadoop.hdfs.server.blockmanagement.CacheReplicationMonitor: Scanned 0 directive(s) and 0 block(s) in 9 millisecond(s).
...
```

Start HDFS.

```sh
/opt/atsd/hadoop/sbin/start-dfs.sh
```

Check that HDFS daemons were successfully started.

```sh
/opt/atsd/hadoop/bin/hdfs dfsadmin -report
```

The command should return information about HDFS usage and available data nodes.

Finalize HDFS upgrade.

```sh
/opt/atsd/hadoop/bin/hdfs dfsadmin -finalizeUpgrade
```

The command should display the following message `Finalize upgrade successful`.

The `jps` command output should report `NameNode`, `SecondaryNameNode`, and `DataNode` processes as running.

## Upgrade HBase

Delete the old HBase directory

```sh
rm -rf /opt/atsd/hbase
```

Download a pre-configured version of HBase-1.2.5  and unarchive it into ATSD installation directory:

```sh
curl -o /opt/atsd/hbase.tar.gz https://axibase.com/public/atsd-125-migration/hbase.tar.gz
tar -xf /opt/atsd/hbase.tar.gz -C /opt/atsd/
```

Update the `JAVA_HOME` to Java 8 in the `/opt/atsd/hbase/conf/hbase-env.sh` file.

```sh
jp=`dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"`; sed -i "s,^export JAVA_HOME=.*,export JAVA_HOME=$jp,g" /opt/atsd/hbase/conf/hbase-env.sh
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

Disable distributed mode in the `/opt/atsd/hbase/conf/hbase-site.xml` file.

```sh
sed -i '/.*hbase.cluster.distributed.*/{n;s/.*/   <value>false<\/value>/}' /opt/atsd/hbase/conf/hbase-site.xml
```

Perform HBase upgrade.

```sh
/opt/atsd/hbase/bin/hbase upgrade -check
```

Review the `hbase.log` file.

```sh
tail /opt/atsd/hbase/logs/hbase.log
```

```
INFO  [main] util.HFileV1Detector: Count of HFileV1: 0
INFO  [main] util.HFileV1Detector: Count of corrupted files: 0
INFO  [main] util.HFileV1Detector: Count of Regions with HFileV1: 0
INFO  [main] migration.UpgradeTo96: No HFileV1 found.
```

Start and stop Zookeeper in upgrade mode.

```sh
/opt/atsd/hbase/bin/hbase-daemon.sh start zookeeper
```

```sh
/opt/atsd/hbase/bin/hbase upgrade -execute
```

Review the `hbase.log` file:

```sh
tail -n 20 /opt/atsd/hbase/logs/hbase.log
```

```txt
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

Check that ATSD tables are available in HBase:

```sh
echo "list" | /opt/atsd/hbase/bin/hbase shell 2>/dev/null | grep -v "\["
```

```txt
...
  TABLE                  
  atsd_calendar                                           
  atsd_collection                                         
  atsd_config
  ...
```

Execute a sample scan in HBase.

```sh
echo "scan 'atsd_d', LIMIT => 1" | /opt/atsd/hbase/bin/hbase shell 2>/dev/null
```

```txt
...
  ROW                  COLUMN+CELL
  ...
  1 row(s) in 0.0560 seconds
```

## Customize Map-Reduce Settings

If the available memory is greater than **8 gigabytes** on the server, customize Map-Reduce [settings](mr-settings.md).

## Start Map-Reduce Services

Start Yarn servers:

```sh
/opt/atsd/hadoop/sbin/start-yarn.sh
```

Ensure that `USER` environment setting is set:

```sh
export USER=axibase
```

Start Job History server:

```sh
/opt/atsd/hadoop/sbin/mr-jobhistory-daemon.sh --config /opt/atsd/hadoop/etc/hadoop/ start historyserver
```

Run the `jps` command to check that the following processes are running:

```txt
9849 ResourceManager  # M/R
25902 NameNode # HDFS
26050 DataNode # HDFS
26262 SecondaryNameNode #HDFS
10381 JobHistoryServer  # M/R
10144 NodeManager # M/R
6940 HMaster # HBase
```

## Configure Migration Job

Download the `migration.jar` file to the `/opt/atsd` directory.

```sh
curl -o /opt/atsd/migration.jar https://axibase.com/public/atsd-125-migration/migration-hbase-1.2.5.jar
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

```txt
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
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.DeleteTaskMigration -m 2
```

```txt
...
17/08/01 10:14:27 INFO mapreduce.Job: Job job_1501581371115_0001 completed successfully
17/08/01 10:14:27 INFO mapreduce.Job: Counters: 62
	File System Counters
		FILE: Number of bytes read=6
...
```

In case of insufficient virtual memory error, adjust Map-Reduce [settings](mr-settings.md) and retry the command with the `-r` flag.

```txt
17/08/01 10:19:50 INFO mapreduce.Job: Task Id : attempt_1501581371115_0003_m_000000_0, Status : FAILED
Container [...2] is running beyond virtual memory limits... Killing container.
```

In case of other errors, review job logs for the application ID displayed above:

```sh
/opt/atsd/hadoop/bin/yarn logs -applicationId application_1501581371115_0001 | less
```

2. Migrate data from the 'atsd_forecast' table.

```sh
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.ForecastMigration -m 2
```

3. Migrate data from the 'atsd_li' table.

```sh
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.LastInsertMigration -m 2
```

This migration task will write intermediate results into a temporary directory for diagnostics.

```sh
INFO mapreduce.LastInsertMigration: Map-reduce job success, files from outputFolder 1609980393918240854 are ready for loading in table atsd_li.
...
INFO mapreduce.LastInsertMigration: Files from outputFolder 1609980393918240854 are loaded in table atsd_li. Start deleting outputFolder.
WARN mapreduce.LastInsertMigration: Deleting outputFolder hdfs://localhost:8020/user/axibase/copytable/1609980393918240854 failed!
WARN mapreduce.LastInsertMigration: Data from outputFolder hdfs://localhost:8020/user/axibase/copytable/1609980393918240854 not needed any more, and you can delete this outputFolder via hdfs cli.
INFO mapreduce.LastInsertMigration: Last Insert table migration job took 37 seconds.
```

Delete the diagnostics folder:

```sh
/opt/atsd/hadoop/bin/hdfs dfs -rm -r /user/axibase/copytable
```

4. Migrate data to the 'atsd_metric' table.

```sh
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.MetricMigration -m 2
```

5. Migrate data to the 'atsd_d' table.

```sh
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.DataMigrator -m 2
```

```txt
...
17/08/01 10:44:31 INFO mapreduce.DataMigrator: HFiles loaded, data table migration job completed, elapsedTime: 15 minutes.
...
```

The `DataMigrator` job may take a long time to complete. You can monitor the job progress in the Yarn web interface at `http://atsd_hostname:8050/`.

The Yarn interface will be automatically terminated once the `DataMigrator` is finished.

6. Migration is now complete.

7. Stop Map-Reduce servers.

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
curl -o /opt/atsd/atsd/bin/atsd.17370.jar https://axibase.com/public/atsd-125-migration/atsd.17370.jar
curl -o /opt/atsd/scripts.tar.gz https://axibase.com/public/atsd-125-migration/scripts.tar.gz
```

Replace old script files.

```sh
tar -xf /opt/atsd/scripts.tar.gz -C /opt/atsd/
```

Set `JAVA_HOME` in `/opt/atsd/atsd/bin/start-atsd.sh` file:

```sh
jp=`dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"`; sed -i "s,^export JAVA_HOME=.*,export JAVA_HOME=$jp,g" /opt/atsd/atsd/bin/start-atsd.sh
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

1. Delete backup tables in HBase.

```sh
/opt/atsd/hbase/bin/hbase shell
```

```sh
disable_all '.*_backup'
```

```sh
drop_all '.*_backup'
```

```sh
exit
```

2. Delete the backup directory.

```sh
rm -rf /home/axibase/atsd-backup
```

3. Remove archives.

```sh
rm /opt/atsd/hadoop.tar.gz
rm /opt/atsd/hbase.tar.gz
rm /opt/atsd/migration.jar
rm /opt/atsd/scripts.tar.gz
```
