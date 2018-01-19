# Database Functions

## Overview

The functions retrieve series and message records from database.

The `db_last` and `db_statistic` functions provide a way to retrieve the last detailed or averaged value stored in the database for a series which may be different from the series in the current window. The functions can be used to compare different series for correlation purposes.

* The `db_last` function retrieves the last value stored in the database for the specified series.
* The `db_statistic` function retrieves an aggregated value from the database for the specified series.

The `db_message_count` and `db_message_last` functions allow one to correlate different types of data - time series and messages.

## Reference

* [db_last](functions-db.md#db_laststring-m)
* [db_statistic](functions-db.md#db_statistic)
* [db_message_count](functions-db.md#db_message_count)
* [db_message_last](functions-db.md#db_message_last)

## Series Functions

### `db_last(string m)` 

```java
  db_last(string m) number
```
Retrieve the last value for the specified metric `m` and the same entity and tags as defined in the current window.

Example:

```java
  value > 60 && db_last('temperature') < 30
```

> As an alternative, if the specified metric was received in the same command, use [`value()`](functions-value.md) function. The `value()` function returns metric values set in the command, even if they're not yet stored in the database.

### `db_last(string m, string e)` 

```java
db_last(string m, string e) number
```
Retrieve the last value for the specified metric `m` and entity `e`. The entity can specified as a string or as `entity` placeholder.

Example:

```java
  value > 60 && db_last('temperature', 'sensor-01') < 30

  // same as db_last('temperature')
  value > 60 && db_last('temperature', entity) < 30
```

### `db_last(string m, string e, string t | [] t)` 

```java
  db_last(string m, string e, string t) number
  db_last(string m, string e, [] t) number
```
Retrieve the last value for the specified metric `m`, entity `e`, and series tags `t`. The tags can be specified as an empty string `''` (no tags), as `key1=value1,key2=value`, or as `tags` placeholder representing the tags of the current window.

Example:

```java
  value > 60 && db_last('temperature', 'sensor-01', 'stage=heating') < 30
```

### `db_statistic` 

The first required argument `s` accepts a [statistical function](../api/data/aggregation.md) name such as `avg` which is applied to values within the selection interval.

The second required argument `i` is the duration of selection interval specified as `count unit`, for example, '1 HOUR'. The end of the selection interval is set to current time.

#### `db_statistic(string s, string i)`

```java
  db_statistic(string s, string i) number
```
Retrieve an aggregated value from the database for the same metric, entity and tags as defined in the current window.

Example:

```java
  value > 60 && db_statistic('avg', '3 hour') > 30
```

#### `db_statistic(string s, string i, string m)`

```java
  db_statistic(string s, string i, string m) number
```
Retrieve an aggregated value from the database for the specified metric `m` and the same entity and series tags as defined in the current window.

Example:

```java
  value > 60 && db_statistic('avg', '3 hour', 'temperature') < 50
```

#### `db_statistic(string s, string i, string m, string e)`

```java
  db_statistic(string s, string i, string m, string e) number
```
Retrieve an aggregated value from the database for the specified metric `m` and entity `e`. The entity can specified as a string or as `entity` placeholder.

Example:

```java
  value > 60 && db_statistic('avg', '3 hour', 'temperature', 'sensor-01') < 50
```

#### `db_statistic(string s, string i, string m, string e, string t | [] t)`

```java
  db_statistic(string s, string i, string m, string e, string t) number
  db_statistic(string s, string i, string m, string e, [] t) number
```
Retrieve an aggregated value from the database for the specified metric `m`, entity `e`, and series tags `t`. The tags can be specified as an empty string `''` (no tags), as `key1=value1,key2=value`, or as `tags` placeholder representing the tags of the current window.

Example:

```java
  value > 60 && db_statistic('avg', '3 hour', 'temperature', 'sensor-01', '') < 50
```

### Series Match

Both `db_last` and `db_statistic` functions search the database for matching series based on the specified metric/entity/tags filter and return a numeric value for the first matched series. If the series in the current window has tags which are not collected by the specified metric and entity, such tags are excluded from the filter.

#### Example `Tags : No Tags`

In the example below, the `db_last('cpu_busy')` function ignores mount_point and file_system tags because these tags are not collected by the cpu_busy metric.

* Current Window

```
  metric = disk_used
  entity = nurswgvml007
  tags   = mount_point=/,file_system=/sda
```

* Expression

```java
  db_last('cpu_busy') > 10
```

* Search Filter

```
  metric = cpu_busy
  entity = nurswgvml007
  tags   = [empty - no tags]
```

* Matched Series

```
  metric = cpu_busy
  entity = nurswgvml007
  tags   = no tags
```

#### Example `Same Tags`

In the example below, the `db_last('disk_used_percent')` function uses the same series tags as in the current window because all of these tags are collected by the disk_used_percent metric.

* Current Window

```
  metric = disk_used
  entity = nurswgvml007
  tags   = mount_point=/,file_system=/sda
```

* Expression

```java
  db_last('disk_used_percent') > 90
```

* Search Filter

```
  metric = disk_used_percent
  entity = nurswgvml007
  tags   = mount_point=/,file_system=/sda
```

* Matched Series

```
  metric = cpu_busy
  entity = nurswgvml007
  tags   = mount_point=/,file_system=/sda
```

#### Example `No Tags : Tags`

In the example below, the `db_last('disk_used_percent')` function will search for first series with **any** tags (including no tags) because the cpu_busy metric in the current window has no tags. This search will likely match multiple series, the first of which will be used to return the value. To better control which series is matched, use `db_last('disk_used_percent', entity, 'mount_point=/')` syntax option.

* Current Window

```
  metric = cpu_busy
  entity = nurswgvml007
  tags   = [empty - no tags]
```

* Expression

```java
  db_last('disk_used_percent') > 90
```

* Search Filter

```
  metric = disk_used_percent
  entity = nurswgvml007
  tags   = [empty - no tags]
```

* Matched Series

```
  metric = disk_used_percent
  entity = nurswgvml007
  tags   = mount_point=/,file_system=/sda
```

#### Example `Different Tags`

In the example below, the `db_last('io_disk_percent_util')` function will search for first series with **any** tags (including no tags) because the io_disk_percent_util and disk_used metrics have different non-intersecting tag sets. This search will likely match multiple series, the first of which will be used to return the value. To better control which series is matched, use `db_last('io_disk_percent_util', entity, 'device=sda')` syntax option.

* Current Window

```
  metric = disk_used_percent
  entity = nurswgvml007
  tags   = mount_point=/,file_system=/sda
```

* Expression

```java
  db_last('io_disk_percent_util') > 90
```

* Search Filter

```
  metric = io_disk_percent_util
  entity = nurswgvml007
  tags   = [empty - no tags - because there are no intersecting tag names]
```

* Matched Series

```
  metric = io_disk_percent_util
  entity = nurswgvml007
  tags   = device=sda
```

## Message Functions

### `db_message_count` 

```java
  db_message_count(string interval, string type, string source[, string tags, [string entity]]) long
```
Calculate the number of messages matching the specified interval, message type, message source, tags, and entity.

Arguments `tags` and `entity` are optional.

If the `type`, `source`, or `tags` arguments are set to `null` or empty string, they are ignored when matching messages.

If the `entity` is not specified, the request retrieves messages for the current entity.

Examples:

```java
  // Check if the average exceeds 20 and the 'compaction' message was not received within the last hour for the current entity.
  avg() > 20 && db_message_count('1 hour', 'compaction', '') == 0

  // Check if the average exceeds 80 and there is an event with type=backup-error received within the last 15 minutes for entity 'nurswgvml006'.
  avg() > 80 && db_message_count('15 minute', 'backup-error', '', '', 'nurswgvml006') > 0
```

### `db_message_last` 

```java
db_message_last(string interval, string type, string source [, string tags, [string entity [, message]]]) message object
```

Return the most recent [message](../api/data/messages/query.md#fields-1) record matching the specified interval, message type, message source, tags, entity, and message text.

Arguments `tags`, `entity`, and `message` are optional.

If the `type`, `source`, or `tags` arguments are set to `null` or empty string, they are ignored when matching messages.

The `tags` argument matches records that include the specified tags but may also include other tags.

If the `entity` is not specified, the request retrieves messages for the current entity.

The `message` argument supports wildcards `?` and `*`.

The returned object contains `type`, `source`, and `tags.{name}` [fields](../api/data/messages/query.md#fields-1) of string type and the `date` long field which contains the record's time in Unix milliseconds.

Example:

```java
  last_msg = db_message_last('60 minute', 'logger', '')
  // Check that the average exceeds 50 and the severity of the last message with type 'logger' for the current entity is greater or equal `ERROR`.
  value > 50 && last_msg != null && last_msg.severity.toString() >= "6"
```

```java
  db_message_last('1 minute', 'webhook', 'slack', 'event.channel=D7UKX9NTG,event.type=message', 'slack', 'docker start sftp*')
```
