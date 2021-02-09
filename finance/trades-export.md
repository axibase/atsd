# Trades

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
| `class` | **[Required]** Class. |
| `exchange` | Exchange. |
| `startDate` | **[Required]** Start date in [ISO format](../shared/date-format.md#supported-formats) or [calendar](../shared/calendar.md) expression.  |
| `endDate` | **[Required]** End date in [ISO format](../shared/date-format.md#supported-formats) or [calendar](../shared/calendar.md) expression. |
| `timezone` | Time zone for evaluating [calendar expressions](../shared/calendar.md), if specified in `startDate`/`endDate` parameters. |
| `workdayCalendar` | Workday calendar for evaluating [calendar expressions](../shared/calendar.md), if specified in `startDate`/`endDate` parameters. |

## Response

### Header

```csv
datetime,trade_num,side,quantity,price,order_num,session
```

Refer to [insert](command-trade-insert.md#fields) command for field descriptions.

`side`, `order_num`, `session` are printed as empty strings if not available.

## Example

### Request

#### URI

```elm
GET /api/v1/trades?class=TQBR&symbol=GAZP&startDate=2020-12-23T10:00:00Z&endDate=2020-12-24T11:00:00Z
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
datetime,trade_num,side,quantity,price,order_num,session
2020-04-20T10:00:00.000000Z,3177336248,B,123,195.36,1150996,N
```