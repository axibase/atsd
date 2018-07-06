# Entity Group: get

## Description

Retrieves information about the specified entity group including its name and user-defined tags.

## Request

| **Method** | **Path** |
|:---|:---|
| `GET` | `/api/v1/entity-groups/{group}` |

### Path Parameters

| **Name** | **Description** |
|:---|:---|
| group | **[Required]** Entity group name. |

## Response

### Fields

Refer to Response Fields in [Entity Groups: List](list.md#fields)

## Example

### Request

#### URI

```elm
GET /api/v1/entity-groups/nmon-aix
```

#### Payload

None.

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/entity-groups/nmon-aix \
  --insecure --include --user {username}:{password}
```

### Response

```json
{
    "name": "nmon-aix",
    "tags": {
        "os_level": "aix 6.3"
    },
    "enabled": true
}
```
