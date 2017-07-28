
# Migrating ATSD to HBase 1.2.5

These instructions describe how to migrate an Axibase Time Series Database instance running on **HBase-0.94** to a version running on the updated **HBase-1.2.5**.

## Versioning

| **Code** | **ATSD Revision Number** | **Java Version** | **HBase Version** | **HDFS Version** |
|---|---|---|---|---|
| Old | 16999 and earlier | 1.7 | 0.94.29 | 1.0.3 |
| New | 17000 and later | 1.8 | 1.2.5 | 2.6.4 |

## Plan for Disk Space Utilization

The migration procedure requires up to 30% of the reported `/opt/atsd` size to store migrated records before old data can be deleted. 

1. Determine the size of the ATSD installation directory.

```sh
du -hs /opt/atsd
24G	/opt/atsd
```

2. Check that free disk space is available on the file system containing the `/opt/atsd` directory.

```sh
df -h /opt/atsd
Filesystem      Size  Used Avail Use% Mounted on
/dev/md2       1008G  262G  736G  27% /
```

3. If the [backup](#backup) will be stored on the same file system, add it to the estimated disk space usage.

4. Calculate disk space requirements.

  | **Data** | **Size** |
  |---|---|
  | Original Data | 24G |
  | Backup | 24G |
  | Migrated Data | 7G (30% of 24G) |
  | Backup + Migrated | 31G |
  | Available | 736G |

  In the example above, 736G is sufficient to store 31G of backup and migrated data on the same file system.

5. Allocate additional disk space, if necessary.

## Prepare ATSD For Upgrade

1. Switch to 'axibase' user if necessary.

```sh
su axibase
```

Execute the remaining steps as the 'axibase' user.

2. Stop ATSD.

  ```sh
  /opt/atsd/bin/atsd-tsd.sh stop
  ```
  
3. Execute the `jps` command. Verify that the `Server` process is **not present** in the `jps` output.

> If the `Server` process continues running, follow the [safe ATSD shutdown](../restarting.md#stop-atsd) procedure.

4. Edit configuration file `/opt/atsd/atsd/conf/hadoop.properties`.

    - Remove the `hbase.regionserver.lease.period` setting, if present.

    - Add the `hbase.client.scanner.timeout.period` setting, if missing:

    ```properties
    hbase.zookeeper.quorum = localhost
    hbase.rpc.timeout = 120000
    hbase.client.scanner.timeout.period = 120000
    ```

5. Save the `hadoop.properties` file.  

## Check HBase Status

1. Check HBase for consistency.

  ```sh
  /opt/atsd/hbase/bin/hbase hbck
  ```

  The expected message is:
  
  ```
  ...
  0 inconsistencies detected.
  Status: OK
  ```

> Follow [recovery](../corrupted-file-recovery.md#repair-hbase) procedures if inconsistencies are reported.

2. Stop HBase.

  ```sh
  /opt/atsd/bin/atsd-hbase.sh stop
  ```

3. Execute the `jps` command and verify that the `HMaster`, `HRegionServer`, and `HQuorumPeer` processes are **not present** in the `jps` command output. 

```sh
jps
1200 DataNode
1308 SecondaryNameNode
5324 Jps
1092 NameNode
```

> If one of the above processes continues running, follow the [safe HBase shutdown](../restarting.md#stop-hbase) procedure.

## Check HDFS Status

1. Check HDFS for consistency.

  ```sh
  /opt/atsd/hadoop/bin/hadoop fsck /hbase/
  ```

  The expected message is  `The filesystem under path '/hbase/' is HEALTHY`. 
  
> If corrupted files are reported, follow the [recovery](../corrupted-file-recovery.md#repair-hbase) procedure.

2. Stop HDFS.

  ```sh
  /opt/atsd/bin/atsd-dfs.sh stop
  ```

3. Execute the `jps` command and verify that the the `NameNode`, `SecondaryNameNode`, and `DataNode` processes are **not  present** in the `jps` command output.

## Backup

1. Copy the ATSD installation directory to a backup directory:

```sh
cp -R /opt/atsd /home/axibase/atsd-backup
```

## Install Java 8 on the ATSD server.

### Option 1. OpenJDK Installation From Repository

1. Ubuntu, Debian

```sh
sudo apt-get install openjdk-8-jdk
```

In case of error `'Unable to locate package openjdk-8-jdk'`, install Java using Option 2.

2. Red Hat Enterprise Linux, SLES, Centos, Oracle Linux

```sh
sudo yum install java-1.8.0-openjdk-devel
```

In case of error `'No package java-1.8.0-openjdk-devel available.'`, install Java using Option 2.

### Option 2. Oracle JDK Installation From Archive

1. Open the [Oracle Java 8 JDK Download](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) page.

2. Accept the license and copy the link to the latest file with the Java SE Development Kit for Linux x64, for example the `jdk-8u144-linux-x64.tar.gz` file.

3. Copy the download URL into the `wget` command and download the `tar.gz` file.

```sh
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz
```

4. Expand the archive into the `/opt/jdk` directory.

```sh
sudo mkdir /opt/jdk
sudo tar -xzf jdk-8u144-linux-x64.tar.gz -C /opt/jdk
```

5. Remove prior Java versions from alternatives

```sh
sudo update-alternatives --remove-all java
sudo update-alternatives --remove-all javac
```

6. Add Java 8 to alternatives

```sh
sudo update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_144/bin/java 100
sudo update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_144/bin/javac 100
```

7. Verify that Java 8 is set as the default executable.

```sh
java -version
javac -version
```

## Upgrade Hadoop

1. Delete the old Hadoop directory

```sh
rm -rf /opt/atsd/hadoop
```

2. Download a pre-configured Hadoop-2.6.4 and unarchive it into the ATSD installation directory.

```sh
wget https://axibase.com/public/atsd-125-migration/hadoop.tar.gz
tar -xf hadoop.tar.gz -C /opt/atsd/
rm hadoop.tar.gz
```

3. Configure Hadoop to use Java 8.

Get path to the Java home.

```sh
$(dirname $(dirname $(readlink -f $(which javac))))
-bash: /usr/lib/jvm/java-8-openjdk-amd64: Is a directory
# Copy path as /usr/lib/jvm/java-8-openjdk-amd64
```

Update the `JAVA_HOME` variable in the `/opt/atsd/hadoop/etc/hadoop/hadoop-env.sh` file to Java 8.

```sh
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
```

4. Upgrade Hadoop.

```sh
/opt/atsd/hadoop/sbin/hadoop-daemon.sh start namenode –upgradeOnly
```

5. Review the log file.

```sh
tail /opt/atsd/hadoop/logs/hadoop-axibase-namenode-atsd.log
```

The expected output:

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

6. Start HDFS.

```sh
/opt/atsd/hadoop/sbin/start-dfs.sh
```

7. Check that HDFS daemons were succeessfully started.

```sh
/opt/atsd/hadoop/bin/hdfs dfsadmin -report
```

The command should return information about HDFS usage and available data nodes.

8. Finalize HDFS upgrade.

```sh
/opt/atsd/hadoop/bin/hdfs dfsadmin -finalizeUpgrade
```

The command should display the following message `Finalize upgrade successful`. 

The `jps` command output should report `NameNode`, `SecondaryNameNode`, and `DataNode` processes as running.

## Upgrade HBase

1. Delete the old HBase directory

```sh
rm -rf /opt/atsd/hbase
```

2. Download a pre-configured version of HBase-1.2.5  and unarchive it into ATSD installation directory:

```sh
wget https://axibase.com/public/atsd-125-migration/hbase.tar.gz
tar -xf hbase.tar.gz -C /opt/atsd/
rm hbase.tar.gz
```

3. Configure HBase.

Update the `JAVA_HOME` variable in the `/opt/atsd/hbase/conf/hbase-env.sh` file so it points to Java 8.

```sh
# Set valid path to java 8 home
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
```

4. View available physical memory on the server.

```sh
cat /proc/meminfo | grep "MemTotal"
MemTotal:        1922136 kB
```

If the memory is greater than 2GB, increase HBase JVM heap size to 50% of available physical memory on the server in the `hbase-env.sh` file.

```sh
export HBASE_HEAPSIZE=2G
```

5. Upgrade HBase.

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

6. Start HBase.

```sh
/opt/atsd/hbase/bin/start-hbase.sh
```

Verify that the `jps` command output contains `HMaster`, `HRegionServer`, and `HQuorumPeer` processes.

7. Check that ATSD tables are available in HBase. 

```sh
/opt/atsd/hbase/bin/hbase shell
hbase(main):001:0> list
...
hbase(main):002:0> exit
```

8. Execute a sample scan in HBase.

```sh
/opt/atsd/hbase/bin/hbase shell
hbase(main):001:0> scan 'atsd_d', LIMIT => 1
ROW                  COLUMN+CELL
...
1 row(s) in 0.0560 seconds
hbase(main):002:0> exit
```

## Prepare Hadoop to Run the Migraton Map-Reduce Job

1. If the server has more than 2GB of physical memory available, increase the amount of memory allocated to Map-Reduce jobs.

View available server memory.

```sh
cat /proc/meminfo | grep "MemTotal"
```

2. Open `/opt/atsd/hadoop/etc/hadoop/mapred-site.xml` file.

* If server memory exceeds 6Gb, set `mapreduce.map.memory.mb` and `mapreduce.reduce.memory.mb` to 3072Mb. Otherwise set them to 50% of the available memory.

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

3. Run the `jps` command to check that the following processes are running:

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

### Configure Migration Job

1. Download [`migration.jar`](https://axibase.com/public/atsd-125-migration/migration.jar) to the `/opt/atsd` directory.

```sh
wget -P /opt/atsd https://axibase.com/public/atsd-125-migration/migration.jar
```

2. Update the `JAVA_HOME` variable to Java 8.

```sh
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
```

3. Check that current Java version is 8.

```sh
java -version
```

4. Add `migration.jar` and HBase classes to classpath.

```sh
export CLASSPATH=$CLASSPATH:$(/opt/atsd/hbase/bin/hbase classpath):/opt/atsd/migration.jar
```

### Create Backup Tables

1. Rename tables to be migrated by appending a `'_backup'` suffix.

The backup tables will be removed after a successful migration.

```sh
java com.axibase.migration.admin.TableCloner -d
```

Check that tables 'atsd_d_backup', 'atsd_li_backup', 'atsd_metric_backup', 'atsd_forecast_backup',
and 'atsd_delete_task_backup' are present in the HBase table list.

```sh
/opt/atsd/hbase/bin/hbase shell
hbase(main):001:0> list
...
hbase(main):002:0> exit
```

2. Set `HADOOP_CLASSPATH` for the Map-Reduce job.

```sh
export HADOOP_CLASSPATH=$(/opt/atsd/hbase/bin/hbase classpath):/opt/atsd/migration.jar
```

### Migrate Records from Backup Tables

1. Migrate data in the `'atsd_delete_task_backup'` table by launching the task and confirming its execution.

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

2. Migrate data in the 'atsd_forecast' table.

```sh
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.ForecastMigration -s 'atsd_forecast_backup' -d 'atsd_forecast' -m 2 -r
```

3. Migrate data in the 'atsd_li' table.

```sh
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.LastInsertMigration -s 'atsd_li_backup' -d 'atsd_li' -m 2 -r
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


Delete folder containing the diagnostics file:

```sh
/opt/atsd/hadoop/bin/hdfs dfs -rm -r /user/axibase/copytable
```

4. Migrate data to the 'atsd_metric' table.

```sh
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.MetricMigration -s 'atsd_metric_backup' -d 'atsd_metric' -m 2 -r
```

5. Migrate data to the 'atsd_d' table.

```sh
/usr/local/hadoop-2.6.4/bin/yarn com.axibase.migration.mapreduce.DataMigrator -s test_d_backup -d test_d -m 2
```

6. Migration is now complete. 

7. Stop Map-Reduce servers.

```sh
/opt/atsd/hadoop/sbin/mr-jobhistory-daemon.sh --config /opt/atsd/hadoop/etc/hadoop/ stop historyserver
/opt/atsd/hadoop/sbin/stop-yarn.sh
```

## Start the New Version of ATSD

1. Remove old ATSD application files.

```sh
rm -rf /opt/atsd/atsd/bin/atsd*.jar
```

2. Download ATSD application files.

```sh
wget /opt/atsd/atsd/bin https://axibase.com/public/atsd-125-migration/atsd.16855.jar
wget /opt/atsd https://axibase.com/public/atsd-125-migration/scripts.tar.gz
```

3. Replace old script files.

```sh
tar -xf scripts.tar.gz -C /opt/atsd/
```

4. Start ATSD.

```sh
/opt/atsd/bin/atsd-tsd.sh start
```

5. Log in to the ATSD web interface.

6. Open the [Metrics] tab. Verify that the data is available by checking that historical data is present for the selected metrics.

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
