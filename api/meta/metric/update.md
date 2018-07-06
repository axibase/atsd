# Metric: update

## Description

Updates fields and tags of the specified metric.

Unlike the [replace method](create-or-replace.md), fields and tags that are **not** specified in the request are left unchanged.

Similarly, fields that are set to `null` are ignored and are left unchanged.

## Request

| Method | Path | `Content-Type` Header|
|:---|:---|---:|
| `PATCH` | `/api/v1/metrics/{metric}` | `application/json` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `metric` |string|Metric name.|

### Fields

Refer to Fields specified in the [Metrics List](list.md#fields) method.

The `name` field specified in the payload is ignored by the server since the metric name is already specified in the path.

## Response

### Fields

None.

## Example

### Request

#### URI

```elm
PATCH /api/v1/metrics/cpu_busy
```

#### Payload

```json
{
  "label": "CPU Busy Average",
  "tags": {
    "table": "CollectD CPU Total"
  }
}
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/metrics/cpu_busy \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request PATCH \
  --data '{"label":"CPU Busy Average","tags":{"table":"CollectD CPU Total"}}'
```

### Response

None.

## Additional Examples
