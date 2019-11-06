# Database Series Functions

## Overview

These functions retrieve series records from the database at any stage of the rule evaluation process.

The `db_last` and `db_statistic` functions retrieve the last stored value or calculate statistics from other stored values. The queried series can be different from the series in the current window.

Related functions:

* [`value`](functions-value.md)

## Reference

* [`db_last`](#db_last)
* [`db_statistics`](#db_statistics)
* [`db_statistic`](#db_statistic)
* [`db_baseline`](#db_baseline)

### `db_last`

```csharp
db_last(string metric [, string entity [, string tags | map tags]]) number
```

Retrieves the most recent (last) value stored in the database for the specified series. Returns `Double.NaN` if no matching series is found.

The `metric` argument specifies the name of the metric for which to retrieve the value. If no other arguments are specified, the data is loaded for same entity and tags as defined in the current window.

```javascript
value > 60 && db_last('temperature') < 30
```

As an alternative, if the specified metric is received in the same `series` command, use the [`value()`](functions-value.md) function. The `value()` function returns metric values set in the command **without** querying the database.

To load data for an entity, other than the entity in the current window, specify `entity` name as a literal string or a field in the second argument.

Example:

```javascript
value > 60 && db_last('temperature', 'sensor-01') < 30
```

```javascript
value > 60 && db_last('temperature', tags.target) < 30
```

To retrieve data for different series tags, specify them in the third argument:

* Empty string `''` for no series tags.
* String containing one or multiple `name=value` pairs separated by comma: `'tag1=value1,tag2=value2'`.
* Key-value map: `['tag1':'value1','tag2':'value2']`
* The `tags` field representing the grouping tags of the current window.

```csharp
db_last(string metric, string entity, string tags) number
```

```csharp
db_last(string metric, string entity, map tags) number
```

Example:

```javascript
value > 60 && db_last('temperature', 'sensor-01', 'stage=heating,unit=c') < 30
```

### `db_statistics`

```csharp
db_statistics(string interval, [ string metric, [string entity, [string tags | map tags]]]) number
```

Returns an object with all statistics that can be retrieved with the [`db_statistic`](#db_statistic) function. The statistics can be accessed by name as the object fields.

```javascript
avg() > 60 && db_statistics('3 hour', 'temperature').avg > 30
```

> The query must match only **one** series.

The object can be initialized as a local variable and re-used in the expression.

```javascript
// stats = db_statistics('3 hour', 'temperature')
avg() > 60 && stats.avg > 30 && stats.max < 90
```

Function names:

```txt
- min
- max
- avg
- count
- sum
- median
- stdDev
- first
- last
- delta
- counter
- wavg
- wtavg
- minValueTime
- maxValueTime
- slope
- intercept
- percentile99_9 (percentile 99.9)
- percentile99_5 (percentile 99.5)
- percentile99
- percentile95
- percentile90
- percentile75
- percentile50
- percentile25
- percentile10
- percentile5
- percentile1
- percentile0_5 (percentile 0.5)
- percentile0_1 (percentile 0.1)
```

### `db_multi_statistics`

```csharp
db_multi_statistics(string interval, [ string metric, [string entity, [string tags | map tags]]]) number
```

Returns an object with the same statistics as the [`db_statistics`](#db_statistics) function except `delta`, `counter`, `wavg`, `wtavg`, `slope`, and `intercept`. The statistics are calculated from **all** matching series unlike `db_statistics` which allows only one series.

```javascript
avg() > 60 && db_multi_statistics('3 hour', 'temperature').max > 50
```

### `db_statistic`

```csharp
db_statistic(string function, string interval, [ string metric, [string entity, [string tags | map tags]]]) number
```

Returns the result of a statistical function applied to historical values loaded from the database. The function returns `Double.NaN` if no matching series are found or if no records are present within the selection interval.

> The query must match only **one** series.

The `function` argument accepts a [statistical function](../api/data/aggregation.md) name such as `avg` applied to all values within the selection interval.

The `interval` argument is the duration of the selection interval specified in 'count [units](../shared/calendar.md#interval-units)', for example, '1 hour'. The end of the selection interval is set to **current time**. The loaded interval is `(current_timestamp - interval, current_timestamp]`.

If no other arguments are provided, the data is loaded for same metric, entity and tags as defined in the current window.

```javascript
avg() > 60 && db_statistic('avg', '3 hour') > 30
```

To load data for a metric, other than the metric in the current window, specify `metric` name as a literal string or a field in the third argument.

```javascript
avg() > 60 && db_statistic('avg', '3 hour', 'temperature') < 50
```

To load data for an entity, other than the entity in the current window, specify `entity` name as a literal string or a field in the fourth argument.

```javascript
avg() > 60 && db_statistic('avg', '3 hour', 'temperature', 'sensor-01') < 50
```

To retrieve data for different series tags, specify them in the third argument:

* Empty string `''` for no series tags.
* String containing one or multiple `name=value` pairs separated by comma: `'tag1=value1,tag2=value2'`.
* Key-value map: `['tag1':'value1','tag2':'value2']`
* The `tags` field representing the grouping tags of the current window.

```javascript
db_last(string metric, string entity, string tags) number
```

```javascript
db_last(string metric, string entity, map tags) number
```

Examples:

```javascript
avg() > 60 && db_statistic('avg', '3 hour', 'temperature', 'sensor-01', 'stage=heating,unit=c') < 50
```

```javascript
avg() > 60 && db_statistic('avg', '3 hour', 'temperature', 'sensor-01', ['stage':'heating', 'unit':'c']) < 50
```

```javascript
avg() > 60 && db_statistic('avg', '3 hour', 'temperature', 'sensor-01', tags) < 50
```

### `db_baseline`

```csharp
db_baseline(string statFunc, int count, string period [, string windowLength]) number
```

Returns the averaged value (baseline) for the data stored in the rule window.

The algorithm of calculating the baseline is as follows:

1) Regularize historical data into periods, each of `windowLength` duration, with the last period ending with the timestamp of the last command.
2) Load samples for N (`count`) previous windows, excluding the last window. The distance between the previous windows is set with `period`.
3) Apply statistical function `statFunc`, such as `avg` or `median`, to the filtered values.

> If the `windowLength` is not set explicitly, the length of the window equals **Window Size** for time-based windows. For count-based windows the `windowLength` is a required parameter.

Example:

```csharp
// Last command time is 2019-01-20 10:08:00
// Period is 1 day and count is 5
// Windows are (10:03 - 10:08] on 01-15, ... , 01-19
// The result is 4.0

db_baseline('avg', 5, '1 day', '5 minute')
```

| Window | Window Average |
|---|---|---:|
| `2019-01-15 (10:03-10:08]` | `10.0` |
| `2019-01-16 (10:03-10:08]` | `0.0` |
| `2019-01-17 (10:03-10:08]` | `0.0` |
| `2019-01-18 (10:03-10:08]` | `10.0` |
| `2019-01-19 (10:03-10:08]` | `0.0` |

* ChartLab [example](https://apps.axibase.com/chartlab/1e8ed72e)

## Series Match Examples

Both `db_last` and `db_statistic` functions search the database for matching series based on the specified `metric`/`entity`/`tags` filter and return a numeric value for the first matched series. If the series in the current window has tags which are not collected by the specified metric and entity, those tags are excluded from the filter.

### `Tags : No Tags`

In the example below, the `db_last('cpu_busy')` function ignores the tags `mount_point` and `file_system` because the tags are not collected by the metric `cpu_busy`.

* Current Window

```elm
metric = disk_used
entity = nurswgvml007
tags   = mount_point=/,file_system=/sda
```

* Expression

```javascript
db_last('cpu_busy') > 10
```

* Search Filter

```elm
metric = cpu_busy
entity = nurswgvml007
tags   = [empty - no tags]
```

* Matched Series

```elm
metric = cpu_busy
entity = nurswgvml007
tags   = no tags
```

### `Same Tags`

In this example, the function `db_last('disk_used_percent')` uses the same series tags as in the current window because all of these tags are collected by the metric `disk_used_percent`.

* Current Window

```elm
metric = disk_used
entity = nurswgvml007
tags   = mount_point=/,file_system=/sda
```

* Expression

```javascript
db_last('disk_used_percent') > 90
```

* Search Filter

```elm
metric = disk_used_percent
entity = nurswgvml007
tags   = mount_point=/,file_system=/sda
```

* Matched Series

```elm
metric = cpu_busy
entity = nurswgvml007
tags   = mount_point=/,file_system=/sda
```

### `No Tags : Tags`

In this example, the function `db_last('disk_used_percent')` searches for a series with **any** tags configuration; the metric `cpu_busy` in the current window has no tags. If the search matches multiple series, the first series is returned. To better control which series is matched, use `db_last('disk_used_percent', entity, 'mount_point=/')` syntax.

* Current Window

```elm
metric = cpu_busy
entity = nurswgvml007
tags   = [empty - no tags]
```

* Expression

```java
db_last('disk_used_percent') > 90
```

* Search Filter

```elm
metric = disk_used_percent
entity = nurswgvml007
tags   = [empty - no tags]
```

* Matched Series

```elm
metric = disk_used_percent
entity = nurswgvml007
tags   = mount_point=/,file_system=/sda
```

### `Different Tags`

In this example, the function `db_last('io_disk_percent_util')` searches for the first series with **any** tags configuration; the metrics `io_disk_percent_util` and `disk_used` have different non-intersecting tag sets. If the search matches multiple series, the first series is returned. To better control which series is matched, use `db_last('io_disk_percent_util', entity, 'device=sda')` syntax.

* Current Window

```elm
metric = disk_used_percent
entity = nurswgvml007
tags   = mount_point=/,file_system=/sda
```

* Expression

```java
db_last('io_disk_percent_util') > 90
```

* Search Filter

```elm
metric = io_disk_percent_util
entity = nurswgvml007
tags   = [empty - no tags - because there are no intersecting tag names]
```

* Matched Series

```elm
metric = io_disk_percent_util
entity = nurswgvml007
tags   = device=sda
```