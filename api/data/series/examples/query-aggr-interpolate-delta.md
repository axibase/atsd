# Series Query: Interpolate with Delta

## Description

When interpolation is specified in the `aggregate` object, the database performs operations in the following order:

1. Calculate period values by applying a given statistical functions to detailed samples recorded within the given period.
2. Add missing (empty) periods by applying an interpolation function.

Since both `aggregate` and `group` objects support interpolation functions, changing their default order can be used as a technique to calculate `DELTA of interpolated period values.

## Data

* Detailed data, collected every 15 seconds, is missing between `2016-01-02T12:44:08Z` and `2016-01-04T08:14:12Z`.
* The metric is a counter, always incrementing.

### Detailed Data

```json
[{
  "startDate": "2016-01-02T12:00:00Z",
  "endDate":   "2016-01-04T09:00:00Z",
  "entity": "e-1",
  "metric": "m-1"
}]
```

```ls
| datetime                 | value |
|--------------------------|-------|
| 2016-01-02T12:14:08.000Z | 13.40 |
| 2016-01-02T12:29:08.000Z | 13.43 |
| 2016-01-02T12:44:08.000Z | 13.44 |
-- no data --
| 2016-01-04T08:14:12.000Z | 15.93 |
| 2016-01-04T08:29:40.000Z | 16.01 |
| 2016-01-04T08:44:18.000Z | 16.26 |
| 2016-01-04T08:59:04.000Z | 16.47 |

```

### Aggregated Data

```json
[{
  "startDate": "2016-01-02T12:00:00Z",
  "endDate":   "2016-01-04T09:00:00Z",
  "entity": "e-1",
  "metric": "m-1",
  "aggregate" : {
    "type": "MAX",
    "period": {"count": 30, "unit": "MINUTE"}
  },
}]
```

```ls
| datetime                 | max(value) |
|--------------------------|------------|
| 2016-01-02T12:00:00.000Z | 13.43      |
| 2016-01-02T12:30:00.000Z | 13.44      |
| 2016-01-04T08:00:00.000Z | 16.01      |
| 2016-01-04T08:30:00.000Z | 16.47      |
```

### Interpolation with Period in Group

```json
[{
  "startDate": "2016-01-02T12:00:00Z",
  "endDate":   "2016-01-04T09:00:00Z",
  "entity": "e-1",
  "metric": "m-1",
  "group": {
    "type": "MAX",
    "interpolate": {"type": "LINEAR"},
    "period": {"count": 30, "unit": "MINUTE"}
  }
}]
```

```ls
| datetime                 | value |
|--------------------------|-------|
| 2016-01-02T12:00:00.000Z | 13.43 |
| 2016-01-02T12:30:00.000Z | 13.44 |
| 2016-01-02T13:00:00.000Z | 13.47 |
| 2016-01-02T13:30:00.000Z | 13.50 |
| 2016-01-02T14:00:00.000Z | 13.53 |
| 2016-01-02T14:30:00.000Z | 13.56 |
... interpolate MAX in group
| 2016-01-04T07:00:00.000Z | 15.95 |
| 2016-01-04T07:30:00.000Z | 15.98 |
| 2016-01-04T08:00:00.000Z | 16.01 |
| 2016-01-04T08:30:00.000Z | 16.47 |
```

## Request

```json
[{
  "startDate": "2016-01-02T12:00:00Z",
  "endDate":   "2016-01-04T09:00:00Z",
  "entity": "e-1",
  "metric": "m-1",
  "aggregate" : {
    "type": "DELTA",
    "period": {"count": 30, "unit": "MINUTE"}
  },
  "group": {
    "type": "MAX",
    "interpolate": {"type": "LINEAR"},
    "period": {"count": 30, "unit": "MINUTE"},
    "order": -1
  }
}]
```

### Response

```json
[{"entity":"e-1","metric":"m-1","tags":{},"type":"HISTORY",
"aggregate":{"type":"DELTA","period":{"count":30,"unit":"MINUTE","align":"CALENDAR"},"counter":false},
"group":{"type":"MAX","period":{"count":30,"unit":"MINUTE","align":"CALENDAR"},
"interpolate":{"type":"LINEAR","value":0.0,"extend":false},"order":-1},
"data":[
{"d":"2016-01-02T12:30:00.000Z","v":0.009000000000014552},
{"d":"2016-01-02T13:00:00.000Z","v":0.02860919540228224},
{"d":"2016-01-02T13:30:00.000Z","v":0.02860919540228224},
...
{"d":"2016-01-04T07:00:00.000Z","v":0.02860919540228224},
{"d":"2016-01-04T07:30:00.000Z","v":0.02860919540228224},
{"d":"2016-01-04T08:00:00.000Z","v":0.10960919540229952},
{"d":"2016-01-04T08:30:00.000Z","v":0.4539999999999509}]}]
```