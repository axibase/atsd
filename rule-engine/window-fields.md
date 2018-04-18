# Window Fields

## Overview

Each window maintains a set of continuously updated fields that can be included in the [condition](condition.md) expression, the [filter](filters.md) expression and the user-defined [variables](variables.md).

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
`now` | Server | Current server time as a [DateTime](object-datetime.md) object.
`alert_duration` | n/a | Interval between current time and alert open time, formatted as `days:hours:minutes:seconds`, for example `00:00:01:45`.
`alert_duration_interval` | n/a | Interval between current time and alert open time, formatted as `alert_duration` with units, for example `1m:45s`.

> Fields ending with `_time` contain time in local server timezone, for example `2017-05-30 14:05:39 PST`.

> Fields ending with `_datetime` contain time in ISO 8601 format in UTC timezone, for example `2017-05-30T06:05:39Z`.

> If 'Check On Exit' option is enabled for time-based window, some of the events will be caused by exiting commands and the `timestamp` placeholder will return the time of the command being removed (oldest command), rounded to seconds.

> The `now` object's fields can be accessed with [`get`](object-datetime.md) methods, e.g. `now.getDayOfWeek() == 4`.


### Details Tables

The built-in 'details' table contains entity name, entity label, entity tags, command tags, and user-defined variables. This data structure can be conveniently accessed to print out full alert information.

* [detailsTable('markdown')](details-table.md#markdown)
* [detailsTable('ascii')](details-table.md#ascii)
* [detailsTable('html')](details-table.md#html)
* [detailsTable('property')](details-table.md#property)
* [detailsTable('csv')](details-table.md#csv)


### Link Fields

* [`serverLink`](links.md#serverlink)
* [`entityLink`](links.md#entitylink)
* [`ruleLink`](links.md#rulelink)
* [`chartLink`](links.md#chartlink)
* [`csvExportLink`](links.md#csvexportlink)
* [`htmlExportLink`](links.md#htmlexportlink)
