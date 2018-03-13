# Window

## Overview

A window is an in-memory structure created by the rule engine for each unique combination of metric, entity, and grouping tags extracted from incoming commands.

Windows are displayed on the **Alerts > Rule Windows** page.

![](images/rule-windows.png)

## Window Length

### Count Based Windows

Count-based windows accumulate up to the specified number of samples. Samples are sorted in **order of arrival**, with the most recently received sample placed at the end of the array. When the window is full, the first (oldest by arrival time) sample is removed from the window to free up space at the end of the array for an incoming sample.

![Count Based Window](images/count_based_window3.png "count_based_window")

### Time Based Windows

Time-based windows store samples received within the specified time interval. The number of samples in such windows is not limited. 

The start of the interval is initially set to current time minus the window length, and is constantly incremented as the time passes, these windows are sometimes refered to as _sliding_ windows. If the timestamp of the incoming command is equal to or greater than the window start time, the command is added to the window.

> The **end** time in time-based windows is not set (in particular, it is not set to current time) and the window will accept commands with future timestamps unless they are to be discarded with the [Time filter](filters.md#time-filter) or [filter expression](filters.md#filter-expression) such as `timestamp <= now.getMillis() + 60000`.

Old commands are automatically removed from the window once their timestamp is earlier than the defined window start time.

![Time Based Window](images/time_based_window3.png)

## Window Status

Response actions are triggered on window status changes.

As new data is received and old data is removed from the window, the rule engine re-evaluates the condition which can cause the status of the current window to change, triggering response actions.

### Initial Status

New windows are created based on incoming data, no historical data is loaded from the database unless the 'Load History' setting is turned on.

The window for the given [grouping](grouping.md) key is created when the first matching command is received by the rule engine.

The new windows are assigned initial status of `CANCEL` which is then updated based on the results of the boolean (`true` or `false`) condition.

### Triggers

Response actions can be triggered whenever the window changes its status as well as at scheduled intervals when the status is `REPEAT`. Triggers for each action type are configured and executed separately.

### Status Events

| Previous State | New Status | Previous Condition Value | New Condition Value | Trigger Supported |
| --- | --- | --- | --- | --- |
| `CANCEL` | `OPEN` | `false` | `true` | Yes |
| `OPEN`  | `REPEAT` | `true` | `true` | Yes |
| `REPEAT` | `REPEAT` | `true` | `true` | Yes |
| `OPEN` | `CANCEL` | `true` | `false` | Yes |
| `REPEAT` | `CANCEL` | `true` | `false` | Yes |
| `CANCEL` | `CANCEL` | `false` | `false` | No |

### `OPEN` Status

`OPEN` status is assigned to the window when the condition changes value from `false` to `true`.

### `REPEAT` Status

`REPEAT` status is assigned to an `OPEN` window when the following sequential condition is evaluated as `true` and retains this status for all subsequent `true` evaluations. The minimum number of evaluations that must have been performed on any window for it to have the `REPEAT` status is two consectutive `true` evaluations.

When the window is in `REPEAT` status, actions can be executed with the frequency specified in the rule editor based on a certain number of evaluations, for example.

### `CANCEL` Status

`CANCEL` is the initial status assigned to new windows. It is also assigned to the window when the condition changes from `true` to `false` or when the window is destroyed on rule modification.

Windows in `CANCEL` status do not trigger _repeat_ actions upon subsequent `false` evaluations. Such behavior can be emulated by creating a rule with a negated expression which returns `true` instead of `false` for the same condition.

A window may assume the `CANCEL` status when the condition changes from `true` to `false` as well as when the rule is modified, deleted, or the database is orderly shutdown. `On Cancel` triggers are not invoked, even if enabled, when the rule is modified/deleted or in case of shutdown.  This behavior is controlled with `cancel.on.rule.change` server property.

## Lifecycle

When the rule is deleted or modified with the rule editor, all windows for the given rule are dropped. The windows are re-created when the new matching commands are received by the database.

## Timers

The condition is re-evaluated each time a new matching command (allowed by the filter) is received by the database or removed from the window. 

As an alternative to reacting to external commands, you can create rules that are evaluated on schedule using internal **timer** metrics:

* `timer_15s` - Command is received every 15 seconds.
* `timer_1m` - Command is received every 1 minute.
* `timer_15m` - Command is received every 15 minutes.
* `timer_1h` - Command is received every 1 hour.

These metrics are generated by the database on schedule and are always available.

## Window Fields

The window fields can be included in the [condition](condition.md), [filter](filters.md) and [variables](variables.md).

### Base Fields

**Name**|**Type**|**Description**|**Example**
:---|---|---|:---
status | string | Window status | OPEN
rule | string | Rule name | memory_low
metric | string | Metric name | memory_free
entity | string | Entity name | nurswgvml007
tags | map | Command tags | memtype=buffered
tags.memtype | string | Command tag by name | buffered
entity.displayName | string | Label, if not empty. Name otherwise | NURswgvml007
entity.tags | map | Entity tags | {version=community}
entity.tags.version | string | Entity tag by name | community
entity.label | string | Entity field by name | NURswgvml007
metric.label | string | Metric field by name | Memory Free, Bytes
condition | string | Rule condition | value < 75
min_interval_expired | boolean | Window delay status | true
repeat_count | integer | `REPEAT` status count | 0
repeat_interval | string | Interval for repeats | 1 MINUTE
rule_filter | string | Rule filter | entity != 'nurswghbs001'
severity | string | Alert severity | WARNING
window | string | Window type and duration | length(1)
threshold | string | Override rule | max() > 20

### Series Fields

|**Name**|**Type**|**Description**|**Example**|
|---|---|---|--|
| value | number | Last value | 3.1415 |
| open_value | number | First value | 1.0 |

### Message Fields

|**Name**|**Type**|**Description**|
|---|---|---|
| type | string | Message type (also `tags.type`) |
| source | string | Message type (also `tags.source`) |
| message | string | Message text |

> The `tags` field for the `message` command contains `type`, `source`, `severity`, and other command tags.

> Alert `severity` value is inherited from message `severity` when the Logging: Severity is set to 'Undefined'.

### Properties Fields

|**Name**|**Type**|**Description**|
|---|---|---|
| type | string | Property type (same as `tags.type`) |
| keys | map | Property keys. To retrieve key value, use `keys.{name}` |
| properties | map | Property tags. To retrieve tag value, use `properties.{name}` |

> The `tags` field for the `property` command contains the `keys` map and the `type` field.

### Time Fields

**Name**|**Time Zone**|**Description**
:---|---|:---
`alert_open_time` | Server | Time when the window changed status to `OPEN`
`alert_open_datetime` | UTC | Time when the window changed status to `OPEN`
`received_time` | Server | Time when the current command was received by the server
`received_datetime` | UTC | Time when the current command was received by the server
`event_time` | Server | Time of the current command
`event_datetime` | UTC | Time of the current command
`window_first_time` | Server | Time of the earliest command in the window
`window_first_datetime` | UTC | Time of the earliest command in the window
`timestamp` | n/a | Time of the command that caused the window status event, in UNIX milliseconds.
`now` | Server | Current server time as a [DateTime](http://joda-time.sourceforge.net/apidocs/org/joda/time/DateTime.html) object.
`alert_duration` | n/a | Interval between current time and alert open time, formatted as `days:hours:minutes:seconds`, for example `00:00:01:45`.
`alert_duration_interval` | n/a | Interval between current time and alert open time, formatted as `alert_duration` with units, for example `1m:45s`.

> Fields ending with `_time` contain time in local server timezone, for example `2017-05-30 14:05:39 PST`.

> Fields ending with `_datetime` contain time in ISO 8601 format in UTC timezone, for example `2017-05-30T06:05:39Z`.

> If 'Check On Exit' option is enabled for time-based window, some of the events will be caused by exiting commands and the `timestamp` placeholder will return the time of the command being removed (oldest command), rounded to seconds.

> The `now` object's fields can be accessed with `get` methods, e.g. `now.getDayOfWeek() == 4`.

### Link Fields

* [`serverLink`](links.md#serverlink)
* [`entityLink`](links.md#entitylink)
* [`ruleLink`](links.md#rulelink)
* [`chartLink`](links.md#chartlink)
* [`csvExportLink`](links.md#csvexportlink)
* [`htmlExportLink`](links.md#htmlexportlink)

### Details Tables

The details table contains entity, entity label, entity tags, command tags, and variables.

* [detailsTable('markdown')](details-table.md#markdown)
* [detailsTable('ascii')](details-table.md#ascii)
* [detailsTable('html')](details-table.md#html)
* [detailsTable('property')](details-table.md#property)
* [detailsTable('csv')](details-table.md#csv)


