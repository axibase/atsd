# Entity: get

## Description

Retrieves fields and tags describing the specified entity.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/entities/{entity}` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| `entity` | **[Required]** Entity name. |

## Response

### Fields

Refer to Response Fields in [Entities: List](list.md#fields)

## Example

### Request

#### URI

```elm
GET /api/v1/entities/nurswgvml006
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/entities/nurswgvml006 \
 --insecure --include --user {username}:{password}
```

### Response

```json
{
    "name": "nurswgvml006",
    "enabled": true,
    "lastInsertDate": "2015-09-04T15:39:40.000Z",
    "tags": {
        "app": "Hadoop/HBase",
        "ip": "192.0.2.5",
        "os": "Linux"
    }
}
```

## Additional Examples
