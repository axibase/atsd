# Message Count per Period

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
    "endDate": "2016-06-20T14:10:00.000Z"
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
        "d": "2016-06-20T14:00:00.000Z",
        "v": 23
      },
      {
        "d": "2016-06-20T14:05:00.000Z",
        "v": 17
      }
    ]
  }
]
```