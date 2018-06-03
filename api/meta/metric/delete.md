# Metric: Delete

## Description

Deletes the specified metric.

Data collected for the metric is removed asynchronously in the background.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| DELETE | `/api/v1/metrics/{metric}` | `application/json` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `metric` |string|Metric name.|

## Response

### Fields

None.

## Example

### Request

#### URI

```elm
DELETE /api/v1/metrics/my-metric
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/metrics/my-metric \
  --insecure --include --user {username}:{password} \
  --request DELETE
```

### Response

None.