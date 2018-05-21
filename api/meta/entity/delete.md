# Entity: Delete

## Description

Delete the specified entity and delete it as member from any entity groups that it belongs to.

Data collected by the entity will be removed asynchronously in the background.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| DELETE | `/api/v1/entities/{entity}` | `application/json` |

### Path Parameters

|**Name**|**Type**|**Description**|
|:---|:---|:---|
| `entity` |string|Entity name.|

## Response

### Fields

None.

## Example

### Request

#### URI

```elm
DELETE https://atsd_hostname:8443/api/v1/entities/nurswgvml001
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/entities/nurswgvml001 \
  --insecure --include --user {username}:{password} \
  --request DELETE
```

### Response

None.

## Additional Examples