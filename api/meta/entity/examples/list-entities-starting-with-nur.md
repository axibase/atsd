# List Entities Starting with `nur`

## Request

### URI

```elm
GET https://atsd_server:8443/api/v1/entities?tags=*&expression=name%20like%20%27nur*%27
```

### Expression 

```javascript
name like 'nur*'
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
            "ip": "10.102.0.2",
            "os": "Linux"
        }
    },
    {
        "name": "nurswgvml006",
        "enabled": true,
        "lastInsertTime": 1442331411000,
        "tags": {
            "app": "Hadoop/HBASE",
            "ip": "10.102.0.5",
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
            "ip": "10.102.0.6",
            "loc_area": "dc2",
            "loc_code": "nur,nur",
            "os": "Linux"
        }
    }
]
```
