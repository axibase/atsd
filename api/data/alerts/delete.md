# Alerts: Delete

## Description

Delete specified alerts by id from the memory store.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| POST | `/api/v1/alerts/delete` | `application/json` |

### Parameters

None.

### Fields

An array of objects containing an 'id' field to identify the alerts to be deleted.

|**Field**|**Description**|
|:---|:---|
|id|Alert id|

## Response

### Fields

None.

### Errors

None.

## Example

### Request

#### URI

```elm
POST /api/v1/alerts/delete
```

#### Payload

```json
[
  {"id": 10},
  {"id": 14}
]
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/alerts/delete \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --data '[{"id":10},{"id":14}]'
```

### Response

None.

## Additional Examples

* [Multiple Id Delete](examples/delete/alerts-delete-multiple-id.md)