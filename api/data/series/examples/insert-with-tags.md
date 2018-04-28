#  Series Insert With Tags
## Request
### URI

```elm
POST https://atsd_hostname:8443/api/v1/series/insert
```
### Payload

```json
[{
    "entity": "nurswgvml007",
    "metric": "df.disk_used_percent",
    "tags": {"file_system": "/sda", "mount_point": "/"},
    "data": [
        { "t": 1462427358127, "v": 22.0 }
    ]
}]
```
