# Series Query: Calculate All Supported Statistical Functions for Each Period

## Description

Aggregation is a process of grouping detailed values into repeating periods and computing aggregation functions on all values in each period.

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
                            "PERCENTILE(99.5)",
                            "MEDIAN",
                            "STANDARD_DEVIATION",
                            "MEDIAN_ABS_DEV",
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
[{
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
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 19.855
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 10.389999999999999
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 9.7575
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 7.57
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 12.7275
  }]
}, {
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
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 79.42
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 31.169999999999995
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 39.03
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 30.28
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 50.91
  }]
}, {
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
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 7.92
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 6.93
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 6.0
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 5.0
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 7.92
  }]
}, {
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
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 37.62
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 12.12
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 14.85
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 11.0
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 20.2
  }]
}, {
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
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 4.0
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 3.0
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 4.0
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 4.0
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 4.0
  }]
}, {
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
    "threshold": {
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": -29.699999999999996
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 4.199999999999999
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 2.7300000000000004
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": -3.8499999999999996
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": -3.08
  }]
}, {
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
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 41.800000000000004
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 12.12
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 14.85
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 19.16
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 25.200000000000003
  }]
}, {
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "tags": {},
  "type": "HISTORY",
  "aggregate": {
    "type": "PERCENTILE(99.5)",
    "period": {
      "count": 1,
      "unit": "MINUTE",
      "align": "CALENDAR"
    },
    "threshold": {
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 37.62
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 12.12
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 14.85
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 11.0
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 20.2
  }]
}, {
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
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 16.94
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 12.12
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 9.09
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 7.140000000000001
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 11.395
  }]
}, {
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
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 13.244383715371583
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 2.9964478970941575
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 4.4461696998652664
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 2.634413280662951
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 5.901408730125376
  }]
}, {
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "tags": {},
  "type": "HISTORY",
  "aggregate": {
    "type": "MEDIAN_ABS_DEV",
    "period": {
      "count": 1,
      "unit": "MINUTE",
      "align": "CALENDAR"
    },
    "threshold": {
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 7.040000000000001
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 0.0
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 3.06
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 1.5800000000000005
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 3.3950000000000005
  }]
}, {
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
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 37.62
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 6.93
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 6.0
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 8.16
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 14.71
  }]
}, {
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
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 7.92
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 12.12
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 14.85
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 11.0
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 7.92
  }]
}, {
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
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 14.894
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 11.255
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 11.388
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 8.052
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 11.103
  }]
}, {
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
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 11.9174
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 12.018235294117646
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 12.3663
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 8.3412
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 10.1283
  }]
}, {
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
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 1.545919856E12
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 1.545919872E12
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 1.54591992E12
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 1.54592E12
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 1.545920096E12
  }]
}, {
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
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 1.545919808E12
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 1.545919888E12
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 1.545919968E12
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 1.545920032E12
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 1.545920064E12
  }]
}, {
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
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 1.0
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 1.0
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 1.0
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 1.0
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 1.0
  }]
}, {
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
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 12405.0
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 21464.0
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 26402.0
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 48721.0
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 22535.0
  }]
}, {
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
      "min": 10.0,
      "max": 90.0
    },
    "order": 0
  },
  "data": [{
    "d": "2018-12-27T14:10:00.000Z",
    "v": 79.325
  }, {
    "d": "2018-12-27T14:11:00.000Z",
    "v": 64.22666666666666
  }, {
    "d": "2018-12-27T14:12:00.000Z",
    "v": 55.99666666666667
  }, {
    "d": "2018-12-27T14:13:00.000Z",
    "v": 18.798333333333332
  }, {
    "d": "2018-12-27T14:14:00.000Z",
    "v": 62.44166666666667
  }]
}]
```
