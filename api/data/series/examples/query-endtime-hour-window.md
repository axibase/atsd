# Series Query: `EndTime` - Hour Window

## Description

Select data for the last hour, ending with current time using [calendar](../../../../shared/calendar.md) keywords.

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
    {
        "endDate":   "now",
        "startDate": "now - 1 * HOUR",
        "entity": "nurswgvml007",
        "metric": "mpstat.cpu_busy"
    }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "metric": "mpstat.cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-06-27T12:06:05.000Z",
        "v": 4.04
      },
      {
        "d": "2016-06-27T12:06:21.000Z",
        "v": 5.05
      },
      {
        "d": "2016-06-27T12:06:37.000Z",
        "v": 9
      }
    ]
  }
]
```
