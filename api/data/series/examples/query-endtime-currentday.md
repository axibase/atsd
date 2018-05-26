# Series Query: End Time Syntax Example - Current Day

## Description

Select data between 00:00 today and now using [calendar](../../../../shared/calendar.md) keywords.

Note that DAY, WEEK, MONTH, QUARTER, and YEAR start times are computed according to server time zone in calendar calculations.

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
        "startDate": "current_day",
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
        "d": "2016-06-27T00:00:04.000Z",
        "v": 21.65
      },
      {
        "d": "2016-06-27T00:00:20.000Z",
        "v": 9.09
      },
      {
        "d": "2016-06-27T00:00:36.000Z",
        "v": 5.05
      }
    ]
  }
]
```
