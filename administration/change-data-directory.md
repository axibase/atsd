# Change ATSD Data Directory

Grant ownership of the new data directory to the `axibase` user.

```sh
sudo chown -R axibase:axibase /path/to/data-dir
```

Switch to `axibase` user.

```sh
su axibase
```

Stop ATSD.

```sh
/opt/atsd/bin/atsd-all.sh stop
```

Copy data to the new target directory.

```sh
cp -a /opt/atsd/hdfs-data/ /path/to/data-dir/
```

```sh
cp -a /opt/atsd/hdfs-data-name/ /path/to/data-dir/
```

```sh
cp -a /opt/atsd/hdfs-cache/ /path/to/data-dir/
```

Backup the old directories.

```sh
mkdir /opt/atsd/old
```

```sh
mv /opt/atsd/hdfs* /opt/atsd/old/
```

Backup the configuration files.

```sh
cp /opt/atsd/hadoop/conf/hdfs-site.xml /opt/atsd/hadoop/conf/hdfs-site.xml.backup
```

```sh
cp /opt/atsd/hadoop/conf/core-site.xml /opt/atsd/hadoop/conf/core-site.xml.backup
```

Open the `/opt/atsd/hadoop/conf/hdfs-site.xml` file.

Set `dfs.name.dir` property to `/path/to/data-dir/hdfs-data-name`.

Set `dfs.data.dir` to `/path/to/data-dir/hdfs-data`.

```xml
 <property>
     <name>dfs.name.dir</name>
     <value>/path/to/data-dir/hdfs-data-name</value>
 </property>
 <property>
     <name>dfs.data.dir</name>
     <value>/path/to/data-dir/hdfs-data</value>
 </property>
```

Open the `/opt/atsd/hadoop/conf/core-site.xml` file.

Set the `hadoop.tmp.dir` property to `/path/to/data-dir/hdfs-cache`.

```xml
 <property>
     <name>hadoop.tmp.dir</name>
     <value>/path/to/data-dir/hdfs-cache</value>
     <description>A base for other temporary directories.</description>
 </property>
```

Start ATSD services.

```sh
/opt/atsd/bin/atsd-all.sh start
```

Verify that all old data is available and that any expected new data is incoming.

Delete the old data and configuration files.

```sh
rm -r /opt/atsd/old
```

```sh
rm /opt/atsd/hadoop/conf/core-site.xml.backup
```

```sh
rm /opt/atsd/hadoop/conf/hdfs-site.xml.backup
```