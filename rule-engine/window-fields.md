# Window Fields

## Overview

Each window maintains a set of continuously updated fields which can be used in the [condition](condition.md) and [filter](filters.md) expressions, or as user-defined [variables](variables.md).

## Base Fields

**Name**|**Type**|**Description**|**Example**
:---|---|---|:---
`status` | string | Window status. | `OPEN`
`rule` | string | Rule name. | `memory_low`
`metric` | string | Metric name. | `memory_free`
`entity` | string | Entity name. | `nurswgvml007`
`tags` | map | Command tags. | `memtype=buffered`
`tags.memtype` | string | Command tag by name. | `buffered`
`entity.displayName` | string | Label, if not empty. Otherwise, name. | `NURswgvml007`
`entity.tags` | map | Entity tags. | `{version=community}`
`entity.tags.version` | string | Entity tag by name. | `community`
`entity.label` | string | Entity field by name. | `NURswgvml007`
`metric.label` | string | Metric field by name. | `Memory Free, Bytes`
`condition` | string | Rule condition | `value < 75`
`delay_expired` | boolean | Delay interval status.<br>Set to `true` if **On Open** notification executed after being deferred.| `true`
`repeat_count` | integer | Number of consecutive `true` results. | `0`
`rule_filter` | string | Filter expression. | `entity != 'nurswghbs001'`
`severity` | string | Alert severity. | `WARNING`
`window` | string | Window type and duration. | `length(1)`
`threshold` | string | Override condition. | `max() > 20`

## Series Fields

|**Name**|**Type**|**Description**|**Example**|
|---|---|---|--|
| `value` | number | Last value | `3.1415` |
| `open_value` | number | First value | `1.0` |

## Message Fields

|**Name**|**Type**|**Description**|
|---|---|---|
| `type` | string | Message type (also `tags.type`). |
| `source` | string | Message type (also `tags.source`). |
| `message` | string | Message text. |

Notes:

* The `tags` field for the `message` command contains `type`, `source`, `severity`, and other command tags.
* Alert `severity` value is inherited from message `severity` when the **Logging: Severity** is set to **Undefined**.

## Properties Fields

|**Name**|**Type**|**Description**|
|---|---|---|
| `type` | string | Property type (same as `tags.type`). |
| `keys` | map | Property keys. To retrieve key value, use `keys.{name}`. |
| `properties` | map | Property tags. To retrieve tag value, use `properties.{name}`. |

Notes:

* The `tags` field for the `property` command contains the `keys` map and the `type` field.

## Date Fields

**Name**|**Time Zone**|**Description**
:---|---|:---
`alert_open_time` | Server | Time when the window changed status to `OPEN`
`alert_open_datetime` | UTC | Time when the window changed status to `OPEN`
`received_time` | Server | Time when the current command is received by the server
`received_datetime` | UTC | Time when the current command is received by the server
`event_time` | Server | Time of the current command
`event_datetime` | UTC | Time of the current command
`window_first_time` | Server | Time of the earliest command in the window
`window_first_datetime` | UTC | Time of the earliest command in the window
`timestamp` | n/a | Time of the command that caused the window status event, in Unix time (milliseconds).
`now` | Server | Current server time as a [`DateTime`](object-datetime.md) object.
`alert_duration` | n/a | Interval between current time and alert open time, formatted as `days:hours:minutes:seconds`, for example `00:00:01:45`. Returns an empty string **On Open** status.
`alert_duration_interval` | n/a | Interval between current time and alert open time, formatted as `alert_duration` with units, for example `1m:45s`. Returns an empty string **On Open** status.

> Fields ending with `_time` contain time in local server time zone, for example `2017-05-30 14:05:39 PST`.
> Fields ending with `_datetime` contain time in [ISO format](../shared/date-format.md) UTC time zone, for example `2017-05-30T06:05:39Z`.
> If **Check On Exit** option is enabled for a time-based window, some of the events are caused by exiting commands in which case the `timestamp` placeholder contains the time of the command being removed (oldest command), rounded to seconds.
> The `now` object fields can be accessed with dot notation syntax, for example `now.day_of_week == 'Thursday'`.

## Details Tables

The built-in `details` table contains entity name, entity label, entity tags, command tags, and user-defined variables. Use this data structure to print out full alert information.

* [`detailsTable('markdown')`](details-table.md#markdown)
* [`detailsTable('ascii')`](details-table.md#ascii)
* [`detailsTable('html')`](details-table.md#html)
* [`detailsTable('property')`](details-table.md#property)
* [`detailsTable('csv')`](details-table.md#csv)

## Link Fields

* [`serverLink`](links.md#serverlink)
* [`entityLink`](links.md#entitylink)
* [`ruleLink`](links.md#rulelink)
* [`chartLink`](links.md#chartlink)
* [`csvExportLink`](links.md#csvexportlink)
* [`htmlExportLink`](links.md#htmlexportlink)
