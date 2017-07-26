# Properties: Insert

## Description

Insert an array of properties.

* Entity name, property type, key names, and tag names cannot contain non-printable characters. They are case-insensitive and are converted to lower case when stored.
* Key values and tag values are **case-sensitive** and are stored as submitted.
* The number of keys and tags must not exceed 1024.

Date limits:

* Minimum time that can be stored in the database is **1970-01-01T00:00:00.000Z**, or 0 milliseconds from Epoch time.
* Maximum date that can be stored by the database is **2106-02-07T06:59:59.999Z**, or 4294969199999 milliseconds from Epoch time.
* If the `date` field is not specified, the record is inserted with the current server time.

## Request

| **Method** | **Path** | **Content-Type Header**|
|:---|:---|---:|
| POST | `/api/v1/properties/insert` | `application/json` |

### Parameters

None.

### Fields

| **Field**  |**Type**  | **Description**  |
|:---|:---|:---|
| type | string | [**Required**] Property type name. <br>Use reserved `$entity_tags` type to insert entity tags.|
| entity | string | [**Required**] Entity name. |
| key | object | Object containing `name=value` fields that uniquely identify the property record. <br>Example: `{"file_system": "/","mount_point":"sda1"}`|
| tags | object | Object containing `name=value` fields that are not part of the key and contain descriptive information about the property record. <br>Example: `{"fs_type": "ext4"}`. |
| date | string | ISO 8601 date, for example `2016-05-25T00:15:00Z`. <br>Set to current server time if omitted. |

## Response

### Fields

None.

### Errors

None.

## Example

### Request

#### URI

```elm
POST https://atsd_host:8443/api/v1/properties/insert
```

#### Payload

```json
[{
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
}]
```

#### curl

```elm
curl https://atsd_host:8443/api/v1/properties/insert  \
  --insecure  --verbose --user {username}:{password} \
  --header "Content-Type: application/json" \
  --request  POST \
  --data '[{"type":"disk","entity":"nurswgvml007","key":{"file_system":"/","mount_point":"sda1"},"tags":{"fs_type":"ext4"},"date":"2016-05-25T04:15:00Z"}]'
```

## Response
