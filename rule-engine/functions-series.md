# Database Series Functions

## Overview

The functions provide a way to retrieve series records from the database at any stage of the rule evaluation process.

The `db_last` and `db_statistic` functions retrieve the last stored value or calculate statistics from other stored values. The queried series may be different from the series in the current window.

## Reference

* [`db_last`](functions-db.md#db_laststring-m)
* [`db_statistic`](functions-db.md#db_statistic)

## `db_last`

The `db_last` function retrieves the most recent value stored in the database for the specified series, regardless of when it was stored.

The functions return `Double.NaN` if no matching series is found.

### `db_last(string m)`

```javascript
  db_last(string m) number
```

Retrieves the last value for the specified metric `m` and the same entity and tags as defined in the current window.

Example:

```javascript
  value > 60 && db_last('temperature') < 30
```

> As an alternative, if the specified metric was received in the same command, use the [`value()`](functions-value.md) function. The `value()` function returns metric values set in the command, even before it is stored in the database.

### `db_last(string m, string e)`

```javascript
db_last(string m, string e) number
```

Retrieves the last value for the specified metric `m` and entity `e`.

The entity `e` can be specified as a string literal value or with an `entity` field in which case it represents the name of the entity in the current window.

Example:

```javascript
  value > 60 && db_last('temperature', 'sensor-01') < 30
```

```javascript
  // same as db_last('temperature')
  value > 60 && db_last('temperature', entity) < 30
```

### `db_last(string m, string e, string t | [] t)`

```javascript
  db_last(string m, string e, string t) number
```

```javascript
  db_last(string m, string e, [] t) number
```

Retrieves the last value for the specified metric `m`, entity `e`, and series tags `t`.

Tags argument `t` may be specified as follows:

* Empty string `''` for no series tags.
* String containing one or multiple `name=value` pairs separated by comma: `'tag1=value1,tag2=value2'`.
* Map: `["tag1":"value1","tag2":"value2"]`
* The `tags` field representing the grouping tags of the current window.

Example:

```javascript
  value > 60 && db_last('temperature', 'sensor-01', 'stage=heating') < 30
```

## `db_statistic`

This function has two required arguments: `s` and `i`.

Argument `s` accepts a [statistical function](../api/data/aggregation.md) name such as `avg` which is applied to all values within the selection interval.

Argument `i` is the duration of the selection interval specified in 'count [units](../shared/calendar.md#interval-units)', for example, '1 hour'. The end of the selection interval is set to current time.

The function returns `Double.NaN` if no matching series are found or if no values were recorded within the selection interval.

### `db_statistic(string s, string i)`

```javascript
  db_statistic(string s, string i) number
```

Retrieves an aggregated value from the database for the same metric, entity and tags as defined in the current window.

Example:

```javascript
  value > 60 && db_statistic('avg', '3 hour') > 30
```

### `db_statistic(string s, string i, string m)`

```javascript
  db_statistic(string s, string i, string m) number
```

Retrieves an aggregated value from the database for the specified metric `m` and the same entity and series tags as defined in the current window.

Example:

```javascript
  value > 60 && db_statistic('avg', '3 hour', 'temperature') < 50
```

### `db_statistic(string s, string i, string m, string e)`

```javascript
  db_statistic(string s, string i, string m, string e) number
```

Retrieves an aggregated value from the database for the specified metric `m` and entity `e`. The entity may either be specified as a string or as `entity` to invoke current entity in the window.

Example:

```javascript
  value > 60 && db_statistic('avg', '3 hour', 'temperature', 'sensor-01') < 50
```

### `db_statistic(string s, string i, string m, string e, string t | [] t)`

```javascript
  db_statistic(string s, string i, string m, string e, string t) number
```

```javascript
  db_statistic(string s, string i, string m, string e, [] t) number
```

Retrieves an aggregated value from the database for the specified metric `m`, entity `e`, and series tags `t`.

The tags argument `t` can be specified as follows:

* Empty string `''` for no series tags.
* String containing one or multiple `name=value` pairs separated by comma: `'tag1=value1,tag2=value2'`.
* Map: `["tag1":"value1","tag2":"value2"]`
* The `tags` field representing the grouping tags of the current window.

Example:

```javascript
  value > 60 && db_statistic('avg', '3 hour', 'temperature', 'sensor-01', '') < 50
```

## Series Match Examples

Both `db_last` and `db_statistic` functions search the database for matching series based on the specified metric/entity/tags filter and return a numeric value for the first matched series. If the series in the current window has tags which are not collected by the specified metric and entity, those tags are excluded from the filter.

### `Tags : No Tags`

In the example below, the `db_last('cpu_busy')` function ignores the tags `mount_point` and `file_system` because they are not collected by the metric `cpu_busy`.

* Current Window

```elm
  metric = disk_used
  entity = nurswgvml007
  tags   = mount_point=/,file_system=/sda
```

* Expression

```java
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

```java
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

In this example, the function `db_last('disk_used_percent')` will search for a series with **any** tags configuration; the metric `cpu_busy` in the current window has no tags. This search will likely match multiple series, the first of which will be used as the returned value. To better control which series is matched, use `db_last('disk_used_percent', entity, 'mount_point=/')` syntax.

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

In this example, the function `db_last('io_disk_percent_util')` will search for the first series with **any** tags configuration; the metrics `io_disk_percent_util` and `disk_used` have different non-intersecting tag sets. This search will likely match multiple series, the first of which will be used as the returned value. To better control which series is matched, use `db_last('io_disk_percent_util', entity, 'device=sda')` syntax.

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