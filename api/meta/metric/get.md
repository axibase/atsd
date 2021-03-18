# Metric: get

## Description

Retrieves properties and tags for the specified metric.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/metrics/{metric}` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `metric` | **[Required]** Metric name. |
| `addInsertTime` | Controls whether [`lastInsertDate`](list.md#fields) field is included in the response. The default value is `true` |

## Response

### Fields

Refer to Response Fields in [Metrics: List](list.md#fields)

## Example

### Request

#### URI

```elm
GET /api/v1/metrics/cpu_busy
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/metrics/cpu_busy \
  -k --user {username}:{password}
```

### Response

```json
{
  "name": "cpu_busy",
  "enabled": true,
  "dataType": "FLOAT",
  "interpolate":"LINEAR",
  "timeZone":"America/New_York",
  "persistent": true,
  "tags": {},
  "retentionDays": 0,
  "invalidAction": "NONE",
  "lastInsertDate": "2016-10-05T12:10:26.000Z",
  "versioned": false
}
```

## Additional Examples
