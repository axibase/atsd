# Series Query: Threshold Aggregators

## Description

Threshold aggregation functions compute threshold violation statistics for each period based on the specified min/max threshold range.

* `THRESHOLD_COUNT` - Number of consecutive samples where the value was above the specified `max` threshold or below the specified `min` threshold.
* `THRESHOLD_DURATION` - Number of milliseconds in all intervals where the value was above the specified `max` threshold or below the specified `min` threshold.
* `THRESHOLD_PERCENT` - 100 * (1-THRESHOLD_DURATION/Period Length). Measures the % of time when the value was within the thresholds: below `max` and above `min`.

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
  {
    "startDate": "2016-06-27T11:10:00Z",
    "endDate":   "2016-06-27T11:15:00Z",
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "aggregate": {"period": {"count": 5, "unit": "MINUTE"},
                  "threshold": {"min": 0, "max": 50},
                  "types": ["THRESHOLD_COUNT",
                            "THRESHOLD_DURATION",
                            "THRESHOLD_PERCENT"  ]}
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
      "type": "THRESHOLD_COUNT",
      "period": {
        "count": 5,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 0,
        "max": 50
      }
    },
    "data": [
      {
        "d": "2016-06-27T11:10:00.000Z",
        "v": 1
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "THRESHOLD_DURATION",
      "period": {
        "count": 5,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 0,
        "max": 50
      }
    },
    "data": [
      {
        "d": "2016-06-27T11:10:00.000Z",
        "v": 1103
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "THRESHOLD_PERCENT",
      "period": {
        "count": 5,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 0,
        "max": 50
      }
    },
    "data": [
      {
        "d": "2016-06-27T11:10:00.000Z",
        "v": 99.63233333333334
      }
    ]
  }
]
```
