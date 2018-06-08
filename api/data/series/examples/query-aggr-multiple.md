# Series Query: Counter Aggregator

## Description

Multiple statistical function in one query translate into faster calculations.

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
  {
    "startDate": "2016-06-27T14:10:00Z",
    "endDate":   "2016-06-27T14:15:00Z",
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "aggregate": {"period": {"count": 5, "unit": "MINUTE"},
                  "types": ["MAX", "COUNT"]}
  }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "MAX",
      "period": {
        "count": 5,
        "unit": "MINUTE",
        "align": "CALENDAR"
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 27.84
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "COUNT",
      "period": {
        "count": 5,
        "unit": "MINUTE",
        "align": "CALENDAR"
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 18
      }
    ]
  }
]
```