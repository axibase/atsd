# Export Statistics History

The endpoint retrieves statistics history for the instrument in CSV format.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/trade-statistics/export` |

### Payload Parameters

| **Name** | **Description** |
|:---|:---|
| `symbol` | **[Required]** Instrument symbol. |
| `class` | **[Required]** Market identifier [code](https://www.iso20022.org/market-identifier-codes) such as `XNGS` for NASDAQ, `XNYS`/`ARCX` for NYSE, `IEXG` for IEX, `SETS`/`SEAQ`/`IOB` for LSE, or `TQBR`/`TQCB`/`CETS` for MOEX.  |
| `exchange` | Exchange or trading venue name, such as `NASDAQ`, `NYSE`, `IEX`, `LSE`, `MOEX`. |
| `startDate` | **[Required]** Export interval start time in ISO format or using [calendar expressions](../shared/calendar.md).  |
| `endDate` | **[Required]** Export interval end time in ISO format or using [calendar expressions](../shared/calendar.md).  |
| `fields` | List of columns to include in the response.<br>If specified, `datetime` and at least one [statistics](statistics-fields.md) field are required.  |

```txt
GET /api/v1/trade-statistics/export?symbol=MOEX&class=TQBR&startDate=2021-04-16T16:00:00Z&endDate=2021-04-16T16:02:00Z&fields=datetime,bid,offer
```

## Response

### Payload

```csv
datetime,bid,offer
2021-04-16T16:01:09.975729Z,158.34,
2021-04-16T16:01:27.499487Z,,169.38
2021-04-16T16:01:30.515247Z,162.99,
2021-04-16T16:01:32.511178Z,,169.38
2021-04-16T16:01:35.523046Z,162.99,
2021-04-16T16:01:37.518997Z,,169.67
2021-04-16T16:01:38.027250Z,162.99,
2021-04-16T16:01:40.529375Z,162.99,
2021-04-16T16:01:47.531342Z,,169.67
2021-04-16T16:01:50.540803Z,162.99,
```
