# Group Processor

Groups multiple input series into one series and applies a statistical function to grouped values.

The transformation is implemented as follows:

1. Load detailed data within the specified `startDate` and `endDate` for each series separately. `startDate` is inclusive and `endDate` is exclusive.

    a. Group multiple series if `period` is specified in the query.<br>Split each series `time:value` array into periods based on the `period`  parameter. Discard periods with start time earlier than `startDate` or greater than `endDate`. Group multiple series samples within the same period. Timestamp of a group equals to the period start time.

    b. Group multiple series if `period` is not specified.<br> Multiple series samples are grouped at all unique timestamps in the input series. Each group has an ordered list of pairs: `[timestamp | samples of several series with given timestamp]`.

1. Interpolate grouped series according to the `interpolate` field.
1. Truncate grouped series if `truncate` field is `true`.
1. Apply [statistical function](../../../api/data/aggregation.md) to values in each group and return a `time:value` array, where time is the period start time and value is the result of the statistical function.

| **Parameter** | **Type** | **Description**  |
|:---|:---|:---|
| `type`  | string        | **[type or types is Required]** [Statistical function](#grouping-functions) applied to values with the same timestamp or within the same period, if the period is specified.<br>The `type` can be set to `DETAIL` in which case no grouping is performed and the underlying series is returned unchanged. |
| `types` | array          | **[type or types is Required]** Array of [statistical functions](#grouping-functions). Each function in the array produces a separate grouped series. If one of the functions is set to `DETAIL`, its result contains the underlying series. |
| `period`      | object           | [Period](period.md). Splits the merged series into periods and applies the statistical function to values in each period separately. |
| `interpolate`   | object           | [Interpolation](#interpolation) function to fill gaps in input series (no period) or in grouped series (if period is specified). |
| `truncate`      | boolean           | Discards samples at the beginning of the interval until values for all input series are established.<br>Default: `false`.  |
| `place`      | object           | Divide grouped series into several groups based on constraint and objective function specified in the [Placement](#placement) object.  |

## Grouping Functions

* `COUNT`
* `MIN`
* `MAX`
* `AVG`
* `SUM`
* `PERCENTILE(n)`
* `MEDIAN`
* `STANDARD_DEVIATION`
* `MEDIAN_ABS_DEV`
* `FIRST`
* `LAST`
* `MIN_VALUE_TIME`
* `MAX_VALUE_TIME`

## Interpolation

### Interpolation Fields

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `type`  | string | [**Required**] Interpolation [function](#interpolation-functions). |
| `value` | number | [**Required by `VALUE` function**] Constant number used to set value for the missing periods. |
| `extend`  | boolean | Add missing periods at the beginning and the end of the selection interval. Default: `false`. |

Values added by `extend` setting are determined as follows:

* If the `VALUE {n}` interpolation function is specified, the `extend` option sets empty leading/trailing period values to equal `{n}`.
* Without the `VALUE {n}` function, the `extend` option adds missing periods at the beginning and end of the selection interval using the `NEXT` and `PREVIOUS` interpolation functions.

### Interpolation Functions

| **Type** | **Description** |
|:---|:---|
| `NONE` | No interpolation. Periods without any raw values are excluded from results. |
| `PREVIOUS` | Set value for the period based on the previous period value. |
| `NEXT` | Set value for the period based on the next period value. |
| `LINEAR` | Calculate period value using linear interpolation between previous and next period values. |
| `VALUE` | Set value for the period to a specific number. |

## Examples

### Data

#### Detailed Data by Series

```ls
| entity | datetime             | value |
|--------|----------------------|-------|
| e-1    | 2016-06-25T08:00:00Z | 1     |
| e-2    | 2016-06-25T08:00:00Z | 11    |
| e-1    | 2016-06-25T08:00:05Z | 3     | e-1 only
| e-1    | 2016-06-25T08:00:10Z | 5     | e-1 only
| e-1    | 2016-06-25T08:00:15Z | 8     |
| e-2    | 2016-06-25T08:00:15Z | 8     |
| e-1    | 2016-06-25T08:00:30Z | 3     |
| e-2    | 2016-06-25T08:00:30Z | 13    |
| e-1    | 2016-06-25T08:00:45Z | 5     |
| e-2    | 2016-06-25T08:00:45Z | 15    |
| e-2    | 2016-06-25T08:00:59Z | 19    | e-2 only
```

#### Detailed Data Grouped by Timestamp

```ls
| datetime             | e1.value | e2.value |
|----------------------|----------|----------|
| 2016-06-25T08:00:00Z | 1        | 11       |
| 2016-06-25T08:00:05Z | 3        | -        |
| 2016-06-25T08:00:10Z | 5        | -        |
| 2016-06-25T08:00:15Z | 8        | 8        |
| 2016-06-25T08:00:30Z | 3        | 13       |
| 2016-06-25T08:00:45Z | 5        | 15       |
| 2016-06-25T08:00:59Z | -        | 19       |
```

### No Aggregation

When aggregation is disabled, the `group` function is applied to values for all unique timestamps in the merged series.

In the example below, the `SUM` function returns `12 = (1+11)` at `2016-06-25T08:00:00Z` as a total of `e-1` and `e-2` series values, both of which have samples this timestamp.

On the other hand, the `SUM` returns `3 = (3 + null->0)` at `2016-06-25T08:00:05Z` because only `e-1` series has a value at that timestamp.

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

```json
[{"entity":"*","metric":"m-1","tags":{},"entities":["e-1","e-2"],"type":"HISTORY",
    "aggregate":{"type":"DETAIL"},
    "group":{"type":"SUM"},
  "data":[
    {"d":"2016-06-25T08:00:00Z","v":12.0},
    {"d":"2016-06-25T08:00:05Z","v":3.0},
    {"d":"2016-06-25T08:00:10Z","v":5.0},
    {"d":"2016-06-25T08:00:15Z","v":16.0},
    {"d":"2016-06-25T08:00:30Z","v":16.0},
    {"d":"2016-06-25T08:00:45Z","v":20.0},
    {"d":"2016-06-25T08:00:59Z","v":19.0}
]}]
```

```ls
| datetime             | e1.value | e2.value | SUM |
|----------------------|----------|----------|-----|
| 2016-06-25T08:00:00Z | 1        | 11       | 12  |
| 2016-06-25T08:00:05Z | 3        | -        | 3   |
| 2016-06-25T08:00:10Z | 5        | -        | 5   |
| 2016-06-25T08:00:15Z | 8        | 8        | 16  |
| 2016-06-25T08:00:30Z | 3        | 13       | 16  |
| 2016-06-25T08:00:45Z | 5        | 15       | 20  |
| 2016-06-25T08:00:59Z | -        | 19       | 19  |
```

### Truncation

Truncation discards timestamps at the beginning of the interval until all of the merged values have a value.

The example below uses `startDate` of `2016-06-25T08:00:01Z`.

The first time is `MAX(MIN(series_sample_time))`, the last time is `MIN(MAX(series_sample_time))`.

`MAX(MIN(series_sample_time))` = `2016-06-25T08:00:15Z`.

`MIN(MAX(series_sample_time))` = `2016-06-25T08:00:45Z`.

```ls
| datetime             | e1.value | e2.value | SUM |
|----------------------|----------|----------|-----|
| 2016-06-25T08:00:05Z | 3        | -        | 3   | discarded because time < MAX(MIN(series_sample_time))
| 2016-06-25T08:00:10Z | 5        | -        | 5   | discarded because time < MAX(MIN(series_sample_time))
| 2016-06-25T08:00:15Z | 8        | 8        | 16  |
| 2016-06-25T08:00:30Z | 3        | 13       | 16  |
| 2016-06-25T08:00:45Z | 5        | 15       | 20  |
| 2016-06-25T08:00:59Z | -        | 19       | 19  | discarded because time > MIN(MAX(series_sample_time))
```

Samples for series `e-1` at `2016-06-25T08:00:05Z` and at `2016-06-25T08:00:10Z` are discarded because there is no value for series e-2 until `2016-06-25T08:00:15Z`.

Sample for series `e-2` at `2016-06-25T08:00:59Z` is discarded because there is no value for series `e-1` after `2016-06-25T08:00:45Z`.

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

```json
[{"entity":"*","metric":"m-1","tags":{},"entities":["e-1","e-2"],"type":"HISTORY",
    "aggregate":{"type":"DETAIL"},
    "group":{"type":"SUM","truncate":true},
"data":[
    {"d":"2016-06-25T08:00:15Z","v":16.0},
    {"d":"2016-06-25T08:00:30Z","v":16.0},
    {"d":"2016-06-25T08:00:45Z","v":20.0}
]}]
```

```ls
| datetime             | e1.value | e2.value | SUM |
|----------------------|----------|----------|-----|
| 2016-06-25T08:00:15Z | 8        | 8        | 16  |
| 2016-06-25T08:00:30Z | 3        | 13       | 16  |
| 2016-06-25T08:00:45Z | 5        | 15       | 20  |
```

### Extend

An opposite operation to truncation, extend adds missing values at the beginning and end of the interval to ensure that all merged series have values when the `group` function is applied.

```ls
| datetime             | e1.value | e2.value | SUM |
|----------------------|----------|----------|-----|
| 2016-06-25T08:00:05Z | 3        | 8 +      | 11  | e2.value extended to start at the beginning of the interval
| 2016-06-25T08:00:10Z | 5        | 8 +      | 13  | e2.value extended to start at the beginning of the interval
| 2016-06-25T08:00:15Z | 8        | 8        | 16  |
| 2016-06-25T08:00:30Z | 3        | 13       | 16  |
| 2016-06-25T08:00:45Z | 5        | 15       | 20  |
| 2016-06-25T08:00:59Z | 5 +      | 19       | 24  | e1.value extended until the end of the interval
```

```json
[
  {
    "startDate": "2016-06-25T08:00:01Z",
    "endDate":   "2016-06-25T08:01:00Z",
    "entities": ["e-1", "e-2"],
    "metric": "m-1",
    "group": {
      "type": "SUM",
      "interpolate": {
        "type": "NONE",
        "extend": true
      }
    }
  }
]
```

```json
[{"entity":"*","metric":"m-1","tags":{},"entities":["e-1","e-2"],"type":"HISTORY",
    "aggregate":{"type":"DETAIL"},
    "group":{"type":"SUM","interpolate":{"type":"NONE","value":0.0,"extend":true}},
"data":[
    {"d":"2016-06-25T08:00:05Z","v":11.0},
    {"d":"2016-06-25T08:00:10Z","v":13.0},
    {"d":"2016-06-25T08:00:15Z","v":16.0},
    {"d":"2016-06-25T08:00:30Z","v":16.0},
    {"d":"2016-06-25T08:00:45Z","v":20.0},
    {"d":"2016-06-25T08:00:59Z","v":24.0}
]}]
```

Extend is similar to interpolation where missing values at the beginning of in interval are interpolated with `NEXT` type, and missing values at the end of the interval are interpolated with `PREVIOUS` type.

```ls
| datetime             | e1.value | e2.value | SUM |
|----------------------|----------|----------|-----|
| 2016-06-25T08:00:05Z | 3        | 8 +(NEXT)| 11  |
| 2016-06-25T08:00:10Z | 5        | 8 +(NEXT)| 13  |
| 2016-06-25T08:00:15Z | 8        | 8        | 16  |
| 2016-06-25T08:00:30Z | 3        | 13       | 16  |
| 2016-06-25T08:00:45Z | 5        | 15       | 20  |
| 2016-06-25T08:00:59Z | 5 +(PREV)| 19       | 24  |
```

Since `extend` is performed prior to truncation, `truncate` setting has no effect on extended results.

### Interpolation

Interpolation fills the gaps in the raw series. Its behavior depends on the `period` parameter specified in the group processor.

#### `period` parameter is not specified

The `interpolate` function is applied to two consecutive samples of the same series to calculate an interim value for a known timestamp.

Query:

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

Response:

```json
[{"entity":"*","metric":"m-1","tags":{},"entities":["e-1","e-2"],"type":"HISTORY",
    "aggregate":{"type":"DETAIL"},
    "group":{"type":"SUM","interpolate":{"type":"PREVIOUS","value":0.0,"extend":false}},
"data":[
    {"d":"2016-06-25T08:00:00Z","v":12.0},
    {"d":"2016-06-25T08:00:05Z","v":14.0},
    {"d":"2016-06-25T08:00:10Z","v":16.0},
    {"d":"2016-06-25T08:00:15Z","v":16.0},
    {"d":"2016-06-25T08:00:30Z","v":16.0},
    {"d":"2016-06-25T08:00:45Z","v":20.0},
    {"d":"2016-06-25T08:00:59Z","v":19.0}
]}]
```

Two interpolated values are added to the second series:

```ls
| datetime             | e1.value | e2.value | SUM |
|----------------------|----------|----------|-----|
| 2016-06-25T08:00:00Z | 1        | 11       | 12  |
| 2016-06-25T08:00:05Z | 3        | 11 (PREV)| 14  |
| 2016-06-25T08:00:10Z | 5        | 11 (PREV)| 16  |
| 2016-06-25T08:00:15Z | 8        | 8        | 16  |
| 2016-06-25T08:00:30Z | 3        | 13       | 16  |
| 2016-06-25T08:00:45Z | 5        | 15       | 20  |
| 2016-06-25T08:00:59Z | -        | 19       | 19  |
```

#### `period` parameter is specified

Assume that `t1`, `t2`, `t3` are timestamps of consecutive periods, and the series has no samples in the `t2` period. Then interpolated value of the `t2` period is calculated based on two samples: `(t1, v1)` and `(t3, v3)`, where `v1` - is the last series value within the `t1` period, and `v3` is the first series value within the `t3` period.

Query:

```json
[ {
    "startDate": "2016-06-25T08:00:00Z",
    "endDate":   "2016-06-25T08:01:00Z",
    "entities": ["e-1", "e-2"],
    "metric": "m-1",
    "group": {
      "type": "SUM",
      "period": {"count": 10, "unit": "SECOND"},
      "interpolate": {"type": "PREVIOUS"}
    }
}]
```

Response

```json
[{
    "entity": "*", ...,
    "data": [
      {"d": "2016-06-25T08:00:00Z", "v": 15},
      {"d": "2016-06-25T08:00:10Z", "v": 21},
      {"d": "2016-06-25T08:00:20Z", "v": 16},
      {"d": "2016-06-25T08:00:30Z", "v": 16},
      {"d": "2016-06-25T08:00:40Z", "v": 20},
      {"d": "2016-06-25T08:00:50Z", "v": 19}
    ]
}]
```

Interpolated values added to each of the grouped series:

```ls
|                      |          |          | group                | e1 grouped   | e2 grouped   |     |
| datetime             | e1.value | e2.value | timestamp            | interpolated | interpolated | SUM |
|----------------------|----------|----------|-----------------------------------------------------------
| 2016-06-25T08:00:00Z | 1        | 11       | 2016-06-25T08:00:00Z | 1, 3         | 11           | 15  |
| 2016-06-25T08:00:05Z | 3        | -        |                      |              |              |     |
| 2016-06-25T08:00:10Z | 5        | -        | 2016-06-25T08:00:10Z | 5, 8         | 8            | 21  |
| 2016-06-25T08:00:15Z | 8        | 8        |                      |              |              |     |
| 2016-06-25T08:00:20Z | -        | -        | 2016-06-25T08:00:20Z | 8 (PREV)     | 8 (PREV)     | 16  |
| 2016-06-25T08:00:30Z | 3        | 13       | 2016-06-25T08:00:30Z | 3            | 13           | 16  |
| 2016-06-25T08:00:40Z | -        | -        | 2016-06-25T08:00:40Z | 5            | 15           | 20  |
| 2016-06-25T08:00:45Z | 5        | 15       |                      |              |              |     |
| 2016-06-25T08:00:50Z | -        | -        | 2016-06-25T08:00:50Z | -            | 19           | 19  |
| 2016-06-25T08:00:59Z | -        | 19       |                      |              |              |     |
```

### Group Aggregation

By default, the `group` function is applied to all unique sample times from the merged series.
To split values into periods, specify a period.

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

```json
[{"entity":"*","metric":"m-1","tags":{},"entities":["e-1","e-2"],"type":"HISTORY",
    "aggregate":{"type":"DETAIL"},
    "group":{"type":"SUM","period":{"count":10,"unit":"SECOND","align":"CALENDAR"}},
"data":[
    {"d":"2016-06-25T08:00:00Z","v":15.0},
    {"d":"2016-06-25T08:00:10Z","v":21.0},
    {"d":"2016-06-25T08:00:30Z","v":16.0},
    {"d":"2016-06-25T08:00:40Z","v":20.0},
    {"d":"2016-06-25T08:00:50Z","v":19.0}
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

### Aggregation -> Group

The `Aggregation -> Group` order creates aggregate series for each of the merged series and then performs grouping of the aggregated series.

The timestamps used for grouping combine period start times from the underlying aggregated series.

```ls
| 10-sec period start  | e1.COUNT | e2.COUNT | SUM |
|----------------------|----------|----------|-----|
| 2016-06-25T08:00:00Z | 2        | 1        | 3   |
| 2016-06-25T08:00:10Z | 2        | 1        | 3   |
| 2016-06-25T08:00:20Z | -        | -        | -   | Period not created because there are no detailed values in the [00:20-00:30) period for any series.
| 2016-06-25T08:00:30Z | 1        | 1        | 2   |
| 2016-06-25T08:00:40Z | 1        | 1        | 2   |
| 2016-06-25T08:00:50Z | 0        | 1        | 1   |
```

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
      "type": "SUM"
    }
  }
]
```

```json
[{"entity":"*","metric":"m-1","tags":{},"entities":["e-1","e-2"],"type":"HISTORY",
"aggregate":{"type":"COUNT","period":{"count":10,"unit":"SECOND","align":"CALENDAR"}},
"group":{"type":"SUM"},
"data":[
    {"d":"2016-06-25T08:00:00Z","v":3.0},
    {"d":"2016-06-25T08:00:10Z","v":3.0},
    {"d":"2016-06-25T08:00:30Z","v":2.0},
    {"d":"2016-06-25T08:00:40Z","v":2.0},
    {"d":"2016-06-25T08:00:50Z","v":1.0}
]}]
```

### Group -> Aggregation

The `Group -> Aggregation` merges series first, and then splits the merged series into periods.

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
| datetime             | e1.value | e2.value | SUM |
|----------------------|----------|----------|-----|
| 2016-06-25T08:00:00Z | 1        | 11       | 12  |
| 2016-06-25T08:00:05Z | 3        | -        | 3   |
| 2016-06-25T08:00:10Z | 5        | -        | 5   |
| 2016-06-25T08:00:15Z | 8        | 8        | 16  |
| 2016-06-25T08:00:30Z | 3        | 13       | 16  |
| 2016-06-25T08:00:45Z | 5        | 15       | 20  |
| 2016-06-25T08:00:59Z | -        | 19       | 19  |
```

The grouped `SUM` series is then aggregated into periods.

> Note that if period is not specified, the `group` function automatically applies aggregation for the same period as the `aggregate` function.<br>To avoid this, specify `"period": {"count": 1, "unit": "MILLISECOND"}` in `group`.

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

```ls
| datetime             | COUNT(SUM(value)) |
|----------------------|-------------------|
| 2016-06-25T08:00:00Z | 2                 |
| 2016-06-25T08:00:10Z | 2                 |
| 2016-06-25T08:00:30Z | 1                 |
| 2016-06-25T08:00:40Z | 1                 |
| 2016-06-25T08:00:50Z | 1                 |
```

```json
[{"entity":"*","metric":"m-1","tags":{},"entities":["e-1","e-2"],"type":"HISTORY",
    "aggregate":{"type":"COUNT","period":{"count":10,"unit":"SECOND","align":"CALENDAR"}},
    "group":{"type":"SUM","period":{"count":1,"unit":"MILLISECOND","align":"CALENDAR"}},
"data":[
    {"d":"2016-06-25T08:00:00Z","v":2.0},
    {"d":"2016-06-25T08:00:10Z","v":2.0},
    {"d":"2016-06-25T08:00:30Z","v":1.0},
    {"d":"2016-06-25T08:00:40Z","v":1.0},
    {"d":"2016-06-25T08:00:50Z","v":1.0}
]}]
```

## Placement

Divide grouped series into several groups based on constraint and objective function specified in the Place object. ATSD supports two types of placement:

* Exact solution of some kind of optimal partitioning problem: [Optimal Partitioning](#optimal-partitioning).

* Approximate solution of a variant of packing problem: [Approximate Packing](#approximate-packing).

### Place Object Fields

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| `count`  | string | Maximum count of subgroups, response may contain less than maximum. |
| `entities` | array | List of entities. Each entity contains numeric characteristics of a subgroup. |
| `entityGroup` | string | Another way to specify entities by [entity group](../../../api/meta/entity-group/README.md) name. |
| `entityExpression`  | string | [Expression](../../../api/data/filter-entity.md) which determines set of entities. |
| `constraint` | string | Boolean MVEL expression that series from each subgroup must satisfy, for example max() < 10. |
| `minimize` | string | Function calcuated for each subgroup. Sum calculated values over all subgroups is minimised. |
| `method` | string | The algorithm used to solve [Approximate Packing](#approximate-packing) problem. Admissible values: `greedy_simple` (default), or `greedy_correlations`.|

### Functions Available in the Placement Context

* stdev()
* median_abs_dev()
* max()
* min()
* sum()
* count()
* median()
* avg()
* percentile(p)

### Optimal Partitioning

The problem is to find the best partition of given group of time series into no more then specified number of subgroups.

Maximum count of subgroups is value of the `count` parameter. The best is a partition which satisfies the constraints and for which value of objective function is minimal. To check constraints and evaluate objective function the following calculations are performed:

* Calculate aggregated series for each subgroup. Use specified `type`, `period`, `interpolate`, and `truncate` to perform aggregation.

* Calculate boolean `constraint` expression for each aggregated series. If for any subgroup the expression is evaluated to `false` then reject the partition. The `constraint` expression could use the following [functions](#functions-available-in-the-placement-context) which are evaluated for aggregated series values.

* For each subgroup calculate value of the `minimize` expression. This expression can use the same [functions](#functions-available-in-the-placement-context).

* Value of objective function is sum of values calculated on the previous step.

* If objective function reaches minimum on several partitions then select one of partitions with the least cardinality.

#### Algorithm Complexity

To exactly determine the optimal partitioning we need loop over all partitions of given set of cardinality N into no more then K subsets. So total count of possible partitions equals to sum of [Stirling](https://en.wikipedia.org/wiki/Stirling_numbers_of_the_second_kind) numbers S(N, K) + S(N, K - 1) + ... + S(N, K).
This sum grows extremely fast, for example, count of partions of 20 series into no more then 7 subgroups equals to `31_415_584_940_850`. ATSD implements the algorithm for number of grouped series < 64, but returns wrong result if number of partitions exceeds `Long.MAX_VALUE`. As we see the problem became computationally intractible already for N > 19 and K > 6.
`(TODO: throw an Exception if number of partitions exceeds 100_000.)`

#### Query Example

```json
[{
  "startDate": "2019-02-01T00:00:00Z",
  "endDate":   "2019-08-08T00:00:00Z",
  "entity": "*",
  "metric": "cpu_usage",
  "group": {
    "type": "SUM",
    "period": {"count": 1, "unit": "HOUR"},
    "interpolate": {"extend": false, "type": "NONE"},
    "place": {
      "count": 3,
      "constraint": "max() < 10",
      "minimize": "stdev()"
    }
  },
  "limit": 2
}]
```

#### Response

The response contains information about series in each subgroup, minimal value of objective function in the `totalScore` field, value calculated for each group in the `groupScore` field, and aggregated series for each subgroup as the `data`.

```json
[
  {
    "entity": "*",
    "metric": "lp_usage",
    "exactMatch": false,
    "type": "HISTORY",
    "meta": {
      "groupScore": 0.0021842975376114887,
      "series": [
        {"entity": "lp_1", "tags": {}, "label": "lp_1"},
        {"entity": "lp_2", "tags": {}, "label": "lp_2"},
        {"entity": "lp_3", "tags": {}, "label": "lp_3"}
      ],
      "name": "lp_1 lp_2 lp_3",
      "totalScore": 0.0021842975376114887
    },
    "transformationOrder": ["GROUP"],
    "group": {
      "series": [
        {"entity": "lp_1", "tags": {}, "label": "lp_1"},
        {"entity": "lp_2", "tags": {}, "label": "lp_2"},
        {"entity": "lp_3", "tags": {}, "label": "lp_3"}
      ],
      "groupScore": 0.0021842975376114887,
      "totalScore": 0.0021842975376114887,
      "type": "SUM",
      "period": {"count": 1, "unit": "HOUR", "align": "CALENDAR"},
      "interpolate": {"type": "NONE", "extend": false},
      "truncate": false,
      "place": {"count": 3, "constraint": "max() < 10", "minimize": "stdev()"}
    },
    "data": [
      {"d": "2019-02-07T22:00:00.000Z", "v": 4.998999189242195},
      {"d": "2019-02-07T23:00:00.000Z", "v": 5.000519124198814}
    ]
  },
  {
    "entity": "*",
    "metric": "lp_usage",
    "exactMatch": false,
    "type": "HISTORY",
    "meta": {
      "groupScore": 0,
      "series": [
        {"entity": "lp_6", "tags": {}, "label": "lp_6"},
        {"entity": "lp_7", "tags": {}, "label": "lp_7"}
      ],
      "name": "lp_6 lp_7",
      "totalScore": 0.0021842975376114887
    },
    "transformationOrder": ["GROUP"],
    "group": {
      "series": [
        {"entity": "lp_6", "tags": {}, "label": "lp_6"},
        {"entity": "lp_7", "tags": {}, "label": "lp_7"}
      ],
      "groupScore": 0,
      "totalScore": 0.0021842975376114887,
      "type": "SUM",
      "period": {"count": 1, "unit": "HOUR", "align": "CALENDAR"},
      "interpolate": {"type": "NONE", "extend": false},
      "truncate": false,
      "place": {"count": 3, "constraint": "max() < 10", "minimize": "stdev()"}
    },
    "data": [
      {"d": "2019-02-07T22:00:00.000Z", "v": 5},
      {"d": "2019-02-07T23:00:00.000Z", "v": 5}
    ]
  },
  {
    "entity": "*",
    "metric": "lp_usage",
    "exactMatch": false,
    "type": "HISTORY",
    "meta": {
      "groupScore": 0,
      "series": [
        {"entity": "lp_4", "tags": {},"label": "lp_4"},
        {"entity": "lp_5", "tags": {}, "label": "lp_5"}
      ],
      "name": "lp_4 lp_5",
      "totalScore": 0.0021842975376114887
    },
    "transformationOrder": ["GROUP"],
    "group": {
      "series": [
        {"entity": "lp_4", "tags": {},"label": "lp_4"},
        {"entity": "lp_5", "tags": {}, "label": "lp_5"}
      ],
      "groupScore": 0,
      "totalScore": 0.0021842975376114887,
      "type": "SUM",
      "period": {"count": 1, "unit": "HOUR", "align": "CALENDAR"},
      "interpolate": {"type": "NONE", "extend": false},
      "truncate": false,
      "place": {"count": 3, "constraint": "max() < 10", "minimize": "stdev()"}
    },
    "data": [
      {"d": "2019-02-07T22:00:00.000Z", "v": 5},
      {"d": "2019-02-07T23:00:00.000Z", "v": 5}
    ]
  }
]
```

### Approximate Packing

The problem is to divide group of series into several subgroups, so that series in each subgroup satisfy the `constraint`.

This problem is similar with the [Optimal Partitioning](#optimal-partitioning), but objective function is not used, and the `constraint` expression may use variables to refer numeric subgroup parameters and parameters of series in the subgroup.

ATSD uses entity tags to pass subgroup parameters and series parameters to the `constraint`.

So each subgroup has dedicated entity, and parameters of the subgroup must be stored in ATSD as the entity tags with numeric values. Each value is available in the `constraint` expression by the tag name.

#### Subgroup Parameters Example

Let there are entities with tags `cpu_limit` and  `memory_limit`:

```ls
| entity name\ tags | cpu_limit | memory_limit |
|-------------------|-----------|--------------|
| lp_group_1        |        10 |           20 |
| lp_group_2        |         8 |           40 |
| lp_group_3        |        12 |           10 |
| lp_group_4        |        14 |           20 |
| lp_group_5        |         8 |           10 |
```

The `constraint` expression may use the variable `cpu_limit`:

```json
"constraint": "max() < cpu_limit"
```

When the expression is evaluated for the subgroup corresponding to entity `lp_group_1` the value of `cpu_limit` is 10.

Each series also may store series numeric parameters in tags of series entity.
This parameters are available in the `constraint` expression by tag name prepended by the prefix `entity.`.

#### Series Parameters Example

Let series entities have tag `memory_allocated`:

```ls
| entity name\ tags | memory_allocated |
|-------------------|------------------|
| lp_1              |                4 |
| lp_2              |                4 |
| lp_3              |                4 |
| lp_4              |                8 |
| lp_5              |                4 |
| lp_6              |                2 |
| lp_7              |                4 |
```

// TODO - rename prefix `entity.` -> `series.`

The following `constraint` means that sum of `memory_allocated` parameters of all series in given subgroup is less then 14:

```json
"constraint": "sum(entity.memory_allocated) < 14"
```

Another example. Let series `lp_2, lp_3, lp_6` are placed in a group dedicated to entity `lp_group_1`. Then following constraint means that maximal value of aggregated series computed for `lp_2, lp_3, lp_6` is less than `cpu_limit = 10`, and sum of memory allocated to each series `sum(entity.memory_allocated) = 4 + 4 + 2` is 
less that `memory_limit = 20`.

```json
"constraint": "max() < cpu_limit && sum(entity.memory_allocated) < memory_limit"
```

#### Approximate Packing Complexity

Exact solution of the Approximate Packing problem requires consider each of
![complexity](./images/complexity.png)
possible assignment of N series to K subgroups. This became computationally unfeasible soon, for small values of N and K. ATSD implements two approximate algorithms to solve the problem.

#### Approximate Packing Algorithm

The algorithm works as follows.

* Sort entities.
* Form a subgroup for each entity in order.
* Collect all not placed series into special subgroup.

The second step depends on selected `method`.

#### Method `greedy_simple`

In this case all series are sorted in the beginning of the algorithm.
Algorithm iterates over all not yet placed series and tries to append series to current group. Then not placed series are considered the step is completed.

#### Method `greedy_correlations`

Select first series in the subgroup arbitrarily.

If some series already are placed in the subgroup then calculate aggregation function, specified in the `type` parameter for them. Then calculate correlations between aggregated series and each not yet placed series, and sort series in increasing order of correlations. Iterate over series starting from series with the least correlation, and try to append series to the subgroup. As some series appended, repeat all calculations: recalculate aggregated series, correlations coefficients, and try to add next series to the subgroup. The step is completed if no more series could be added to the subgroup.

#### Approximate Query Example

```json
[{
  "startDate": "2019-02-01T00:00:00Z",
  "endDate":   "2019-02-08T00:00:00Z",
  "entity": "*",
  "metric": "lp_usage",
  "group": {
    "type": "SUM",
    "period": {"count": 1, "unit": "HOUR"},
    "interpolate": {"extend": true, "type": "LINEAR"},
    "place": {
      "entities": ["lp_group_1", "lp_group_2", "lp_group_3", "lp_group_4", "lp_group_5"],
      "constraint": "max() < cpu_limit && sum(entity.memory_allocated) < memory_limit",
      "method": "greedy_correlations"
    }
  }
}]
```

#### Approximate Query Response

```json
[
  {
    "entity": "*",
    "metric": "lp_usage",
    "exactMatch": false,
    "type": "HISTORY",
    "meta": {
      "groupScore": 0,
      "series": [
        {"entity": "lp_1", "tags": {}, "label": "lp_1"},
        {"entity": "lp_2", "tags": {}, "label": "lp_2"},
        {"entity": "lp_3", "tags": {}, "label": "lp_3"},
        {"entity": "lp_5", "tags": {}, "label": "lp_5"}
      ],
      "name": "lp_1 lp_2 lp_3 lp_5",
      "group-entity": "lp_group_1",
      "grouping-tags": {"cpu_limit": "10", "memory_limit": "20"},
      "totalScore": 0
    },
    "transformationOrder": ["GROUP"],
    "group": {
      "series": [ 
        {"entity": "lp_1", "tags": {}, "label": "lp_1"},
        {"entity": "lp_2", "tags": {}, "label": "lp_2"},
        {"entity": "lp_3", "tags": {}, "label": "lp_3"},
        {"entity": "lp_5", "tags": {}, "label": "lp_5"}
      ],
      "groupScore": 0,
      "totalScore": 0,
      "entity": "lp_group_1",
      "tags": {"cpu_limit": "10", "memory_limit": "20"},
      "type": "SUM",
      "period": {"count": 1, "unit": "HOUR", "align": "CALENDAR"},
      "interpolate": {"type": "LINEAR", "extend": true},
      "truncate": false,
      "place": {
          "count": 0, 
          "constraint": "max() < cpu_limit && sum(entity.memory_allocated) < memory_limit"
      }
    },
    "data": [
      {"d": "2019-02-07T23:00:00.000Z", "v": 9.000519124198814},
      {"d": "2019-02-08T00:00:00.000Z", "v": 9.000519124198814}
    ]
  },
  {
    "entity": "*",
    "metric": "lp_usage",
    "exactMatch": false,
    "type": "HISTORY",
    "meta": {
      "groupScore": 0,
      "series": [
        {"entity": "lp_4", "tags": {}, "label": "lp_4"},
        {"entity": "lp_6", "tags": {}, "label": "lp_6"},
        {"entity": "lp_7", "tags": {}, "label": "lp_7"}
      ],
      "name": "lp_4 lp_6 lp_7",
      "group-entity": "lp_group_2",
      "grouping-tags": {"cpu_limit": "8", "memory_limit": "40"},
      "totalScore": 0
    },
    "transformationOrder": ["GROUP"],
    "group": {
      "series": [
        {"entity": "lp_4", "tags": {}, "label": "lp_4"},
        {"entity": "lp_6", "tags": {}, "label": "lp_6"},
        {"entity": "lp_7", "tags": {}, "label": "lp_7"}
      ],
      "groupScore": 0,
      "totalScore": 0,
      "entity": "lp_group_2",
      "tags": {"cpu_limit": "8", "memory_limit": "40"},
      "type": "SUM",
      "period": {"count": 1, "unit": "HOUR", "align": "CALENDAR"},
      "interpolate": {"type": "LINEAR", "extend": true },
      "truncate": false,
      "place": {
        "count": 0,
        "constraint": "max() < cpu_limit && sum(entity.memory_allocated) < memory_limit"
      }
    },
    "data": [
      {"d": "2019-02-07T23:00:00.000Z", "v": 6},
      {"d": "2019-02-08T00:00:00.000Z", "v": 6}
    ]
  },
  ...
]
```