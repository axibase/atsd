
# Migrating ATSD to HBase 1.2.5

This instruction describes how to migrate Axibase Time Series Database running on **HBase-0.94** to a version running on **HBase-1.2.5**.

## Versioning

| **Code** | **ATSD Revision Number** | **Java Version** | **HBase Version** | **HDFS Version** |
|---|---|---|---|---|
| Old | 16999 and earlier | 1.7 | 0.94.29 | 1.0.3 |
| New | 17000 and later | 1.8 | 1.2.5 | 2.6.4 |

## Prepare ATSD For Upgrade

1. Switch user to 'axibase'.

```sh
su axibase
```

2. Stop ATSD.

  ```sh
  /opt/atsd/bin/atsd-tsd.sh stop
  ```
  
3. Execute the `jps` command and verify that the `Server` process is **not present** in the `jps` output.
If necessary, follow the safe [ATSD shutdown](../restarting.md#stop-atsd) procedure.

4. Open configuration file `/opt/atsd/atsd/conf/hadoop.properties`.

5. If this file contains property
`hbase.regionserver.lease.period=120000`
replace it by
`hbase.client.scanner.timeout.period=120000`.

6. Save the file.  

## Check HBase Status

1. Check HBase files for consistency.

  ```sh
  /opt/atsd/hbase/bin/hbase hbck
  ```

  The expected message is `Status: OK`. 

  Follow [recovery](../corrupted-file-recovery.md#repair-hbase) procedures if inconsistencies were detected.

2. Stop HBase.

  ```sh
  /opt/atsd/bin/atsd-hbase.sh stop
  ```

3. Execute the `jps` command and verify that the `HMaster`, `HRegionServer`, and `HQuorumPeer` processes are **not present** in the `jps` command output. If necessary, follow the safe [HBase shutdown](../restarting.md#stop-hbase) procedure.

## Check HDFS Status

1. Check HDFS for consistency.

  ```sh
  /opt/atsd/hadoop/bin/hadoop fsck /hbase/
  ```

  The expected message is  `The filesystem under path '/hbase/' is HEALTHY`. 
  
  Follow [recovery](../corrupted-file-recovery.md#repair-hbase) if there are corrupted files.

2. Stop HDFS daemons:

  ```sh
  /opt/atsd/bin/atsd-dfs.sh stop
  ```

3. Execute the `jps` command and verify that the the `NameNode`, `SecondaryNameNode`, and `DataNode` processes are **not  present** in the `jps` command output.

## Backup Old ATSD Files

Copy the entire ATSD installation directory to a backup directory:

  ```sh
  cp -R /opt/atsd /home/axibase/atsd-backup
  ```

## Java

Install Java 8 on the ATSD server.

1. Ubuntu 14.04.

```sh
sudo apt-add-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer
sudo apt install oracle-java8-set-default
```
Accept Java license agreement.

2. RHEL 6/7 and CentOS 6/7. 

Download `jdk-8u141-linux-x64.rpm` package from [Oracle Java 8 JDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) page.
Install java 8 (in directory /usr/java).

```sh
sudo yum localinstall jdk-8u141-linux-x64.rpm
```

Set default java 8 as default java.

```sh
sudo alternatives --config java
```

Delete downloaded `jdk-8u141-linux-x64.rpm` file.

## Check `/etc/hosts` File
In case your run HBase in standolone or pseudo-distributed mode and your `/etc/hosts` file contains lines

```sh
127.0.0.1 localhost 
127.0.1.1 myhostname
```

change them to

```sh
127.0.0.1 localhost myhostname
```
because otherwise new HBase will not work: Master will not be able connect to Region Server, as explained in [elazar](http://web.archive.org/web/20140104070155/http://blog.devving.com/why-does-hbase-care-about-etchosts/).

## Setup passphraseless ssh
Check that you can ssh to the localhost without a passphrase:

```sh
ssh localhost
```

If you cannot ssh to localhost without a passphrase, then create RSA key pair.
Accept default private key path (should be `/home/axibase/.ssh/id_rsa`) and empty passphrase.

```sh
ssh-keygen 
```

Add public key to `authorized_keys` file.

```sh
cat /home/axibase/.ssh/id_rsa.pub >> /home/axibase/.ssh/authorized_keys
```

## Upgrade Hadoop

1. Download Hadoop-2.6.4 and unarchive it into the ATSD installation directory.

```shell
wget https://archive.apache.org/dist/hadoop/core/hadoop-2.6.4/hadoop-2.6.4.tar.gz
tar -xf hadoop-2.6.4.tar.gz -C /opt/atsd/
```

2. Configure Hadoop-2.6.4.

Copy configuration files from the old installation.

```sh
cp /opt/atsd/hadoop/conf/core-site.xml /opt/atsd/hadoop-2.6.4/etc/hadoop/core-site.xml
cp /opt/atsd/hadoop/conf/hdfs-site.xml /opt/atsd/hadoop-2.6.4/etc/hadoop/hdfs-site.xml
```

Change `JAVA_HOME` variables in `/opt/atsd/hadoop-2.6.4/etc/hadoop/hadoop-env.sh` file
so it points to java 8.
Check your current default java version is 8.

```sh
java -verson
```

Get path to java home.
```sh
$(dirname $(dirname $(readlink -f $(which javac))))
```

```sh
# set valid path to java 8 home here!
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
```

Change `HADOOP_PID_DIR` and `HADOOP_SECURE_DN_PID_DIR` variables in `/opt/atsd/hadoop-2.6.4/etc/hadoop/hadoop-env.sh` file.

```sh
export HADOOP_PID_DIR=/opt/atsd/pids
export HADOOP_SECURE_DN_PID_DIR=/opt/atsd/pids
```

3. Replace the Hadoop directory.

```sh
rm -r /opt/atsd/hadoop
mv /opt/atsd/hadoop-2.6.4 /opt/atsd/hadoop
```

4. Run Hadoop upgrade.

```sh
/opt/atsd/hadoop/sbin/hadoop-daemon.sh start namenode –upgradeOnly
```

Check log file.

```sh
tail -n 10 /opt/atsd/hadoop/logs/hadoop-axibase-namenode-atsd.log
```

Expected output.

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

```sh
/opt/atsd/hadoop/sbin/start-dfs.sh
```

Wait while the upgrade is completed and check that HDFS daemons were succeessfully started:

```sh
/opt/atsd/hadoop/bin/hdfs dfsadmin -report
```

You should get information about HDFS usage and available data nodes.

Finalize HDFS upgrade:

```sh
/opt/atsd/hadoop/bin/hdfs dfsadmin -finalizeUpgrade
```

The command should display the following message `Finalize upgrade successful`. The `jps` command should show `NameNode`, `SecondaryNameNode`, and `DataNode` processes are running.

## Upgrade HBase

1. Download HBase-1.2.5 and unzip it into ATSD directory:

```sh
wget https://archive.apache.org/dist/hbase/1.2.5/hbase-1.2.5-bin.tar.gz
tar -xf hbase-1.2.5-bin.tar.gz -C /opt/atsd/
```

2. Configure HBase-1.2.5.

Copy configuration files from the old installation.

```sh
cp /opt/atsd/hbase/conf/hbase-site.xml /opt/atsd/hbase-1.2.5/conf/hbase-site.xml
```
Comment `hbase.coprocessor.region.classes` property in `/opt/atsd/hbase-1.2.5/conf/hbase-site.xml`.
If left unchanged, it will prevent HBase from starting.

```xml
<!--
<property>
  <name>hbase.coprocessor.region.classes</name>
    <value>
      com.axibase.tsd.hbase.coprocessor.MessagesStatsEndpoint,
      com.axibase.tsd.hbase.coprocessor.DeleteDataEndpoint,
      com.axibase.tsd.hbase.coprocessor.CompactRawDataEndpoint,
      org.apache.hadoop.hbase.coprocessor.example.BulkDeleteEndpoint
    </value>
</property>
-->
```

Modify `JAVA_HOME` and `HBASE_PID_DIR` settings in `/opt/atsd/hbase-1.2.5/conf/hbase-env.sh`:

```sh
# set valid path to java 8 home here!
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export HBASE_PID_DIR=/opt/atsd/pids
```

View available server memory.

```sh
cat /proc/meminfo | grep "MemTotal"
```

Set HBase JVM heap size to 50% of memory on the server. The setting can be reverted to a lower value after migration is completed.

```sh
# adjust for your server memory!
export HBASE_HEAPSIZE=4G
```

3. Replace HBase directory.

```sh
rm -r /opt/atsd/hbase
mv /opt/atsd/hbase-1.2.5 /opt/atsd/hbase
```

4. Upgrade and start HBase.

```sh
/opt/atsd/hbase/bin/hbase upgrade -check
```

```
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

Check that `jps` command output contains `HMaster`, `HRegionServer`, and `HQuorumPeer` processes.

5. Check that ATSD tables are available in HBase. 

```sh
/opt/atsd/hbase/bin/hbase shell
hbase(main):001:0> list
...
hbase(main):002:0> exit
```

6. Execute a sample scan in HBase.

```sh
/opt/atsd/hbase/bin/hbase shell
hbase(main):001:0> scan 'atsd_d', LIMIT => 1
ROW                  COLUMN+CELL
...
1 row(s) in 0.0560 seconds
hbase(main):002:0> exit
```

## Prepare Hadoop to Run ATSD Migraton Map-Reduce Job

1. Configure Hadoop for map-reduce migration job: [yarn-site.xml](conf/yarn-site.xml), [mapred-site.xml](conf/mapred-site.xml).

Add these properties to `/opt/atsd/hadoop/etc/hadoop/yarn-site.xml`:

```xml
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
    <name>yarn.log-aggregation-enable</name>
    <value>true</value>
  </property>
```

Add these properties to `/opt/atsd/hadoop/etc/hadoop/mapred-site.xml` (copy this file from `/opt/atsd/hadoop/etc/hadoop/mapred-site.xml.template` if it is not present):

```xml
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.map.memory.mb</name>
        <!-- should not exceed 50% of available physical memory on the server! -->
        <value>4096</value>
    </property>
    <property>
        <name>mapreduce.map.java.opts</name>
        <!-- set to 80% of mapreduce.map.memory.mb -->
        <value>-Xmx3276m</value>
    </property>
    <property>
        <name>mapreduce.map.cpu.vcores</name>
        <value>1</value>
    </property>
    <property>
        <name>mapreduce.reduce.memory.mb</name>
        <!-- should not exceed 50% of available physical memory on the server! -->
        <value>4096</value>
    </property>
    <property>
        <!-- set to 80% of mapreduce.reduce.memory.mb -->
        <name>mapreduce.reduce.java.opts</name>
        <value>-Xmx3276m</value>
    </property>
    <property>
        <name>mapreduce.reduce.cpu.vcores</name>
        <value>1</value>
    </property>
    <property>
        <name>mapreduce.job.maps.speculative.execution</name>
        <value>false</value>
    </property>
</configuration>
```

2. Start Yarn and History server:

```sh
/opt/atsd/hadoop/sbin/start-yarn.sh
/opt/atsd/hadoop/sbin/mr-jobhistory-daemon.sh --config /opt/atsd/hadoop/etc/hadoop/ start historyserver
```

<!--
Check that Yarn resource manager and History server web interface is available on ports
8088 and 19888 respectively.
-->

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

1. Download [`migration.jar`](bin/migration.jar) to directory `/home/axibase/`.
You can download this file by `wget` command.

```sh
wget -P /home/axibase/ https://github.com/axibase/atsd/raw/migration/administration/migration/bin/migration.jar
```

2. Set `JAVA_HOME` variable to Java 8.

```sh
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
```

3. Check that current java version is 8.

```sh
java -version
```

3. Add `migration.jar` and HBase classes to classpath.

```sh
export CLASSPATH=$CLASSPATH:$(/opt/atsd/hbase/bin/hbase classpath):/home/axibase/migration.jar
```

4. Rename tables 'atsd_d', 'atsd_li', 'atsd_metric', 'atsd_forecast', and 'atsd_delete_task' by adding suffix `'_backup'`.

 The records in these tables will be converted to the new schema and copied to new tables 'atsd_d', 'atsd_li', 'atsd_metric', 'atsd_forecast', 'atsd_delete_task'. The backup tables will be removed after a successful migration.

Rename all tables:

```sh
java com.axibase.migration.admin.TableCloner -d
```

Check that tables 'atsd_d_backup', 'atsd_li_backup', 'atsd_metric_backup', 'atsd_forecast_backup',
and 'atsd_delete_task_backup' were created.

```sh
/opt/atsd/hbase/bin/hbase shell
hbase(main):001:0> list
hbase(main):002:0> exit
```

5. Set `HADOOP_CLASSPATH` for map-reduce jobs.

```sh
$ export HADOOP_CLASSPATH=$(/opt/atsd/hbase/bin/hbase classpath):/home/axibase/migration.jar
```

6. Migrate `'atsd_delete_task_backup'` table to new schema and copy results to the `'atsd_delete_task'` table.

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

This migration task writes intermediate results into a temporary directory and reports if it fails to delete this directory:

```sh
INFO mapreduce.LastInsertMigration: Map-reduce job success, files from outputFolder 1609980393918240854 are ready for loading in table atsd_li.
...
INFO mapreduce.LastInsertMigration: Files from outputFolder 1609980393918240854 are loaded in table atsd_li. Start deleting outputFolder.
ERROR mapreduce.LastInsertMigration: Deleting outputFolder hdfs://localhost:8020/user/axibase/copytable/1609980393918240854 failed!
ERROR mapreduce.LastInsertMigration: Data from outputFolder hdfs://localhost:8020/user/axibase/copytable/1609980393918240854 not needed any more, and you can delete this outputFolder via hdfs cli.
INFO mapreduce.LastInsertMigration: Last Insert table migration job took 37 seconds.
```
In case of such an error, check if HDFS really still contains temporary folder:

```sh
/opt/atsd/hadoop/bin/hdfs dfs -ls /user/axibase/copytable/1609980393918240854
```

Delete this folder if it exists:

```sh
/opt/atsd/hadoop/bin/hdfs dfs -rm -r /user/axibase/copytable/1609980393918240854
```

9. Migrate the 'atsd_metric' table.

```sh
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.MetricMigration -s 'atsd_metric_backup' -d 'atsd_metric' -m 2 -r
```

10. Migrate the 'atsd_d' table.

```sh
$ /usr/local/hadoop-2.6.4/bin/yarn com.axibase.migration.mapreduce.DataMigrator -s test_d_backup -d test_d -m 2
```

11. Migration is now completed. Stop Yarn and History server. Stop Yarn as it binds to the same port as ATSD.

```sh
/opt/atsd/hadoop/sbin/mr-jobhistory-daemon.sh --config /opt/atsd/hadoop/etc/hadoop/ stop historyserver
/opt/atsd/hadoop/sbin/stop-yarn.sh
```

## Start New ATSD Version

1. Modify HBase configuration to use ATSD coprocessors:

Stop HBase:

```sh
/opt/atsd/hbase/bin/stop-hbase.sh
```

Add coprocessors in `/opt/atsd/hbase/conf/hbase-site.xml`,

```xml
<property>
    <name>hbase.coprocessor.region.classes</name>
    <value>
        com.axibase.tsd.hbase.coprocessor.MessagesStatsEndpoint,
        com.axibase.tsd.hbase.coprocessor.DeleteDataEndpoint
    </value>
</property>
```

2. Download ATSD files.

* Download [`atsd-dfs.sh`](bin/atsd-dfs.sh) script to `/opt/atsd/bin/` directory.
* Download [`atsd-executable.jar`](bin/atsd-executable.jar) to `/opt/atsd/bin/` directory.
* Download [`tsd-hbase-1.0.0.jar`](bin/tsd-hbase-1.0.0.jar) to `/opt/atsd/hbase/lib/` directory.

3. Start HBase:

```sh
/opt/atsd/bin/atsd-hbase.sh start
```

4. Start ATSD.

```sh
/opt/atsd/bin/atsd-tsd.sh start
```

5. Check that all data are available in ATSD.

6. Delete backup copies of original tables via HBase shell.

```sh
/opt/atsd/hbase/bin/hbase shell
hbase(main):001:0> disable 'atsd_forecast_backup'
hbase(main):002:0> drop 'atsd_forecast_backup'
hbase(main):002:0> exit
```
