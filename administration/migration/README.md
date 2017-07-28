
# Migrating ATSD to HBase 1.2.5

This instruction describes how to migrate Axibase Time Series Database running on **HBase-0.94** to a version running on **HBase-1.2.5**.

## Versioning

| **Code** | **ATSD Revision Number** | **Java Version** | **HBase Version** | **HDFS Version** |
|---|---|---|---|---|
| Old | 16999 and earlier | 1.7 | 0.94.29 | 1.0.3 |
| New | 17000 and later | 1.8 | 1.2.5 | 2.6.4 |

## Check Disk Space

The migration procedure requires sufficient disk space to store migrated records before old data can be deleted. 

Make sure that sufficient disk space is available.

* Determine the size of the ATSD installation directory.

```sh
du -hs /opt/atsd
24G	/opt/atsd
```

The migration procedure would require up to 30% of the reported `/opt/atsd` size.

* Check that free disk space is available on the file system containing the `/opt/atsd` directory.

```sh
df -h /opt/atsd
Filesystem      Size  Used Avail Use% Mounted on
/dev/md2       1008G  262G  736G  27% /
```

* If the `/opt/atsd` backup, described [below](#backup), will be stored on the same file system, take this into consideration.

| **Data** | **Size** |
|---|---|
| Original Data | 24G |
| Backup | 24G |
| Migrated Data | 7G (30% of 24G) |
| Backup + Migrated | 31G |
| Available | 736G |

In the example above, 736G is sufficient to store the backup and migrated data on the same file system.

## Prepare ATSD For Upgrade

1. Switch user to 'axibase'.

```sh
su axibase
```

2. Stop ATSD.

  ```sh
  /opt/atsd/bin/atsd-tsd.sh stop
  ```
  
3. Execute the `jps` command. Verify that the `Server` process is **not present** in the `jps` output.

If `Server` process continues running, follow the safe [ATSD shutdown](../restarting.md#stop-atsd) procedure.

4. Edit configuration file `/opt/atsd/atsd/conf/hadoop.properties`.

    - Remove `hbase.regionserver.lease.period` setting, is present.

    - Add `hbase.client.scanner.timeout.period` setting if missing:

    ```
    hbase.client.scanner.timeout.period=120000
    ```

5. Save the `hadoop.properties` file.  

## Check HBase Status

1. Check HBase for consistency.

  ```sh
    /opt/atsd/hbase/bin/hbase hbck
  ```

  The expected message is `Status: OK`. 

  Follow [recovery](../corrupted-file-recovery.md#repair-hbase) procedures if inconsistencies are reported.

2. Stop HBase.

  ```sh
  /opt/atsd/bin/atsd-hbase.sh stop
  ```

3. Execute the `jps` command and verify that the `HMaster`, `HRegionServer`, and `HQuorumPeer` processes are **not present** in the `jps` command output. 

Follow the safe [HBase shutdown](../restarting.md#stop-hbase) procedure, if one of the above processes continues running.

## Check HDFS Status

1. Check HDFS for consistency.

  ```sh
  /opt/atsd/hadoop/bin/hadoop fsck /hbase/
  ```

  The expected message is  `The filesystem under path '/hbase/' is HEALTHY`. 
  
  Follow [recovery](../corrupted-file-recovery.md#repair-hbase) if corrupted files are reported.

2. Stop HDFS.

  ```sh
  /opt/atsd/bin/atsd-dfs.sh stop
  ```

3. Execute the `jps` command and verify that the the `NameNode`, `SecondaryNameNode`, and `DataNode` processes are **not  present** in the `jps` command output.

## Backup

Copy the ATSD installation directory to a backup directory:

  ```sh
  cp -R /opt/atsd /home/axibase/atsd-backup
  ```

## Install Java 8 on the ATSD server.

### Option 1. OpenJDK Installation From Repository

* Debian, Ubuntu

```sh
sudo apt-get install openjdk-8-jdk
```

In case of error `'Unable to locate package openjdk-8-jdk'`, install Java using Option 2.

* Centos, Oracle Linux, Red Hat Enterprise Linux, SLES

```sh
sudo yum install java-1.8.0-openjdk-devel
```

In case of error `'No package java-1.8.0-openjdk-devel available.'`, install Java using Option 2.

### Option 2. Oracle JDK Installation From Downloaded Archive

Open [Oracle Java 8 JDK Download](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) page, accept the license and copy the link to the latest Java SE Development Kit for Linux x64, for example `jdk-8u144-linux-x64.tar.gz`.

Copy the link into the wget command and download the `tar.gz` file.

```sh
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz
```

Expand the archive into the `/opt/jdk` directory.

```sh
sudo mkdir /opt/jdk
sudo tar -xzf jdk-8u144-linux-x64.tar.gz -C /opt/jdk
```

2. Remove prior Java versions from alternatives

```sh
sudo update-alternatives --remove-all java
sudo update-alternatives --remove-all javac
```

3. Add Java 8 to alternatives

```sh
sudo update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_144/bin/java 100
sudo update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_144/bin/javac 100
```

4. Verify that Java 8 is set as the default executable.

```sh
java -version
javac -version
```

## Upgrade Hadoop

1. Download a pre-configured Hadoop-2.6.4 and unarchive it into the ATSD installation directory.

```shell
wget https://axibase.com/public/atsd-125-migration/hadoop.tar.gz
tar -xf hadoop.tar.gz -C /opt/atsd/
rm hadoop.tar.gz
```

2. Configure Hadoop to use java 8.

Get path to java home.
```sh
$(dirname $(dirname $(readlink -f $(which javac))))
```

Change `JAVA_HOME` variable in the `/opt/atsd/hadoop/etc/hadoop/hadoop-env.sh` file so it points to Java 8.

```sh
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
```

3. Run Hadoop upgrade.

```sh
/opt/atsd/hadoop/sbin/hadoop-daemon.sh start namenode –upgradeOnly
```

Review the log file.

```sh
tail /opt/atsd/hadoop/logs/hadoop-axibase-namenode-atsd.log
```

Expected output:

```sh
2017-07-26 16:16:16,974 INFO org.apache.hadoop.util.ExitUtil: Exiting with status 0
2017-07-26 16:16:16,959 INFO org.apache.hadoop.ipc.Server: IPC Server Responder: starting
2017-07-26 16:16:16,962 INFO org.apache.hadoop.ipc.Server: IPC Server listener on 8020: starting
2017-07-26 16:16:16,986 INFO org.apache.hadoop.hdfs.server.blockmanagement.CacheReplicationMonitor: Starting CacheReplicationMonitor with interval 30000 milliseconds
2017-07-26 16:16:16,986 INFO org.apache.hadoop.hdfs.server.blockmanagement.CacheReplicationMonitor: Rescanning after 1511498 milliseconds
2017-07-26 16:16:16,995 INFO org.apache.hadoop.hdfs.server.blockmanagement.CacheReplicationMonitor: Scanned 0 directive(s) and 0 block(s) in 9 millisecond(s).
2017-07-26 16:16:16,996 INFO org.apache.hadoop.hdfs.server.namenode.NameNode: SHUTDOWN_MSG: 
/************************************************************
SHUTDOWN_MSG: Shutting down NameNode at atsd/127.0.1.1
************************************************************/
```

4. Start HDFS.

```sh
/opt/atsd/hadoop/sbin/start-dfs.sh
```

Check that HDFS daemons were succeessfully started.

```sh
/opt/atsd/hadoop/bin/hdfs dfsadmin -report
```

The command should return information about HDFS usage and available data nodes.

5. Finalize HDFS upgrade.

```sh
/opt/atsd/hadoop/bin/hdfs dfsadmin -finalizeUpgrade
```

The command should display the following message `Finalize upgrade successful`. 

The `jps` command output should report `NameNode`, `SecondaryNameNode`, and `DataNode` processes as running.

## Upgrade HBase

1. Download pre-configured HBase-1.2.5  and unarchive it into ATSD installation directory:

```sh
wget https://axibase.com/public/atsd-125-migration/hbase.tar.gz
tar -xf hbase.tar.gz -C /opt/atsd/
rm hbase.tar.gz
```

2. Configure HBase.

Modify `JAVA_HOME` so it points to Java 8 in the `/opt/atsd/hbase/conf/hbase-env.sh` file:

```sh
# Set valid path to java 8 home
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
```

View available server memory.

```sh
cat /proc/meminfo | grep "MemTotal"
MemTotal:        1922136 kB
```

Optionally, increase HBase JVM heap size to 50% of available physical memory on the server in the `hbase-env.sh` file.

```sh
export HBASE_HEAPSIZE=1G
```

3. Upgrade and start HBase.

```sh
/opt/atsd/hbase/bin/hbase upgrade -check
```

```
  ...
  INFO  [main] util.HFileV1Detector: Count of HFileV1: 0
  INFO  [main] util.HFileV1Detector: Count of corrupted files: 0
  INFO  [main] util.HFileV1Detector: Count of Regions with HFileV1: 0
  INFO  [main] migration.UpgradeTo96: No HFileV1 found.
```

```sh
/opt/atsd/hbase/bin/hbase-daemon.sh start zookeeper
/opt/atsd/hbase/bin/hbase upgrade -execute
/opt/atsd/hbase/bin/hbase-daemon.sh stop zookeeper
```

```sh
/opt/atsd/hbase/bin/start-hbase.sh
```

Verify that `jps` command output contains `HMaster`, `HRegionServer`, and `HQuorumPeer` processes.

4. Check that ATSD tables are available in HBase. 

```sh
/opt/atsd/hbase/bin/hbase shell
hbase(main):001:0> list
...
hbase(main):002:0> exit
```

5. Execute a sample scan in HBase.

```sh
/opt/atsd/hbase/bin/hbase shell
hbase(main):001:0> scan 'atsd_d', LIMIT => 1
ROW                  COLUMN+CELL
...
1 row(s) in 0.0560 seconds
hbase(main):002:0> exit
```

## Prepare Hadoop to Run Migraton Map-Reduce Job

1. If the server has more than 2GB of physical memory available, increase the amount of memory allocated to Map-Reduce.

View available server memory.

```sh
cat /proc/meminfo | grep "MemTotal"
```

Change memory related properties in file `/opt/atsd/hadoop/etc/hadoop/mapred-site.xml`.

* If server memory exceed 6Gb, set `mapreduce.map.memory.mb` and `mapreduce.reduce.memory.mb` to 3072Mb. Otherwise set these settings to 50% of the available memory.

* Set `mapreduce.map.java.opts` and `mapreduce.reduce.java.opts` to 80% of `mapreduce.map.memory.mb` and `mapreduce.reduce.memory.mb`.

Sample memory configuration for a server with 4GB of RAM:

```xml
    <property>
        <name>mapreduce.map.memory.mb</name>
        <!-- should not exceed 50% of available physical memory on the server! -->
        <value>2048</value>
    </property>
    <property>
        <name>mapreduce.map.java.opts</name>
        <!-- set to 80% of mapreduce.map.memory.mb -->
        <value>-Xmx1638m</value>
    </property>
    <property>
        <name>mapreduce.reduce.memory.mb</name>
        <!-- should not exceed 50% of available physical memory on the server! -->
        <value>2048</value>
    </property>
    <property>
        <!-- set to 80% of mapreduce.reduce.memory.mb -->
        <name>mapreduce.reduce.java.opts</name>
        <value>-Xmx1638m</value>
    </property>
```

2. Start Yarn and History server:

```sh
/opt/atsd/hadoop/sbin/start-yarn.sh
/opt/atsd/hadoop/sbin/mr-jobhistory-daemon.sh --config /opt/atsd/hadoop/etc/hadoop/ start historyserver
```

3. Run the `jps` command to check that all processes are running:

```sh
jps
```

```
9849 ResourceManager
25902 NameNode
6857 HQuorumPeer
26050 DataNode
26262 SecondaryNameNode
10381 JobHistoryServer
10144 NodeManager
6940 HMaster
7057 HRegionServer
```

## Run ATSD Migration Map-Reduce Job

1. Download [`migration.jar`](https://axibase.com/public/atsd-125-migration/migration.jar) to `/opt/atsd` directory.

```sh
wget -P /opt/atsd https://axibase.com/public/atsd-125-migration/migration.jar
```

2. Set `JAVA_HOME` variable to Java 8.

```sh
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
```

3. Check that current Java version is 8.

```sh
java -version
```

3. Add `migration.jar` and HBase classes to classpath.

```sh
export CLASSPATH=$CLASSPATH:$(/opt/atsd/hbase/bin/hbase classpath):/opt/atsd/migration.jar
```

4. Rename tables to be migrated by appending a suffix `'_backup'`.

The backup tables will be removed after a successful migration.

```sh
java com.axibase.migration.admin.TableCloner -d
```

Check that tables 'atsd_d_backup', 'atsd_li_backup', 'atsd_metric_backup', 'atsd_forecast_backup',
and 'atsd_delete_task_backup' are present in the HBase table list.

```sh
/opt/atsd/hbase/bin/hbase shell
hbase(main):001:0> list
hbase(main):002:0> exit
```

5. Set `HADOOP_CLASSPATH` for the Map-Reduce job.

```sh
export HADOOP_CLASSPATH=$(/opt/atsd/hbase/bin/hbase classpath):/opt/atsd/migration.jar
```

6. Migrate `'atsd_delete_task_backup'` table.

```sh
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.DeleteTaskMigration -s 'atsd_delete_task_backup' -d 'atsd_delete_task' -m 2 -r
```

```
INFO mapreduce.Job: Job job_xxxxxxxxxxxxx_xxxx completed successfully
```

In case of errors, review job logs:

```sh
/opt/atsd/hadoop/bin/yarn logs -applicationId application__xxxxxxxxxxxxx_xxxx | less
```

7. Migrate the 'atsd_forecast' table.

```sh
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.ForecastMigration -s 'atsd_forecast_backup' -d 'atsd_forecast' -m 2 -r
```

8. Migrate the 'atsd_li' table.

```sh
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.LastInsertMigration -s 'atsd_li_backup' -d 'atsd_li' -m 2 -r
```

This migration task writes intermediate results into a temporary directory for diagnostics.

```sh
INFO mapreduce.LastInsertMigration: Map-reduce job success, files from outputFolder 1609980393918240854 are ready for loading in table atsd_li.
...
INFO mapreduce.LastInsertMigration: Files from outputFolder 1609980393918240854 are loaded in table atsd_li. Start deleting outputFolder.
WARN mapreduce.LastInsertMigration: Deleting outputFolder hdfs://localhost:8020/user/axibase/copytable/1609980393918240854 failed!
WARN mapreduce.LastInsertMigration: Data from outputFolder hdfs://localhost:8020/user/axibase/copytable/1609980393918240854 not needed any more, and you can delete this outputFolder via hdfs cli.
INFO mapreduce.LastInsertMigration: Last Insert table migration job took 37 seconds.
```


Delete the folder containing the diagnostics file:

```sh
/opt/atsd/hadoop/bin/hdfs dfs -rm -r /user/axibase/copytable
```

9. Migrate the 'atsd_metric' table.

```sh
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.MetricMigration -s 'atsd_metric_backup' -d 'atsd_metric' -m 2 -r
```

10. Migrate the 'atsd_d' table.

```sh
/usr/local/hadoop-2.6.4/bin/yarn com.axibase.migration.mapreduce.DataMigrator -s test_d_backup -d test_d -m 2
```

11. Migration is now completed. 

12. Stop Map-Reduce servers.

```sh
/opt/atsd/hadoop/sbin/mr-jobhistory-daemon.sh --config /opt/atsd/hadoop/etc/hadoop/ stop historyserver
/opt/atsd/hadoop/sbin/stop-yarn.sh
```

## Start New ATSD Version

1. Download ATSD files.

* Download [`atsd-dfs.sh`](bin/atsd-dfs.sh) script to `/opt/atsd/bin/` directory.
* Download [`atsd-executable.jar`](https://axibase.com/public/atsd-125-migration/atsd-executable.jar) to `/opt/atsd/bin/` directory.

2. Start ATSD.

```sh
/opt/atsd/bin/atsd-tsd.sh start
```

3. Check that data is available in ATSD by opening the [Metrics] tab and checking that historical data is availble for selected metrics.

4. Delete backup copies via HBase shell.

* 'atsd_d_backup'
* 'atsd_li_backup'
* 'atsd_metric_backup'
* 'atsd_forecast_backup'
* 'atsd_delete_task_backup'

```sh
/opt/atsd/hbase/bin/hbase shell
hbase(main):001:0> disable 'atsd_forecast_backup'
hbase(main):002:0> drop 'atsd_forecast_backup'
hbase(main):002:0> exit
```
