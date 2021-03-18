# Export Snapshots

## Description

Retrieves order book snapshots in CSV format.

An order book snapshot describes the book state for the specified instrument at a particular point of time during the trading day. The snapshot can include a large set of current and intraday [statistics](statistics-fields.md) and is primarily used to capture the book state at the start and the end of trading sessions as well as during the auction stages.

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
| `session` | Session name, one of `Morning`, `Day`, `Evening`.<br>Default value: `Day` | `Day` |
| `stage` | Session [stage](./sessions.md).<br>Default value: `N` | `O` |
| `fields` | List of statistics to include in the response.<br>If specified, `datetime`, `symbol`, and at least one [statistics](statistics-fields.md) field are required. | `datetime,class,symbol,close,openinterest` |

:::tip Note
`symbol`, `class`, `session`, and `stage` fields can enumerate multiple values specified as a comma-separated list `symbol=A,B` or multiple parameters in the query string `&symbol=A&symbol=B`.
:::

## Example

```elm
GET /api/v1/trade-session-summary/export?class=IEXG&symbol=TSLA,AAPL&stage=E&startDate=2021-01-13T00%3A00%3A00Z&endDate=2021-01-14T00%3A00%3A00Z&fields=datetime,class,symbol,session,stage,auctvolume,auctprice,imbalance
```

```txt
datetime,class,symbol,session,stage,auctvolume,auctprice,imbalance
2021-01-13T21:00:01.859Z,IEXG,TSLA,Day,E,34500,843.67,-8200
2021-01-13T21:00:01.859Z,IEXG,AAPL,Day,E,50100,128.91,15400
```