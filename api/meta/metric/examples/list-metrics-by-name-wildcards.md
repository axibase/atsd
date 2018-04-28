# List Metrics by Name using Wildcards

The `expression` parameter supports the following wildcards:

* `*` - matches any characters
* `?` - matches any one character

The wildcards are evaluated when the operator is 'LIKE'.

## Expression Examples

* List metrics whose names **start with** the specified text 'disk'

```javascript
name LIKE 'disk*'
```

* List metrics whose names **end with** the specified text

```javascript
name LIKE '*percent'
```

* List metrics whose names **contain** the specified text

```javascript
name LIKE '*used*'
```

* List metrics whose names **match** any single character in a specific position

```javascript
// matches disk_used
name LIKE 'disk?used'
```

* List metrics whose names **start with** the specified text and **match** any single character in a specific position

```javascript
// matches disk_used, disk_used_percent
name LIKE 'disk?used*'
```

## Request

### URI

```elm
GET https://atsd_hostname:8443/api/v1/metrics?expression=name%20LIKE%20%27disk%3Fused*%27
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
	"timePrecision": "MILLISECONDS",
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
	"timePrecision": "MILLISECONDS",
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
