# Alerts: Update

## Description

Change acknowledgement status of the specified open alerts.

This method can be used to acknowledge and un-acknowledge alerts with the `"acknowledged": true|false` property in the request.

If the `acknowledged` property is not specified, the alert will be un-acknowledged.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| POST | `/api/v1/alerts/update` | `application/json` |

### Parameters

None.

### Fields

An array of objects containing an 'id' field to identify the alert and its new `acknowledge` status.

|**Field**|**Type**|**Required**|**Description**|
|:---|:---|:---|:---|
|id|number|yes|Alert id.|
|acknowledged|boolean|no|Acknowledgement status. Default `false`.|

## Response

### Fields

None.

### Errors

None.

## Example

### Request

#### URI

```elm
POST /api/v1/alerts/update
```

#### Payload

```json
[
  {"id": 10, "acknowledged": true},
  {"id": 14, "acknowledged": true}
]
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/alerts/update \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --data '[{"id":10, "acknowledged": true},{"id":14, "acknowledged": true}]'
```

## Additional Examples

* [Multiple Id Update](examples/update/alerts-update-multiple-id.md)
