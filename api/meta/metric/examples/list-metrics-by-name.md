# List Metrics by Name 

List all metrics whose name includes 'disk'

## Request

### URI

```elm
GET https://atsd_server:8443/api/v1/metrics?expression=name%20like%20%27*disk*%27
```

### Expression

```javascript
expression=name like '*disk*'
```

## Response

```json
[
    {
        "name": "aws_ec2.diskreadbytes.average",
        "enabled": true,
        "dataType": "FLOAT",
        "persistent": true,
        "tags": {},
        "timePrecision": "MILLISECONDS",
        "retentionDays": 0,
        "invalidAction": "NONE",
        "lastInsertDate": "2016-05-18T00:35:12.000Z",
        "versioned": false
    },
    {
        "name": "aws_ec2.diskreadbytes.maximum",
        "enabled": true,
        "dataType": "FLOAT",
        "persistent": true,
        "tags": {},
        "timePrecision": "MILLISECONDS",
        "retentionDays": 0,
        "invalidAction": "NONE",
        "lastInsertDate": "2016-05-18T00:35:12.000Z",
        "versioned": false
    },
    {
        "name": "aws_ec2.diskreadbytes.minimum",
        "enabled": true,
        "dataType": "FLOAT",
        "persistent": true,
        "tags": {},
        "timePrecision": "MILLISECONDS",
        "retentionDays": 0,
        "invalidAction": "NONE",
        "lastInsertDate": "2016-05-18T00:35:12.000Z",
        "versioned": false
    }
]
```
