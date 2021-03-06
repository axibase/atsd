# Window and Command Fields

## Overview

Each window maintains a set of continuously updated fields which can be used in the [condition](condition.md) and [filter](filters.md) expressions, or as user-defined [variables](variables.md).

## Base Fields

## Window Fields

**Name**|**Type**|**Description**|**Example**
:---|---|---|:---
`rule` | string | Rule name. | `memory_low`
`rule_filter` | string | Filter expression. | `entity != 'nurswghbs001'`
`window` | string | Window type and duration. | `length(1)`
`before_status` | string | Window status **before** the condition is evaluated.<br>**Accessible** in condition. | `OPEN`, `REPEAT`, or `CANCEL`
`status` | string | Window status assigned **after** the condition is evaluated.<br>**Not accessible** in condition. | `OPEN`, `REPEAT`, or `CANCEL`
`condition` | string | Rule condition.<br>**Not accessible** in condition. | `value < 75`
`threshold` | string | Override condition.<br>**Not accessible** in condition. | `max() > 20`
`repeat_count` | integer | Number of consecutive `true` results.<br>**Not accessible** in condition. | `4`
`severity` | string | Alert severity.<br>**Not accessible** in condition. | `WARNING`
`delay_expired` | boolean | Delay expiration status.<br>Set to `true` if notifications triggered after delay.<br>**Not accessible** in condition. | `true`
`metric` | string | Metric name. | `memory_free`
`metric.label` | string | Metric field by name. | `Memory Free, Bytes`
`window_entity` | string | Entity name if [grouping](grouping.md) by entity is enabled. | `nurswgvml007`
`window_tags` | map | Windows tags if [grouping](grouping.md) by tags is enabled, serialized as `[key1: val1, key2: val2]`. | `[location: SVL]`

## Command Fields

**Name**|**Type**|**Description**|**Example**
:---|---|---|:---
`entity` | string | Entity specified in the command. | `entity LIKE 'nur*'`
`tags` | map | Command tags, serialized as `[key1: val1, key2: val2]`. | `tags.size() != 0`
`tags.<name>` | string | Command tag by name. | `tags.memtype != 'buffered'`
`command_time` | [`DateTime`](object-datetime.md) | Time of the most recently added or removed command.
`command_first_time` | [`DateTime`](object-datetime.md) | Time of the command with the smallest timestamp in the window.<br>`null` if the window is empty.
`command_last_time` | [`DateTime`](object-datetime.md) | Time of the command with the largest timestamp in the window.<br>`null` if the window is empty.

### Series Fields

|**Name**|**Type**|**Description**|**Example**|
|---|---|---|--|
| `value` | number | Last value | `3.1415` |
| `open_value` | number | First value | `1.0` |

### Message Fields

|**Name**|**Type**|**Description**|
|---|---|---|
| `type` | string | Message type (also `tags.type`). |
| `source` | string | Message type (also `tags.source`). |
| `message` | string | Message text. |

Notes:

* The `tags` field for the `message` command contains `type`, `source`, `severity`, and other command tags.
* Alert `severity` value is inherited from message `severity` when **Logging: Severity** is set to **Undefined**.

### Properties Fields

|**Name**|**Type**|**Description**|
|---|---|---|
| `type` | string | Property type, same as `tags.type`. |
| `keys` | map | Property keys, serialized as `[key1: val1, key2: val2]`.<br>To retrieve key value, use `keys.{name}`. |
| `properties` | map | Property tags, serialized as `[key1: val1, key2: val2]`.<br>To retrieve tag value, use `properties.{name}`. |
| `properties_all` | map | All property tags for the current entity and type. Initialized from database and subsequently updated with matching `property` command. |
| `properties_previous` | map | Property tags before changed by the current `property` command. |

* The `tags` field for the `property` command contains the `keys` map and the `type` field.
* The `properties_all` field is loaded from the database at the window initialization time, beginning with the **Start Date** set on the **Windows** tab.

## Entity Fields

**Name**|**Type**|**Description**|**Example**
:---|---|---|:---
`entity.tags` | map | Entity tags, serialized as `[key1: val1, key2: val2]`. | `entity.tags.size() > 0`
`entity.tags.<name>` | string | Entity tag by name. | `entity.tags.location = 'DC1'`
`entity.label` | string | Entity label. | `entity.label == '*abc*'`
`entity.displayName` | string | Entity label, or entity name if label is empty. | `entity.displayName LIKE '*swg*'`
`entity.enabled` | boolean | Entity label. | `entity.enabled ? 'ON' : 'OFF'`
`entity.interpolate` | string | Interpolation mode. | `entity.interpolate == 'LINEAR'`
`entity.timeZone` | string | Entity time zone. | `entity.timeZone != 'US/Eastern'`
`entity.creationTime` | [`DateTime`](object-datetime.md) | Entity creation time. | `entity.creationTime > '2020-05-01'`
`entity.lastInsertTime` | [`DateTime`](object-datetime.md) | Time of the most recent series insert for any metric of the entity. | `elapsed_minutes(entity.lastInsertTime) < 15`

## Date Fields

<!-- markdownlint-disable MD102 -->

**Name**|**Data Type**|**Description**
:---|---|:---
`add_time` | [`DateTime`](object-datetime.md) | Last time when command added to window.
`previous_add_time` | [`DateTime`](object-datetime.md) | Previous command `add_time`.
`open_time` | [`DateTime`](object-datetime.md) | Time when the window changed status to `OPEN`, or when the condition evaluated to `true` for the first time.
`repeat_time` | [`DateTime`](object-datetime.md) | Last time when the condition evaluated to `true`, equal to `open_time` when the status changes to `OPEN`.
`cancel_time` | [`DateTime`](object-datetime.md) | Time when the window changed status to `CANCEL`, or when the condition evaluated to `false` for the first time.
`change_time` | [`DateTime`](object-datetime.md) | Last time when the window changed status.
`remove_time` | [`DateTime`](object-datetime.md) | Last time when command removed from the window.
`update_time` | [`DateTime`](object-datetime.md) | Last time when command added or removed from the window.
`window_duration` | `long` | Difference between `command_last_time` and `command_first_time` measured in milliseconds.<br>`0` if the window is empty.
`alert_duration` | `string` | Interval between current time and `open_time`, formatted as `days:hours:minutes:seconds`, for example `00:00:01:45`.<br>Returns an empty string **On Open** status.
`alert_duration_interval` | `string` | Interval between current time and `open_time`, formatted as `alert_duration` with units, for example `1m:45s`.<br>Returns an empty string **On Open** status.
`is_exiting` | `bool` | `true` if **Check On Exit** setting is enabled and the condition check is caused by a removed command.

<!-- markdownlint-enable MD102 -->

**Notes**:

* [`DateTime`](object-datetime.md) object fields can be accessed with dot notation syntax, for example `now.millis`.
* To format the [`DateTime`](object-datetime.md) object using a custom pattern or time zone, use the [`date_format`](./functions-date.md#date_format) function.
* [`DateTime`](object-datetime.md) object fields that begin with `command_` contain the command timestamps, otherwise the fields are set based on server time.
* [`DateTime`](object-datetime.md) object fields can be `null` if the event has not yet occurred or if the window is empty.
* If **Check On Exit** setting is enabled and the condition check is caused by a removed command, the `command_time` field contains the timestamp of the **exiting command** (oldest command), rounded to seconds.

## Current Time Fields

**Name**|**Data Type**|**Description**
:---|---|:---
| `now` | [`DateTime`](object-datetime.md) | Current server time. |
| `today` | [`DateTime`](object-datetime.md) | `00:00` (midnight) of the **current day** in server time zone. |
| `yesterday` | [`DateTime`](object-datetime.md) | `00:00` (midnight) of the **previous day** in server time zone. |
| `tomorrow` | [`DateTime`](object-datetime.md) | `00:00` (midnight) of the **next day** in server time zone. |

## Detail Tables

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
