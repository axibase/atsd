# Alert History Functions

## Overview

## `last_open`

```java
last_open() RuleAlertWrapper
```

Retrieves window from Alert History for the last alert with `OPEN` or `REPEAT` status for current rule and current time series key.

### Fields Supported by `RuleAlertWrapper`

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
randomKey(excludeKeys(replacementTable('lunch-places'), [last_open().lunch_place]))
```
