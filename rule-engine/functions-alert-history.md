# Alert History Functions

## `last_open`

```javascript
last_open() AlertHistory
```

Retrieves the most recent [`AlertHistory`](logging.md#logging-to-database) record with `OPEN` or `REPEAT` status for the current window.

If no records match, the function returns an `AlertHistory` object with default values such as `0` timestamp, `NaN` value, etc.

To call this function, enable [Alert History](logging.md#logging-to-database) logging on the **Logging** tab. Check the **Log to Alert History** option and enable either `On Open` / `On Repeat` triggers.

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
`command_time` | DateTime | Timestamp of the command that caused the alert when Alert History was written.<br>Default: `1970-00-00T00:00:00Z[UTC]` | `2018-09-12T21:33:42+01:00[Europe/Berlin]`
`add_time` | DateTime | Server time when command was last added to the window when Alert History was written.<br>Default: `1970-00-00T00:00:00Z[UTC]` | `2018-09-12T21:33:47.116+01:00[Europe/Berlin]`
`remove_time` | DateTime | Server time when command was last removed from the window when Alert History was written. `null` if no command was removed from the window.<br>Default: `1970-00-00T00:00:00Z[UTC]` | `null`
`update_time` | DateTime | Server time when command was last added or removed from the window when Alert History was written.<br>Default: `1970-00-00T00:00:00Z[UTC]` | `2018-09-12T21:34:04.951+01:00[Europe/Berlin]`
`open_time` | DateTime | Server time when window status changed to `OPEN` when Alert History was written. `null` if status was not changed to `OPEN`.<br>Default: `1970-00-00T00:00:00Z[UTC]` | `2018-09-12T21:33:42.246+01:00[Europe/Berlin]`
`repeat_time` | DateTime | Last time when condition evaluated to `true` when Alert History was written. `null` if status was not changed to `REPEAT`.<br>Default: `1970-00-00T00:00:00Z[UTC]` | `2018-09-12T21:33:58.298+01:00[Europe/Berlin]`
`cancel_time` | DateTime | Time when the window changed status to CANCEL, or when the condition evaluated to false for the first time when Alert History was written. `null` if status was not changed to `CANCEL`.<br>Default: `1970-00-00T00:00:00Z[UTC]` | `2018-09-12T21:33:39.278+01:00[Europe/Berlin]`
`change_time` | DateTime | Time when the window changed status when the condition evaluated to false for the first time when Alert History was written. `null` if status was not changed.<br>Default: `1970-00-00T00:00:00Z[UTC]` | `2018-09-12T21:33:47.116+01:00[Europe/Berlin]`
`message` | string | Message text | `Application restarted`
`value` | double | Command value.<br>Default: `NaN`. | `85.2`
`open_value` | double | Open value.<br>Default: `NaN`. | `82.7`
`status` | string | Window status. | `REPEAT`
`condition` | string | Rule condition. | `value > 75`
`alert_message` | string | Alert message. | `High cpu usage (85.2)`
`alert_duration` | string | Alert duration in `dd:hh:mm:ss` format. | `00:00:01:00`
`alert_duration_interval` | string | Alert duration in short format. | `1m:0s`
`alert_open_time` | number | Alert open in Unix time with millisecond precision.<br>Default: `0` | `2018-08-01 07:51:17`
`alert_open_datetime` | string | Alert open time in [ISO format](../shared/date-format.md).<br>Default: `1970-01-01T00:00:00Z` | `2018-08-01T07:51:17Z`
`rule_filter` | string | Filter expression | `entity.tags.profile = 'production'`
`severity` | string | Alert severity.<br>Default: `UNDEFINED` | `WARNING`
`window` | string | Window duration. | `time(5 minute)`
`repeat_count` | integer | Alert repeat counter.<br>Default: `0` | `5`
`{user-variable-name}` | string | User-defined variable value. | `last_open().valueCnt`: `2`

## Examples

* Check if sixty minutes passed since the last `OPEN`/`REPEAT` status, or if no previous record is found.

    ```javascript
    elapsed_minutes(last_open().command_time) > 60
    ```

* Check if the last command value exceeds the value in the previous `OPEN`/`REPEAT` record.

    ```javascript
    last_open().command_time > 0 && value > last_open().value
    ```

* Check if the user variable named `location` has changed compared to the previous `OPEN`/`REPEAT` record.

    ```javascript
    last_open().location != location
    ```