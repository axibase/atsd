# Series Query: Calculate All Supported Statistical Functions for Each Period

## Description

Aggregation is a process of grouping detailed values into repeating periods and computing aggregation function(s) on all values in each period.

The query can contain multiple aggregation functions in a `period:types` array.

Threshold function require a threshold range object with min/max thresholds.

The response contains separate series for each function.

[List of aggregation functions](../../../../api/data/aggregation.md)

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
    "aggregate": {"period": {"count": 1, "unit": "MINUTE"},
                  "threshold": {"min": 10, "max": 90},
                  "types": ["AVG",
                            "SUM",
                            "MIN",
                            "MAX",
                            "COUNT",
                            "DELTA",
                            "COUNTER",
                            "PERCENTILE_999",
                            "PERCENTILE_995",
                            "PERCENTILE_99",
                            "PERCENTILE_95",
                            "PERCENTILE_90",
                            "PERCENTILE_75",
                            "PERCENTILE_50",
                            "MEDIAN",
                            "STANDARD_DEVIATION",
                            "FIRST",
                            "LAST",
                            "WAVG",
                            "WTAVG",
                            "MIN_VALUE_TIME",
                            "MAX_VALUE_TIME",
                            "THRESHOLD_COUNT",
                            "THRESHOLD_DURATION",
                            "THRESHOLD_PERCENT"
                           ]}
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
      "type": "AVG",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 7.4775
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 8.593333333333334
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 12.845
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 13.1675
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 9.746666666666666
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "SUM",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 29.91
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 25.78
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 51.38
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 52.67
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 29.24
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "MIN",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 3.96
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 6.12
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 9.89
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 3
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 5.05
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "MAX",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 11.83
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 13.54
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 19.39
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 27.84
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 14.29
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
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 4
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 3
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 4
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 4
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 3
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DELTA",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "counter": false,
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": -7.87
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 2.16
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 3.7700000000000005
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": -4.890000000000001
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 9.29
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "COUNTER",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 18.080000000000002
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 15.7
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 35.160000000000004
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 49.67
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 9.29
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "MEDIAN",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 7.0600000000000005
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 6.12
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 11.05
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 10.915
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 9.9
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "PERCENTILE_999",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 11.83
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 13.54
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 19.39
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 27.84
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 14.29
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "PERCENTILE_995",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 11.83
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 13.54
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 19.39
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 27.84
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 14.29
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "PERCENTILE_99",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 11.83
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 13.54
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 19.39
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 27.84
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 14.29
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "PERCENTILE_95",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 11.83
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 13.54
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 19.39
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 27.84
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 14.29
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "PERCENTILE_90",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 11.83
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 13.54
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 19.39
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 27.84
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 14.29
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "PERCENTILE_75",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 10.8725
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 13.54
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 17.5425
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 25.0875
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 14.29
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "PERCENTILE_50",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 7.0600000000000005
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 6.12
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 11.05
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 10.915
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 9.9
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "STANDARD_DEVIATION",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 2.8910584134534534
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 3.4978215442694545
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 3.8671080926190826
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 9.984766835034257
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 3.77377205930029
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "FIRST",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 11.83
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 6.12
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 12
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 3
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 5.05
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "LAST",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 3.96
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 6.12
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 9.89
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 5
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 14.29
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "WAVG",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 6.203
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 8.593333333333332
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 12.993
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 12.916999999999998
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 11.286666666666667
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "WTAVG",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 5.438300000000001
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 8.593333333333334
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 13.081799999999998
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 12.7667
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 12.645490196078432
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "MIN_VALUE_TIME",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 1467036659000
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 1467036675000
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 1467036771000
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 1467036787000
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 1467036851000
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "MAX_VALUE_TIME",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 1467036611000
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 1467036691000
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 1467036755000
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 1467036803000
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 1467036883000
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "THRESHOLD_COUNT",
      "period": {
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 1
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 2
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 1
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 2
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
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
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 41356
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": -1450
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": -69
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 23271
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": -1567636
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
        "count": 1,
        "unit": "MINUTE",
        "align": "CALENDAR"
      },
      "threshold": {
        "min": 10,
        "max": 90
      }
    },
    "data": [
      {
        "d": "2016-06-27T14:10:00.000Z",
        "v": 31.073333333333338
      },
      {
        "d": "2016-06-27T14:11:00.000Z",
        "v": 102.41666666666667
      },
      {
        "d": "2016-06-27T14:12:00.000Z",
        "v": 100.115
      },
      {
        "d": "2016-06-27T14:13:00.000Z",
        "v": 61.215
      },
      {
        "d": "2016-06-27T14:14:00.000Z",
        "v": 2712.7266666666665
      }
    ]
  }
]
```
