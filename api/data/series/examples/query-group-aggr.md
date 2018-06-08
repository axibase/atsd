# Series Query: Group with Aggregation

## Description

By default, the grouping function is applied at all unique sample times from the merged series.

To split values into periods, specify the period.

## Detailed Data by Series

```ls
| entity | datetime                 | value |
|--------|--------------------------|-------|
| e-1    | 2016-06-25T08:00:00.000Z | 1     |
| e-2    | 2016-06-25T08:00:00.000Z | 11    |
| e-1    | 2016-06-25T08:00:05.000Z | 3     | e-1 only
| e-1    | 2016-06-25T08:00:10.000Z | 5     | e-1 only
| e-1    | 2016-06-25T08:00:15.000Z | 8     |
| e-2    | 2016-06-25T08:00:15.000Z | 8     |
| e-1    | 2016-06-25T08:00:30.000Z | 3     |
| e-2    | 2016-06-25T08:00:30.000Z | 13    |
| e-1    | 2016-06-25T08:00:45.000Z | 5     |
| e-2    | 2016-06-25T08:00:45.000Z | 15    |
| e-2    | 2016-06-25T08:00:59.000Z | 19    | e-2 only
```

## Detailed Data Grouped by Timestamp

```ls
| datetime                 | e1.value | e2.value |
|--------------------------|----------|----------|
| 2016-06-25T08:00:00.000Z | 1        | 11       |
| 2016-06-25T08:00:05.000Z | 3        | -        |
| 2016-06-25T08:00:10.000Z | 5        | -        |
| 2016-06-25T08:00:15.000Z | 8        | 8        |
| 2016-06-25T08:00:30.000Z | 3        | 13       |
| 2016-06-25T08:00:45.000Z | 5        | 15       |
| 2016-06-25T08:00:59.000Z | -        | 19       |
```

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
  {
    "startDate": "2016-06-25T08:00:00Z",
    "endDate":   "2016-06-25T08:01:00Z",
    "entities": ["e-1", "e-2"],
    "metric": "m-1",
    "group": {
      "type": "SUM",
      "period": {"count": 10, "unit": "SECOND"}
    }
  }
]
```

## Response

### Payload

```json
[{"entity":"*","metric":"m-1","tags":{},"entities":["e-1","e-2"],"type":"HISTORY",
    "aggregate":{"type":"DETAIL"},
    "group":{"type":"SUM","period":{"count":10,"unit":"SECOND","align":"CALENDAR"},"order":0},
"data":[
    {"d":"2016-06-25T08:00:00.000Z","v":15.0},
    {"d":"2016-06-25T08:00:10.000Z","v":21.0},
    {"d":"2016-06-25T08:00:30.000Z","v":16.0},
    {"d":"2016-06-25T08:00:40.000Z","v":20.0},
    {"d":"2016-06-25T08:00:50.000Z","v":19.0}
]}]
```

This is equivalent to `Group <-> Aggregation` processing in case of `SUM`+`SUM` functions.

```json
[
  {
    "startDate": "2016-06-25T08:00:00Z",
    "endDate":   "2016-06-25T08:01:00Z",
    "entities": ["e-1", "e-2"],
    "metric": "m-1",
    "aggregate": {
      "type": "SUM",
      "period": {"count": 10, "unit": "SECOND"}
    },
    "group": {
      "type": "SUM",
      "period": {"count": 10, "unit": "SECOND"}
    }
  }
]
```
