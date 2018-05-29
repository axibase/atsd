# Series Query: Group/Aggregate Sequence

## Description

Group merges multiple series into one. If group is applied after aggregation, it merges aggregate values.

The sequence can be controlled with the `order` parameter.

Default order is to aggregate first and group second.

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
  {
    "startDate": "2016-06-26T03:40:00Z",
    "endDate":   "2016-06-26T03:41:00Z",
    "entity": "nurswgvml007",
    "metric": "disk_used",
    "aggregate": {
      "type": "DELTA",
      "period": { "count": 1, "unit": "MINUTE" },
      "order": 0
    },
    "group": {
      "type": "SUM",
      "period": { "count": 1, "unit": "MINUTE" },
      "order": 1
    }
  }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "metric": "disk_used",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DELTA",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "counter": false
    },
    "group": {
      "type": "SUM",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "order": 1
    },
    "data": [
      {
        "d": "2016-06-26T03:40:00.000Z",
        "v": 7248
      }
    ]
  }
]
```
