# Entity: Update

## Description

Updates fields and tags of the specified entity.

Unlike the [replace method](create-or-replace.md), fields and tags that are **not** specified in the request are left unchanged.

Similarly, fields that are set to `null` are ignored and are left unchanged.

## Request

| Method | Path | `Content-Type` Header|
|:---|:---|---:|
| `PATCH` | `/api/v1/entities/{entity}` | `application/json` |

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
PATCH /api/v1/entities/{entity}
```

#### Payload

```json
{
    "tags": {
        "alias": "cadvisor"
    }
}
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/entities/nurswgvml006 \
  --insecure --include --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request PUT \
  --data '{"tags": {"alias": "vmware_host"}}'
```

### Response

None.

## Additional examples
