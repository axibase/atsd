# Metrics: list

## Description

Retrieves a list of metrics matching the specified filters.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/metrics` |

### Query Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `expression` |string|Include metrics that match a filter [expression](../../../api/meta/expression.md) consisting of fields and operators. Example: `name LIKE 'cpu*'`.<br>Supported wildcards: `*` and `?`.<br>Example: `name LIKE 'cpu_busy'` or `or tags.source = 'iostat'`.|
| `minInsertDate` |string|Include metrics with `lastInsertDate` equal or greater than `minInsertDate`.<br>[ISO format](../../../shared/date-format.md#supported-formats) date or a [calendar](../../../shared/calendar.md) keyword, for example `2017-10-01T00:00:00Z` or `current_day`.|
| `maxInsertDate` |string|Include metrics with `lastInsertDate` less than `maxInsertDate`, including metrics without `lastInsertDate`.<br>[ISO format](../../../shared/date-format.md#supported-formats) date or a [calendar](../../../shared/calendar.md) expression for example `2017-10-01T00:00:00Z` or `now - 1*DAY`.|
| `limit` |integer|Maximum number of metrics to retrieve, ordered by name.<br>Default: `0`, unlimited.|
| `tags` |string|Comma-separated list of metric tag names to include in the response, for example, `tags=table,frequency`.<br>Specify `tags=*` to include all metric tags.<br>Specify `tags=env.*` to include all metric tags starting with `env.`.|
| `tags` |string|Comma-separated list of metric tag names to include in the response.<br>Use wildcard as part of name pattern, for example `cpu_*`, to include matching metric tags.<br>Default: no tags are included.|
| `addInsertTime` | boolean| Controls whether [`lastInsertDate`](#fields) field is included in the response.<br>The default value is inherited from the `default.addInsertTime` setting on the [**Settings > Server Properties**](../../../administration/server-properties.md) page which is set to `true` by default.|

#### Expression

The expression can include any field listed [below](#fields), such as `name`, `label`, and `minValue`, except the `filter` field and the `lastInsertDate` field which can be filtered using `minInsertDate` and `maxInsertDate` parameters for performance reasons.

String literals must be enclosed in single or double quotes.

Examples:

* Retrieve metrics with name starting with `meminfo.`.

```javascript
name LIKE 'meminfo.*'
```

* Retrieve metrics with name starting with `cpu` and created after '2017-Oct-01'.

```javascript
lower(name) NOT LIKE 'cpu*' AND createdDate > '2017-10-01T00:00:00Z'
```

* Retrieve metrics with automated data pruning.

```javascript
retentionDays > 0 OR seriesRetentionDays > 0
```

* Retrieve metrics with tag `table` equal to `iostat` (case insensitive comparison).

```javascript
lower(tags.table) = 'iostat'
```

* Retrieve metrics with non-empty `table` tag.

```javascript
tags.table != ''
```

* Retrieve metrics without any tags and name consisting of 64 characters.

```javascript
tags.size() == 0 && name.length() == 64
```

## Response

### Fields

| **Name** | **Type** | **Description** |
|:---|:---|:---|
|`name`| string | Metric name.|
|`label`| string | Metric label.|
|`description` | string | Metric description.|
|`tags`| object | An object containing tags as names and values.<br>For example, `"tags": {"table": "axibase-collector"}`|
|`dataType`| string | [Data Type](#data-types).|
|`interpolate`| string | Interpolation mode: `LINEAR` or `PREVIOUS`. <br>Used in SQL `WITH INTERPOLATE` clause when interpolation mode is set to `AUTO`, for example, `WITH INTERPOLATE(1 MINUTE, AUTO)`. |
|`units`| string | Measurement units. |
|`timeZone`| string | Time Zone ID, for example EST.<br>Refer to [Time Zone](../../../shared/timezone-list.md) table for a list of supported Time Zone IDs.<br>The time zone is applied by date-formatting functions to return local time in metric-specific time zone.|
|`enabled`| boolean | Enabled status. Incoming data is discarded for disabled metrics.|
|`persistent` | boolean | Persistence status. Non-persistent metrics are not stored in the database and are only processed by the rule engine.|
|`filter` | string | Persistence filter [expression](../../../api/meta/expression.md). Discards series that do not match this filter.|
|`createdDate`| string | Date of metric creation in [ISO format](../../../shared/date-format.md#supported-formats).|
|`lastInsertDate`| string | Last time of a received value for this metric by any series in [ISO format](../../../shared/date-format.md#supported-formats).|
|`retentionDays`| integer | Number of days to store the values for this metric. Samples with insert date earlier than current time minus retention days are removed on schedule.|
|`seriesRetentionDays`| integer | Number of days to retain series. Expired series with last insert date earlier than current time minus series retention days are removed on schedule.|
|`versioned`| boolean | If set to `true`, enables versioning for the specified metric. <br>When metrics are versioned, the database retains the history of series value changes for the same timestamp along with `version_source` and `version_status`.|
|`minValue`| double | Minimum value for [Invalid Action](#invalid-actions) trigger.|
|`maxValue`| double | Maximum value for [Invalid Action](#invalid-actions) trigger.|
|`invalidAction` | string | [Invalid Action](#invalid-actions) type.|

### Data Types

|**Type**|**Storage Size, bytes**|
|:---|:---|
|SHORT|2|
|INTEGER|4|
|LONG|8|
|FLOAT|4|
|DOUBLE|8|
|DECIMAL|variable|

Default data type for new metrics, when auto-created, is **float**.

### Invalid Actions

Invalid Action is triggered if the received series value is less than the Minimum value, or if the value is greater than the Maximum value.

|**Action**|**Description**|
|:---|:---|
|`NONE`|Retain value.|
|`DISCARD`|Do not process the received value, discard it.|
|`TRANSFORM`|Set value to `min_value` or `max_value`, if value is outside of range.|
|`RAISE_ERROR`|Log an `ERROR` event in the database log.|
|`SET_VERSION_STATUS`|For versioned metrics, set status to `Invalid`.|

### Interpolate

|**Type**|
|:---|
|LINEAR|
|PREVIOUS|

## Example 1

### Request

#### URI

```elm
GET /api/v1/metrics?limit=2
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/metrics?limit=2 \
  -k --user {username}:{password}
```

### Response

```json
[
  {
    "name": "m-vers",
    "enabled": true,
    "dataType": "FLOAT",
    "persistent": true,
    "retentionDays": 0,
    "invalidAction": "NONE",
    "lastInsertDate": "2016-05-19T00:15:02.000Z",
    "versioned": true,
    "interpolate":"LINEAR",
    "createdDate": "2018-10-03T07:03:45.558Z"
  },
  {
    "name": "temperature",
    "enabled": true,
    "dataType": "FLOAT",
    "persistent": true,
    "retentionDays": 0,
    "invalidAction": "NONE",
    "lastInsertDate": "2016-05-18T00:35:12.000Z",
    "versioned": false,
    "interpolate":"LINEAR",
    "timeZone":"America/New_York"
  }
]
```

## Example 2

Expression text:

```javascript
name != "" OR tags.keyName != "" OR label! = "" OR description != "" OR enabled = true OR persistent=true OR persistenceFilter != "" OR retentionDays=0 OR dataType="FLOAT" OR versioning=false AND invalidAction="NONE" OR timeZone="" OR interpolate="LINEAR"
```

### Request

#### URI

```elm
GET /api/v1/metrics?tags=*&expression=versioning=true%20and%20retentionDays%3E0%20and%20dataType=%22FLOAT%22
```

#### Payload

None.

#### curl

```bash
curl "https://atsd_hostname:8443/api/v1/metrics?expression=versioning=true%20and%20retentionDays%3E0%20and%20dataType=%22FLOAT%22" \
  -k --user {username}:{password}
```

### Response

```json
[
  {
    "name": "metric",
    "enabled": true,
    "dataType": "FLOAT",
    "persistent": true,
    "retentionDays": 3,
    "invalidAction": "NONE",
    "lastInsertDate": "2016-10-28T08:18:17.218Z",
    "versioned": true,
    "interpolate": "LINEAR"
  }
]
```

## Additional Examples

* [Filter metrics by name](examples/list-metrics-by-name.md)
* [List metrics by name using wildcards](examples/list-metrics-by-name-wildcards.md)
* [List metrics by name and tag value](examples/list-metrics-by-name-and-tag.md)
* [List metrics with tag `table`](examples/list-metrics-with-tag-table.md)
* [Filter metrics by maximum insert date](examples/list-metrics-by-maxinsertdate.md)
* [Filter metrics by minimum insert date](examples/list-metrics-by-mininsertdate.md)
* [Filter metrics for last insert date range](examples/list-metrics-for-last-insert-range.md)
* [Retrieve metrics without last insert date](examples/list-metrics-without-last-insert-date.md)
