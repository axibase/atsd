# Alert History Functions

## `last_open`

```javascript
last_open() object
```

Retrieves the most recent `RuleAlert` object with `OPEN` or `REPEAT` status from the [Alert History](logging.md#logging-to-database) for the current window key consisting of rule name, metric (type/source), entity, and grouping tags.

If no records are matched, the function returns a `RuleAlert` object with default field values.

The function depends on the [Alert History](logging.md#logging-to-database) logging. To store status changes in the database, check the **Log to Alert History** option on the **Logging** tab and enable `On Open` or `On Repeat` trigger.

### `RuleAlert` Object

**Field** | **Type** | **Default Value**
----|-----|-----
`rule` | string | current rule
`metric` | string | current metric
`entity` | string | current entity
`tags` | map | current tags
`tags.{tag-name}` | string | current value of `{tag-name}` tag
`type` | string | current value of `type` tag
`source` | string | current value of `source` tag
`keys` | string | current tags
`timestamp` | long | `0`
`message` | string | empty string
`value` | double | `NaN`
`open_value` | double | `NaN`
`status` | string | empty string
`condition` | string | empty string
`alert_message` | string | empty string
`alert_duration` | string | empty string
`alert_duration_interval` | string | empty string
`alert_open_time` | string | `1970-01-01 00:00:00`
`alert_open_datetime` | string | `1970-01-01T00:00:00Z`
`rule_filter` | string | empty string
`severity` | string | `UNDEFINED`
`window` | string | empty string
`repeat_count` | integer | `0`
`{user-variable-name}` | string | empty string

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
