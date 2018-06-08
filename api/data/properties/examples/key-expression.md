# Key/Tag Expression

Key/tag expression: Filter out all disks except those starting with `sd*`. Disks `dm1`, `dm2` are excluded.

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
        "entity": "nurswgvml007" ,
        "keyTagExpression": "id like 'sd*'"
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
           "id": "sda"
       },
       "tags": {
           "disk_%busy": "1.9",
           "disk_block_size": "6.1",
           "disk_read_kb/s": "0.0",
           "disk_transfers_per_second": "43.1",
           "disk_write_kb/s": "262.8"
       },
       "date": "2015-02-05T16:55:02Z"
   },
   {
       "type": "disk",
       "entity": "nurswgvml007",
       "key": {
           "id": "sda1"
       },
       "tags": {
           "disk_%busy": "0.0",
           "disk_block_size": "0.0",
           "disk_read_kb/s": "0.0",
           "disk_transfers_per_second": "0.0",
           "disk_write_kb/s": "0.0"
       },
       "date": "2015-02-05T16:55:02Z"
   },
   {
       "type": "disk",
       "entity": "nurswgvml007",
       "key": {
           "id": "sda2"
       },
       "tags": {
           "disk_%busy": "1.9",
           "disk_block_size": "6.1",
           "disk_read_kb/s": "0.0",
           "disk_transfers_per_second": "43.1",
           "disk_write_kb/s": "262.8"
       },
       "date": "2015-02-05T16:55:02Z"
   }
]
```
