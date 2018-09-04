# List Metrics by Name using Wildcards

The `expression` parameter supports the following wildcards:

* `*`: matches any characters
* `?`: matches any one character

The wildcards are evaluated when the operator is `LIKE`.

## Expression Examples

* List metrics with names that **begin with** `disk`

```javascript
name LIKE 'disk*'
```

* List metrics with names that **end with** `percent`

```javascript
name LIKE '*percent'
```

* List metrics with names that **contain** `used`

```javascript
name LIKE '*used*'
```

* List metrics with names that **match** any single character in a specific position

```javascript
// matches disk_used
name LIKE 'disk?used'
```

* List metrics with names that **begin with** the specified text and **match** any single character in a specific position

```javascript
// matches disk_used, disk_used_percent
name LIKE 'disk?used*'
```

## Request

### URI

```elm
GET /api/v1/metrics?expression=name%20LIKE%20%27disk%3Fused*%27
```

### Expression

```javascript
name LIKE 'disk?used*'
```

## Response

```json
[{
    "name": "disk_used",
    "enabled": true,
    "dataType": "FLOAT",
    "persistent": true,
    "retentionDays": 0,
    "invalidAction": "NONE",
    "lastInsertDate": "2017-07-17T12:24:26.000Z",
    "filter": "!likeAny(tags.mount_point, collection('ignore-collector-mount-points'))",
    "versioned": false,
    "interpolate": "LINEAR"
}, {
    "name": "disk_used_percent",
    "enabled": true,
    "dataType": "FLOAT",
    "label": "Disk Used, %",
    "persistent": true,
    "retentionDays": 0,
    "minValue": 0.0,
    "maxValue": 100.0,
    "invalidAction": "TRANSFORM",
    "lastInsertDate": "2017-07-17T12:24:26.000Z",
    "filter": "!likeAny(tags.mount_point, collection('ignore-collector-mount-points'))",
    "versioned": false,
    "interpolate": "LINEAR"
}]
```
