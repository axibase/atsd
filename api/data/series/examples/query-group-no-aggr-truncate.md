# Series Query: Group Truncation without Aggregation

## Description

Truncation discards timestamps at the beginning of the interval until all of the merged values have a value.

The first time is MAX(MIN(series_sample_time)), the last time is MIN(MAX(series_sample_time)).

MAX(MIN(series_sample_time)) = 2016-06-25T08:00:15.000Z.

MIN(MAX(series_sample_time)) = 2016-06-25T08:00:45.000Z.

```ls
| datetime                 | e1.value | e2.value | SUM |
|--------------------------|----------|----------|-----|
| 2016-06-25T08:00:05.000Z | 3        | -        | 3   | discarded because time < MAX(MIN(series_sample_time))
| 2016-06-25T08:00:10.000Z | 5        | -        | 5   | discarded because time < MAX(MIN(series_sample_time))
| 2016-06-25T08:00:15.000Z | 8        | 8        | 16  |
| 2016-06-25T08:00:30.000Z | 3        | 13       | 16  |
| 2016-06-25T08:00:45.000Z | 5        | 15       | 20  |
| 2016-06-25T08:00:59.000Z | -        | 19       | 19  | discarded because time > MIN(MAX(series_sample_time))
```

Samples for series e-1 at 2016-06-25T08:00:05.000Z and at 2016-06-25T08:00:10.000Z are discarded because there is no value for series e-2 until 2016-06-25T08:00:15.000Z.

Sample for series e-2 at 2016-06-25T08:00:59.000Z is discarded because there is no value for series e-1 after 2016-06-25T08:00:45.000Z.

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
      "truncate": true
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
    {"d":"2016-06-25T08:00:15.000Z","v":16.0},
    {"d":"2016-06-25T08:00:30.000Z","v":16.0},
    {"d":"2016-06-25T08:00:45.000Z","v":20.0}
]}]
```

```ls
| datetime                 | e1.value | e2.value | SUM |
|--------------------------|----------|----------|-----|
| 2016-06-25T08:00:15.000Z | 8        | 8        | 16  |
| 2016-06-25T08:00:30.000Z | 3        | 13       | 16  |
| 2016-06-25T08:00:45.000Z | 5        | 15       | 20  |
```
