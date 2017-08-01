# Map-Reduce Settings

## Check Memory

Check available server memory.

```sh
cat /proc/meminfo | grep "MemTotal"
```

If the server has less than 8 gigabytes of available physical memory, leave the default settings in place.

## Increase Resource Allocations

Edit `/opt/atsd/hadoop/etc/hadoop/mapred-site.xml` file.

* Set `mapreduce.map.memory.mb` and `mapreduce.reduce.memory.mb` to 50% of the available memory.

* Set `mapreduce.map.java.opts` and `mapreduce.reduce.java.opts` to 80% of `mapreduce.map.memory.mb` and `mapreduce.reduce.memory.mb`.

Sample memory configuration for a server with 16GB of RAM:

```xml
    <property>
        <name>mapreduce.map.memory.mb</name>
        <!-- should not exceed 50% of available physical memory on the server! -->
        <value>8000</value>
    </property>
    <property>
        <name>mapreduce.map.java.opts</name>
        <!-- set to 80% of mapreduce.map.memory.mb -->
        <value>-Xmx5600m</value>
    </property>
    <property>
        <name>mapreduce.reduce.memory.mb</name>
        <!-- should not exceed 50% of available physical memory on the server! -->
        <value>8000</value>
    </property>
    <property>
        <!-- set to 80% of mapreduce.reduce.memory.mb -->
        <name>mapreduce.reduce.java.opts</name>
        <value>-Xmx5600m</value>
    </property>
```
