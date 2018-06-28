# Series Query: Group Extend without Aggregation

## Description

An opposite operation to truncation, extend adds missing values at the beginning and end of the interval to ensure that that all merged series have values when the grouping function is applied.

```ls
| datetime                 | e1.value | e2.value | SUM |
|--------------------------|----------|----------|-----|
| 2016-06-25T08:00:05.000Z | 3        | 8 +      | 11  | e2.value extended to start at the beginning of the interval
| 2016-06-25T08:00:10.000Z | 5        | 8 +      | 13  | e2.value extended to start at the beginning of the interval
| 2016-06-25T08:00:15.000Z | 8        | 8        | 16  |
| 2016-06-25T08:00:30.000Z | 3        | 13       | 16  |
| 2016-06-25T08:00:45.000Z | 5        | 15       | 20  |
| 2016-06-25T08:00:59.000Z | 5 +      | 19       | 24  | e1.value extended until the end of the interval
```

## Detailed Data by Series

```ls
| entity | datetime                 | value |
|--------|--------------------------|-------|
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
    "startDate": "2016-06-25T08:00:01Z",
    "endDate":   "2016-06-25T08:01:00Z",
    "entities": ["e-1", "e-2"],
    "metric": "m-1",
    "group": {
      "type": "SUM",
      "interpolate": { "extend": true }
    }
  }
]
```

## Response

### Payload

```json
[{"entity":"*","metric":"m-1","tags":{},"entities":["e-1","e-2"],"type":"HISTORY",
    "aggregate":{"type":"DETAIL"},
    "group":{"type":"SUM","truncate":true,"order":0},
"data":[
    {"d":"2016-06-25T08:00:05.000Z","v":11.0},
    {"d":"2016-06-25T08:00:10.000Z","v":13.0},
    {"d":"2016-06-25T08:00:15.000Z","v":16.0},
    {"d":"2016-06-25T08:00:30.000Z","v":16.0},
    {"d":"2016-06-25T08:00:45.000Z","v":20.0},
    {"d":"2016-06-25T08:00:59.000Z","v":24.0}
]}]
```

Extend is similar to interpolation where missing values at the beginning of an interval are interpolated with `NEXT` type. Missing values at the end of the interval are interpolated with `PREVIOUS` type.

```ls
| datetime                 | e1.value | e2.value | SUM |
|--------------------------|----------|----------|-----|
| 2016-06-25T08:00:05.000Z | 3        | 8 +(NEXT)| 11  |
| 2016-06-25T08:00:10.000Z | 5        | 8 +(NEXT)| 13  |
| 2016-06-25T08:00:15.000Z | 8        | 8        | 16  |
| 2016-06-25T08:00:30.000Z | 3        | 13       | 16  |
| 2016-06-25T08:00:45.000Z | 5        | 15       | 20  |
| 2016-06-25T08:00:59.000Z | 5 +(PREV)| 19       | 24  |
```

Since `extend` is performed prior to truncation, the `truncate` setting has no effect on extended results.
