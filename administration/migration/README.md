
# Migration ATSD on HBase 1.2.5

This instruction describes how to migrate Axibase Time Series Database running on HBase-0.94 to a version running on HBase-1.2.5.

## Versioning

| **Code** | **ATSD Revision Number** | **Java Version** | **HBase Version** | **HDFS Version** |
|---|---|---|---|---|
| Old | 16999 and earlier | 1.7 | 0.94.29 | 1.0.3 |
| New | 17000 and later | 1.8 | 1.2.5 | 2.6.4 |

## Prepare For Upgrade

1. Login into ATSD, open **Admin -> Configuration Files -> `hadoop.properties`** file.
2. Remove the following line:

  ```properties
  hbase.regionserver.lease.period=1200
  ```
3. Add new setting:

  ```properties
  hbase.client.scanner.timeout.period=1200
  ```
  
## Stop Old ATSD

Stop old versions of ATSD, HBase and Hadoop.

```sh
/opt/atsd/bin/atsd-all.sh stop
```

Verify that no Java processes are running by executing the `jps` commands.

If necessary, follow the safe shutdown [procedure](https://github.com/axibase/atsd/blob/master/administration/restarting.md#stop-services).

## Backup Old ATSD

```sh
cp -R /opt/atsd /opt/atsd-backup
```

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
# set path to java 8 home
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

Check that namenode web interface is available on port 50070.

Stop the namenode process and start HDFS.

```sh
/opt/atsd/hadoop/sbin/hadoop-daemon.sh stop namenode
/opt/atsd/hadoop/sbin/start-dfs.sh
```

Check that HDFS web interface has started execute the finalize command:

```sh
/opt/atsd/hadoop/bin/hdfs dfsadmin -finalizeUpgrade
```

The command should display the following message `Finalize upgrade successful`.

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

Optionally, enable JMX in HBase. Modify `-p 22` to the port on which SSH daemon is running.

```sh
export HBASE_SSH_OPTS="-p 22"
HBASE_JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false" #-Djava.rmi.server.hostname=NURSWGHBS001"
HBASE_JMX_OPTS="$HBASE_JMX_OPTS -Dcom.sun.management.jmxremote.password.file=$HBASE_HOME/conf/jmxremote.passwd"
HBASE_JMX_OPTS="$HBASE_JMX_OPTS -Dcom.sun.management.jmxremote.access.file=$HBASE_HOME/conf/jmxremote.access"
export HBASE_MASTER_OPTS="$HBASE_JMX_OPTS -Dcom.sun.management.jmxremote.port=10101"
export HBASE_REGIONSERVER_OPTS="$HBASE_JMX_OPTS -Dcom.sun.management.jmxremote.port=10102"
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

Check that the web interface of the HBase master is available on port 16010.

5. Check that ATSD tables are available in HBase.


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

Add these properties to `/opt/atsd/hadoop/etc/hadoop/mapred-site.xml`:

```xml
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.map.memory.mb</name>
        <!-- set to 50% of available physical memory on the server -->
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
        <!-- set to 50% of available physical memory on the server -->
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

The following properties can be further adjusted based on available OS and VM/hardware configuration of the ATSD server:

* `mapreduce.map.memory.mb`
* `mapreduce.map.memory.mb`
* `mapreduce.map.cpu.vcores`
* `mapreduce.reduce.memory.mb`
* `mapreduce.reduce.java.opts`
* `mapreduce.reduce.cpu.vcores`

2. Start Yarn and History server:

```sh
/opt/atsd/hadoop/sbin/start-yarn.sh
/opt/atsd/hadoop/sbin/mr-jobhistory-daemon.sh --config /opt/atsd/hadoop/etc/hadoop/ start historyserver
```

Check that Yarn resource manager and History server web interface is available on ports
8088 and 19888 respectively.

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

1. Download [`migration.jar`](bin/migration.jar) to `/home/axibase/migration.jar`

2. Migration program and new ATSD version run on Java 8, so set `JAVA_HOME` variable to Java 8.

Check that java is 8 is available.

```sh
java -version
```

3. Add `migration.jar` and HBase classes to classpath.

```sh
export CLASSPATH=$CLASSPATH:$(/opt/atsd/hbase/bin/hbase classpath):/home/axibase/migration.jar
```

4. First migration step is make backup copies of tables 'atsd_d', 'atsd_li', 'atsd_metric', 'atsd_forecast', and 'atsd_delete_task'
which are affected by migration. The below commands copy pointers to the same data in HBase as original tables,
so they don't consume a lot of disk.

Print usage:

```sh
java com.axibase.migration.admin.TableCloner -h
```

Backup copies of all tables:

```sh
java com.axibase.migration.admin.TableCloner
```

Check that tables 'atsd_d_backup', 'atsd_li_backup', 'atsd_metric_backup', 'atsd_forecast_backup',
and 'atsd_delete_task_backup' were created and have the same data as original tables.

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
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.ForecastMigration -h
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

In case of errors, check HDFS and delete this temporary directory.

9. Migrate the 'atsd_metric' table.

```sh
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.MetricMigration -s 'atsd_metric_backup' -d 'atsd_metric' -m 2 -r
```

10. Migrate the 'atsd_d' table.

```sh
$ /usr/local/hadoop-2.6.4/bin/yarn com.axibase.migration.mapreduce.DataMigrator -s test_d_backup -d test_d -m 2
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

Add coprocessors in `/opt/atsd/hbase-1.2.5/conf/hbase-site.xml`,

```xml
<property>
    <name>hbase.coprocessor.region.classes</name>
    <value>
        com.axibase.tsd.hbase.coprocessor.MessagesStatsEndpoint,
        com.axibase.tsd.hbase.coprocessor.DeleteDataEndpoint
    </value>
</property>
```

Start HBase:

```sh
/opt/atsd/hbase/bin/start-hbase.sh
```

2. Download new ATSD files.

Download [`atsd-dfs.sh`](bin/atsd-dfs.sh) script to `/opt/atsd/bin/` folder.
Download [`atsd-executable.jar`](bin/atsd-executable.jar) to `/opt/atsd/bin/` folder.
Download [`tsd-hbase-1.0.0.jar`](bin/tsd-hbase-1.0.0.jar) to `/opt/atsd/hbase/lib/` folder.

3. Start new version of ATSD.

```sh
/opt/atsd/atsd/bin/start-atsd.sh
```

4. Check that all data are available in ATSD.

5. Delete backup copies of original tables via HBase shell.

```sh
/opt/atsd/atsd/bin/hbase shell
hbase(main):001:0> disable 'atsd_forecast_backup'
hbase(main):002:0> drop 'atsd_forecast_backup'
hbase(main):002:0> exit
```
