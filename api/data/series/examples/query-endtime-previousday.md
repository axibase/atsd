# Series Query: Calendar Expression Syntax Example - Previous Day

## Description

Select data between `00:00` today and `00:00` yesterday using [calendar](../../../../shared/calendar.md) keywords.

Note that `DAY`, `WEEK`, `MONTH`, `QUARTER`, and `YEAR` start times are computed according to server time zone in calendar calculations.

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
    {
        "endDate":   "current_day",
        "startDate": "previous_day",
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
        "d": "2016-06-26T00:00:00.000Z",
        "v": 63.38
      },
      {
        "d": "2016-06-26T00:00:16.000Z",
        "v": 9.2
      },
      {
        "d": "2016-06-26T00:00:32.000Z",
        "v": 8.08
      }
    ]
  }
]
```
