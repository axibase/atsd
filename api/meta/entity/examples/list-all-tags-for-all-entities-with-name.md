# List Entities starting with `nurswgvml00`

## Request

### URI

```elm
https://atsd_hostname:8443/api/v1/entities?timeFormat=iso&expression=name%20LIKE%20%27nurswgvml00*%27&tags=*
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
        "lastInsertDate": "2015-09-15T14:31:34.000Z",
        "tags": {
            "app": "Shared NFS/CIFS disk, ntp server",
            "ip": "10.102.0.2",
            "os": "Linux"
        }
    },
    {
        "name": "nurswgvml006",
        "enabled": true,
        "lastInsertDate": "2015-09-15T14:31:37.000Z",
        "tags": {
            "app": "Hadoop/HBASE",
            "ip": "10.102.0.5",
            "os": "Linux"
        }
    },
    {
        "name": "nurswgvml007",
        "enabled": true,
        "lastInsertDate": "2015-09-15T14:31:32.000Z",
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
