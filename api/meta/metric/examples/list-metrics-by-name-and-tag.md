# List Metrics by Name and Tag

List metrics starting with `nmon` and with tag `table` starting with `CPU`

## Request

### URI

```elm
GET /api/v1/metrics?tags=table&limit=2&expression=name%20LIKE%20%27nmon*%27%20and%20tags.table%20LIKE%20%27*CPU*%27
```

### Expression

```javascript
name LIKE 'nmon*' AND tags.table LIKE '*CPU*'
```

## Response

```json
[
   {
        "name": "nmon.cpu.busy%",
        "enabled": true,
        "dataType": "FLOAT",
        "persistent": true,
        "tags": {
            "table": "CPU Detail"
        },
        "retentionDays": 0,
        "invalidAction": "NONE",
        "lastInsertDate": "2016-05-19T10:38:26.731Z",
        "versioned": false
    },
    {
        "name": "nmon.cpu.idle%",
        "enabled": true,
        "dataType": "FLOAT",
        "persistent": true,
        "tags": {
            "table": "CPU Detail"
        },
        "retentionDays": 0,
        "invalidAction": "NONE",
        "lastInsertDate": "2016-05-19T10:38:26.731Z",
        "versioned": false
    }
]
```
