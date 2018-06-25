# Database Message Functions

## Overview

The functions provide a way to retrieve message records from the database at any stage of the rule evaluation process.

The `db_message_count` and `db_message_last` functions can be used to verify the existence of or establish a correlation between time series and messages.

## Reference

* [`db_message_count`](#db_message_count)
* [`db_message_last`](#db_message_last)
* [`db_messages`](#db_messages)

## `db_message_count`

```javascript
  db_message_count(string i, string g, string s[, string t | [] t[, string e[, string p]]]) long
```

Returns the number of message records matching the specified interval `i`, message type `g`, message source `s`, tags `t`, entity `e`, and expression `p`. See matching rules [below](#matching-rules).

## `db_message_last`

```javascript
  db_message_last(string i, string g, string s[, string t | [] t[, string e[, string p]]]) object
```

Returns the most recent [message](../api/data/messages/query.md) record matching the specified interval `i`, message type `g`, message source `s`, tags `t`, entity `e`, and expression `p`. See [Matching Rules](#matching-rules).

[Fields](../api/data/messages/query.md#fields-1) of a returned object can be invoked using dot notation, for example `db_message_last('1 hour', 'webhook', '').timestamp`.

> Note that `date` field in the message object is `null`. The record time is stored in the `timestamp` field instead (Unix milliseconds).

## `db_messages`

```javascript
  db_messages(string i, string g, string s[, string t | [] t[, string e[, string p]]]) [object]
```

Returns a list of [message](../api/data/messages/query.md) records matching the specified interval `i`, message type `g`, message source `s`, tags `t`, entity `e`, and expression `p`.

The messages are ordered by time (similar to the **Message Search** page). See [Matching Rules](#matching-rules).

If no messages are found, an empty `[]` list is returned.

To access the `n`-th element in the collection, use square brackets `[index]` or `get(index)` method. The first indexed element is `0`.

[Fields](../api/data/messages/query.md#fields-1) of a returned object can be accessed using dot notation, for example `db_messages('1 hour', 'webhook', '')[0].timestamp`.

> Note that `date` field in the message object is `null`. The record time is stored in the `timestamp` field instead (Unix milliseconds).

## Matching Rules

The following matching rules apply:

### Interval

* The selection interval `i` is specified in `count [units](../shared/calendar.md#interval-units)`, for example, `1 hour`.
* The end of the selection interval is set to the **timestamp of the last command** in the window. As a result, the current command is excluded.

### Type

* If the message type argument `g` is specified as `null` or an empty string `''`, all types are matched.

### Source

* If the message source argument `s` is specified as `null` or an empty string `''`, all sources are matched.

### Entity

* If the entity argument `e` is not specified, the **current** entity in the window is used for matching.
* If the entity argument `e` is specified as `null` or empty string `''` or `*` wildcard, all entities are matched.

### Tags

* If tags argument `t` is specified as `null` or an empty string `''`, all tags are matched.
* To match records with empty tags use `'tags.isEmpty()=true'` or `'tags.size()=0'` in expression `p`.
* Tags argument `t` matches records that include the specified tags but can also include other tags.
* Tags argument `t` can be specified as follows:
  * String containing one or multiple `name=value` pairs separated with comma: `'tag1=value1,tag2=value2'`.
  * Map: `["tag1":"value1", "tag2":"value2"]`
  * The `tags` field representing the grouping tags of the current window.

### Expression

* The expression `p` can include the following fields and supports wildcards in field values:
  * `message`
  * `type`
  * `source`
  * `severity`
  * `entity`
  * `tags` and `tags.{name}`

## Examples

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