# Metric: rename

## Description

Renames metric.

## Request

| **Method** | **Path** | **`Content-Type` Header** |
|:---|:---|---:|
| `POST` | `/api/v1/metrics/{metric}/rename` | `application/json` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `metric` | **[Required]** Old metric name. |

### Fields

| **Name** | **Type** | **Description** |
|:---|:---|---:|
| `name` | string | **[Required]** New metric name. Must be unique. |

## Response

### Fields

None.

## Example

### Request

#### URI

```elm
POST /api/v1/metrics/cpu_busy/rename
```

#### Payload

```json
{
  "name": "cpu_free"
}
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/metrics/cpu_busy/rename \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --data '{"name":"cpu_free"}'
```

### Response

None.

## Additional Examples
