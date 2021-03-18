# Export Reference Data

## Description

Retrieves instrument reference data in JSON format using the [`entity: get`](../api/meta/entity/get.md) endpoint.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/entities/{entity}` |

## Response

### Payload

```json
{
  "name": "aapl_[iexg]",
  "enabled": true,
  "tags": {
    "symbol": "AAPL",
    "figi": "BBG000B9Y5X2",
    "industry": "Computer Hardware",
    "type": "cs",
    "lei": "HWUPKR0MPOU8FGXBT394",
    "currency": "USD",
    "sector": "Technology",
    "name": "Apple Inc.",
    "class_code": "IEXG"
  },
  "createdDate": "2016-03-14T19:09:12.001Z",
  "versionDate": "2021-03-15T15:13:05.191Z"
}
```

## SQL Alternative

```sql
SELECT *
  FROM atsd_entity
WHERE class = 'IEXG' AND symbol = 'AAPL'
```