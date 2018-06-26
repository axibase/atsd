# Metric: Create or Replace

## Description

Creates a metric with specified fields and tags or replaces the fields and tags of an existing metric.

In case of an existing metric, all the current metric tags are replaced with metric tags specified in the request.

If the replace request for an existing metric does not contain any tags, current metric tags are deleted.

Fields that are set to `null` are ignored by the server and are set to their default value.

The replace request for an existing metric does not affect any series data since the internal identifier of the metric remains the same.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| `PUT` | `/api/v1/metrics/{metric}` | `application/json` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `metric` |string|Metric name.|

### Fields

Refer to Fields specified in the [Metrics List](list.md#fields) method.

The `name` field specified in the payload is ignored by the server since the metric name is already specified in path.

## Response

### Fields

None.

## Example

### Request

#### URI

```elm
PUT /api/v1/metrics/my-metric
```

#### Payload

```json
{
  "enabled": true,
  "persistent": true,
  "dataType": "DOUBLE",
  "interpolate": "PREVIOUS",
  "timePrecision": "MILLISECONDS",
  "retentionDays": 0
}
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/metrics/my-metric \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request PUT \
  --data '{"enabled":true,"persistent":true,"dataType":"DOUBLE","interpolate": "PREVIOUS","timePrecision":"MILLISECONDS","retentionDays":0}'
```

### Response

None.

## Additional Examples
