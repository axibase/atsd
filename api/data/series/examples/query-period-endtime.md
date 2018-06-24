# Series Query: Period End Time

## Description

By default, period start time is based on calendar.

For a 1-minute period, each period starts at 0 seconds of each minute. For a 1-hour period, the period starts at 0 minute and 0 seconds of each hour, etc.

This is called the `CALENDAR` alignment.

For example, the default alignment can be changed so that the period start or end time is aligned with boundaries of the requested time range.

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
  {
    "startDate": "2016-06-27T14:12:33.111Z",
    "endDate":   "2016-06-27T14:22:33.111Z",
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "aggregate": {"period": {"count": 5, "unit": "MINUTE", "align": "END_TIME"},
                  "type": "COUNT"}
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
      "type": "COUNT",
      "period": {
        "count": 5,
        "unit": "MINUTE",
        "align": "END_TIME"
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:12:33.111Z",
        "v": 19
      },
      {
        "d": "2016-06-27T14:17:33.111Z",
        "v": 19
      }
    ]
  }
]
```
