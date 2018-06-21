# Replacement Table: Delete

## Description

Deletes the specified replacement table.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| DELETE | `/api/v1/replacement-tables/{name}` | `application/json` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `name` |string|Replacement table name.|

## Response

### Fields

None.

## Example

### Request

#### URI

```elm
DELETE /api/v1/replacement-tables/status_codes
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/replacement-tables/status_codes \
  --insecure --include --user {username}:{password} \
  --request DELETE
```

### Response

None.