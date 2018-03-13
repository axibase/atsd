# Alert Logging

Alert Logging records [window](window.md) status changes in the ATSD database and in log files located on the local file system for testing, integration and audit trailing.

## Logging to Database

`OPEN` and `CANCEL` status changes are automatically stored in the database and can be retrieved with [Data API: Alert History Query](../api/data/alerts/history-query.md). The records are visible on the **Alerts: Alert History** page.

In addition, the 'Log to ATSD' checkbox can be enabled for each rule separately to generate messages which can be retrieved with [Data API: Message Query](../api/data/messages/query.md) and are visible on the **Messages** tab. The messages are persisted with `alert` type and `rule-engine` source.

## Logging to Files

Logging to files or even remote systems can be enabled for each rule separately by selecting one of the pre-configured loggers in the `File Logger` drop-down.

Loggers can be added and modified by administrators on the **Settings > Configuration Files > logback.xml** page. Once a new logger is created and the `logback.xml` file is re-scanned, the new logger will appear in the `Alert Logger` drop-down.

![](images/logging-loggers.png)

By default, loggers record `OPEN` and `CANCEL` status changes. To enable logging of `REPEAT` changes, set Repeat Interval from `None` to a valid interval on the 'Alerts' tab in the Rule Editor.

### Default Logger

The default logger named `atsd.alert.default` is available even if it's not defined in the `logback.xml` file. To modify default logger behavior, copy the following text to logback.xml file and adjust its properties as required.

```xml
<appender name="defaultAlertAppender" class="ch.qos.logback.core.rolling.RollingFileAppender">
   <!-- Name of the log file where alert status changes will be stored.
        The path can be absolute or relative to /opt/atsd/atsd directory.
        For example, relative path ../logs/alert.log is resolved to /opt/atsd/atsd/logs/alert.log.  -->
    <file>../logs/alert.log</file>

    <!-- Name of the archived files and their maximum count.
         The files are archived once they cross maxFileSize threshold. -->
    <rollingPolicy class="ch.qos.logback.core.rolling.FixedWindowRollingPolicy">
        <fileNamePattern>../logs/alert.%i.log.zip</fileNamePattern>
        <minIndex>1</minIndex>
        <maxIndex>10</maxIndex>
    </rollingPolicy>

    <!-- Maximum size of the log file. Once the threshold is reached, the files is compressed and rolled over. -->
    <triggeringPolicy class="ch.qos.logback.core.rolling.SizeBasedTriggeringPolicy">
        <maxFileSize>25Mb</maxFileSize>
    </triggeringPolicy>

    <!-- Pattern. The fields can include both pre-defined fields such as %date{ISO8601}, %level, %thread, %logger, %message%n
         as well as placeholders referenced with %X{name}, for example %X{entity} or %X{alert_open_datetime}.
         Available placeholders are listed below. -->
    <encoder>
        <pattern>%message%n</pattern>
    </encoder>
</appender>
<logger name="atsd.alert.default" level="INFO" additivity="false">
    <appender-ref ref="defaultAlertAppender"/>
</logger>
```

### Custom Logger

Custom logger names must start with `atsd.alert.` and should specify a unique file name (including roll-over pattern) that is different from file names used by other loggers. Similarly, custom loggers must specify unique appender names.

Multiple custom loggers can be created to customize alert logging for various rules.

```xml
<appender name="customAppender" class="ch.qos.logback.core.rolling.RollingFileAppender">
    <file>../logs/alert_custom.log</file>

    <rollingPolicy class="ch.qos.logback.core.rolling.FixedWindowRollingPolicy">
        <fileNamePattern>../logs/alert_custom.%i.log.zip</fileNamePattern>
        <minIndex>1</minIndex>
        <maxIndex>5</maxIndex>
    </rollingPolicy>

    <triggeringPolicy class="ch.qos.logback.core.rolling.SizeBasedTriggeringPolicy">
        <maxFileSize>10Mb</maxFileSize>
    </triggeringPolicy>
    <encoder>
        <pattern>%X{rule},%X{entity},%X{alert_open_datetime},%message%n</pattern>
    </encoder>
</appender>
<logger name="atsd.alert.custom" level="INFO" additivity="false">
    <appender-ref ref="customAppender"/>
</logger>
```

### Placeholders

Placeholders can be incorporated in the encoder pattern using the `%X{name}` syntax, for example `%X{entity}` or `%X{alert_open_datetime}`.

**Name**|**Example**
:---|:---
alert_duration | 00:00:05:12
alert_duration_interval |
alert_message | Alert open: ${entity}, ${metric}, ${tags}.
alert_type | OPEN
columns | {memkb = round(value/1024)} - variables
entity | atsd
entity_label | Axibase TSD
entity_tags | {version=community}
entity_tags.tag_name | community
event_tags | {location=dc-5}
expression | value < 512 * 1024 * 1024
metric | jvm_memory_free
open_value | 3103100000
properties |
repeat_count | 0
repeat_interval | 1 MINUTE
rule | memory_low
rule_expression | value < 512 * 1024 * 1024
rule_filter | entity != 'nurswghbs001'
rule_name | memory_low
schedule | * * * * MON-FRI
severity | warning
status | OPEN
tags.tag_name | nurswgvml003
tags | host=nurswgvml003
timestamp | 145678784500 (Unix milliseconds)
value | 3103100000
window | length(1)
threshold | max() > 20

#### Time Placeholders

* alert_open_time
* alert_open_datetime
* received_time
* received_datetime
* event_time
* event_datetime
* window_first_time
* window_first_datetime

> Placeholders ending with `_time` keep time in the local server timezone, for example 2017-05-30 14:05:39 PST.
> Placeholders ending with `_datetime` keep time in ISO 8601 format in UTC timezone, for example 2017-05-30T06:05:39Z.
