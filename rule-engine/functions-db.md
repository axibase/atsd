# Database Functions

## Overview

Database functions provide a way to retrieve series and message records from the database at any stage of the rule evaluation process.

The `db_last` and `db_statistic` functions retrieve the last stored value or calculate statistics from other stored values. The queried series may be different from the series in the current window.

The `db_message_count` and `db_message_last` functions may be used to verify the existence of or establish a correlation between time series and messages.

The `executeSqlQuery` function returns the results of a user-defined SQL query.

## Reference

Series functions:

* [`db_last`](functions-db.md#db_laststring-m)
* [`db_statistic`](functions-db.md#db_statistic)

Message functions:

* [`db_message_count`](functions-db.md#db_message_count)
* [`db_message_last`](functions-db.md#db_message_last)
* [`db_messages`](functions-db.md#db_messages)

SQL functions:

* [`executeSqlQuery`](functions-db.md#executesqlquery)

## Series Functions

### `db_last`

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

### `db_statistic`

This function has two required arguments: `s` and `i`.

Argument `s` accepts a [statistical function](../api/data/aggregation.md) name such as `avg` which is applied to all values within the selection interval.

Argument `i` is the duration of the selection interval specified in 'count [units](../shared/calendar.md#interval-units)', for example, '1 hour'. The end of the selection interval is set to current time.

The function returns `Double.NaN` if no matching series are found or if no values were recorded within the selection interval.

#### `db_statistic(string s, string i)`

```javascript
  db_statistic(string s, string i) number
```

Retrieves an aggregated value from the database for the same metric, entity and tags as defined in the current window.

Example:

```javascript
  value > 60 && db_statistic('avg', '3 hour') > 30
```

#### `db_statistic(string s, string i, string m)`

```javascript
  db_statistic(string s, string i, string m) number
```

Retrieves an aggregated value from the database for the specified metric `m` and the same entity and series tags as defined in the current window.

Example:

```javascript
  value > 60 && db_statistic('avg', '3 hour', 'temperature') < 50
```

#### `db_statistic(string s, string i, string m, string e)`

```javascript
  db_statistic(string s, string i, string m, string e) number
```

Retrieves an aggregated value from the database for the specified metric `m` and entity `e`. The entity may either be specified as a string or as `entity` to invoke current entity in the window.

Example:

```javascript
  value > 60 && db_statistic('avg', '3 hour', 'temperature', 'sensor-01') < 50
```

#### `db_statistic(string s, string i, string m, string e, string t | [] t)`

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

### Series Match

Both `db_last` and `db_statistic` functions search the database for matching series based on the specified metric/entity/tags filter and return a numeric value for the first matched series. If the series in the current window has tags which are not collected by the specified metric and entity, those tags are excluded from the filter.

#### Example `Tags : No Tags`

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

#### Example `Same Tags`

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

#### Example `No Tags : Tags`

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

#### Example `Different Tags`

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

## Message Functions

### `db_message_count`

```javascript
  db_message_count(string i, string g, string s[, string t | [] t[, string e[, string p]]]) long
```

Returns the number of message records matching the specified interval `i`, message type `g`, message source `s`, tags `t`, entity `e`, and expression `p`. See matching rules [below](#matching-rules).

### `db_message_last`

```javascript
  db_message_last(string i, string g, string s[, string t | [] t[, string e[, string p]]]) object
```

Returns the most recent [message](../api/data/messages/query.md) record matching the specified interval `i`, message type `g`, message source `s`, tags `t`, entity `e`, and expression `p`. See [Matching Rules](#matching-rules).

[Fields](../api/data/messages/query.md#fields-1) of a returned object may be invoked using dot notation, for example `db_message_last('1 hour', 'webhook', '').timestamp`.

> Note that `date` field in the message object is `null`. The record time is stored in the `timestamp` field instead (Unix milliseconds).

### `db_messages`

```javascript
  db_messages(string i, string g, string s[, string t | [] t[, string e[, string p]]]) [object]
```

Returns a list of [message](../api/data/messages/query.md) records matching the specified interval `i`, message type `g`, message source `s`, tags `t`, entity `e`, and expression `p`.

The messages are ordered by time (similar to the **Message Search** page). See [Matching Rules](#matching-rules).

If no messages are found, an empty `[]` list is returned.

To access the `n`-th element in the collection, use square brackets `[index]` or `get(index)` method. The first indexed element is `0`.

[Fields](../api/data/messages/query.md#fields-1) of a returned object may be accessed using dot notation, for example `db_messages('1 hour', 'webhook', '')[0].timestamp`.

> Note that `date` field in the message object is `null`. The record time is stored in the `timestamp` field instead (Unix milliseconds).

#### Matching Rules

The following matching rules apply:

* Interval:
  * The selection interval `i` is specified in `count [units](../shared/calendar.md#interval-units)`, for example, `1 hour`.
  * The end of the selection interval is set to the **timestamp of the last command** in the window. As a result, the current command is excluded.

* Type:
  * If the message type argument `g` is specified as `null` or an empty string `''`, all types are matched.

* Source:
  * If the message source argument `s` is specified as `null` or an empty string `''`, all sources are matched.

* Entity:
  * If the entity argument `e` is not specified, the **current** entity in the window is used for matching.
  * If the entity argument `e` is specified as `null` or empty string `''` or `*` wildcard, all entities are matched.

* Tags:
  * If tags argument `t` is specified as `null` or an empty string `''`, all tags are matched.
  * To match records with empty tags use `'tags.isEmpty()=true'` or `'tags.size()=0'` in expression `p`.
  * Tags argument `t` matches records that include the specified tags but may also include other tags.
  * Tags argument `t` may be specified as follows:
    * String containing one or multiple `name=value` pairs separated with comma: `'tag1=value1,tag2=value2'`.
    * Map: `["tag1":"value1", "tag2":"value2"]`
    * The `tags` field representing the grouping tags of the current window.

* Expression:
  * The expression `p` can include the following fields and supports wildcards in field values:
    * `message`
    * `type`
    * `source`
    * `severity`
    * `entity`
    * `tags` and `tags.{name}`

### `db_message_count` Examples

```javascript
  /*
  Check if the average exceeds 20 and the 'compaction' message was not received
  within the last hour for the current entity.
  */
  avg() > 20 && db_message_count('1 hour', 'compaction', '') == 0

  /*
  Check if the average exceeds 80 and there is an event with 'type=backup-error'
  received within the last 15 minutes for entity 'nurswgvml006'.
  */
  avg() > 80 && db_message_count('15 minute', 'backup-error', '', '', 'nurswgvml006') > 0

  /*
  Count messages within the previous 60 minutes
  for 'type=compaction', any source, any tags and all entities.
  */
  db_message_count('1 hour', 'compaction', '',  '', '*')

  /*
  Count messages with the same text as in the last command, but from different users.
  */
  db_message_count('1 minute', 'webhook', 'slack', 'event.type=' + tags.event.type, entity, 'message=' + message + 'AND tags.event.user!=' + tags.event.user)
```

### `db_message_last` Examples

```javascript
  last_msg = db_message_last('60 minute', 'logger', '')
  /*
  Check that the average exceeds 50 and the severity of the last message with type 'logger'
  for the current entity is greater than or equal to 'ERROR'.
  */
  avg() > 50 && last_msg != null && last_msg.severity.toString() >= "6"
```

```javascript
  /*
  Retrieve the last message with text beginning 'docker start sftp*'.
  */
  db_message_last('1 minute', 'webhook', 'slack', 'event.channel=D7UKX9NTG,event.type=message', 'slack', 'message LIKE "docker start sftp*"')

  /*
  Returns the most recent message within 1 day for the current entity,
  containing tag 'api_app_id=583' and regardless of type or source.
  */
  db_message_last('1 day', null, null, ["api_app_id":"583"], entity)

  /*
  Returns message with type 'webhook' and empty tags.
  */
  db_message_last('15 second', 'webhook', '',  '', '', "tags.isEmpty()=true")
```

### `db_messages` Examples

```javascript
  /*
  Retrieve messages with the text ending '*Selected' and any tags.
  */
  db_messages('30 second', 'webhook', 'axibase-bot', '', 'slack', 'message LIKE "*Selected"')
```

```javascript
  /*
  Retrieve messages with severety 'Warning' within 15 second and send values of 'command' tag in notification.
  */
  msgs = db_messages('15 second', 'logger', '', '', '', 'severity="warning"')

  @foreach{m : msgs}
  @{m.tags.get('command')}
  @end{}
```

## SQL Functions

### `executeSqlQuery`

```javascript
  executeSqlQuery(string q) collection[collection[string]]
```

Returns the result of SQL query `q`. The first row contains headers consisting of column labels.

The response is limited to 1000 rows.

If query `q` is empty or not valid, an error is thrown.

Examples:

```javascript
executeSqlQuery('SELECT datetime, value FROM http.sessions WHERE datetime > current_hour LIMIT 2')
```

```css
  [
    [datetime, value],
    [2018-01-25T19:00:12.346Z, 1],
    [2018-01-25T19:00:27.347Z, 1]
  ]
```

```javascript
executeSqlQuery("SELECT entity, avg(value) AS \"Average Value\" FROM jvm_memory_used WHERE datetime > current_hour GROUP BY entity")
```

```css
  [
    [entity, Average Value],
    [atsd, 467675162.105]
  ]
```

```javascript
query = 'SELECT datetime, value FROM http.sessions WHERE datetime > current_hour LIMIT 2'
//
addTable(executeSqlQuery(query), 'ascii', true)
```

```ls
+--------------------------+-------+
| datetime                 | value |
+--------------------------+-------+
| 2018-01-26T13:00:14.098Z | 23    |
| 2018-01-26T13:00:29.110Z | 22    |
+--------------------------+-------+
```
