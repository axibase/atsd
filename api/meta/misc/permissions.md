# Version

## Description

Returns JSON with access [permissions](../../../administration/user-authorization.md) for the current user.

## Request

| **Method** | **Path** |
|:---|:---|
| GET | `/api/v1/permissions` |

## Response

### Fields

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| `roles`  | array | List of user roles. |
| `user-groups` | array | List of groups of which user is a member.|
| `entity-groups` | map | Entity Groups `name=role` pairs to which user is authorized, for example `"aws-ec2": "WRITE"`. |
| `all-entities-read` | boolean | User is authorized to read data for any entity.|
| `all-entities-write`  | boolean | User is authorized to write data for any entity.|
| `all-portals-permission`  | boolean | User is authorized to view all portals enabled in the system. |
| `portals`  | array | List of portals the user is authorized to view.|

### Errors

## Example

### Request

#### URI

```elm
GET https://atsd_hostname:8443/api/v1/permissions
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/permissions \
  --insecure --include --user {username}:{password} \
  --request GET
```

### Response

```json
{
  "roles": [
    "ROLE_API_DATA_WRITE",
    "ROLE_API_DATA_READ",
    "ROLE_API_META_WRITE",
    "ROLE_API_META_READ"
  ],
  "user-groups": [
    "Editors"
  ],
  "entity-groups": {
    "java-virtual-machine": "READ"
  },
  "all-entities-read": false,
  "all-entities-write": true,
  "all-portals-permission": false,
  "portals": [
    "ATSD"
  ]
}
```
