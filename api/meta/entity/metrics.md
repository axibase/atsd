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
| entity |string|Entity name.|

### Query Parameters 

|**Name**|**Type**|**Description**|
|:--|:--|:--|
| expression | string | Expression to include metrics by name or tags. Use the `name` variable for metric name. The wildcard `*` is supported.|
| minInsertDate | string | Include metrics with last insert date at or greater than specified time. <br>`minInsertDate` can be specified in ISO format or using [endtime](../../../end-time-syntax.md) syntax.|
| maxInsertDate | string | Include metrics with last insert date less than specified time.<br>`maxInsertDate` can be specified in ISO format or using [endtime](../../../end-time-syntax.md) syntax.|
| useEntityInsertTime | boolean | If true, `lastInsertDate` is calculated for the specified entity and metric.<br>Otherwise, `lastInsertDate` represents the last time for all entities. Default: false. |
| limit | integer | Maximum number of metrics to retrieve, ordered by name. |
| tags | string | Comma-separated list of metric tags to be included in the response.<br>For example, `tags=table,unit`<br>Specify `tags=*` to include all metric tags.|

## Response

### Fields

Refer to Fields specified in [Metrics List](../../../api/meta/metric/list.md#fields) method.

## Example

### Request

#### URI

```elm
GET https://atsd_host:8443/api/v1/entities/nurswgvml007/metrics?limit=2
```

#### Payload

None.

#### curl

```elm
curl https://atsd_host:8443/api/v1/entities/nurswgvml007/metrics?limit=2 \
  --insecure --verbose --user {username}:{password} \
  --request GET
``` 

### Response

```json
[
    {
        "name": "mpstat.cpu_busy",
        "enabled": true,
        "dataType": "FLOAT",
        "persistent": true,
        "timePrecision": "MILLISECONDS",
        "retentionDays": 0,
        "invalidAction": "NONE",
        "lastInsertDate": "2015-09-04T16:10:21.000Z"
    },
    {
        "name": "df.disk_used",
        "enabled": true,
        "dataType": "FLOAT",
        "persistent": true,
        "timePrecision": "MILLISECONDS",
        "retentionDays": 0,
        "invalidAction": "NONE",
        "lastInsertDate": "2015-09-04T16:10:21.000Z"
    }
]
```

## Additional examples
