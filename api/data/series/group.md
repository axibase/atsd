# Group Processor

Groups multiple input series into one series and applies a statistical function to grouped values.

The group process is implemented as follows:

1. Load detailed data within the specified `startDate` and `endDate` for each series separately. `startDate` is inclusive and `endDate` is exclusive.
2. Group multiple series:
  - If `period` is specified in the query:
<br> Split each series' `time:value` array into periods based on the `period`  parameter. Discard periods with start time earlier than `startDate` or greater than `endDate`. Group multiple series samples within the same period. Timestamp of a group equals to the period start time.
  - If `period` is not specified:
Multiple series samples are grouped at all unique timestamps in the input series.
Each group has an ordered list of pairs: [timestamp | samples of several series with given timestamp].
3. Interpolate grouped series according to the `interpolate` field.
4. Truncate grouped series if `truncate` field is `true`.
5. Apply [statistical function](../../../api/data/aggregation.md) to values in each group and return a `time:value` array, where time is the period start time and value is the result of the statistical function.

| **Parameter** | **Type** | **Description**  |
|:---|:---|:---|
| type          | string          | **[Required]** Grouping [function](#grouping-functions) applied to values of the input series. |
| period      | object           | [Period](period.md). Splits the merged series into periods and applies the statistical function to values in each period separately.<br>Default value: `undefined`. If period is undefined, and the query includes both `group` and `aggregate` objects, the group's period is inherited from `aggregate` object.|
| interpolate   | object           | [Interpolation](#interpolation) function to fill gaps in input series (no period) or in grouped series (if period is specified). Default value: `NONE` |
| truncate      | boolean           | Discards samples at the beginning of the interval until values for all input series are established. Default: false.  |
| order         | integer           | Controls the processing sequence of the `group`, `rate` and `aggregate` stages. The stage with the smallest order is executed first. If the stages have the same order, the default order is: `group`, `rate`, `aggregate`. Default value: `0`.  |

## Grouping Functions

* COUNT
* MIN
* MAX
* AVG
* SUM
* PERCENTILE_999
* PERCENTILE_995
* PERCENTILE_99
* PERCENTILE_95
* PERCENTILE_90
* PERCENTILE_75
* PERCENTILE_50
* PERCENTILE_25
* PERCENTILE_10
* PERCENTILE_5
* PERCENTILE_1
* PERCENTILE_05
* PERCENTILE_01
* MEDIAN
* STANDARD_DEVIATION
* FIRST
* LAST
* MIN_VALUE_TIME
* MAX_VALUE_TIME

## Interpolation

### Interpolation Fields

| **Name** | **Type**  | **Description**   |
|:---|:---|:---|
| type  | string | [**Required**] Interpolation [function](#interpolation-functions). |
| value | number | [**Required by `VALUE` function**] Constant number used to set value for the missing periods. |
| extend  | boolean | Add missing periods at the beginning and the end of the selection interval. Default: `false`. |

Values added by `extend` setting are determined as follows:

* If the `VALUE {n}` interpolation function is specified, the `extend` option sets empty leading/trailing period values to equal `{n}`.
* Without the `VALUE {n}` function, the `extend` option adds missing periods at the beginning and end of the selection interval using the `NEXT` and `PREVIOUS` interpolation functions.

### Interpolation Functions

| **Type** | **Description** |
|:---|:---|
| NONE | No interpolation. Periods without any raw values are excluded from results. |
| PREVIOUS | Set value for the period based on the previous period's value. |
| NEXT | Set value for the period based on the next period's value. |
| LINEAR | Calculate period value using linear interpolation between previous and next period values. |
| VALUE| Set value for the period to a specific number. |

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

In the example below, the `SUM` function returns 12 (1+11) at `2016-06-25T08:00:00Z` as a total of e-1 and e-2 series values, both of which have samples this timestamp.

On the other hand, the `SUM` returns 3 (3 + null->0) at `2016-06-25T08:00:05Z` because only e-1 series has a value at that timestamp.

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
	"group":{"type":"SUM","order":0},
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
	"group":{"type":"SUM","truncate":true,"order":0},
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

An opposite operation to truncation, extend adds missing values at the beginning and end of the interval so that all merged series have values when the `group` function is applied.

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
	    "interpolate": { "extend": true }
    }
  }
]
```

```json
[{"entity":"*","metric":"m-1","tags":{},"entities":["e-1","e-2"],"type":"HISTORY",
	"aggregate":{"type":"DETAIL"},
	"group":{"type":"SUM","interpolate":{"type":"NONE","value":0.0,"extend":true},"order":0},
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

#### `period` parameter is not specified.

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
	"group":{"type":"SUM","interpolate":{"type":"PREVIOUS","value":0.0,"extend":false},"order":0},
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

Two interpolated values were added to the second series:

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
#### `period` parameter is specified.

Let `t1`, `t2`, `t3` be timestamps of consecutive periods, and lets assume the series has no samples in the `t2` period. Then interpolated value of the `t2` period will be calculated based on two samples: `(t1, v1)` and `(t3, v3)`, where `v1` - is the last series value within the `t1` period, and `v3` is the first series value within the `t3` period.

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

Interpolated values were added to each of the grouped series:

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
	"group":{"type":"SUM","period":{"count":10,"unit":"SECOND","align":"CALENDAR"},"order":0},
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
      "period": {"count": 10, "unit": "SECOND"},
	    "order": 0
    },    
    "group": {
      "type": "SUM",
	    "order": 1
    }
  }
]
```

```json
[{"entity":"*","metric":"m-1","tags":{},"entities":["e-1","e-2"],"type":"HISTORY",
"aggregate":{"type":"COUNT","period":{"count":10,"unit":"SECOND","align":"CALENDAR"}},
"group":{"type":"SUM","order":1},
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
      "period": {"count": 10, "unit": "SECOND"},
	    "order": 1
    },    
    "group": {
      "type": "SUM",
      "period": {"count": 1, "unit": "MILLISECOND"},
	    "order": 0
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
	"group":{"type":"SUM","period":{"count":1,"unit":"MILLISECOND","align":"CALENDAR"},"order":0},
"data":[
	{"d":"2016-06-25T08:00:00Z","v":2.0},
	{"d":"2016-06-25T08:00:10Z","v":2.0},
	{"d":"2016-06-25T08:00:30Z","v":1.0},
	{"d":"2016-06-25T08:00:40Z","v":1.0},
	{"d":"2016-06-25T08:00:50Z","v":1.0}
]}]
```
