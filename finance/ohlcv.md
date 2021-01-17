# OHLCV

## Description

Retrieves aggregated period statistics for the instrument in CSV format.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/ohlcv` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `symbol` | **[Required]** Symbol. |
| `class` | **[Required]** Class. |
| `exchange` | Exchange. |
| `startDate` | **[Required]** Start date in [ISO format](../shared/date-format.md#supported-formats) or [calendar](../shared/calendar.md) expression.  |
| `endDate` | **[Required]** End date in [ISO format](../shared/date-format.md#supported-formats) or [calendar](../shared/calendar.md) expression. |
| `timezone` | Time zone for evaluating [calendar expressions](../shared/calendar.md), if specified in `startDate`/`endDate` parameters. |
| `workdayCalendar` | Workday calendar for evaluating [calendar expressions](../shared/calendar.md), if specified in `startDate`/`endDate` parameters. |
| `period` | **[Required]** Period for calculating statistics formatted as `<unit> <count>` such as `1 HOUR` based on [calendar alignment](../api/data/series/period.md#alignment). |
| `statistics` | List of [statistic](#statistics) names `statistics=name[,name]`<br>Default is `open,high,low,close,volume`. |

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

```csv
datetime,open,high,low,close,volume
```

All:

```csv
datetime,open,high,low,close,volume,count,vwap,amount
```

## Example

### Request

#### URI

```elm
GET /api/v1/ohlcv?class=TQBR&symbol=GAZP&startDate=2020-12-23T00:00:00Z&endDate=2020-12-24T00:00:00Z&period=15%20MINUTE
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/trades?class=TQBR&symbol=GAZP&startDate=2020-12-23T00:00:00Z&endDate=2020-12-24T00:00:00Z \
 --insecure --include --user {username}:{password}
```

### Response

```csv
datetime,open,high,low,close,volume
2020-04-20T10:00:00.000000Z,8.0,12.0,7.0,10,14200
```