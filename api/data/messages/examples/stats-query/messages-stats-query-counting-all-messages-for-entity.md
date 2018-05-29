# Counting all Messages for an Entity

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
    "entity": "nurswgvml006",
    "metric": "message-count",
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
      "interval": {
        "count": 600000,
        "unit": "MILLISECOND"
      }
    },
    "data": [
      {
        "d": "2016-06-20T14:00:00.000Z",
        "v": 40
      }
    ]
  }
]
```