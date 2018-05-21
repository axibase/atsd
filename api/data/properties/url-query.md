# Properties: URL Query

## Description

Retrieve property records for the specified entity and type.

## Request

| **Method** | **Path** |
|:---|:---|
| GET | `/api/v1/properties/{entity}/types/{type}` |

### Parameters

| **Name** | **In** | **Description** |
|:---|:---|:---|
| `entity` | path | **[Required]** Entity name. |
| `type` | path | **[Required]** Property type. |

### Fields

None.

## Response

An array of property objects.

### Fields

| **Name**  | **Type** | **Description**  |
|:---|:---|:---|
| `type` | string | Property type name. |
| `entity` |string | Entity name. |
| `key` | object | Object containing `name=value` fields that uniquely identify the property record. <br>Example: `{"file_system": "/","mount_point":"sda1"}`|
| `tags` | object | Object containing `name=value` fields that are not part of the key and contain descriptive information about the property record. <br>Example: `{"fs_type": "ext4"}`. |
| `date` | string | ISO 8601 date when the property record was last modified. |

## Example

### Request

#### URI

```elm
GET https://atsd_hostname:8443/api/v1/properties/nurswgvml007/types/disk
```

#### curl

```bash
curl https://atsd_hostname:8443/api/v1/properties/nurswgvml007/types/disk \
  --insecure --include --user {username}:{password} \
  --request GET
```

### Response

```json
[
   {
       "type": "disk",
       "entity": "nurswgvml007",
       "key": {
           "file_system": "/",
           "mount_point": "sda1"
       },
       "tags": {
           "fs_type": "ext4"
       },
       "date": "2016-05-25T04:15:00Z"
   }
]
```
