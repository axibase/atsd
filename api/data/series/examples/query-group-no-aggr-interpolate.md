# Series Query: Group Interpolate without Aggregation

## Description

Interpolation can fill the gaps in a merged series. The interpolation function is applied to two consecutive samples to calculate an interim value for a known timestamp.

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
      "interpolate": { "type": "PREVIOUS" }
    }
  }
]
```

## Response

### Payload

```json
[{"entity":"*","metric":"m-1","tags":{},"entities":["e-1","e-2"],"type":"HISTORY",
    "aggregate":{"type":"DETAIL"},
    "group":{"type":"SUM","interpolate":{"type":"PREVIOUS","value":0.0,"extend":false},"order":0},
"data":[
    {"d":"2016-06-25T08:00:00.000Z","v":12.0},
    {"d":"2016-06-25T08:00:05.000Z","v":14.0},
    {"d":"2016-06-25T08:00:10.000Z","v":16.0},
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
| 2016-06-25T08:00:05.000Z | 3        | 11 (PREV)| 14  |
| 2016-06-25T08:00:10.000Z | 5        | 11 (PREV)| 16  |
| 2016-06-25T08:00:15.000Z | 8        | 8        | 16  |
| 2016-06-25T08:00:30.000Z | 3        | 13       | 16  |
| 2016-06-25T08:00:45.000Z | 5        | 15       | 20  |
| 2016-06-25T08:00:59.000Z | -        | 19       | 19  |
```
