# Series Query: Multiple Periods

## Description

Aggregation is a process of grouping detailed samples into repeating intervals (periods) in order to apply a statistical function to all samples in the group.

Time between `startDate` and `endDate` can be split into periods of different durations.

In this example, a 10 minute time range is split into 1, 5, and 10-minute periods.

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
    "endDate":   "2016-06-27T14:20:00Z",
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "aggregate": {"period": {"count": 10, "unit": "MINUTE"},
                  "type": "COUNT"}
  },
  {
    "startDate": "2016-06-27T14:10:00Z",
    "endDate":   "2016-06-27T14:20:00Z",
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "aggregate": {"period": {"count": 5, "unit": "MINUTE"},
                  "type": "COUNT"}
  },
  {
    "startDate": "2016-06-27T14:10:00Z",
    "endDate":   "2016-06-27T14:20:00Z",
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "aggregate": {"period": {"count": 1, "unit": "MINUTE"},
                  "type": "COUNT"}
  }
]
```

## Response

### Payload

```json
[{"entity":"nurswgvml007","metric":"cpu_busy","tags":{},"type":"HISTORY",
"aggregate":{"type":"COUNT","period":{"count":10,"unit":"MINUTE","align":"CALENDAR"}},
"data":[
    {"d":"2016-06-27T14:10:00.000Z","v":37.0}
]},
{"entity":"nurswgvml007","metric":"cpu_busy","tags":{},"type":"HISTORY",
"aggregate":{"type":"COUNT","period":{"count":5,"unit":"MINUTE","align":"CALENDAR"}},
"data":[
    {"d":"2016-06-27T14:10:00.000Z","v":18.0},
    {"d":"2016-06-27T14:15:00.000Z","v":19.0}
]},
{"entity":"nurswgvml007","metric":"cpu_busy","tags":{},"type":"HISTORY",
"aggregate":{"type":"COUNT","period":{"count":1,"unit":"MINUTE","align":"CALENDAR"}},
"data":[
    {"d":"2016-06-27T14:10:00.000Z","v":4.0},
    {"d":"2016-06-27T14:11:00.000Z","v":3.0},
    {"d":"2016-06-27T14:12:00.000Z","v":4.0},
    {"d":"2016-06-27T14:13:00.000Z","v":4.0},
    {"d":"2016-06-27T14:14:00.000Z","v":3.0},
    {"d":"2016-06-27T14:15:00.000Z","v":4.0},
    {"d":"2016-06-27T14:16:00.000Z","v":4.0},
    {"d":"2016-06-27T14:17:00.000Z","v":4.0},
    {"d":"2016-06-27T14:18:00.000Z","v":3.0},
    {"d":"2016-06-27T14:19:00.000Z","v":4.0}
]}]
```