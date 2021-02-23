# Statistics

To insert a Level 1 statistics such as best bid or offer or daily volume into the database, send the command in the specified format to TCP port `8091` or UDP port `8092`.

```bash
echo -e "TQBR,GAZP,1610622170591,5,0=674451,9=199,5=4534,1=674450,4=477227,10=227.05" | gzip > /dev/tcp/atsd_hostname/8091
```

The commands must be terminated by line break. Multiple commands can be sent over the same connection. The content must be compressed with `gzip`.

## Format

```bash
class,symbol,unix_time,fractions,key=value[,key=value]
```

## Example

```ls
TQBR,GAZP,1610622170591,5,4=477227,5=4534,9=199,10=227.05
```

The event time is `2021-01-14T11:02:50.591005Z`

|Code|Name|Value|
|---:|:---|---:|
|4 | `biddeptht` | 477227 |
|5 | `numbids` | 4534 |
|9 | `biddepth` | 199 |
|10 | `bid` | 227.05 |

## Fields

|Name|Type|Required|Example|Description|
|:---|:---|:---|:---|:---|
|class|string|yes|TQBR| Order book system identifier where trade is executed such as `SETS`/`SEAQ`/`IOB` for LSE or `TQBR`/`TQCB`/`CETS` for MOEX.|
|symbol|string|yes|GAZP| Security symbol.|
|unix_time|long|yes|1588230831048| Transaction time in Unix milliseconds.|
|fractions|integer|yes|469| Microsecond/nanosecond part of the transaction time. <br>0 if sub-millisecond precision is not supported by exchange.|
|key|integer|yes|10|Field [code](./statistics-fields.md)|
|value|various|yes|227.05|Field value|

## Notes

* Class and exchange fields can contain alphanumeric characters and one of the following characters: `.`, `-`, `_`, `[`, `]`, `+`, `/`. Whitespace characters are not allowed.

* Symbol field can contain alphanumeric characters and one of the following characters: `.`, `-`, `_`, `[`, `]`, `+`, `/`, `@`. Whitespace characters are not allowed.

* Class and symbol fields are case-insensitive.

* New instruments are automatically registered as entities with name `<symbol>_[<class>]`, for example `gazp_[tqbr]` for class `TQBR` and symbol `GAZP`.

* If the number of digits in `fractions` field exceeds 3, it is treated as nanoseconds, microseconds otherwise. `0003` counts as 3 nanoseconds, while `3` as 3000 nanoseconds.

* When sending multiple commands over the same connection, separate commands with a `\n` line break.

## Logging

Incoming statistics are logged in `statistics.log` file by default. The logging [settings](../administration/logging.md) can be configured on **Admin > Configuration > Configuration Files** page.

Invalid commands are logged in `command_malformed.log` file.

```xml
<appender name="statistics.csv.appender" class="ch.qos.logback.core.rolling.RollingFileAppender">
  <file>../logs/statistics.log</file>
  <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
      <fileNamePattern>../logs/statistics.%d{yyyy-MM-dd}.%i.log.zip</fileNamePattern>
      <maxFileSize>200MB</maxFileSize>
      <maxHistory>10</maxHistory>
      <totalSizeCap>10GB</totalSizeCap>
  </rollingPolicy>
  <encoder class="com.axibase.tsd.log.LogbackEncoder">
      <pattern>%d{"yyyy-MM-dd'T'HH:mm:ss.SSSXXX",UTC};%message%n</pattern>
  </encoder>
</appender>
```