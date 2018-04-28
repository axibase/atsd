# Entity Group: Delete Entities

## Description

Remove the specified members from the entity group.

To delete all entities from the group, submit an empty array `[]` with the [set entities](set-entities.md) method.

> Membership in expression-based groups is managed by the server. Adding and removing members of such groups is not supported.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| POST | `/api/v1/entity-groups/{group}/entities/delete` | `application/json` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| group |string|Entity group name.|

### Payload

An array of entity names to be removed as members.

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
POST https://atsd_hostname:8443/api/v1/entity-groups/nmon-aix/entities/delete
```

#### Payload

```json
[
  "nurswgvml010",
  "nurswgvml011"
]
```

#### curl

```sh
curl https://atsd_hostname:8443/api/v1/entity-groups/nmon-aix/entities/delete \
  --insecure --verbose --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request POST \
  --data '["nurswgvml010", "nurswgvml011"]'
```

### Response

None.

## Additional examples
