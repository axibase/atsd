# Metric: List

## Description

Retrieve a list of metrics matching the specified filter conditions.

## Request

| **Method** | **Path** |
|:---|:---|
| GET | `/api/v1/metrics` |

### Query Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| expression |string|Include metrics that match an [expression](../../../api/meta/expression.md) filter. Use the `name` variable for metric name. Supported wildcards: `*` and `?`.|
| minInsertDate |string|Include metrics with `lastInsertDate` equal or greater than `minInsertDate`.<br>The parameter can be specified in ISO-8601 format or using [endtime](../../../end-time-syntax.md) syntax.|
| maxInsertDate |string|Include metrics with `lastInsertDate` less than `maxInsertDate`, including metrics without `lastInsertDate`.<br>The parameter can be specified in ISO format or using [endtime](../../../end-time-syntax.md) syntax.|
| limit |integer|Maximum number of metrics to retrieve, ordered by name.|
| tags |string|Comma-separated list of metric tag names to be displayed in the response.<br>For example, `tags=OS,location`<br>Specify `tags=*` to request all metric tags.|

## Response

### Fields

| **Name** | **Type** | **Description** |
|:---|:---|:---|
|name| string | Metric name.|
|label| string | Metric label.|
|description | string | Metric description.|
|tags| object | An object containing tags as names and values.<br>For example, `"tags": {"table": "axibase-collector"}`|
|dataType| string | [Data Type](#data-types).|
|interpolate| string | Interpolation mode: `LINEAR` or `PREVIOUS`. <br>Used in SQL `WITH INTERPOLATE` clause when interpolation mode is set to `AUTO`, for example, `WITH INTERPOLATE(1 MINUTE, AUTO)`. |ß
|units| string | Measurement units. |
|timeZone| string | Time Zone ID, for example `America/New_York` or `EST`.<br>Refer to [Java Time Zone](../../../api/network/timezone-list.md) table for a list of supported Time Zone IDs.<br>The timezone is applied by date-formatting functions to return local time in metric-specific timezone.|
|timePrecision| string | Time precision: SECONDS or MILLISECONDS.|
|enabled| boolean | Enabled status. Incoming data is discarded for disabled metrics.|
|persistent | boolean | Persistence status. Non-persistent metrics are not stored in the database and are only processed by the rule engine.|
|filter | string | Persistence filter [expression](../../../api/meta/expression.md). Discards series that do not match this filter.|
|createdDate| string | Date when this metric was created in ISO-8601 format.|
|lastInsertDate| string | Last time a value was received for this metric by any series in ISO-8601 format.|
|retentionDays| integer | Number of days to store the values for this metric. Samples with insert date earlier than current time minus retention days are removed on schedule.|
|seriesRetentionDays| integer | Number of days to retain series. Expired series with last insert date earlier than current time minus series retention days are removed on schedule.|
|versioned| boolean | If set to true, enables versioning for the specified metric. <br>When metrics are versioned, the database retains the history of series value changes for the same timestamp along with `version_source` and `version_status`.|
|minValue| double | Minimum value for [Invalid Action](#invalid-actions) trigger.|
|maxValue| double | Maximum value for [Invalid Action](#invalid-actions) trigger.|
|invalidAction | string | [Invalid Action](#invalid-actions) type.|

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

 Invalid Action is triggered if the received series value is less than the Minimum value, or if it's greater than the Maximum value.

|**Action**|**Description**|
|:---|:---|
|NONE|Retain value as is.|
|DISCARD|Don't process the received value, discard it.|
|TRANSFORM|Set value to `min_value` or `max_value`, if value is outside of range.|
|RAISE_ERROR|Log an ERROR event in the database log.|
|SET_VERION_STATUS|For versioned metrics, set status to 'Invalid'.|

### Interpolate

|**Type**|
|:---|
|LINEAR|
|PREVIOUS|

### Time Precision

|**Precision**|
|:---|
|MILLISECONDS|
|SECONDS|

## Example 1

### Request

#### URI

```elm
https://atsd_host:8443/api/v1/metrics?limit=2
```

#### Payload

None.

#### curl

```elm
curl https://atsd_host:8443/api/v1/metrics?limit=2 \
  --insecure --verbose --user {username}:{password} \
  --request GET
```

### Response

```json
[
  {
    "name": "m-vers",
    "enabled": true,
    "dataType": "FLOAT",
    "persistent": true,
    "timePrecision": "MILLISECONDS",
    "retentionDays": 0,
    "invalidAction": "NONE",
    "lastInsertDate": "2016-05-19T00:15:02.000Z",
    "versioned": true,
    "interpolate":"LINEAR",
    "createdDate": "2015-10-03T07:03:45.558Z"
  },
  {
    "name": "temperature",
    "enabled": true,
    "dataType": "FLOAT",
    "persistent": true,
    "timePrecision": "MILLISECONDS",
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

```text
name != "" OR tags.keyName != "" OR label! = "" OR description != "" OR enabled = true OR persistent=true OR persistenceFilter != "" OR retentionDays=0 OR dataType="FLOAT" OR timePrecision="MILLISECONDS" OR versioning=false AND invalidAction="NONE" OR timeZone="" OR interpolate="LINEAR"
```

### Request

#### URI

```elm
https://atsd_host:8443/api/v1/metrics?tags=*&expression=versioning=true%20and%20retentionDays%3E0%20and%20dataType=%22FLOAT%22
```

#### Payload

None.

#### curl

```elm
curl https://atsd_host:8443/api/v1/metrics?expression=versioning=true%20and%20retentionDays%3E0%20and%20dataType=%22FLOAT%22 \
  --insecure --verbose --user {username}:{password} \
  --request GET
```

### Response

```json
[
  {
    "name": "metric",
    "enabled": true,
    "dataType": "FLOAT",
    "persistent": true,
    "timePrecision": "MILLISECONDS",
    "retentionDays": 3,
    "invalidAction": "NONE",
    "lastInsertDate": "2016-10-28T08:18:17.218Z",
    "versioned": true,
    "interpolate": "LINEAR"
  }
]
```

## Additional Examples

* [List metrics by name](examples/list-metrics-by-name.md)
* [List metrics by name using wildcards](examples/list-metrics-by-name-wildcards.md)
* [List metrics by name and tag](examples/list-metrics-by-name-and-tag.md)
* [List metrics with tag `table`](examples/list-metrics-with-tag-table.md)
* [List metrics by maxInsertDate](examples/list-metrics-by-maxinsertdate.md)
* [List metrics by minInsertDate](examples/list-metrics-by-mininsertdate.md)
* [List metrics for last insert range](examples/list-metrics-for-last-insert-range.md)
* [List metrics without last insert date](examples/list-metrics-without-last-insert-date.md)
