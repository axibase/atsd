# Entity: Get

## Description

Retrieve information about the specified entity including its tags.

## Request

| **Method** | **Path** |
|:---|:---|
| GET | `/api/v1/entities/{entity}` |

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
GET https://atsd_hostname:8443/api/v1/entities/nurswgvml006
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/entities/nurswgvml006 \
 --insecure --include --user {username}:{password} \
 --request GET
```

### Response

```json
{
    "name": "nurswgvml006",
    "enabled": true,
    "lastInsertDate": "2015-09-04T15:39:40.000Z",
    "tags": {
        "app": "Hadoop/HBASE",
        "ip": "10.102.0.5",
        "os": "Linux"
    }
}
```

## Additional Examples
