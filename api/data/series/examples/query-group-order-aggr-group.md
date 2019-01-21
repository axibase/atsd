# Series Query: Aggregation > Group

## Description

The `Aggregation -> Group` order creates aggregate series for each of the merged series, and then performs grouping of the aggregated series.

The timestamps used for grouping combine period start times from the underlying aggregated series.

```ls
| 10-second period start   | e1.COUNT | e2.COUNT | SUM |
|--------------------------|----------|----------|-----|
| 2016-06-25T08:00:00.000Z | 2        | 1        | 3   |
| 2016-06-25T08:00:10.000Z | 2        | 1        | 3   |
| 2016-06-25T08:00:20.000Z | -        | -        | -   | Period not created because there are no detailed values in the [00:20-00:30) period for any series.
| 2016-06-25T08:00:30.000Z | 1        | 1        | 2   |
| 2016-06-25T08:00:40.000Z | 1        | 1        | 2   |
| 2016-06-25T08:00:50.000Z | 0        | 1        | 1   |
```

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
    "transformationOrder": ["aggregate", "group"],
    "aggregate": {
      "type": "COUNT",
      "period": {"count": 10, "unit": "SECOND"}
    },
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
"transformationOrder":["AGGREGATE","GROUP"],
"aggregate":{"type":"COUNT","period":{"count":10,"unit":"SECOND","align":"CALENDAR"}},
"group":{"type":"SUM"},
"data":[
    {"d":"2016-06-25T08:00:00.000Z","v":3.0},
    {"d":"2016-06-25T08:00:10.000Z","v":3.0},
    {"d":"2016-06-25T08:00:30.000Z","v":2.0},
    {"d":"2016-06-25T08:00:40.000Z","v":2.0},
    {"d":"2016-06-25T08:00:50.000Z","v":1.0}
]}]
```
