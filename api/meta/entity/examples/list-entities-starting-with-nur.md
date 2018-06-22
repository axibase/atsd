# List Entities Starting with `nur`

## Request

### URI

```elm
GET /api/v1/entities?tags=*&expression=name%20LIKE%20%27nur*%27
```

### Expression

```javascript
name LIKE 'nur*'
```

## Response

```json
[
    {
        "name": "nurswgvml003",
        "enabled": true,
        "lastInsertTime": 1442331411000,
        "tags": {
            "app": "Shared NFS/CIFS disk, ntp server",
            "app-test": "1",
            "ip": "192.0.2.2",
            "os": "Linux"
        }
    },
    {
        "name": "nurswgvml006",
        "enabled": true,
        "lastInsertTime": 1442331411000,
        "tags": {
            "app": "Hadoop/HBase",
            "ip": "192.0.2.5",
            "os": "Linux"
        }
    },
    {
        "name": "nurswgvml007",
        "enabled": true,
        "lastInsertTime": 1442331411000,
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
