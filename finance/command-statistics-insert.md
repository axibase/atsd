# Insert Statistics

The endpoint consumes a stream of order book [statistics](./statistics-fields.md) in plain text format on port `8091` (TCP) or port `8092` (UDP). Each line can contain multiple fields such as current daily volume, last price, auction volume etc.

```bash
echo -e "IEXG,TSLA,1610622170591,5,16=845.15,17=100,42=845.15" | gzip > /dev/tcp/atsd_hostname/8091
```

The content **must be compressed** with `gzip`.

## Format

```bash
class,symbol,unix_time,fractions,key=value[,key=value]
```

## Example

```ls
IEXG,TSLA,1610622170591,5,16=845.15,17=100,42=845.15
```

The event time is `2021-01-14T11:02:50.591005Z`

|Code|Name|Value| Description|
|---:|:---|---:|---:|
|16 | `last` | 845.15 | Price of the last trade |
|17 | `qty` | 100 | Number of shares in the last trade |
|42 | `high` | 845.15 | Maximum trade price during the current trading session |

## Fields

|Name|Type|Required|Example|Description|
|:---|:---|:---|:---|:---|
|class|string|yes|TQBR| Market identifier [code](https://www.iso20022.org/market-identifier-codes) such as `XNGS` for NASDAQ, `XNYS`/`ARCX` for NYSE, `IEXG` for IEX, `SETS`/`SEAQ`/`IOB` for LSE, or `TQBR`/`TQCB`/`CETS` for MOEX. |
|symbol|string|yes|TSLA| Instrument symbol.|
|unix_time|long|yes|1610622170591| Transaction time in Unix milliseconds.|
|fractions|integer|yes|469| Microsecond/nanosecond part of the transaction time. <br>0 if sub-millisecond precision is not supported by exchange.|
|key|integer|yes|10|Field [code](./statistics-fields.md)|
|value|various|yes|227.05|Field value|

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
ls -rt statistics.$(date '+%Y-%m-%d').* statistics.log | xargs zgrep -ih "IEXG,TSLA" | grep -E ",(42|47)="
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
  STAT.accruedint,
  STAT.action,
  STAT.admittedquote,
  STAT.assured,
  STAT.auctnumtrades,
  STAT.auctprice,
  STAT.auctvalue,
  STAT.auctvolume,
  STAT.bid,
  STAT.biddepth,
  STAT.biddeptht,
  STAT.biddeptht_0,
  STAT.change,
  STAT.changetime,
  STAT.chngclose,
  STAT.close,
  STAT.close_adj,
  STAT.closeprice,
  STAT.closeyield,
  STAT.crossrate,
  STAT.currentvalue,
  STAT.custom_num_01,
  STAT.custom_num_02,
  STAT.custom_num_03,
  STAT.custom_num_04,
  STAT.custom_num_05,
  STAT.custom_num_06,
  STAT.custom_num_07,
  STAT.custom_num_08,
  STAT.custom_num_09,
  STAT.custom_num_10,
  STAT.darkpool,
  STAT.datetime,  
  STAT.duration,
  STAT.high,
  STAT.highbid,
  STAT.highlimitpx,
  STAT.highval,
  STAT.icapital,
  STAT.imbalance,
  STAT.initialmarginonbuy,
  STAT.initialmarginonsell,
  STAT.initialmarginsyntetic,
  STAT.iopen,
  STAT.ivolume,
  STAT.last,
  STAT.lastbid,
  STAT.lastoffer,
  STAT.lastvalue,
  STAT.lcloseprice,
  STAT.lcurrentprice,
  STAT.low,
  STAT.lowlimitpx,
  STAT.lowoffer,
  STAT.lowval,
  STAT.marketprice,
  STAT.marketprice2,
  STAT.marketpricetoday,
  STAT.marketvolb,
  STAT.marketvols,
  STAT.min_curr_last,
  STAT.min_curr_last_ti,
  STAT.national_bid,
  STAT.national_biddepth,
  STAT.national_offer,
  STAT.national_offerdepth,
  STAT.nfaprice,
  STAT.numbids,
  STAT.numbids_0,
  STAT.numcontracts,
  STAT.numoffers,
  STAT.numoffers_0,
  STAT.numtrades,
  STAT.offer,
  STAT.offerdepth,
  STAT.offerdeptht,
  STAT.offerdeptht_0,
  STAT.open,
  STAT.openinterest,
  STAT.openperiodprice,
  STAT.plannedtime,
  STAT.prevadmittedquot,
  STAT.prevdate,
  STAT.prevlegalclosepr,
  STAT.prevprice,
  STAT.prevsettlprice,
  STAT.prevwaprice,
  STAT.priceminusprevwa,
  STAT.qty,
  STAT.repoterm,
  STAT.root_bid,
  STAT.root_last,
  STAT.root_offer,
  STAT.rptseq,
  STAT.rptseq_st,
  STAT.settledate,
  STAT.settledate1,
  STAT.settledate2,
  STAT.settleprice,
  STAT.settlpriceopen,
  STAT.snapshot_datetime,
  STAT.snapshot_start_datetime,
  STAT.starttime,
  STAT.theorprice,
  STAT.theorpricelimit,
  STAT.time,
  STAT.tradingsession,
  STAT.underlying_bid,
  STAT.underlying_last,
  STAT.underlying_offer,
  STAT.valtoday,
  STAT.value,
  STAT.volatility,
  STAT.voltoday,
  STAT.vwap,
  STAT.waprice,
  STAT.yield,
  STAT.yieldatprevwapr,
  STAT.yieldatwaprice
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