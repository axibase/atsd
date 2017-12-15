# Placeholders

## Overview

Placeholders can be used to include [window](window.md) fields, [entity fields](../api/meta/entity/list.md#fields), [metric fields](../api/meta/metric/list.md#fields), and [function](functions.md) values into email messages, web notifications, system commands, and logging messages.

Specified using the `${name}` syntax, the placeholder is resolved, evaluated and replaced with the actual value of the named field, variable or function at the time the trigger is executed.

![](images/placeholders.png)

Non-existing placeholders are substituted with empty strings.

## Base Placeholders

**Name**|**Example**
:---|:---
status | OPEN
rule | memory_low
metric | memory_free
entity | nurswgvml007
tags | memtype=buffered
tags.memtype | buffered
value | 3103100000
entity.tags | {version=community}
entity.tags.version | community
entity.label | NURswgvml007
metric.label | Memory Free, Bytes
alert_type | OPEN
condition | value < 512*1024*1024
min_interval_expired | true
open_value | 3103100000
repeat_count | 0
repeat_interval | 1 MINUTE
rule_filter | entity != 'nurswghbs001'
rule_name | memory_low
severity | warning
window | length(1)
threshold | max() > 20

## Series Placeholders

* open_value
* value

## Message Placeholders

* message
* severity

## Properties Placeholders

* properties
* properties.key_name
* properties.tag_name
* type

## Time Placeholders

* alert_duration
* alert_duration_interval
* alert_open_time
* alert_open_datetime
* received_time
* received_datetime
* event_time
* event_datetime
* window_first_time
* window_first_datetime
* timestamp
* now

> Placeholders ending with `_time` contain time in local server timezone, for example 2017-05-30 14:05:39 PST.
> Placeholders ending with `_datetime` contain time in ISO 8601 format in UTC timezone, for example 2017-05-30T06:05:39Z.
> `timestamp` returns `event_time` in Unix milliseconds.
> `now` returns a [Joda-time](http://joda-time.sourceforge.net/apidocs/org/joda/time/DateTime.html) DateTime object object representing the current server time in the server timezone. Its properties can be accessed via `get` methods, e.g. `now.getDayOfWeek()`.

## Link Placeholders

* ruleLink
* chartLink
* csvExportLink
* htmlExportLink

## Details Table Placeholders

* detailsTable('markdown')
* detailsTable('ascii')
* detailsTable('html')
* detailsTable('property')
* detailsTable('csv')
* detailsTable('json')

## Placeholders for Custom Variables

Variables defined on the 'Overview' tab can be referenced by name, similar to the other fields.

```sh
${idle}
```

![](images/variables.png)

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
