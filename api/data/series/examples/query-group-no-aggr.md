# Series Query: Group without Aggregation

## Description

Groups multiple input series into one series and applies a grouping function to the grouped values.

When aggregation is disabled, the grouping function is applied to values for all unique timestamps in the merged series.

In the example below, the `SUM` function returns 12 (1+11) at 2016-06-25T08:00:00Z as a total of e-1 and e-2 series values, both of which have samples for this timestamp.

On the other hand, `SUM` returns 3 (3 + null->0) at 2016-06-25T08:00:05Z because only e-1 series has a value at that timestamp.

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
      "type": "SUM"
    }
  }
]
```

## Response

### Payload

```json
[{"entity":"*","metric":"m-1","tags":{},"entities":["e-1","e-2"],"type":"HISTORY",
    "aggregate":{"type":"DETAIL"},
    "group":{"type":"SUM"},
"data":[
    {"d":"2016-06-25T08:00:00.000Z","v":12.0},
    {"d":"2016-06-25T08:00:05.000Z","v":3.0},
    {"d":"2016-06-25T08:00:10.000Z","v":5.0},
    {"d":"2016-06-25T08:00:15.000Z","v":16.0},
    {"d":"2016-06-25T08:00:30.000Z","v":16.0},
    {"d":"2016-06-25T08:00:45.000Z","v":20.0},
    {"d":"2016-06-25T08:00:59.000Z","v":19.0}
]}]
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
