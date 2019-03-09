# Properties for Type disk

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
  }
]
```

## Response

```json
[
   {
       "type": "disk",
       "entity": "nurswgvml007",
       "key": {
           "id": "dm-0"
       },
       "tags": {
           "disk_%busy": "1.3",
           "disk_block_size": "4.0",
           "disk_read_kb/s": "0.0",
           "disk_transfers_per_second": "59.1",
           "disk_write_kb/s": "236.3"
       },
       "date": "2018-02-05T16:55:02Z"
   },
   {
       "type": "disk",
       "entity": "nurswgvml007",
       "key": {
           "id": "dm-1"
       },
       "tags": {
           "disk_%busy": "0.0",
           "disk_block_size": "0.0",
           "disk_read_kb/s": "0.0",
           "disk_transfers_per_second": "0.0",
           "disk_write_kb/s": "0.0"
       },
       "date": "2018-02-05T16:55:02Z"
   }
]
```
