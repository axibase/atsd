# Series Query: End Time Syntax

## Description

`startDate` and `endDate` can be specified with [calendar](../../../../shared/calendar.md) keywords.

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
        "startDate": "current_hour",
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
        "d": "2016-06-27T12:00:13.000Z",
        "v": 34.38
      },
      {
        "d": "2016-06-27T12:00:29.000Z",
        "v": 37.76
      }
    ]
  }
]
```
