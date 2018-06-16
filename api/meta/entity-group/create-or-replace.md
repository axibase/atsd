# Entity Group: Create or Replace

## Description

Creates an entity group with specified fields and tags or replaces the fields and tags of an existing entity group.

The following rules apply if the specified group exists:

* The current tags are replaced with tags specified in the request.
* If the request does not contain any tags, the current tags are deleted.
* The request does **not** change the list of members.
* If the `expression` field is set to `null` in the request, the expression is deleted.
* If the `enabled` field is not included, the entity status is set to `true`.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| PUT | `/api/v1/entity-groups/{group}` | `application/json` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `group` |string|Entity group name.|

### Fields

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| `expression` | string| Group membership expression. The expression is applied to entities to automatically add/remove members of this group.|
| `tags` | object| Object containing entity group tags, where field name represents tag name and field value is tag value.<br>`{"tag-1":string,"tag-2":string}`.  |

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
    "tags": {
        "collector": "nmon"
    }
}
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/entity-groups/nmon-collectors \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request PUT \
  --data '{"tags": {"collector": "nmon"}}
```

### Response

None.

## Additional examples
