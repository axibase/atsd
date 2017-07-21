
# Migration to New ATSD Version

This instruction describes how to migrate from old ATSD version, which runs on top of HBase-0.94/Hadoop-1.0.3 to new ATSD version running with HBase-1.2.5/Hadoop-2.6.4.


## While Old ATSD is Running

1. Via ATSD UI: 
`Admin -> Configuration Files -> hadoop.properties` <br>
Comment or remove line: <br>

```properties
hbase.regionserver.lease.period=1200
```

Because config option "hbase.regionserver.lease.period" is deprecated in HBase-1.2.5.
Instead, use "hbase.client.scanner.timeout.period".


## Upgrade Hadoop
1. Stop old versions of ATSD, HBase and Hadoop.

```Shell
/opt/atsd/bin/atsd-all.sh stop
```

2. Download Hadoop-2.6.4 and unzip it into ATSD folder:

```Shell
$ wget https://archive.apache.org/dist/hadoop/core/hadoop-2.6.4/hadoop-2.6.4.tar.gz
$ tar -xf hadoop-2.6.4.tar.gz -C /opt/atsd/
```

3. Configure Hadoop-2.6.4: [core-site.xml](conf/core-site.xml), 
[hdfs-site.xml](conf/hdfs-site.xml), [hadoop-env.sh](conf/hadoop-env.sh). <br>
Just copy configuration files of old hadoop.

```Shell
$ cp /opt/atsd/hadoop/conf/core-site.xml /opt/atsd/hadoop-2.6.4/etc/hadoop/core-site.xml
$ cp /opt/atsd/hadoop/conf/hdfs-site.xml /opt/atsd/hadoop-2.6.4/etc/hadoop/hdfs-site.xml
```

Add lines in `/opt/atsd/hadoop-2.6.4/etc/hadoop/hadoop-env.sh` file:

```Shell
# set path to java 8 home
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_PID_DIR=/opt/atsd/pids
```

4. Remove/archive old Hadoop folder, and set new instead of it.

```Shell
$ rm -r hadoop
$ mv /opt/atsd/hadoop-2.6.4 /opt/atsd/hadoop
```

5. Run Hadoop upgrade.

```Shell
$ /opt/atsd/hadoop/sbin/hadoop-daemon.sh start namenode –upgrade
```

Check that namenode web interface is available for browser on port 50070.

Stop namenode, and launch HDFS:

```Shell
$ /opt/atsd/hadoop/sbin/hadoop-daemon.sh stop namenode
$ /opt/atsd/hadoop/sbin/start-dfs.sh
```

Check again via web interface that HDFS has started, and finalize upgrade:

```Shell
$ /opt/atsd/hadoop/bin/hdfs dfsadmin -finalizeUpgrade
...
$ Finalize upgrade successful
```


## Upgrade HBase

1. Download HBase-1.2.5 and unzip it into ATSD folder:

```Shell
$ wget https://archive.apache.org/dist/hbase/1.2.5/hbase-1.2.5-bin.tar.gz
$ tar -xf hbase-1.2.5-bin.tar.gz -C /opt/atsd/
```

2. Configure HBase-1.2.5: [hbase-site.xml](conf/hbase-site.xml), [hbase-env.sh](conf/hbase-env.sh). <br>
Just copy configuration hbase-site.xml of old hbase.

```Shell
$ cp /opt/atsd/hbase/conf/hbase-site.xml /opt/atsd/hbase-1.2.5/conf/hbase-site.xml
```
Delete or comment region coprocessors property in `/opt/atsd/hbase-1.2.5/conf/hbase-site.xml`,
because old coprocessors will prevent new version of HBase launching:

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

Add/change lines in `/opt/atsd/hbase-1.2.5/conf/hbase-env.sh`:

```Shell
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HBASE_PID_DIR=/opt/atsd/pids
```

Set HBase JVM heap size to 50% of available physical memory on the server. The setting can be reverted to a lower value after migration is finished.

```Shell
export HBASE_HEAPSIZE=8G
```

Optionally, enable JMX in HBase. Modify `-p 22` to the port on which SSH daemon is running.

```Shell
export HBASE_SSH_OPTS="-p 22"
HBASE_JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false" #-Djava.rmi.server.hostname=NURSWGHBS001"
HBASE_JMX_OPTS="$HBASE_JMX_OPTS -Dcom.sun.management.jmxremote.password.file=$HBASE_HOME/conf/jmxremote.passwd"
HBASE_JMX_OPTS="$HBASE_JMX_OPTS -Dcom.sun.management.jmxremote.access.file=$HBASE_HOME/conf/jmxremote.access"
export HBASE_MASTER_OPTS="$HBASE_JMX_OPTS -Dcom.sun.management.jmxremote.port=10101"
export HBASE_REGIONSERVER_OPTS="$HBASE_JMX_OPTS -Dcom.sun.management.jmxremote.port=10102"
```

3. Remove/archive old HBase folder, and set new instead of it:

```Shell
$ rm -r /opt/atsd/hbase
$ mv /opt/atsd/hbase-1.2.5 /opt/atsd/hbase
```

4. Upgrade and start HBase.

```Shell
$ /opt/atsd/hbase/bin/hbase upgrade -check
...
$ INFO  [main] util.HFileV1Detector: Count of HFileV1: 0
$ INFO  [main] util.HFileV1Detector: Count of corrupted files: 0
$ INFO  [main] util.HFileV1Detector: Count of Regions with HFileV1: 0
$ INFO  [main] migration.UpgradeTo96: No HFileV1 found.
```

```Shell
$ /opt/atsd/hbase/bin/hbase-daemon.sh start zookeeper
$ /opt/atsd/hbase/bin/hbase upgrade -execute
$ /opt/atsd/hbase/bin/hbase-daemon.sh stop zookeeper
```

```Shell
$ /opt/atsd/hbase/bin/start-hbase.sh
```

Check that hbase master and region servers are available via web interface
on port 16010.

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

Add this properties to `/opt/atsd/hadoop/etc/hadoop/mapred-site.xml`:

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

You should adjust properties
`mapreduce.map.memory.mb`,
`mapreduce.map.memory.mb`,
`mapreduce.map.cpu.vcores`,
`mapreduce.reduce.memory.mb`,
`mapreduce.reduce.java.opts`,
`mapreduce.reduce.cpu.vcores`
to your hardware.

2. Start Yarn and History server:

```Shell
$ /opt/atsd/hadoop/sbin/start-yarn.sh
$ /opt/atsd/hadoop/sbin/mr-jobhistory-daemon.sh --config /opt/atsd/hadoop/etc/hadoop/ start historyserver
```

Check that Yarn resource manager and History server are available via web interface on ports
8088 and 19888.

3. Run `jps` command, to check that all services are running:

```Shell
$ jps
$ 9849 ResourceManager
$ 25902 NameNode
$ 6857 HQuorumPeer
$ 26050 DataNode
$ 26262 SecondaryNameNode
$ 10381 JobHistoryServer
$ 10144 NodeManager
$ 6940 HMaster
$ 7057 HRegionServer
```

## Run ATSD Migration Map-Reduce Job in the Case Old ATSD Schema Uses 2 Bytes to Store metricId

1. Get [`migration.jar`](bin/migration.jar) and put it somewhere, for example:
`/home/axibase/migration.jar`

2. Migration program and new ATSD version run on Java 8, so
set `JAVA_HOME` variable point to Java 8, and check that

```Shell
$ java -version
```
returns Java 8.

3. Set java classpath to include `migration.jar`, and HBase classes used in map-reduce job.

```Shell
export CLASSPATH=$CLASSPATH:$(/opt/atsd/hbase/bin/hbase classpath):/home/axibase/migration.jar
```

4. First migration step is make backup copies of tables `'atsd_d'`, `'atsd_li'`, `'atsd_metric'`, `'atsd_forecast'`, and `'atsd_delete_task'`
which are affected by migration. This copies points out to the same data in HBase as original tables,
so they not consume a lot of disk.

Print usage:

```Shell
$ java com.axibase.migration.admin.TableCloner -h
```

Make backup copies of all tables:

```Shell
$ java com.axibase.migration.admin.TableCloner
```

Check that tables `'atsd_d_backup'`, `'atsd_li_backup'`, `'atsd_metric_backup'`, `'atsd_forecast_backup'`,
and `'atsd_delete_task_backup'` were created and have the same data as original tables.

5. Set `HADOOP_CLASSPATH` for map-reduce jobs.

```Shell
$ export HADOOP_CLASSPATH=$(/opt/atsd/hbase/bin/hbase classpath):/home/axibase/migration.jar
```

6. Migrate `'atsd_delete_task_backup'` table to new schema and store result in `'atsd_delete_task'` table.

Print usage:

```Shell
$ /opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.DeleteTaskMigration -h
```

Do migration:

```Shell
$ /opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.DeleteTaskMigration -s 'atsd_delete_task_backup' -d 'atsd_delete_task' -m 2 -r
...
$ INFO mapreduce.Job: Job job_xxxxxxxxxxxxx_xxxx completed successfully
...
```

In case of errors, view logs for the job:

```Shell
$ /opt/atsd/hadoop/bin/yarn logs -applicationId application__xxxxxxxxxxxxx_xxxx | less
```

7. Migrate the `'atsd_forecast'` table:

```Shell
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.ForecastMigration -h
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.ForecastMigration -s 'atsd_forecast_backup' -d 'atsd_forecast' -m 2 -r
```

8. Migrate the `'atsd_li'` table:

```Shell
/opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.LastInsertMigration -s 'atsd_li_backup' -d 'atsd_li' -m 2 -r
```

This migration task writes intermediate results in temporary folder,
and report if it fails to delete this folder:

```Shell
$ INFO mapreduce.LastInsertMigration: Map-reduce job success, files from outputFolder 1609980393918240854 are ready for loading in table atsd_li.
...
$ INFO mapreduce.LastInsertMigration: Files from outputFolder 1609980393918240854 are loaded in table atsd_li. Start deleting outputFolder.
$ ERROR mapreduce.LastInsertMigration: Deleting outputFolder hdfs://localhost:8020/user/axibase/copytable/1609980393918240854 failed!
$ ERROR mapreduce.LastInsertMigration: Data from outputFolder hdfs://localhost:8020/user/axibase/copytable/1609980393918240854 not needed any more, and you can delete this outputFolder via hdfs cli.
$ INFO mapreduce.LastInsertMigration: Last Insert table migration job took 37 seconds.
```

In that case, check HDFS, and delete this temporary folder.

9. Migrate the `'atsd_metric'` table:

```Shell
$ /opt/atsd/hadoop/bin/yarn com.axibase.migration.mapreduce.MetricMigration -s 'atsd_metric_backup' -d 'atsd_metric' -m 2 -r
```

10. Migrate the `'atsd_d'` table:

```Shell
$ /usr/local/hadoop-2.6.4/bin/yarn com.axibase.migration.mapreduce.FastDataMigration -s test_d_backup -d test_d -m 2
```

11. Migration completed - stop Yarn and History server. You should stop Yarn as it binds to the same port as ATSD.

```Shell
$ /opt/atsd/hadoop/sbin/mr-jobhistory-daemon.sh --config /opt/atsd/hadoop/etc/hadoop/ stop historyserver
$ /opt/atsd/hadoop/sbin/stop-yarn.sh
```


## Run New Version of ATSD

1. Adjust HBase configuration to use ATSD coprocessors:

Stop HBase:

```Shell
$ /opt/atsd/hbase/bin/stop-hbase.sh
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

```Shell
$ /opt/atsd/hbase/bin/start-hbase.sh
```

2. Put new [`atsd-dfs.sh`](bin/atsd-dfs.sh) script in `/opt/atsd/bin/` folder.
Put new [`atsd-executable.jar`](bin/atsd-executable.jar) in `/opt/atsd/bin/` folder.
Put new [`tsd-hbase-1.0.0.jar`](bin/tsd-hbase-1.0.0.jar) in `/opt/atsd/hbase/lib/` folder.

3. Start new version of ATSD:

```Shell
/opt/atsd/atsd/bin/start-atsd.sh
```

4. Check that all data are available in ATSD.

5. Delete backup copies of original tables via HBase shell, e.g.:

```Shell
$ /opt/atsd/atsd/bin/hbase shell
hbase(main):001:0> disable 'atsd_forecast_backup'
hbase(main):002:0> drop 'atsd_forecast_backup'
hbase(main):002:0> exit
$ 
```