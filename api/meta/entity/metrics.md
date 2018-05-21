# Metrics: Entity

## Description

Retrieve a list of metrics collected by the entity.

## Request

| **Method** | **Path** |
|:---|:---|
| GET | `/api/v1/entities/{entity}/metrics` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `entity` |string|Entity name.|

### Query Parameters

|**Name**|**Type**|**Description**|
|:--|:--|:--|
| `expression` | string | Include metrics that match a filter [expression](../../../api/meta/expression.md) consisting of fields and operators. Example: `name LIKE 'cpu*'`.<br>Supported wildcards: `*` and `?`.|
| `minInsertDate` | string | Include metrics with last insert date equal or greater than specified time. <br>`minInsertDate` can be specified in ISO format or using [calendar](../../../shared/calendar.md) keywords.|
| `maxInsertDate` | string | Include metrics with last insert date less than specified time.<br>`maxInsertDate` can be specified in ISO format or using [calendar](../../../shared/calendar.md) keywords.|
| `useEntityInsertTime` | boolean | If true, `lastInsertDate` is calculated for the specified entity and metric.<br>Otherwise, `lastInsertDate` represents the last time for all entities. Default: false. |
| `limit` | integer | Maximum number of metrics to retrieve, ordered by name. |
| `tags` | string | Comma-separated list of metric tags to be included in the response.<br>For example, `tags=table,unit`<br>Specify `tags=*` to include all metric tags.|

#### Expression

The expression can include any field specified in [Metrics List](../metric/list.md#fields) method, such as name, label, and minValue, except the lastInsertDate field which can be filtered using minInsertDate and maxInsertDate parameters for performance reasons.

String literals must be enclosed in single or double quotes.

Examples:

```ls

label IN ('Employed full time', 'OECD')

tags.fs='ext4'
```
## Response

### Fields

Refer to Fields specified in [Metrics List](../metric/list.md#fields) method.

## Example

### Request

#### URI

```elm
GET https://atsd_hostname:8443/api/v1/entities/nurswgvml007/metrics?limit=2
```

#### Payload

None.

#### curl

```sh
curl https://atsd_hostname:8443/api/v1/entities/nurswgvml007/metrics?limit=2 \
  --insecure --verbose --user {username}:{password} \
  --request GET
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
    "timePrecision": "MILLISECONDS",
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
    "timePrecision": "MILLISECONDS",
    "retentionDays": 0,
    "seriesRetentionDays": 0,
    "invalidAction": "NONE",
    "lastInsertDate": "2017-12-18T12:17:04.000Z",
    "versioned": false,
    "interpolate": "LINEAR"
  }
]
```

## Additional examples
