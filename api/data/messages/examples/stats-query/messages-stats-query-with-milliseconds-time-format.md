# Count Query with Milliseconds Time Format

## Description

## Request

### URI

```elm
POST /api/v1/messages/stats/query
```

### Payload

```json
[
  {
    "entities": "nurswgvml006",
    "metric": "message-count",
    "aggregate": {
      "types": [
        "COUNT"
      ],
      "period": {
        "count": 5,
        "unit": "MINUTE"
      }
    },
    "startDate": "2016-06-20T14:00:00.000Z",
    "endDate": "2016-06-20T14:10:00.000Z",
    "timeFormat": "milliseconds"
  }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml006",
    "metric": "message-count",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "COUNT",
      "period": {
        "count": 5,
        "unit": "MINUTE"
      }
    },
    "data": [
      {
        "t": 1466431200000,
        "v": 23
      },
      {
        "t": 1466431500000,
        "v": 17
      }
    ]
  }
]
```
