# Alert History Functions

## Overview

## `last_open`

```java
last_open() RuleAlert
```

Retrieves window from Alert History for the **last** alert with `OPEN` or `REPEAT` status for current rule and current 
window key based on metric, entity, grouping tags.

If the record is not found, the function returns an empty `RuleAlert` object with `timestamp` set to 0,
 `value` and `open_value` set to `NaN`, and other fields set to empty strings.
 
The function needs [Alert History logging](logging.md#logging-to-database) to be enabled.

### Fields Supported by `RuleAlert`

**Field** | **Type**
----|-----
`metric` | string
`entity` | string
`tags` | map
`tags.{tag-name}` | string
`timestamp` | long
`text` | string
`value` | double
`open_value` | double
`status` | string
`rule` | string
`condition` | string
`alert_message` | string
`alert_duration` | string
`alert_duration_interval` | string
`alert_open_time` | string
`alert_open_datetime` | string
`rule_filter` | string
`severity` | string
`window` | string
`repeat_count` | integer
`{user-variable-name}` | string

Examples:

```javascript
elapsed_minutes(last_open().timestamp) > 60
```

```javascript
(value - last_open().value) / last_open().value > 0.1
```
