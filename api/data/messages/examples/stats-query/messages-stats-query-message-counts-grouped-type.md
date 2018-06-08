# Message Counts Grouped by Type

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
    "groupKeys": [
      "type"
    ],
    "aggregate": {
      "types": [
        "COUNT"
      ],
      "period": {
        "count": 10,
        "unit": "MINUTE"
      }
    },
    "startDate": "2016-06-20T14:00:00.000Z",
    "endDate": "2016-06-20T15:00:00.000Z"
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
    "tags": {
      "type": "logger"
    },
    "type": "HISTORY",
    "aggregate": {
      "type": "COUNT",
      "period": {
        "count": 10,
        "unit": "MINUTE"
      }
    },
    "data": [
      {
        "d": "2016-06-20T14:00:00.000Z",
        "v": 40
      },
      {
        "d": "2016-06-20T14:10:00.000Z",
        "v": 15
      },
      {
        "d": "2016-06-20T14:20:00.000Z",
        "v": 40
      },
      {
        "d": "2016-06-20T14:30:00.000Z",
        "v": 20
      },
      {
        "d": "2016-06-20T14:40:00.000Z",
        "v": 23
      },
      {
        "d": "2016-06-20T14:50:00.000Z",
        "v": 38
      }
    ]
  }
]
```