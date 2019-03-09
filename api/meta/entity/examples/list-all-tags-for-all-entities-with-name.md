# List Entities starting with `nurswgvml00`

## Request

### URI

```elm
GET /api/v1/entities?expression=name%20LIKE%20%27nurswgvml00*%27&tags=*
```

### Expression

```elm
expression=name LIKE 'nurswgvml00*'
```

## Response

```json
[
    {
        "name": "nurswgvml003",
        "enabled": true,
        "lastInsertDate": "2018-09-15T14:31:34.000Z",
        "tags": {
            "app": "Shared NFS/CIFS disk, ntp server",
            "ip": "192.0.2.2",
            "os": "Linux"
        }
    },
    {
        "name": "nurswgvml006",
        "enabled": true,
        "lastInsertDate": "2018-09-15T14:31:37.000Z",
        "tags": {
            "app": "Hadoop/HBase",
            "ip": "192.0.2.5",
            "os": "Linux"
        }
    },
    {
        "name": "nurswgvml007",
        "enabled": true,
        "lastInsertDate": "2018-09-15T14:31:32.000Z",
        "tags": {
            "alias": "007",
            "app": "ATSD",
            "ip": "192.0.2.6",
            "loc_area": "dc2",
            "loc_code": "nur,nur",
            "os": "Linux"
        }
    }
]
```
