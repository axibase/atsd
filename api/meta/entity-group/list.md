# Entity Groups: List

## Description

Retrieve a list of entity groups.

Membership in entity groups with non-empty expression is managed by the server. Adding/removing members of expression-based groups is not supported.

## Request

| **Method** | **Path** | 
|:---|:---|
| GET | `/api/v1/entity-groups` |

### Query Parameters 

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| expression |string|Expression to include entity groups by name or tags. Use the `name` variable for group name. Supported wildcards: `*` and `?`.|
| limit |integer|Maximum number of entity groups to retrieve, ordered by name.|
| tags |string|Comma-separated list of entity group tag names to be displayed in the response.<br>For example, `tags=environment,os-type`<br>Specify `tags=*` to print all entity group tags.|

## Response

### Fields

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| name | string| Entity group name. |
| expression | string | Group membership expression. The expression is applied to entities to automatically add/remove members of this group.|
| tags | object | Entity group tags, as requested with the `tags` parameter. |
| enabled | boolean | Disabled groups are not visible to users. Disabled expression-based groups are empty and are not updated on schedule. |

## Example

### Request

#### URI

```elm
GET https://atsd_host:8443/api/v1/entity-groups?tags=os_level&limit=2&expression=name%20like%20%27nmon*%27
```

#### Payload

None.

#### curl

```elm
curl https://atsd_host:8443/api/v1/entity-groups?tags=os_level&limit=2&expression=name%20like%20%27nmon*%27 \
 --insecure --verbose --user {username}:{password} \
 --request GET
 ```
 
### Response

```json
[{
    "name": "nmon-aix",
    "tags": {
        "os_level": "aix 6.3"
    }, 
    "enabled": true
},
{
    "name": "nmon-linux",
    "enabled": true
}]
```

## Additional examples
