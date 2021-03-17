# Export Trades

## Description

Retrieves trades for the instrument in CSV format.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/trades` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `symbol` | **[Required]** Symbol. |
| `class` | **[Required]** Market identifier [code](https://www.iso20022.org/market-identifier-codes) such as `XNGS` for NASDAQ, `XNYS`/`ARCX` for NYSE, `IEXG` for IEX, `SETS`/`SEAQ`/`IOB` for LSE, or `TQBR`/`TQCB`/`CETS` for MOEX. |
| `exchange` | Exchange or trading venue name, such as `NASDAQ`, `NYSE`, `IEX`, `LSE`, `MOEX`. |
| `startDate` | **[Required]** Start date in [ISO format](../shared/date-format.md#supported-formats) or [calendar](../shared/calendar.md) expression.  |
| `endDate` | **[Required]** End date in [ISO format](../shared/date-format.md#supported-formats) or [calendar](../shared/calendar.md) expression. |
| `timezone` | Time zone for evaluating [calendar expressions](../shared/calendar.md), if specified in `startDate`/`endDate` parameters. |
| `workdayCalendar` | Workday calendar for evaluating [calendar expressions](../shared/calendar.md), if specified in `startDate`/`endDate` parameters. |

## Response

### Header

```txt
datetime,trade_num,side,quantity,price,order_num,session
```

Refer to [insert](command-trade-insert.md#fields) command for field descriptions.

Optional fields such as `side`, `order_num`, `session` are printed as empty strings if not available.

## Examples

* Interval between `2021-01-13 19:00:00` and `2021-01-13 19:05:00` in UTC time zone.

```elm
GET /api/v1/trades?class=IEXG&symbol=TSLA&startDate=2021-01-13T19%3A00%3A00Z&endDate=2021-01-13T19%3A05%3A00Z
```

* Interval between `2021-01-13 14:00:00` and `2021-01-13 14:05:00` in `US/Eastern` time zone.

```elm
GET /api/v1/trades?class=IEXG&symbol=TSLA&startDate=2021-01-13T14%3A00%3A00-05%3A00&endDate=2021-01-13T14%3A05%3A00-05%3A00
```

* Current trading day

```elm
GET /api/v1/trades?class=IEXG&symbol=TSLA&startDate=current_working_day&endDate=now
```

### curl Example

```bash
curl "https://atsd_hostname:8443/api/v1/trades?class=IEXG&symbol=TSLA&startDate=2021-01-13%2014%3A00%3A00-05%3A00&endDate=2021-01-13%2014%3A05%3A00-05%3A00" \
 --insecure --include --header "Authorization: Bearer ****"
```

```txt
datetime,trade_num,side,quantity,price,order_num,session
2021-01-13T19:00:06.859843Z,1367042482,,100,843.67,,N
2021-01-13T19:00:11.573151Z,1367352219,,100,843.63,,N
2021-01-13T19:00:18.013559Z,1368945732,,16,844.2,,N
```

## SQL Alternative

```sql
SELECT symbol, class, datetime, trade_num, price, quantity, session, side, order_num
  FROM atsd_trade
WHERE class = 'IEXG' AND symbol = 'TSLA'
  AND datetime BETWEEN '2021-01-13 14:00:00' and '2021-01-13 14:05:00'
  --AND datetime BETWEEN current_day and now
ORDER BY datetime, trade_num
  LIMIT 100
```