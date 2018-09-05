# Entity: metrics

## Description

Retrieves a list of metrics collected by the entity.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/entities/{entity}/metrics` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `entity` |string|Entity name.|

### Query Parameters

|**Name**|**Type**|**Description**|
|:--|:--|:--|
| `expression` | string | Include metrics that match a filter [expression](../../../api/meta/expression.md) consisting of fields and operators. Example: `name LIKE 'cpu*'`.<br>Supported wildcards: `*` and `?`.|
| `minInsertDate` | string | Include metrics with last insert date equal or greater than specified time. <br>`minInsertDate` can be specified in [ISO format](../../../shared/date-format.md#supported-formats) or using [calendar](../../../shared/calendar.md) keywords.|
| `maxInsertDate` | string | Include metrics with last insert date less than specified time.<br>`maxInsertDate` can be specified in [ISO format](../../../shared/date-format.md#supported-formats) or using [calendar](../../../shared/calendar.md) keywords.|
| `useEntityInsertTime` | boolean | Controls how `lastInsertDate` field in the response is calculated. If `true`, the field contains the maximum insert time of series collected for the given metric by **the specified entity**.<br>If `false`, the field contains the maximum insert time of series collected for the given metric by **all entities**.<br>Default: `true`. |
| `limit` | integer | Maximum number of metrics to retrieve, ordered by name. |
| `tags` | string | Comma-separated list of metric tags to be included in the response.<br>For example, `tags=table,unit`<br>Specify `tags=*` to include all metric tags.|
| `addInsertTime` | boolean| Controls whether [`lastInsertDate`](../metric/list.md#fields) field is included in the response.<br>The default value is inherited from the `default.addInsertTime` setting on the [**Settings > Server Properties**](../../../administration/server-properties.md) page which is set to `true` by default.|

#### Expression

The expression can include any field specified in [Metrics List](../metric/list.md#fields) method, such as `name`, `label`, and `minValue`, except the `filter` field and `lastInsertDate` which can be filtered using `minInsertDate` and `maxInsertDate` parameters for performance reasons.

String literals must be enclosed in single or double quotes.

Examples:

```javascript
label IN ('Employed full time', 'OECD')
```

```javascript
tags.fs='ext4'
```

```javascript
name LIKE 'cpu*' AND dataType!='FLOAT'
```

## Response

### Fields

Refer to Fields specified in [Metrics List](../metric/list.md#fields) method.

## Example 1

### Request

#### URI

```elm
GET /api/v1/entities/nurswgvml007/metrics?limit=2
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/entities/nurswgvml007/metrics?limit=2 \
  --insecure --include --user {username}:{password}
```

### Response

```json
[
  {
    "name": "cpu_busy",
    "enabled": true,
    "dataType": "FLOAT",
    "label": "CPU Busy %",
    "persistent": true,
    "retentionDays": 0,
    "seriesRetentionDays": 0,
    "minValue": 0,
    "maxValue": 100,
    "invalidAction": "TRANSFORM",
    "lastInsertDate": "2017-12-18T12:17:04.000Z",
    "versioned": false,
    "interpolate": "LINEAR",
    "timeZone": "US/Eastern"
  },
  {
    "name": "cpu_idle",
    "enabled": true,
    "dataType": "FLOAT",
    "persistent": true,
    "retentionDays": 0,
    "seriesRetentionDays": 0,
    "invalidAction": "NONE",
    "lastInsertDate": "2017-12-18T12:17:04.000Z",
    "versioned": false,
    "interpolate": "LINEAR"
  }
]
```

## Example 2

### Request

#### URI

```elm
GET /api/v1/entities/nurswgvml007/metrics?useEntityInsertTime=false&tags=*&limit=2
```

#### Payload

None.

#### curl

```sh
curl "https://atsd_hostname:8443/api/v1/entities/nurswgvml007/metrics?useEntityInsertTime=false&tags=*&limit=2" \
  --insecure --user {username}:{password}
```

### Response

```json
[
  {
    "name": "disk_used_percent",
    "enabled": true,
    "dataType": "DECIMAL",
    "label": "Disk Used, %",
    "persistent": true,
    "tags": {
      "table": "Disk (script)",
      "unit": "Percent (%)"
    },
    "retentionDays": 0,
    "seriesRetentionDays": 60,
    "minValue": 0,
    "maxValue": 100,
    "invalidAction": "TRANSFORM",
    "lastInsertDate": "2018-05-23T16:58:47.000Z",
    "filter": "!likeAny(tags.mount_point, collection('ignore-collector-mount-points'))",
    "versioned": false,
    "interpolate": "LINEAR"
  }
]
```

## Additional examples

* [List Entity Metrics by Name and Tag](examples/list-entity-metrics-by-name-and-tag.md)
* [List Entity Metrics by Persistence Status](examples/list-entity-metrics-by-persistence.md)
* [List Entity Metrics by Tags and Description](examples/list-entity-metrics-by-tags-and-description.md)
* [List Entity Metrics by Min and Max Value](examples/list-entity-metrics-by-min-max-value.md)
* [List Entity Metrics for Last Insert Date Range](examples/list-entity-metrics-for-last-insert-range.md)
