# Entity Array with Message Counts Grouped by Entity

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
    "entities": [
      "nurswgvml007",
      "nurswgvml006"
    ],
    "metric": "message-count",
    "groupKeys": [
      "entity"
    ],
    "aggregate": {
      "types": [
        "COUNT"
      ],
      "period": {
        "count": 1,
        "unit": "MONTH"
      }
    },
    "startDate": "2016-05-15T00:00:00.000Z",
    "endDate": "2016-06-21T00:00:00.000Z"
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
        "count": 1,
        "unit": "MONTH"
      }
    },
    "data": [
      {
        "d": "2016-06-01T00:00:00.000Z",
        "v": 130850
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "message-count",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "COUNT",
      "period": {
        "count": 1,
        "unit": "MONTH"
      }
    },
    "data": [
      {
        "d": "2016-06-01T00:00:00.000Z",
        "v": 92315
      }
    ]
  }
]
```