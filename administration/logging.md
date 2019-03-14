# Logging

Database logs are located in the `/opt/atsd/atsd/logs` directory.

Log files can be also downloaded from the **Settings > Server Logs** page.

Logs are rolled over and archived according to the retention settings in the `/opt/atsd/atsd/conf/logback.xml` file.

## ATSD Log Files

|**Log Name**|**Description**|
|---|:---|
|`atsd.log`| Main database log.|
|`command.log`| Received commands log. This log contains all data received by the database converted to the Network API syntax.|
|`command_malformed.log`| Malformed commands log. Includes commands with invalid syntax.|
|`command_discarded.log`| Discarded commands log. Includes commands received for disabled entities/metrics.|
|`command_ignored.log`| Ignored commands log. |
|`update.log`| Update log. |
|`metrics.txt`| Snapshot of current database metrics. Refreshed every 15 seconds. |
|`start.log`| Start log.|
|`stop.log`| Stop log.|
|`err.log`| Standard error. |
|`alert.log`| Alert log. |

## HBase Log Files

:::tip Note
**HBase Log Files** section is visible in non-distributed installations where ATSD is co-located with HBase.
:::

|**Log Name**|**Description**|
|---|:---|
|`hbase-<user>-master-<hostname>.log`| `HMaster` log.|
|`hbase-<user>-regionserver-<hostname>.log`| `RegionServer` log.|
|`hbase-<user>-zookeeper-<hostname>.log`| `Zookeeper` log.|
|`hbase.log`| `HBase` default log.|
|`SecurityAuth.audit`| Security log.|

## HDFS Log Files

:::tip Note
**HDFS Log Files** section is visible in non-distributed installations where ATSD is co-located with HDFS.
:::

|**Log Name**|**Description**|
|---|:---|
|`hadoop-<user>-namenode-<hostname>.log`| `NameNode` log.|
|`hadoop-<user>-secondarynamenode-<hostname>.log`| `SecondaryNameNode` log.|
|`hadoop-<user>-datanode-<hostname>.log`| `DataNode` log.|
|`SecurityAuth.audit`| Security log.|

![](./images/server-logs-atsd.png)

## Logging Properties

Logging settings are controlled with `maxFileSize`, `maxHistory`, and `totalSizeCap` settings. All three settings are **required**.

:::warning Warning
`FixedWindowRollingPolicy` is deprecated. Replace `FixedWindowRollingPolicy` and `SizeBasedTriggeringPolicy` sections with `SizeAndTimeBasedRollingPolicy`.
:::

### Sample `SizeAndTimeBasedRollingPolicy` Configuration

```xml
<rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
    <!-- roll-over daily -->
    <fileNamePattern>../logs/command.%d{yyyy-MM-dd}.%i.log.zip</fileNamePattern>
    <!-- roll-over main file after 100MB, keep 8 days of archives, but at most 5GB -->
    <maxFileSize>100MB</maxFileSize>
    <maxHistory>8</maxHistory>
    <totalSizeCap>5GB</totalSizeCap>
</rollingPolicy>
```

### Maximum File Size

The setting specifies the maximum size of the main log file before the file is rolled over and compressed. The archive name contains the creation date and an index within that date. The index starts at `0` for the first archive within the daily period. Supported size units: `MB` and `GB`.

```xml
<maxFileSize>100MB</maxFileSize>
```

The roll over is performed a few seconds **after** the size of the main log file overflows the `maxFileSize` limit. As such, the archives contain more data than set by `maxFileSize`.

The setting must be smaller than `totalSizeCap`.

> The archives are typically 10-15 times smaller than the original files.

### Max History

The setting controls the maximum number of roll-over periods (days) to keep. Each daily period can contain any number of archives provided the total size of all archives is within the `totalSizeCap` limit.

```xml
<maxHistory>8</maxHistory>
```

### Total Limit

The setting restricts the amount of disk space used by the archive files. When the limit is reached, the oldest archive is deleted. Supported size units: `MB` and `GB`.

```xml
<totalSizeCap>1GB</totalSizeCap>
```

The setting must be greater than `maxFileSize`.

### File Name

To change the name of the main file and archives, change both the `file` and `fileNamePattern` tags.

```xml
<file>../logs/command.log</file>
<fileNamePattern>../logs/command.%d{yyyy-MM-dd}.%i.log.zip</fileNamePattern>
```

### Logging Level

To adjust tracing level, add a logging declaration containing the full class name and the level such as `DEBUG`, `INFO`, `WARN`, `ERROR`.

```xml
<logger name="com.axibase.tsd.service.MetricServiceImpl" level="DEBUG"/>
```

## Applying Changes

Logging properties can be modified in the `logback.xml` file located in the `/opt/atsd/atsd/conf` directory or using the [**Settings > Configuration Files**](./configuration-files.md) editor.

:::tip
Database restart is **not** required. The changes in `logback.xml` are automatically applied every 60 seconds, as specified in the `scanPeriod` tag.
:::

![](./images/config-editor.png "configuration_files_editor")

## Command Logging

Logging of incoming commands to `command*.log` files must be enabled **both** in the `logback.xml` file as well as with the **Command Log Enabled** setting on the **Settings > Input Settings** page.

![Input Settings](./images/logging_input.png)

The `command.log` file contains received `series`, `property`, and `message` data commands and is continuously appended with incoming commands.

```txt
2018-06-28T14:11:55.841Z;atsd.incoming.api.command.raw;series e:nurswgvml007 m:os.disk.fs.percent_used=45.62672958755293  t:disk=/
2018-06-28T14:11:55.849Z;atsd.incoming.api.command.raw;message e:nurswgvml008 ms:1530195115844 t:job_type="DOCKER" t:job_name="docker-hbs-to-nur" t:source="docker-hbs-to-nur" t:type="collector-job" t:status="COMPLETED"
2018-06-28T14:13:19.841Z;atsd.internal.command;property t:java_method e:atsd ms:1530195199841 k:host=NURSWGVML007 v:java_method_invoke_last=5
```

`command.log` file format:

```ls
date_received_iso;channel_type;command
```

Each message in the file contains the received date and the channel type, for example:

* `incoming.tcp.raw`
* `atsd.incoming.api.command.raw`
* `atsd.internal.command`

The data command is printed out in the [Network API](../api/network/README.md) syntax and can be replayed on any ATSD instance by uploading the commands via TCP/UDP protocol, [`/api/v1/command`](../api/data/ext/command.md) endpoint, or on the **Data > Data Entry** page.

The retention settings for received commands can be modified in the `logback.xml` file.

:::warning Warning
`FixedWindowRollingPolicy` is deprecated. If your `logback.xml` file contains `FixedWindowRollingPolicy`, replace it with `SizeAndTimeBasedRollingPolicy`.
:::

```xml
<!-- command.log -->
<appender name="commandsLogRoller" class="ch.qos.logback.core.rolling.RollingFileAppender">
    <file>../logs/command.log</file>

    <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
        <!-- rollover daily -->
        <fileNamePattern>../logs/command.%d{yyyy-MM-dd}.%i.log.zip</fileNamePattern>
        <!-- roll over command.log after it reaches 200MB, keep 15 days of history, but at most 10GB -->
        <maxFileSize>200MB</maxFileSize>
        <maxHistory>15</maxHistory>
        <totalSizeCap>10GB</totalSizeCap>
    </rollingPolicy>

    <encoder>
        <pattern>%d{"yyyy-MM-dd'T'HH:mm:ss.SSSXXX",UTC};%logger;%message%n</pattern>
    </encoder>
</appender>
```

To log the data commands without the received date and channel, remove the corresponding fields from the `pattern` tag.

```xml
<encoder>
  <pattern>%message%n</pattern>
</encoder>
```

The `%date{ISO8601}` token formats the date in local time zone using the following pattern `yyyy-MM-dd HH:mm:ss,SSS`.

```txt
2018-06-28 14:11:55,841
```

To print dates in ISO-8601 format in the UTC time zone, change the pattern to `%d{"yyyy-MM-dd'T'HH:mm:ss.SSSXXX",UTC}`.

```txt
2018-06-28T19:11:55.841T
```
