# Trades

To insert a trade into the database, send the command in the specified format to TCP port `8085` or UDP port `8086`.

```bash
echo -e "19351405492193896,1588286697000,974890,TQBR,GAZP,MOEX,B,48,33.38," > /dev/tcp/atsd_hostname/8085
```

The commands must be terminated by line break. Multiple commands can be sent over the same connection.

Timestamp precision is microseconds.

## Format

```bash
trade_num,unix_time,microseconds,class,symbol,exchange,side,quantity,price,order_num[,session][,field-1,..field-N]
```

## Examples

```ls
3177336248,1588230831048,469,TQBR,GAZP,MOEX,B,123,195.36,1150996,N
```

The trade time is `2020-04-30T07:13:51.048469Z`

```ls
19351405492176528,1588283343000,645713,IOB,SMSN,LSE,B,1,33.32,
```

The trade time is `2020-04-30T21:49:03.645713Z`

## Fields

|Name|Type|Required|Example|Description|
|:---|:---|:---|:---|:---|
|trade_num|long|yes|3177336248| Trade number assigned by the exchange.|
|unix_time|long|yes|1588230831048| Transaction time in Unix milliseconds.|
|microseconds|integer|yes|469| Microsecond part of the trade time. <br>0 if sub-millisecond precision is not supported by exchange.|
|class|string|yes|TQBR| Order book system identifier where trade is executed such as `SETS`/`SEAQ`/`IOB` for LSE or `TQBR`/`TQCB`/`CETS` for MOEX.|
|symbol|string|yes|GAZP| Security symbol.|
|exchange|string|no|MOEX| Exchange [identifier](https://www.iso20022.org/market-identifier-codes), such as `NYSE`, `LSE`, `MOEX`, or a market data provider name. If empty, `trade.exchange.default.value` is used.|
|side|string|no|B| Trade direction: `B` (buy), `S` (sell), or empty, based on the direction of the initiating (taker) order.|
|quantity|long|yes|123| Quantity in the trade. Non-negative.|
|price|decimal|yes|195.36| Price of the trade. Can be negative.|
|order_num|long|no|1150996| Order number which initiated the trade (taker).|
|session|string|no|E| Exchange-specific [trading session and auction code](#trading-session-codes), such as `N` or `O`.|

## Notes

* Class and exchange fields can contain alphanumeric characters and one of the following characters: `.`, `-`, `_`, `[`, `]`, `+`, `/`. Whitespace characters are not allowed.

* Symbol field can contain alphanumeric characters and one of the following characters: `.`, `-`, `_`, `[`, `]`, `+`, `/`, `@`. Whitespace characters are not allowed.

* Class, exchange, and symbol fields are case-insensitive.

* New instruments are automatically registered as entities with name `<symbol>_[<class>]`, for example `gazp_[tqbr]` for class `TQBR` and symbol `GAZP`.

* If the value of `microseconds` field exceeds 1000, it is added to milliseconds. `1588283343000,645713` is the same as `1588283343645,713`.

* Price can be negative or zero.

* Field specified after the `session` field are not stored in the database however are logged in the `trades.log` file and can be used for latency monitoring and tracing.

* When sending multiple commands over the same connection, separate commands with a `\n` line break.

* To correct fields in an existing trade, submit a new command for the same `trade_num` and instrument identifier fields.

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

## Logging

Incoming trades are logged in `statistics.log` file by default. The logging [settings](../administration/logging.md) can be configured on **Admin > Configuration > Configuration Files** page.

Invalid commands are logger in `command_malformed.log` file.

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