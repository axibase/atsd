# Metric: rename

## Description

Renames metric: modifies the name, whereas the identifier and the data are retained.

The new name of the metric must be unique, otherwise operation fails.

New operations with the old metric name are stored under a new metric with the old name and a new identifier.

## Request

| **Method** | **Path** | **`Content-Type` Header** |
|:---|:---|---:|
| `POST` | `/api/v1/metrics/{old_name}/rename` | `application/json` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `old_name` | **[Required]** Old metric name. |

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
POST /api/v1/metrics/old_name/rename
```

#### Payload

```json
{
  "name": "new_name"
}
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/metrics/old_name/rename \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --data '{"name":"new_name"}'
```

### Response

None.

## Additional Examples
