
# Migration ATSD on HBase 1.2.5

This instruction describes how to migrate Axibase Time Series Database running on HBase-0.94 to a version running on HBase-1.2.5.

## Versioning

| **Code** | **ATSD Revision Number** | **Java Version** | **HBase Version** | **HDFS Version** |
|---|---|---|---|---|
| Old | 16999 and earlier | 1.7 | 0.94.29 | 1.0.3 |
| New | 17000 and later | 1.8 | 1.2.5 | 2.6.4 |

Java 8 is required to run new version of ATSD, so install it on your machine/cluster.

## Prepare ATSD For Upgrade and Stop It

1. Login into ATSD, open **Admin -> Configuration Files -> `hadoop.properties`** file.
2. Remove the following line (if present):

  ```properties
  hbase.regionserver.lease.period=120000
  ```
3. Add new setting:

  ```properties
  hbase.client.scanner.timeout.period=120000
  ```
4. Stop ATSD:

  ```sh
  /opt/atsd/bin/atsd-tsd.sh stop
  ```
  
Verify that the `Server` process is **not** represented in the `jps` command output.
If necessary, follow the safe [ATSD shutdown](https://github.com/axibase/atsd/blob/master/administration/restarting.md#stop-atsd) procedure.

## Check HBase Status and Stop It

```sh
/opt/atsd/hbase/bin/hbase hbck
```

You shoud get message `Status: OK`. Follow [recovery](https://github.com/axibase/atsd/blob/master/administration/corrupted-file-recovery.md#repair-hbase) if some inconsistencies were detected.

Stop HBase daemons:

```sh
/opt/atsd/bin/atsd-hbase.sh stop
```

Verify that the `HMaster`, `HRegionServer`, and `HQuorumPeer` processes are **not** represented in the `jps` command output.
If necessary, follow the safe [HBase shutdown](https://github.com/axibase/atsd/blob/master/administration/restarting.md#stop-hbase) procedure.

## Check HDFS Status and Stop It

```sh
/opt/atsd/hadoop/bin/hadoop fsck /hbase/
```

You shoud get message `The filesystem under path '/hbase/' is HEALTHY`. Follow [recovery](https://github.com/axibase/atsd/blob/master/administration/corrupted-file-recovery.md#repair-hbase) if there are corrupted files.

Stop HDFS daemons:

```sh
/opt/atsd/bin/atsd-dfs.sh stop
```

Verify that the `NameNode`, `SecondaryNameNode`, and `DataNode` processes are **not** represented in the `jps` command output.


## Backup Old ATSD

```sh
cp -R /opt/atsd /opt/atsd-backup
```

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

## Upgrade Hadoop

1. Download Hadoop-2.6.4 and unzip it into ATSD folder.

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

Set `JAVA_HOME` and `HADOOP_PID_DIR` in `/opt/atsd/hadoop-2.6.4/etc/hadoop/hadoop-env.sh` file:

```sh
# set valid path to java 8 home here!
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_PID_DIR=/opt/atsd/pids
```

3. Replace the Hadoop folder.

```sh
rm -r /opt/atsd/hadoop
mv /opt/atsd/hadoop-2.6.4 /opt/atsd/hadoop
```

4. Run Hadoop upgrade.

```sh
/opt/atsd/hadoop/sbin/hadoop-daemon.sh start namenode –upgrade
```

View namenode web interface on port 50070: `namenodeIP:50070`.
The web page should contain information: `"Upgrade in progress. Not yet finalized."` and `SafeMode is ON`.

Stop the namenode process and start HDFS.

```sh
/opt/atsd/hadoop/sbin/hadoop-daemon.sh stop namenode
/opt/atsd/hadoop/sbin/start-dfs.sh
```

<!--
```sh
/opt/atsd/hadoop/sbin/hadoop-daemon.sh start namenode –upgradeOnly
/opt/atsd/hadoop/sbin/start-dfs.sh
```
-->

Wait a bit and check that HDFS daemons were succeessfully started:

```sh
/opt/atsd/hadoop/bin/hdfs dfsadmin -report
```

You should get information about HDFS usage and available data nodes.

Finalize HDFS upgrade:

```sh
/opt/atsd/hadoop/bin/hdfs dfsadmin -finalizeUpgrade
```

The command should display the following message `Finalize upgrade successful`. The `jps` command should show `NameNode`, `SecondaryNameNode`, and `DataNode` are running.

## Upgrade HBase

1. Download HBase-1.2.5 and unzip it into ATSD folder:

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

Modify `JAVA_HOME` in `/opt/atsd/hbase-1.2.5/conf/hbase-env.sh`:

```sh
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HBASE_PID_DIR=/opt/atsd/pids
```

Set HBase JVM heap size to 50% of available physical memory on the server. The setting can be reverted to a lower value after migration is finished.

```sh
export HBASE_HEAPSIZE=8G
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
Let HBase daemons to start, and check that `jps` command displays `HMaster`, `HRegionServer`, and `HQuorumPeer` are running.

5. Check that ATSD tables are available in HBase. For example, list all tables, read a row of data from the 'atsd_d' table via HBase shell:

```sh
/opt/atsd/hbase/bin/hbase shell
hbase(main):001:0> scan 'atsd_d', LIMIT => 1
ROW                                                       COLUMN+CELL
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

Add these properties to `/opt/atsd/hadoop/etc/hadoop/mapred-site.xml` (copy  this file from `/opt/atsd/hadoop/etc/hadoop/mapred-site.xml` if it is not already presented):

```xml
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.map.memory.mb</name>
        <!-- should not exceeds 50% of available physical memory on the server! -->
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
        <!-- should not exceeds 50% of available physical memory on the server! -->
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

The following properties can be further adjusted based on available OS and VM/hardware configuration:

* `mapreduce.map.memory.mb`
* `mapreduce.map.memory.mb`
* `mapreduce.map.cpu.vcores`
* `mapreduce.reduce.memory.mb`
* `mapreduce.reduce.java.opts`
* `mapreduce.reduce.cpu.vcores`

View these articles [Zhu](https://mapr.com/blog/best-practices-yarn-resource-management/), [Lynch](https://discuss.pivotal.io/hc/en-us/articles/201462036-MapReduce-YARN-Memory-Parameters) for more details about memory/resources allocation for map-reduce jobs.

2. Start Yarn and History server:

```sh
/opt/atsd/hadoop/sbin/start-yarn.sh
/opt/atsd/hadoop/sbin/mr-jobhistory-daemon.sh --config /opt/atsd/hadoop/etc/hadoop/ start historyserver
```

<!--
Check that Yarn resource manager and History server web interface is available on ports
8088 and 19888 respectively.
-->

3. Run the `jps` command to check that all services are running:

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

1. Download [`migration.jar`](bin/migration.jar) to `/home/axibase/migration.jar`. If web interface 

2. Migration program and new ATSD version run on Java 8, so set `JAVA_HOME` variable to Java 8.

Check that java is 8 is available.

```sh
java -version
```

3. Add `migration.jar` and HBase classes to classpath.

```sh
export CLASSPATH=$CLASSPATH:$(/opt/atsd/hbase/bin/hbase classpath):/home/axibase/migration.jar
```

4. First migration step is rename tables 'atsd_d', 'atsd_li', 'atsd_metric', 'atsd_forecast', and 'atsd_delete_task' by adding them suffix '_backup'.
Then data from these tables will be transformed to new schema and stored in new tables 'atsd_d', 'atsd_li', 'atsd_metric', 'atsd_forecast', 'atsd_delete_task', which will be compatible with new version of ATSD.

Print usage:

```sh
java com.axibase.migration.admin.TableCloner -h
```

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

6. Migrate `'atsd_delete_task_backup'` table to new schema and store result in `'atsd_delete_task'` table.

Print usage:

```sh
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.DeleteTaskMigration -h
```

Perform migration:

```sh
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.DeleteTaskMigration -s 'atsd_delete_task_backup' -d 'atsd_delete_task' -m 2 -r
```

```
INFO mapreduce.Job: Job job_xxxxxxxxxxxxx_xxxx completed successfully
```

In case of errors, review logs for the job:

```sh
/opt/atsd/hadoop/bin/yarn logs -applicationId application__xxxxxxxxxxxxx_xxxx | less
```

7. Migrate the 'atsd_forecast' table:

```sh
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.ForecastMigration -s 'atsd_forecast_backup' -d 'atsd_forecast' -m 2 -r
```

8. Migrate the 'atsd_li' table.

```sh
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.LastInsertMigration -s 'atsd_li_backup' -d 'atsd_li' -m 2 -r
```

This migration task writes intermediate results into the temporary directory and report if it fails to delete this directory:

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
$ /opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.DataMigrator -s atsd_d_backup -d atsd_d -m 2 -r
```

11. Migration completed - stop Yarn and History server. You should stop Yarn as it binds to the same port as ATSD.

```sh
/opt/atsd/hadoop/sbin/mr-jobhistory-daemon.sh --config /opt/atsd/hadoop/etc/hadoop/ stop historyserver
/opt/atsd/hadoop/sbin/stop-yarn.sh
```

## Run New Version of ATSD

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

2. Download new ATSD files.

Download [`atsd-dfs.sh`](bin/atsd-dfs.sh) script to `/opt/atsd/bin/` folder.
Download [`atsd-executable.jar`](bin/atsd-executable.jar) to `/opt/atsd/bin/` folder.
Download [`tsd-hbase-1.0.0.jar`](bin/tsd-hbase-1.0.0.jar) to `/opt/atsd/hbase/lib/` folder.

3. Start HBase:

```sh
/opt/atsd/bin/atsd-hbase.sh start
```

4. Start new version of ATSD.

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
