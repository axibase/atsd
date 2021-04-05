# Insert Quotes

The endpoint consumes a stream of Level 1 (Top of book) quotes in plain text format on port `8091` (TCP) or port `8092` (UDP). Each line can contain one or multiple field codes such as best bid, best bid size, total number of bids etc.

```bash
echo -e "IEXG,TSLA,1610622170591,5,9=199,10=845.15" | gzip | nc -q 0 atsd_hostname 8091
```

The content **must be compressed** with `gzip`.

## Format

```bash
class,symbol,unix_time,fractions,key=value[,key=value]
```

## Field Codes

|Code|Name|Type|Short Name | Description|
|---:|:---|---:|:---|:---|
| 10 | `bid` | DECIMAL | Bid | Best bid price |
| 9 | `biddepth` | LONG | Best bid size | Unmatched volume of all active buy orders at the current best bid price |
| 7 | `offer` | DECIMAL | Offer | Best offer price |
| 6 | `offerdepth` | LONG | Best offer depth | Unmatched volume of all active sell orders at the best price |

## Example

```ls
IEXG,TSLA,1610622170591,5,9=199,10=845.15
```

The event time is `2021-01-14T11:02:50.591005Z`

|Code|Name|Value|
|---:|:---|---:|
|9 | `biddepth` | 199 |
|10 | `bid` | 845.15 |

## Fields

|Name|Type|Required|Example|Description|
|:---|:---|:---|:---|:---|
|class|string|yes|TQBR| Market identifier [code](https://www.iso20022.org/market-identifier-codes) such as `XNGS` for NASDAQ, `XNYS`/`ARCX` for NYSE, `IEXG` for IEX, `SETS`/`SEAQ`/`IOB` for LSE, or `TQBR`/`TQCB`/`CETS` for MOEX. |
|symbol|string|yes|TSLA| Instrument symbol.|
|unix_time|long|yes|1610622170591| Transaction time in Unix milliseconds.|
|fractions|integer|yes|469| Microsecond/nanosecond part of the transaction time. <br>0 if sub-millisecond precision is not supported by exchange.|
|key|integer|yes|10|Field code.|
|value|various|yes|227.05|Field value.|

## Notes

* Class and exchange fields can contain alphanumeric characters and one of the following characters: `.`, `-`, `_`, `[`, `]`, `+`, `/`. Whitespace characters are not allowed.

* Symbol field can contain alphanumeric characters and one of the following characters: `.`, `-`, `_`, `[`, `]`, `+`, `/`, `@`, '+'. Whitespace characters are not allowed.

* Class and symbol fields are case-insensitive.

* New instruments are automatically registered with entity name `<symbol>_[<class>]`, for example `tsla_[iexg]` for class `IEXG` and symbol `TSLA`.

* If the number of digits in `fractions` field exceeds 3, it is treated as nanoseconds, microseconds otherwise. `0003` counts as 3 nanoseconds, while `3` as 3000 nanoseconds.

* When sending multiple commands over the same connection, separate commands with a line break.

## Logging

Statistics commands are [logged](../administration/logging.md) in `statistics.log` file located in the `./atsd/logs` directory.

```sh
# search today's archives and the current statistics.log sorted by time
ls -rt statistics.$(date '+%Y-%m-%d').* statistics.log | xargs zgrep -ih "IEXG,TSLA" | grep -E ",(9|10)="
```

The logging [settings](../administration/logging.md) can be configured on **Admin > Configuration > Configuration Files** page.

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

## Validating Results

* UI:

```elm
https://atsd_hostname:8443/financial/instrument/properties/statistics?entity=TSLA_[IEXG]
```

* SQL using [`STAT`](./sql.md#stat) function accessible in `atsd_trade`, `atsd_entity`, `atsd_session_summary` tables:

```sql
SELECT name,
  STAT.bid,
  STAT.biddepth,
  STAT.offer,
  STAT.offerdepth
FROM atsd_entity
  WHERE tags.class_code = 'IEXG' AND tags.symbol = 'TSLA'
```

* API using [`property query`](../api/data/properties/query.md) endpoint:

```elm
POST /api/v1/properties/query
```

```json
[{
  "type": "statistics",
  "entity": "tsla_[iexg]",
  "startDate": "1970-01-01T00:00:00Z",
  "endDate":   "now",
  "merge": true
}]
```