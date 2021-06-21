# Export Statistics History

The endpoint retrieves statistics values for the instrument at given timestamp in JSON format.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/trade-statistics/instant` |

### Payload Parameters

| **Name** | **Description** |
|:---|:---|
| `symbol` | **[Required]** Instrument symbol. |
| `class` | **[Required]** Market identifier [code](https://www.iso20022.org/market-identifier-codes) such as `XNGS` for NASDAQ, `XNYS`/`ARCX` for NYSE, `IEXG` for IEX, `SETS`/`SEAQ`/`IOB` for LSE, or `TQBR`/`TQCB`/`CETS` for MOEX.  |
| `exchange` | Exchange or trading venue name, such as `NASDAQ`, `NYSE`, `IEX`, `LSE`, `MOEX`. |
| `timestamp` | **[Required]** Timestamp in ISO format.  |
| `fields` | **[Required]** List of [statistics](statistics-fields.md) to include in the response. |

```txt
GET /api/v1/trade-statistics/instant?symbol=MOEX&class=TQBR&timestamp=2021-04-19T17:10:00Z&statistics=bid,offer,last,qty,value,change
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
