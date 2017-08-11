# Entity Group: Get

## Description

Retrieve information about the specified entity group including its name and user-defined tags.

## Request

| **Method** | **Path** |
|:---|:---|
| GET | `/api/v1/entity-groups/{group}` |

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
GET https://atsd_host:8443/api/v1/entity-groups/nmon-aix
```

#### Payload

None.

#### curl

```elm
curl https://atsd_host:8443/api/v1/entity-groups/nmon-aix \
  --insecure --verbose --user {username}:{password} \
  --request GET
  ```

### Response

```json
{
    "name": "nmon-aix",
    "tags": {
        "os_level": "aix 6.3"
    }
}
```
