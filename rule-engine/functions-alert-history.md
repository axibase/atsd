# Alert History Functions

## `last_open`

```java
last_open() RuleAlert
```

Retrieves the most recent `RuleAlert` object with `OPEN` or `REPEAT` status from the [Alert History](logging.md#logging-to-database) for the current window key consisting of rule name, metric (type/source), entity, and grouping tags.

If no records are matched, the function returns an empty `RuleAlert` object with `timestamp` set to `0`,
 `value`, `open_value` set to `NaN`, and the remaining fields set to empty strings.

The function requires enabled Alert History [database logging](logging.md#logging-to-database).

### `RuleAlert` Object

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

## Examples

* Check whether more than sixty minutes passed since the last `OPEN`/`REPEAT` status, or if no previous record is found.

```javascript
elapsed_minutes(last_open().timestamp) > 60
```

* Check that the received command value increased compared to the previous `OPEN`/`REPEAT` record.

```javascript
last_open().timestamp > 0 && value > last_open().value
```

* Check that the user variable named `place` has changed compared to the previous `OPEN`/`REPEAT` record.

```javascript
last_open().place != place
```
