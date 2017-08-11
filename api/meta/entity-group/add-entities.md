# Entity Group: Add Entities

## Description

Add entities as members to the specified entity group.

> Membership in expression-based groups is managed by the server. Adding and removing members of such groups is not supported.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| POST | `/api/v1/entity-groups/{group}/entities/add` | `application/json` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| group |string|Entity group name.|

### Query Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| createEntities | boolean | Automatically create new entities from the submitted list if such entities don't exist. Default: true. |

### Payload

An array of entity names.

```json
[
  "entity-1",
  "entity-2"
]
```

## Response

### Fields

None.

### Response

If createEntities is false, and the request contains a non-existing entity, the following error will be raised:

```json
{"error":"com.axibase.tsd.service.DictionaryNotFoundException: ENTITY not found for name: 'e-111'"}
```

## Example

### Request

#### URI

```elm
POST https://atsd_host:8443/api/v1/entity-groups/nmon-aix/entities/add
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
curl https://atsd_host:8443/api/v1/entity-groups/nmon-aix/entities/add \
  --insecure --verbose --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request POST \
  --data '["nurswgvml010", "nurswgvml011"]'
  ```

### Response

None.

## Additional examples
