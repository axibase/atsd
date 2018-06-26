# Entity: Create or Replace

## Description

Creates an entity with specified fields and tags or replaces the fields and tags of an existing entity.

If the entity exists, its current entity tags are replaced with tags specified in the request. If the request does not contain any tags, the current tags are deleted.

Fields that are set to `null` are ignored by the server and are set to their default value.

The replace request for an existing entity does not affect any series, properties, or metrics since the internal identifier of the entity remains the same.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| `PUT` | `/api/v1/entities/{entity}` | `application/json` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `entity` |string|Entity name.|

### Fields

Refer to Fields specified in the [Entity List](list.md#fields) method.

The `name` field contained in the payload is ignored by the server since the entity name is already specified in the path.

## Response

### Fields

None.

## Example

### Request

#### URI

```elm
PUT /api/v1/entities/nurswgvml006
```

#### Payload

```json
{
  "enabled": true,
  "tags": {
    "location": "NUR-2",
    "env": "production"
  }
}
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/entities/nurswgvml006 \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request PUT \
  --data '{"enabled":true,"tags":{"env":"production","location":"NUR-2"}}'
```

### Response

None.

## Additional Examples
