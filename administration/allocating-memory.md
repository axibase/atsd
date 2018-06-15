# Allocating Memory to Components

Distribute memory among the components using the following guidelines, based on available physical memory `P`.

* ATSD - `0.20 * P`. Minimum: `1 gigabyte`. Maximum: `8 gigabytes`.
* HBase - `0.20 * P`. Minimum: `1 gigabyte`. Maximum: `8 gigabytes`.
* HDFS - `0.10 * P`. Minimum: `1 gigabyte`. Maximum: `4 gigabytes`.

Example for a server with physical memory of `16` gigabytes:

* ATSD heap size: `3` gigabytes.
* HBase heap size: `3` gigabytes.
* HDFS heap size: `2` gigabytes.

## ATSD Heap Size

To increase maximum heap memory in ATSD, open the database environment file `/opt/atsd/atsd/conf/atsd-env.sh` and modify the [`-Xmx`](https://docs.oracle.com/cd/E13150_01/jrockit_jvm/jrockit/jrdocs/refman/optionX.html) setting in the `JAVA_OPTS` parameter.

The format is `-Xmx<size>{G|M}`.

Examples:

* `-Xmx1024M` - 1024 megabytes
* `-Xmx2G` - 2 gigabytes.

> Note that no whitespace must be present in this setting.

```sh
nano /opt/atsd/atsd/conf/atsd-env.sh
```

```txt
export JAVA_OPTS="-server -Xmx2048M -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath="$atsd_home"/logs"
```

Restart ATSD

```sh
/opt/atsd/bin/atsd-tsd.sh stop
```

```sh
/opt/atsd/bin/atsd-tsd.sh start
```

## HBase Heap

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
```

```sh
/opt/atsd/bin/atsd-hbase.sh stop
```

```sh
/opt/atsd/bin/atsd-hbase.sh start
```

```sh
/opt/atsd/bin/atsd-tsd.sh start
```

## HDFS Heap

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
```

```sh
/opt/atsd/bin/atsd-all.sh start
```

## Verify Settings

View `Xmx` parameters as specified in program arguments.

```sh
ps aux | grep Xmx
```

Open the ATSD portal and check the memory charts.

![](./images/portal_jvm_memory.png)

![](./images/portal_server_memory.png)
