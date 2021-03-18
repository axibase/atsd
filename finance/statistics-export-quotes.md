# Export Statistics

## Description

Retrieves current top-of-book (Level 1) quotes for the instrument in JSON format.

## Request

| **Method** | **Path** |
|:---|:---|
| `POST` | `/api/v1/properties/query` |

### Payload Parameters

| **Name** | **Description** |
|:---|:---|
| `type` | **[Required]** Set to `statistics`. |
| `entity` | **[Required]** Set to `<symbol>_[<class_code>]`. |
| `startDate` | **[Required]** Set to `1970-01-01T00:00:00Z`.  |
| `endDate` | **[Required]** Set to `now`. |

```json
[{
  "type": "statistics",
  "entity": "tsla_[iexg]",
  "startDate": "1970-01-01T00:00:00Z",
  "endDate":   "now",
  "merge": true
}]
```

## Response

### Payload

```json
[
  {
    "type": "statistics",
    "entity": "tsla_[iexg]",
    "key": {},
    "tags": {
      "bid": "843.61",
      "biddepth": "300",
      "offer": "843.67",
      "offerdepth": "35"
    },
    "date": "2021-01-13T19:00:06.978Z"
  }
]
```

## SQL Alternative

```sql
SELECT tags.symbol, STAT.bid, STAT.biddepth, STAT.offer, STAT.offerdepth
  FROM atsd_entity
WHERE tags.class_code = 'IEXG' AND tags.symbol = 'TSLA'
```