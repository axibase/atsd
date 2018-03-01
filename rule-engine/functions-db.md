# Database Functions

## Overview

The `db_*` functions retrieve series and message records from database. The `executeSqlQuery` function retrieves results of an SQL query executed against the database.

The `db_last` and `db_statistic` functions provide a way to retrieve the last detailed or averaged value stored in the database for a series which may be different from the series in the current window. The functions can be used to compare different series for correlation purposes.

* The `db_last` function retrieves the last value stored in the database for the specified series.
* The `db_statistic` function retrieves an aggregated value from the database for the specified series.

The `db_message_count` and `db_message_last` functions allow one to correlate different types of data - time series and messages.

## Reference

Series functions:

* [db_last](functions-db.md#db_laststring-m)
* [db_statistic](functions-db.md#db_statistic)

Message functions:

* [db_message_count](functions-db.md#db_message_count)
* [db_message_last](functions-db.md#db_message_last)

SQL functions:

* [executeSqlQuery](functions-db.md#executesqlquery)

## Series Functions

### `db_last(string m)` 

```javascript
  db_last(string m) number
```
Retrieves the last value for the specified metric `m` and the same entity and tags as defined in the current window.

Example:

```javascript
  value > 60 && db_last('temperature') < 30
```

> As an alternative, if the specified metric was received in the same command, use [`value()`](functions-value.md) function. The `value()` function returns metric values set in the command, even if they're not yet stored in the database.

### `db_last(string m, string e)` 

```javascript
db_last(string m, string e) number
```
Retrieves the last value for the specified metric `m` and entity `e`. The entity can specified as a string or as `entity` field (current entity in the window).

Example:

```javascript
  value > 60 && db_last('temperature', 'sensor-01') < 30

  // same as db_last('temperature')
  value > 60 && db_last('temperature', entity) < 30
```

### `db_last(string m, string e, string t | [] t)` 

```javascript
  db_last(string m, string e, string t) number
  db_last(string m, string e, [] t) number
```
Retrieves the last value for the specified metric `m`, entity `e`, and series tags `t`. 

The tags argument `t` can be specified as follows:

* Empty string `''` (no tags).
* One or multiple `name=value` pairs separated with comma, for example `key1=value1,key2=value2`.
* As key-value map, for example `["key1":"value1","key2":"value2"]`
* As `tags` field representing the grouping tags of the current window.

Example:

```javascript
  value > 60 && db_last('temperature', 'sensor-01', 'stage=heating') < 30
```

### `db_statistic` 

The first required argument `s` accepts a [statistical function](../api/data/aggregation.md) name such as `avg` which is applied to values within the selection interval.

The second required argument `i` is the duration of selection interval specified as 'count [unit](../shared/calendar.md#interval-units)', for example, '1 hour'. The end of the selection interval is set to current time.

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
Retrieves an aggregated value from the database for the specified metric `m` and entity `e`. The entity can specified as a string or as `entity` field  current entity in the window).

Example:

```javascript
  value > 60 && db_statistic('avg', '3 hour', 'temperature', 'sensor-01') < 50
```

#### `db_statistic(string s, string i, string m, string e, string t | [] t)`

```javascript
  db_statistic(string s, string i, string m, string e, string t) number
  db_statistic(string s, string i, string m, string e, [] t) number
```
Retrieves an aggregated value from the database for the specified metric `m`, entity `e`, and series tags `t`. 

The tags argument `t` can be specified as follows:

* Empty string `''` (no tags).
* One or multiple `name=value` pairs separated with comma, for example `key1=value1,key2=value2`.
* As key-value map, for example `["key1":"value1","key2":"value2"]`
* As `tags` field representing the grouping tags of the current window.

Example:

```javascript
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

The first required argument `i` is the duration of selection interval specified as 'count [unit](../shared/calendar.md#interval-units)', for example, '1 hour'. The end of the selection interval is set to the alert open time.

Arguments tags `t`, entity `e` and expression `p` are optional.

The following match conditions are applied:

* If the entity argument `e` is not specified, the **current** entity is used for matching.
* If the entity argument `e` is specified as `null` / `''` / `*`, any entity is matched.
* The expression `p` can be built using tags, wildcards and the following string variables:

    * `message`
    * `type`
    * `source`
    * `severity`
    * `entity`
    * `tags`
    
* The current command is excluded from matching.
* If the type `g`, source `s` or tags `t` arguments are set to `null`/ `''`, they are ignored when matching messages.
* The tags `t` argument matches records that include the specified tags but may also include other tags.

The tags `t` argument can be specified as follows:

* Empty string `''` (no tags).
* One or multiple `name=value` pairs separated with comma, for example `key1=value1,key2=value2`.
* As key-value map, for example `["key1":"value1","key2":"value2"]`
* As `tags` field representing the grouping tags of the current window.

### `db_message_count` 

```javascript
  db_message_count(string i, string g, string s[, string t | [] t[, string e[, string p]]]) long
```
Returns the number of message records matching the specified interval `i`, message type `g`, message source `s`, tags `t`, entity `e`, and expression `p`.

Examples:

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
  
  db_message_count('1 minute', 'webhook', 'slack', 'event.type=' + tags.event.type, entity, 'message=' + message + 'AND tags.event.user!=' + tags.event.user)
```

### `db_message_last` 

```javascript
  db_message_last(string i, string g, string s[, string t | [] t[, string e[, string p]]]) object
```
Returns the most recent [message](../api/data/messages/query.md#fields-1) record matching the specified interval `i`, message type `g`, message source `s`, tags `t`, entity `e`, and expression `p`.

The object's [fields](../api/data/messages/query.md#fields-1) can be accessed using the dot notation, for example `db_message_last('1 hour', 'webhook', '').date`.

Example:

```javascript
  last_msg = db_message_last('60 minute', 'logger', '')
  /* 
  Check that the average exceeds 50 and the severity of the last message with type 'logger' 
  for the current entity is greater or equal 'ERROR'. 
  */
  avg() > 50 && last_msg != null && last_msg.severity.toString() >= "6"
```

```javascript
  db_message_last('1 minute', 'webhook', 'slack', 'event.channel=D7UKX9NTG,event.type=message', 'slack', 'message LIKE "docker start sftp*"')
  
  /* 
  Returns the most recent message within 1 day for the current entity,
  containg tag 'api_app_id=583' and regardless of type and source. 
  */
  db_message_last('1 day', null, null, ["api_app_id":"583"], entity)
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
