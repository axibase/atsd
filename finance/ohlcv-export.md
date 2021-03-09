# OHLCV

## Description

Retrieves OHLCV and VWAP period statistics (candlesticks, bars) for the instrument in CSV format.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/ohlcv` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `symbol` | **[Required]** Symbol. |
| `class` | **[Required]** Market identifier [code](https://www.iso20022.org/market-identifier-codes) such as `XNGS` for NASDAQ, `XNYS`/`ARCX` for NYSE, `IEXG` for IEX, `SETS`/`SEAQ`/`IOB` for LSE, or `TQBR`/`TQCB`/`CETS` for MOEX. |
| `exchange` | Exchange or trading venue name, such as `NASDAQ`, `NYSE`, `IEX`, `LSE`, `MOEX`. |
| `startDate` | **[Required]** Start date in [ISO format](../shared/date-format.md#supported-formats) or [calendar](../shared/calendar.md) expression.  |
| `endDate` | **[Required]** End date in [ISO format](../shared/date-format.md#supported-formats) or [calendar](../shared/calendar.md) expression. |
| `period` | **[Required]** Period for calculating statistics formatted as `<unit> <count>` such as `1 HOUR` based on [calendar alignment](../api/data/series/period.md#alignment). |
| `statistics` | List of [statistic](#statistics) names `statistics=name[,name]`<br>Default is `open,high,low,close,volume`. |
| `timezone` | Time zone for evaluating [calendar expressions](../shared/calendar.md), if specified in `startDate`/`endDate` parameters. |
| `workdayCalendar` | Workday calendar for evaluating [calendar expressions](../shared/calendar.md), if specified in `startDate`/`endDate` parameters. |

### Statistics

* `open` - Price of the first trade in the period.
* `high` - Highest price in the period.
* `low` - Lowest price in the period.
* `close` - Price of the last trade in the period.
* `volume` - Sum of all trade quantities in the period `SUM(quantity)`
* `count` - Number of trades in the period.
* `vwap` - Volume-weighed average price.
* `amount` - Total value of trades in the period `SUM(price * quantity * entity.tags.lot)`.

## Response

### Header

Default:

```txt
datetime,open,high,low,close,volume
```

All:

```txt
datetime,open,high,low,close,volume,count,vwap,amount
```

## Example

### Request

#### URI

* 1-minute OHLCV bars between `2021-01-13 19:00:00` and `2021-01-13 19:05:00` in UTC time zone.

```elm
GET /api/v1/ohlcv?class=IEXG&symbol=TSLA&startDate=2021-01-13T19%3A00%3A00Z&endDate=2021-01-13T19%3A05%3A00Z&period=1%20MINUTE
```

* 1-minute OHLCV bars between `2021-01-13 14:00:00` and `2021-01-13 14:05:00` in `US/Eastern` time zone.

```elm
GET /api/v1/ohlcv?class=IEXG&symbol=TSLA&startDate=2021-01-13T14%3A00%3A00-05%3A00&endDate=2021-01-13T14%3A05%3A00-05%3A00&period=1%20MINUTE
```

* 1-hour bars for the current trading day

```elm
GET /api/v1/ohlcv?class=IEXG&symbol=TSLA&startDate=current_working_day&endDate=now&period=1%20HOUR
```

#### Payload

None.

#### curl

```bash
curl "https://atsd_hostname:8443/api/v1/ohlcv?class=IEXG&symbol=TSLA&startDate=2021-01-13T19%3A00%3A00Z&endDate=2021-01-13T19%3A05%3A00Z&period=1%20MINUTE" \
 --insecure --include --user {username}:{password}
```

### Response

```txt
datetime,open,high,low,close,volume
2021-01-13T19:00:00.000Z,843.67,844.38,843.02,843.88,910
2021-01-13T19:01:00.000Z,843.95,845.36,843.95,844.56,895
2021-01-13T19:02:00.000Z,845.48,845.48,844.83,844.97,503
2021-01-13T19:03:00.000Z,845.25,845.35,844.21,844.65,996
2021-01-13T19:04:00.000Z,844.85,846.97,844.85,846.96,1178
```

### SQL Alternative

```sql
SELECT datetime, open(), high(), low(), close(), volume(), vwap()
  FROM atsd_trade
WHERE class = 'IEXG' AND symbol = 'TSLA'
  AND datetime between '2021-01-13 14:00:00' and '2021-01-13 14:05:00'
GROUP BY exchange, class, symbol, PERIOD(1 MINUTE)
  ORDER BY datetime
```