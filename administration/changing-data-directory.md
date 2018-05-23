# Changing the Directory Where Data is Stored

> Note: `/data/` is an example of a new path used to store ATSD data.

Grant ownership of the target directory to the `axibase` user:

```sh
 sudo chown axibase /data
```

Change to `axibase` user:

```sh
su axibase
```

Stop ATSD:

```sh
/opt/atsd/bin/atsd-all.sh stop
```

Copy data to the target directory:

```sh
cp -a /opt/atsd/hdfs-data/  /data/
```

```sh
cp -a /opt/atsd/hdfs-data-name/  /data/
```

```sh
cp -a /opt/atsd/hdfs-cache/ /data/
```

Backup the old directories:

```sh
mkdir /opt/atsd/old && mv /opt/atsd/hdfs* /opt/atsd/old/
```

Backup the configuration files:

```sh
cp /opt/atsd/hadoop/conf/hdfs-site.xml /opt/atsd/hadoop/conf/hdfs-site.xml.backup
```

```sh
cp /opt/atsd/hadoop/conf/core-site.xml /opt/atsd/hadoop/conf/core-site.xml.backup
```

Open the `/opt/atsd/hadoop/conf/hdfs-site.xml` file and set `dfs.name.dir`
and `dfs.data.dir` properties to `/data/hdfs-data-name` and
`/data/hdfs-data`, respectively:

```xml
 <property>
     <name>dfs.name.dir</name>
     <value>/data/hdfs-data-name</value>
 </property>
 <property>
     <name>dfs.data.dir</name>
     <value>/data/hdfs-data</value>
 </property>
```

Open the `/opt/atsd/hadoop/conf/core-site.xml` file and set the `hadoop.tmp.dir`
property to `/data/hdfs-cache`:

```xml
 <property>
     <name>hadoop.tmp.dir</name>
     <value>/data/hdfs-cache</value>
     <description>A base for other temporary directories.</description>
 </property>
```

Start ATSD:

```sh
/opt/atsd/bin/atsd-all.sh start
```

Verify that the old data is available and that the new data is coming in.

Delete the old data and configuration files:

```sh
rm -r /opt/atsd/old
```

```sh
rm /opt/atsd/hadoop/conf/core-site.xml.backup
```

```sh
rm /opt/atsd/hadoop/conf/hdfs-site.xml.backup
```
