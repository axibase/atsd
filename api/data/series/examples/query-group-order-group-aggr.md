# Series Query: Group > Aggregation

## Description

The `Group -> Aggregation` function merges series first, and then splits the merged series into periods.

At the first stage, grouping produces the following `SUM` series:

```json
[
  {
    "startDate": "2016-06-25T08:00:00Z",
    "endDate":   "2016-06-25T08:01:00Z",
    "entities": ["e-1", "e-2"],
    "metric": "m-1",
    "group": {
      "type": "SUM"
    }
  }
]
```

```ls
| datetime                 | e1.value | e2.value | SUM |
|--------------------------|----------|----------|-----|
| 2016-06-25T08:00:00.000Z | 1        | 11       | 12  |
| 2016-06-25T08:00:05.000Z | 3        | -        | 3   |
| 2016-06-25T08:00:10.000Z | 5        | -        | 5   |
| 2016-06-25T08:00:15.000Z | 8        | 8        | 16  |
| 2016-06-25T08:00:30.000Z | 3        | 13       | 16  |
| 2016-06-25T08:00:45.000Z | 5        | 15       | 20  |
| 2016-06-25T08:00:59.000Z | -        | 19       | 19  |
```

The grouped SUM series is then aggregated into periods.

> Note that if a period is not specified, the grouping function automatically applies aggregation for the same period as the aggregate function.<br>To avoid this, specify `"period": {"count": 1, "unit": "MILLISECOND"}` in `group`.

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
    "aggregate": {
      "type": "COUNT",
      "period": {"count": 10, "unit": "SECOND"}
    },
    "group": {
      "type": "SUM",
      "period": {"count": 1, "unit": "MILLISECOND"}
    }
  }
]
```

## Response

### Payload

```json
[{"entity":"*","metric":"m-1","tags":{},"entities":["e-1","e-2"],"type":"HISTORY",
    "aggregate":{"type":"COUNT","period":{"count":10,"unit":"SECOND","align":"CALENDAR"}},
    "group":{"type":"SUM","period":{"count":1,"unit":"MILLISECOND","align":"CALENDAR"}},
"data":[
    {"d":"2016-06-25T08:00:00.000Z","v":2.0},
    {"d":"2016-06-25T08:00:10.000Z","v":2.0},
    {"d":"2016-06-25T08:00:30.000Z","v":1.0},
    {"d":"2016-06-25T08:00:40.000Z","v":1.0},
    {"d":"2016-06-25T08:00:50.000Z","v":1.0}
]}]
```

```ls
| datetime                 | COUNT(SUM(value)) |
|--------------------------|-------------------|
| 2016-06-25T08:00:00.000Z | 2                 |
| 2016-06-25T08:00:10.000Z | 2                 |
| 2016-06-25T08:00:30.000Z | 1                 |
| 2016-06-25T08:00:40.000Z | 1                 |
| 2016-06-25T08:00:50.000Z | 1                 |
```
