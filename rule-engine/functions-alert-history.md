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
`rule` | `string` | Rule name. | `CPU high alert`
`metric` | `string` | Metric name. | `cpu.used.percent`
`entity` | `string` | Entity name. | `nginx-proxy`
`tags` | `map` | Command tags of the command that caused the alert. | `{"docker-host":"nurswghbs001"}`
`tags.{tag-name}` | `string` | `{tag-name}` command tag value. | `last_open().tags.docker-host`: `nurswghbs001`
`type` | `string` | Message type | `web`
`source` | `string` | Message source | `access.log`
`keys` | `string` | Command tags or property keys | `{"docker-host":"nurswghbs001"}`
`timestamp` | `long `| Command time in Unix time with millisecond granularity.<br>Default: `0` | `1533109937000`
`message` | `string` | Message text | `Application restarted`
`value` | `double` | Command value.<br>Default: `NaN`. | `85.2`
`open_value` | `double` | Open value.<br>Default: `NaN`. | `82.7`
`status` | `string` | Window status. | `REPEAT`
`condition` | `string` | Rule condition. | `value > 75`
`add_time` | `DateTime` | Last time when command was added to window. <br>Default: `null`.| `2018-09-13T12:03Z[Etc/UTC]`
`alert_message` | `string` | Alert message. | `High cpu usage (85.2)`
`alert_duration` | `string` | Alert duration in `dd:hh:mm:ss` format. | `00:00:01:00`
`alert_duration_interval` | `string` | Alert duration in short format. | `1m:0s`
`cancel_time` | `DateTime` | Time when the window changed status to `CANCEL`, or when the condition evaluated to `false` for the first time. <br>Default: `null`. | `2018-09-13T12:03Z[Etc/UTC]`
`command_first_time` | `DateTime` | Time of the command with the smallest timestamp in the window. <br>Default: `null`.| `2018-09-13T12:03Z[Etc/UTC]`
`command_last_time` | `DateTime` | Time of the command with the largest timestamp in the window. <br>Default: `null`.| `2018-09-13T12:03Z[Etc/UTC]`
`command_time` | `DateTime` | Time of the command that was last added or removed from the window. <br>Default: `null`.| `2018-09-13T12:17:45Z[Etc/UTC]`
`open_time` | `DateTime` | Time when the window changed status to `OPEN`, or when the condition evaluated to `true` for the first time. <br>Default: `null`. | `2018-08-01T07:51:17Z[Etc/UTC]`
`repeat_time` | `DateTime` | Last time when the condition evaluated to `true`, equal to `open_time` when the status changes to `OPEN`. <br>Default: `null`.| `2018-09-13T12:15:15Z[Etc/UTC]`
`update_time` | `DateTime` | Last time when command was added or removed from the window. <br>Default: `null`.| `2018-09-13T12:03Z[Etc/UTC]`
`remove_time` | `DateTime` | Last time when command was removed from the window. <br>Default: `null`.| `2018-09-13T12:17:45Z[Etc/UTC]`
`rule_filter` | `string` | Filter expression | `entity.tags.profile = 'production'`
`severity` | `string` | Alert severity.<br>Default: `UNDEFINED` | `WARNING`
`window` | `string` | Window duration. | `time(5 minute)`
`repeat_count` | `integer` | Alert repeat counter.<br>Default: `0` | `5`
`{user-variable-name}` | `string` | User-defined variable value. | `last_open().valueCnt`: `2`

## Examples

* Check if sixty minutes passed since the last `OPEN`/`REPEAT` status, or if no previous record is found.

    ```javascript
    elapsed_minutes(last_open().timestamp) > 60
    ```

* Check if the last command value exceeds the value in the previous `OPEN`/`REPEAT` record.

    ```javascript
    last_open().timestamp > 0 && value > last_open().value
    ```

* Check if the user variable named `location` has changed compared to the previous `OPEN`/`REPEAT` record.

    ```javascript
    last_open().location != location
    ```