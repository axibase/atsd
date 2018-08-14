# Entity Group: create or replace

## Description

Creates an entity group with specified fields and tags or replaces the fields and tags of an existing entity group.

The following rules apply if the specified group **exists**:

* The current fields, if not specified in the request, are reset to default values. For example, if the `enabled` field is not included, the group status defaults to `true`.
* If the `expression` field is set to `null` or empty string in the request, the expression is deleted.
* The current tags are replaced with tags specified in the request.
* If the request does not contain any tags, the current tags are deleted.
* The request does **not** change the list of members. To manage members, refer to [`add-entities`](./add-entities.md), [`set-entities`](./set-entities.md), and [`delete-entities`](./delete-entities.md) methods.

## Request

| Method | Path | `Content-Type` Header|
|:---|:---|---:|
| `PUT` | `/api/v1/entity-groups/{group}` | `application/json` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `group` |string|Entity group name.|

### Fields

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| `enabled` | boolean | Group status. If disabled, the group is not visible to users. Disabled expression-based groups are empty and are not updated on schedule. |
| `expression` | string| Group membership expression. The expression is applied to entities to automatically add/remove members of this group.|
| `tags` | object| Object containing entity group tags, where field name represents tag name and field value is tag value.<br>`{"tag-1":"value-1","tag-2":"value-2"}`.  |

## Response

### Fields

None.

## Example

### Request

#### URI

```elm
PUT /api/v1/entity-groups/nmon-collectors
```

#### Payload

```json
{
  "enabled": true,
  "tags": {
    "collector": "nmon",
    "evn": "prod"
  }
}
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/entity-groups/nmon-collectors \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request PUT \
  --data '{"tags": {"collector": "nmon"}}'
```

### Response

None.