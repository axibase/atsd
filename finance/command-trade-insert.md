# Insert Trades

The endpoint consumes a stream of trades in CSV format on port `8085` (TCP) or port `8086` (UDP). It provides a simple alternative to binary protocols such as FAST, SBE, and proprietary specifications.

```bash
echo -e "2415548,1614603602208,492,IEXG,TSLA,IEX,,5,688.57,,X,96" | nc -q 0 atsd_hostname 8085
```

To insert multiple commands from file:

```bash
# Skip header with tail
tail -n +2 trades.csv | nc -q 0 atsd_hostname 8085
```

```bash
tar -xzOf trades.csv.tar.gz | tail -n +2 | nc -q 0 atsd_hostname 8085
```

The endpoint is primarily used by market data consumer applications.

## Fields

```bash
trade_num,unix_time,microseconds,class,symbol,exchange,side,quantity,price,order_num[,session][,field-1,..field-N]
```

## Fields

|Name|Type|Required|Example|Description|
|:---|:---|:---|:---|:---|
|trade_num|long|yes|3177336248| Trade number assigned by the exchange.|
|unix_time|long|yes|1588230831048| Transaction time in Unix milliseconds.|
|microseconds|integer|yes|469| Microsecond part of the trade time. <br>0 if sub-millisecond precision is not provided by data feed.|
|class|string|yes|IEXG| Market identifier [code](https://www.iso20022.org/market-identifier-codes) such as `XNGS` for NASDAQ, `XNYS`/`ARCX` for NYSE, `IEXG` for IEX, `SETS`/`SEAQ`/`IOB` for LSE, or `TQBR`/`TQCB`/`CETS` for MOEX. |
|symbol|string|yes|TSLA| Instrument symbol.|
|exchange|string|no|IEX| Exchange or trading venue name, such as `NASDAQ`, `NYSE`, `IEX`, `LSE`, `MOEX`, or a market data provider name. If empty, `trade.exchange.default.value` is used.|
|side|string|no|B| Trade direction: `B` (buy), `S` (sell), or empty, if not available in the data feed. Typically based on the direction of the initiating (taker) order.|
|quantity|long|yes|123| Size of the trade. Non-negative.|
|price|decimal|yes|195.36| Price of the trade. Can be negative.|
|order_num|long|no|1150996| Order number which initiated the trade (taker).|
|session|string|no|E| Exchange-specific [trading session and auction code](#trading-session-codes), such as `N` (normal) or `X` (extended).|

## Example

```ls
2415548,1614603602208,492,IEXG,TSLA,IEX,,5,688.57,,X,96
```

* `trade_num`: `2415548`
* `timestamp`: `2021-03-01T13:00:02.208492Z`
* `class`: `IEXG`
* `symbol`: `TSLA`
* `exchange`: `IEX`
* `quantity`: `5`
* `price`: `688.57`
* `session`: `X`
* `saleCondition`: `96` (custom field)

## Notes

* Class and exchange fields can contain alphanumeric characters and one of the following characters: `.`, `-`, `_`, `[`, `]`, `+`, `/`. Whitespace characters are not allowed.

* Symbol field can contain alphanumeric characters and one of the following characters: `.`, `-`, `_`, `[`, `]`, `+`, `/`, `@`, `=`. Whitespace characters are not allowed.

* Class, exchange, and symbol fields are case-insensitive.

* New instruments are automatically registered with entity name `<symbol>_[<class>]`, for example `tsla_[iexg]` for class `IEXG` and symbol `TSLA`.

* If the value of `microseconds` field exceeds 1000, it is added to milliseconds. `1588283343000,645713` is the same as `1588283343645,713`.

* Price can be negative or zero.

* Field specified after the `session` field are not stored in the database however are logged in the `trades.log` file and can be used for latency monitoring and tracing.

* When sending multiple commands over the same connection, separate commands with a line break.

* To modify an existing trade, send a new command with the same `trade_num` and instrument identifier fields.

## Trading Session Codes

| Code | Identifier | Description | Trade Stage |
|:---|---:|:---|---|
| S | 1 | `OPENING_AUCTION_CALL` | No |
| O | 2 | `OPENING_AUCTION` | Yes |
| N | 3 | `REGULAR_TRADING` | Yes |
| L | 4 | `CLOSING_AUCTION` | Yes |
| E | 5 | `CLOSING_AUCTION_POST_CROSSING` | Yes |
| I | 6 | `DISCRETE_AUCTION` | Yes |
| D | 7 | `DARK_POOL_AUCTION` | Yes |
| A | 8 | `AUCTION_ORDER_ENTRY` | No |
| a | 9 | `AUCTION_TRADE_CONCLUSION` | No |
| b | 10 | `AUCTION_BOOKBUILDING` | No |
| p | 11 | `AFTER_AUCTION_TRADE` | Yes |
| C | 12 | `CLOSING` | Yes |
| NA | 13 | `NON_ACTIVE` | No |
| M | 14 | `PRE_MARKET` | Yes |
| V | 15 | `AFTER_MARKET` | Yes |
| X | 16 | `EXTENDED_TRADING` | Yes |

## Logging

Trade commands are [logged](../administration/logging.md) in `trade.log` file located in the `./atsd/logs` directory.

```sh
# search today's archives and the current statistics.log sorted by time
ls -rt trade.$(date '+%Y-%m-%d').* trade.log | xargs zgrep -ih "IEXG,TSLA"
```

The logging [settings](../administration/logging.md) can be configured on **Admin > Configuration > Configuration Files** page.

Invalid commands are logged in `command_malformed.log` file.

```xml
<appender name="trade.csv.appender" class="ch.qos.logback.core.rolling.RollingFileAppender">
    <file>../logs/trades.log</file>
    <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
        <fileNamePattern>../logs/trades.%d{yyyy-MM-dd}.%i.log.zip</fileNamePattern>
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

* UI **Trade Viewer** page, instrument overview page.

* SQL using [`atsd_trade`](./sql.md#atsd_trade-table) table:

```sql
SELECT symbol, class, datetime, trade_num, price, quantity, session, side, order_num
  FROM atsd_trade
WHERE class = 'IEXG' AND symbol = 'TSLA'
  AND datetime BETWEEN '2021-01-13 14:00:00' and '2021-01-13 14:05:00'
  --AND datetime BETWEEN current_day and now
ORDER BY datetime, trade_num
  LIMIT 100
```

```sql
SELECT datetime, open(), high(), low(), close(), volume(), vwap()
  FROM atsd_trade
WHERE class = 'IEXG' AND symbol = 'TSLA'
  AND datetime between '2021-01-13 14:00:00' and '2021-01-13 14:05:00'
GROUP BY exchange, class, symbol, PERIOD(1 MINUTE)
  ORDER BY datetime
```

* API [`trades export`](./trades-export.md) endpoint:

```elm
GET /api/v1/trades?class=IEXG&symbol=TSLA&startDate=2020-12-23T10:00:00Z&endDate=2020-12-24T11:00:00Z
```

* API [`ohlcv export`](./ohlcv-export.md) endpoint:

```elm
GET /api/v1/ohlcv?class=IEXG&symbol=TSLA&startDate=2020-12-23T00:00:00Z&endDate=2020-12-24T00:00:00Z&period=15%20MINUTE
```