# Entity Groups: list

## Description

Retrieves a list of entity groups.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/entity-groups` |

### Query Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `expression` |string|Expression to include entity groups by name or tags. Use the `name` variable for group name. Supported wildcards: `*` and `?`.|
| `limit` |integer|Maximum number of entity groups to retrieve, ordered by name.|
| `tags` |string|Comma-separated list of entity group tag names to be displayed in the response.<br>For example, `tags=environment,os-type`<br>Specify `tags=*` to print all entity group tags.|

## Response

### Fields

| **Name** | **Type** | **Description** |
|:---|:---|:---|
| `name` | string| Entity group name. |
| `enabled` | boolean | Group status. If disabled, the group is not visible to users. Disabled expression-based groups are empty and are not updated on schedule. |
| `expression` | string | Group membership expression. The expression is applied to entities to automatically add/remove members of this group.|
| `tags` | object | Entity group tags, as requested with the `tags` parameter. |

## Example

### Request

#### URI

```elm
GET /api/v1/entity-groups?tags=os_level&limit=2&expression=name%20LIKE%20%27nmon*%27
```

#### Payload

None.

#### curl

```bash
curl "https://atsd_hostname:8443/api/v1/entity-groups?tags=os_level&limit=2&expression=name%20LIKE%20%27nmon*%27" \
 --insecure --include --user {username}:{password}
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