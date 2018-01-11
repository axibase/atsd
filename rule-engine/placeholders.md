# Placeholders

## Overview

Placeholders can be used to include [window](window.md) fields, [entity fields](../api/meta/entity/list.md#fields), [metric fields](../api/meta/metric/list.md#fields), user-defined [variables](variables.md), and [function](functions.md) values into email messages, web notifications, system commands, and logging messages.

Specified using the `${name}` syntax, the placeholders are resolved and replaced with the actual value of the named field, variable or function at the time the trigger is executed.

![](images/placeholders.png)

> If the specified placeholder doesn't exist, it is substituted with an empty string.

## Base Placeholders

**Name**|**Type**|**Description**|**Example**
:---|---|---|:---
status | string | Window status | OPEN
rule | string | Rule name | memory_low
metric | string | Metric name | memory_free
entity | string | Entity name | nurswgvml007
tags | map | Command tags | memtype=buffered
tags.memtype | string | Command tag by name | buffered
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

## Series Command Placeholders

|**Name**|**Type**|**Description**|**Example**|
|---|---|---|--|
| value | number | Last value | 3.1415 |
| open_value | number | First value | 1.0 |

## Message Command Placeholders

|**Name**|**Type**|**Description**|
|---|---|---|
| type | string | Message type (also `tags.type`) |
| source | string | Message type (also `tags.source`) |
| message | string | Message text |

> The `tags` map for the `message` command contains `type`, `source`, `severity`, and other command tags.

> Alert `severity` value is inherited from message `severity` when the Logging: Severity is set to 'Undefined'.

## Properties Command Placeholders

|**Name**|**Type**|**Description**|
|---|---|---|
| type | string | Property type (same as `tags.type`) |
| keys | map | Property keys. To retrieve key value, use `keys.{name}` |
| properties | map | Property tags. To retrieve tag value, use `properties.{name}` |

> The `tags` map for the `property` command contains the `keys` map and the `type` field.

## Time Placeholders

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

> Placeholders ending with `_time` contain time in local server timezone, for example 2017-05-30 14:05:39 PST.

> Placeholders ending with `_datetime` contain time in ISO 8601 format in UTC timezone, for example 2017-05-30T06:05:39Z.

> If 'Check On Exit' option is enabled for time-based window, some of the events will be caused by exiting commands and the `timestamp` placeholder will return the time of the command being remove (oldest command), rounded to seconds.

> `now` properties can be accessed with `get` methods, e.g. `now.getDayOfWeek() == 4`.

## Link Placeholders

* ruleLink
* chartLink
* csvExportLink
* htmlExportLink

## Details Table Placeholders

* [detailsTable('markdown')](details-table.md#markdown)
* [detailsTable('ascii')](details-table.md#ascii)
* [detailsTable('html')](details-table.md#html)
* [detailsTable('property')](details-table.md#property)
* [detailsTable('csv')](details-table.md#csv)
* [detailsTable('json')](details-table.md#json)

## User-defined Variables

Refer to [variables](variables.md).


## Examples

```sh
[${status}] ActiveMQ on ${entity}:
Unauthorized connection from ${tags.remoteaddress}.
```

```sh
[${status}] JVM on ${entity}:
Average CPU usage ${round(avg()*100,1)} exceeds threshold.
```

```sh
${tags.file_system}
```

```sh
${entity.tags.location}
```

```sh
${tags}
```
