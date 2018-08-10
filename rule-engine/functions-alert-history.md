# Alert History Functions

## `last_open`

```javascript
last_open() object
```

Retrieves the most recent [`AlertHistory`](logging.md#logging-to-database) record with `OPEN` or `REPEAT` status for the current window.

If no records match, the function returns an `AlertHistory` object with default values such as `0` timestamp, `NaN` value, etc.

To use this function, enable [Alert History](logging.md#logging-to-database) logging on the **Logging** tab. Check the **Log to Alert History** option and enable either `On Open` / `On Repeat` triggers.

### `AlertHistory` Object

**Field** | **Type** | **Description** | **Example**
----|-----|-----|------
`rule` | string | Rule name. | `CPU high alert`
`metric` | string | Metric name. | `cpu.used.percent`
`entity` | string | Entity name. | `nginx-proxy`
`tags` | map | Command tags of the command that caused the alert. | `{"docker-host":"nurswghbs001"}`
`tags.{tag-name}` | string | `{tag-name}` command tag value. | `last_open().tags.docker-host`: `nurswghbs001`
`type` | string | Message type | `web`
`source` | string | Message source | `access.log`
`keys` | string | Command tags or property keys | `{"docker-host":"nurswghbs001"}`
`timestamp` | long | Command time in Unix milliseconds.<br>Default: `0` | `1533109937000`
`message` | string | Message text | `Application restarted`
`value` | double | Command value.<br>Default: `NaN`. | `85.2`
`open_value` | double | Open value.<br>Default: `NaN`. | `82.7`
`status` | string | Window status. | `REPEAT`
`condition` | string | Rule condition. | `value > 75`
`alert_message` | string | Alert message. | `High cpu usage (85.2)`
`alert_duration` | string | Alert duration in `dd:hh:mm:ss` format. | `00:00:01:00`
`alert_duration_interval` | string | Alert duration in short format. | `1m:0s`
`alert_open_time` | number | Alert open time in Unix milliseconds.<br>Default: `0` | `2018-08-01 07:51:17`
`alert_open_datetime` | string | Alert open time in ISO format.<br>Default: `1970-01-01T00:00:00Z` | `2018-08-01T07:51:17Z`
`rule_filter` | string | Filter expression | `entity.tags.profile = 'production'`
`severity` | string | Alert severity.<br>Default: `UNDEFINED` | `WARNING`
`window` | string | Window duration. | `time(5 minute)`
`repeat_count` | integer | Alert repeat counter.<br>Default: `0` | `5`
`{user-variable-name}` | string | User-defined variable value. | `last_open().valueCnt`: `2`

## Examples

* Check if sixty minutes passed since the last `OPEN`/`REPEAT` status, or if no previous record is found.

    ```javascript
    elapsed_minutes(last_open().timestamp) > 60
    ```

* Check if the last command value exceeds the value in the previous `OPEN`/`REPEAT` record.

    ```javascript
    last_open().timestamp > 0 && value > last_open().value
    ```

* Check if the user variable named `place` has changed compared to the previous `OPEN`/`REPEAT` record.

    ```javascript
    last_open().place != place
    ```