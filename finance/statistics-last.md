# Export Statistics History

The endpoint retrieves current statistics values for the instrument in JSON format.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/trade-statistics/last` |

### Payload Parameters

| **Name** | **Description** |
|:---|:---|
| `symbol` | **[Required]** Instrument symbol. |
| `class` | **[Required]** Market identifier [code](https://www.iso20022.org/market-identifier-codes) such as `XNGS` for NASDAQ, `XNYS`/`ARCX` for NYSE, `IEXG` for IEX, `SETS`/`SEAQ`/`IOB` for LSE, or `TQBR`/`TQCB`/`CETS` for MOEX.  |
| `exchange` | Exchange or trading venue name, such as `NASDAQ`, `NYSE`, `IEX`, `LSE`, `MOEX`. |
| `statistics` | List of [statistics](statistics-fields.md) to include in the response. If not specified, all non-empty statistics are returned. |

```txt
GET /api/v1/trade-statistics/last?symbol=MOEX&class=TQBR&statistics=bid,offer,last,qty,value,change
```

## Response

### Payload

```json
{
  "datetime": "2021-04-19T17:09:15.882353Z",
  "instrument": {
    "symbol": "MOEX",
    "class": "TQBR",
    "exchange": "MOEX"
  },
  "statistics": {
    "bid": "173.8",
    "offer": "173.84",
    "last": "173.8",
    "qty": "5",
    "value": "8690",
    "change": "0.33"
  }
}
```
