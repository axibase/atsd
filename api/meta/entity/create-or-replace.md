# Entity: Create or Replace

## Description

Create an entity with specified fields and tags or replace the fields and tags of an existing entity.

In case of an existing entity, all the current entity tags will be replaced with entity tags specified in the request.

If the replace request for an existing entity doesn't contain any tags, the current tags will be deleted.

Fields that are set to `null` are ignored by the server and are set to their default value.

The replace request for an existing entity doesn't affect any series, properties, or metrics since the internal identifier of the entity remains the same.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| PUT | `/api/v1/entities/{entity}` | `application/json` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `entity` |string|Entity name.|

### Fields

Refer to Fields specified in the [Entity List](list.md#fields) method.

The `name` field specified in the payload is ignored by the server since it's specified in the path.

## Response

### Fields

None.

## Example

### Request

#### URI

```elm
PUT https://atsd_hostname:8443/api/v1/entities/nurswgvml006
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
