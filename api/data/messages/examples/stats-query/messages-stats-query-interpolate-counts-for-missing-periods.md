# Interpolate Counts for Missing Periods with 0 Value

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
        "count": 1,
        "unit": "MINUTE"
      },
      "interpolate": {
        "type": "VALUE",
        "value": 0
      }
    },
    "startDate": "2016-06-20T14:05:00.000Z",
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
        "count": 1,
        "unit": "MINUTE"
      }
    },
    "data": [
      {
        "d": "2016-06-20T14:05:00.000Z",
        "v": 11
      },
      {
        "d": "2016-06-20T14:06:00.000Z",
        "v": 0
      },
      {
        "d": "2016-06-20T14:07:00.000Z",
        "v": 6
      },
      {
        "d": "2016-06-20T14:08:00.000Z",
        "v": 0
      },
      {
        "d": "2016-06-20T14:09:00.000Z",
        "v": 0
      }
    ]
  }
]
```
