# Series Query: Calendar Expression Syntax

## Description

`startDate` and `endDate` can be specified with [calendar](../../../../shared/calendar.md) keywords.

The below example selects data between 23:00 of the previous day and now.

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
        "startDate": "current_day - 1 * HOUR",
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
        "d": "2016-06-26T23:00:02.000Z",
        "v": 17.89
      },
      {
        "d": "2016-06-26T23:00:18.000Z",
        "v": 4.04
      },
      {
        "d": "2016-06-26T23:00:34.000Z",
        "v": 9.09
      }
    ]
  }
]
```
