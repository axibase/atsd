# List Metrics with Tag table

## Request

### URI

```elm
GET /api/v1/metrics?tags=table&expression=tags.table%20!=%20%27%27
```

### Expression

```javascript
tags.table != ''
```

### Response

```json
[
    {
        "name": "collector-csv-job-exec-time",
        "enabled": true,
        "dataType": "FLOAT",
        "persistent": true,
        "tags": {
            "table": "axibase-collector"
        },
        "retentionDays": 0,
        "invalidAction": "NONE",
        "lastInsertDate": "2016-05-19T10:38:26.731Z",
        "versioned": false
    },
     {
        "name": "collector-http-connection",
        "enabled": true,
        "dataType": "FLOAT",
        "persistent": true,
        "tags": {
            "table": "axibase-collector"
        },
        "retentionDays": 0,
        "invalidAction": "NONE",
        "lastInsertDate": "2016-05-19T10:38:26.731Z",
        "versioned": false
    }
]
```
