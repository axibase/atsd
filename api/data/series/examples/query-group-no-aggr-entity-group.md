# Series Query: Entity Group and Wildcard with Extend

## Description

When merging irregular series for multiple entities, `extend=true` with interpolation enables filling interim values as well as extrapolating missing values at the beginning and end of each series.

Entities that have no values in the specified interval are ignored and have no impact on the truncate operation.

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

The request for all entities matches entity e-3, which has data but outside of the `[2016-06-25T08:00:01Z-2016-06-25T08:01:00Z)` interval.
This e-3 entity has no impact on `extend` and `truncate`.

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
    "entity": "*",
    "metric": "m-1",
    "group": {
      "type": "SUM",
      "interpolate": {"extend": true}
    }
  }
]
```

## Response

### Payload

```json
[{"entity":"*","metric":"m-1","tags":{},"type":"HISTORY",
    "aggregate":{"type":"DETAIL"},
    "group":{"type":"SUM","interpolate":{"type":"NONE","value":0.0,"extend":true}},
"data":[
    {"d":"2016-06-25T08:00:05.000Z","v":11.0},
    {"d":"2016-06-25T08:00:10.000Z","v":13.0},
    {"d":"2016-06-25T08:00:15.000Z","v":16.0},
    {"d":"2016-06-25T08:00:30.000Z","v":16.0},
    {"d":"2016-06-25T08:00:45.000Z","v":20.0},
    {"d":"2016-06-25T08:00:59.000Z","v":24.0}
]}]
```

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

## Entity Group Request

Entity group e-entities contains e-1, e-2, e-3 entities.

The request for e-entities group matches entity e-3; however it has no value within the `[2016-06-25T08:00:01Z-2016-06-25T08:01:00Z)` interval.

e-3 entity has no impact on `extend` and `truncate`.

```json
[
  {
    "startDate": "2016-06-25T08:00:01Z",
    "endDate":   "2016-06-25T08:01:00Z",
    "entityGroup": "e-entities",
    "metric": "m-1",
    "group": {
      "type": "SUM",
      "truncate": true,
      "interpolate": {"extend": true}
    }
  }
]
```

```json
[{"entity":"*","metric":"m-1","tags":{},"entityGroup":"e-entities","type":"HISTORY",
"aggregate":{"type":"DETAIL"},
"group":{"type":"SUM","interpolate":{"type":"NONE","value":0.0,"extend":true},"truncate":true},
"data":[
    {"d":"2016-06-25T08:00:05.000Z","v":11.0},
    {"d":"2016-06-25T08:00:10.000Z","v":13.0},
    {"d":"2016-06-25T08:00:15.000Z","v":16.0},
    {"d":"2016-06-25T08:00:30.000Z","v":16.0},
    {"d":"2016-06-25T08:00:45.000Z","v":20.0},
    {"d":"2016-06-25T08:00:59.000Z","v":24.0}
]}]
```
