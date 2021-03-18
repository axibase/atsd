# Export Snapshots

## Description

Retrieves **stored** OHLCV bars in CSV format. The stored bars are created by inserting OHLCV records using the [`OHLCV: insert`](./session-summary-import-ohlcv.md) endpoint.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/trade-session-summary/export` |

### Query Parameters

| **Name** | **Description** | **Example** |
|-----------|----------------|--------------|
| `symbol` | **[Required]** Symbol. |
| `class` | **[Required]** Market identifier [code](https://www.iso20022.org/market-identifier-codes) such as `XNGS` for NASDAQ, `XNYS`/`ARCX` for NYSE, `IEXG` for IEX, `SETS`/`SEAQ`/`IOB` for LSE, or `TQBR`/`TQCB`/`CETS` for MOEX. |
| `exchange` | Exchange or trading venue name, such as `NASDAQ`, `NYSE`, `IEX`, `LSE`, `MOEX`. |
| `startDate`  | **[Required]** Start date in [ISO format](../shared/date-format.md#supported-formats), inclusive | `"2021-01-01T00:00:00Z"` |
| `endDate`  | **[Required]** End date in [ISO format](../shared/date-format.md#supported-formats), exclusive | `"2022-01-01T00:00:00Z"` |
| `session` | Session name.  All session types are retrieved if not specified. | `DAY` |
| `stage` | Session stage. All stages are retrieved if not specified. | `O` |
| `fields` | List of statistics to include in the response.<br>If specified, `datetime`, `symbol`, and at least one [statistics](statistics-fields.md) field must be present.<br>If not specified, `datetime,session,stage,symbol,class,exchange` + all statistics are returned. | `datetime,class,symbol,open,high,low,close,vwap,voltoday,numtrades` |

:::tip Note
`symbol`, `class`, `session`, and `stage` fields can enumerate multiple values specified as a comma-separated list `symbol=A,B` or multiple parameters in the query string `&symbol=A&symbol=B`.
:::

## Example

```elm
GET /api/v1/trades?class=IEXG&symbol=TSLA&startDate=2021-02-10T00%3A00%3A00Z&endDate=2021-02-11T00%3A00%3A00Z&fields=datetime,class,symbol,open,high,low,close,vwap,voltoday,numtrades
```

```txt
datetime,class,symbol,close,openinterest
2021-02-10T20:45:00.000Z,XCBO,VIX20210216P00035000,10.22,34502
2021-02-10T20:45:00.000Z,XCBO,VIX20210216P00040000,15.12,18103
```