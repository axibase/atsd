# Entity Group: Set Entities

## Description

Set members of the entity group from the specified entity list.

All existing members that are not included in the request will be removed from members.

If the array in the request is empty, all entities are **removed** from the group and are replaced with an empty list.

> Membership in expression-based groups is managed by the server. Adding and removing members of such groups is not supported.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| POST | `/api/v1/entity-groups/{group}/entities/set` | `application/json` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| group |string|Entity group name.|

### Query Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| createEntities | boolean | Automatically create new entities from the submitted list if such entities don't exist. Default: true. |

### Payload

An array of entity names to be set as members of this group.

```json
[
  "entity-1",
  "entity-2"
]
```

## Response

### Fields

None.

## Example

### Request

#### URI

```elm
POST https://atsd_host:8443/api/v1/entity-groups/nmon-aix/entities/set?createEntities=true
```

#### Payload

```json
[
  "nurswgvml010",
  "nurswgvml011"
]
```

#### curl

```elm
curl https://atsd_host:8443/api/v1/entity-groups/nmon-aix/entities/set?createEntities=true \
  --insecure --verbose --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request POST \
  --data '["nurswgvml010", "nurswgvml011"]'
  ```
### Response

None.

## Additional examples
