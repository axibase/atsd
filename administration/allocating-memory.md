# Allocating Memory to Components


## Change Maximum ATSD Heap Memory

Open the ATSD environment file and modify the -Xmx parameter.

```sh
nano /opt/atsd/atsd/conf/atsd-env.sh
```

Restart ATSD

```sh
/opt/atsd/bin/atsd-tsd.sh stop
/opt/atsd/bin/atsd-tsd.sh start
```

## Change Maximum HBase Heap Memory

Open the HBase environment file and uncomment the `export HBASE_HEAPSIZE` line.
Set new maximum memory size in megabytes:

```sh
nano /opt/atsd/hbase/conf/hbase-env.sh
```

```sh
export HBASE_HEAPSIZE=4096
```

Restart ATSD and HBase:

```sh
/opt/atsd/bin/atsd-tsd.sh stop
/opt/atsd/bin/atsd-hbase.sh stop
/opt/atsd/bin/atsd-hbase.sh start
/opt/atsd/bin/atsd-tsd.sh start
```

## Change Maximum HDFS Heap Memory

Open the HDFS environment file and uncomment the `export HADOOP_HEAPSIZE` line.
Set new maximum memory size in megabytes:

```sh
nano /opt/atsd/hadoop/conf/hadoop-env.sh
```

```sh
export HADOOP_HEAPSIZE=4096
```

Restart all services:

```sh
/opt/atsd/bin/atsd-all.sh stop
/opt/atsd/bin/atsd-all.sh start
```

## Verify Settings


```
ps aux | grep Xmx
```
