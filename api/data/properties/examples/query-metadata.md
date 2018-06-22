# Properties Query: Add Metadata

## Description

The `addMeta` parameter instructs the server to include entity metadata, namely fields and tags, in the response object.

This provides a convenient method for retrieving both property records and descriptive information about the entities, without executing a separate request to Meta API.

The list of returned fields corresponds to the entity [get](../../../../api/meta/entity/get.md) methods

Meta API user role is not required to access this metadata.

## Request

### URI

```elm
POST /api/v1/properties/query
```

### Payload

```json
[
  {
    "type": "disk",
    "entity": "nurswgvml007",
    "startDate": "now - 1 * DAY",
    "endDate": "now",
    "limit": 1,
    "addMeta": true
  }
]
```

## Response

```json
[
  {
    "type": "disk",
    "entity": "nurswgvml007",
    "meta": {
      "entity": {"name":"nurswgvml007","enabled":true,"timeZone":"PST","tags":{"alias":"007","app":"ATSD","environment":"prod","ip":"192.0.2.6","loc_area":"dc1","loc_code":"nur,nur","os":"Linux"},"interpolate":"LINEAR","label":"NURswgvml007"}
    },
    "key": {
      "id": "dm-0"
    },
    "tags": {
      "disk_%busy": "0.1",
      "disk_block_size": "4.0",
      "disk_read_kb/s": "0.0",
      "disk_transfers_per_second": "11.0",
      "disk_write_kb/s": "43.9"
    },
    "date": "2016-11-28T09:13:03.000Z"
  }
]
```
