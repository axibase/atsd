# Alert History Functions

## `last_open`

```javascript
last_open() object
```

Retrieves the most recent `RuleAlert` object with `OPEN` or `REPEAT` status from the [Alert History](logging.md#logging-to-database) for the current window key consisting of rule name, metric (type/source), entity, and grouping tags.

If no records are matched, the function returns a `RuleAlert` object with default field values.

The function depends on the [Alert History](logging.md#logging-to-database) logging. To store status changes in the database, check the **Log to Alert History** option on the **Logging** tab and enable `On Open` or `On Repeat` trigger.

### `RuleAlert` Object

**Field** | **Type** | **Default Value** | **Example**
----|-----|-----|------
`rule` | string | Rule name | `Active containers by docker host`
`metric` | string | Metric of command caused the alert | `docker.cpu.avg.usage.total.percent`
`entity` | string | Entity of command caused the alert | `86465ffe9b7f6fc4dd5108f82404e3c6983f4f4d7709657c5fc3e0e4be674ca2`
`tags` | map | Tags of command caused the alert | `{"docker-host":"nurswghbs001"}`
`tags.{tag-name}` | string | `{tag-name}` tag value | `last_open().tags.docker-host`: `nurswghbs001`
`type` | string | Value of `type` tag | empty string
`source` | string | Value of `source` tag | empty string
`keys` | string | Tags of command that caused the alert | `{"docker-host":"nurswghbs001"}`
`timestamp` | long | `0` | `1533109937000`
`message` | string | empty string | empty string
`value` | double | `NaN` | `85.2`
`open_value` | double | `NaN` | `82.7`
`status` | string | empty string | `REPEAT`
`condition` | string | Rule condition | `value > 75`
`alert_message` | string | empty string | `Container with high cpu usage (85.2): wordpress-load-test`
`alert_duration` | string | empty string | `00:00:01:00`
`alert_duration_interval` | string | empty string | `1m:0s`
`alert_open_time` | string | `1970-01-01 00:00:00` | `2018-08-01 07:51:17`
`alert_open_datetime` | string | `1970-01-01T00:00:00Z` | `2018-08-01T07:51:17Z`
`rule_filter` | string | Rule filter | `entity.tags.profile = 'production'`
`severity` | string | `UNDEFINED` | `WARNING`
`window` | string | Window expression of the rule | `time (5 minute)`
`repeat_count` | integer | `0` | `1`
`{user-variable-name}` | string | empty string | `last_open().cnt`: `2`

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
