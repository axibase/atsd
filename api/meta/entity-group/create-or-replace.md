# Entity Group: Create or Replace

## Description

Create an entity group with specified fields and tags or replace the fields and tags of an existing entity group.

The following rules apply if the specified group exists:

* The groups current tags will be replaced with tags specified in the request.
* If the request doesn't contain any tags, the current tags will be deleted.
* The request does **not** change the list of members.
* If the `expression` field is set to 'null' in the request, the expression will be deleted.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| PUT | `/api/v1/entity-groups/{group}` | `application/json` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| group |string|Entity group name.|

### Fields

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| expression | string| Group membership expression. The expression is applied to entities to automatically add/remove members of this group.|
| tags | object| Object containing entity group tags, where field name represents tag name and field value is tag value.<br>`{"tag-1":string,"tag-2":string}`.  |

## Response

### Fields

None.

## Example

### Request

#### URI

```elm
PUT https://atsd_host:8443/api/v1/entity-groups/nmon-collectors
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

```elm
curl https://atsd_host:8443/api/v1/entity-groups/nmon-collectors \
  --insecure --verbose --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request PUT \
  --data '{"tags": {"collector": "nmon"}}
 ```

### Response

None.

## Additional examples
