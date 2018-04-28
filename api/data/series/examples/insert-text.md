# Series Insert Text Value

## Description

Insert text value without numeric value. The numeric value will initialized as `NaN` (not a number). 

## Request

### URI

```elm
POST https://atsd_hostname:8443/api/v1/series/insert
```

### Payload
```json
[
    {
        "entity": "sensor-01",
        "metric": "status",
        "data": [
            {
                "d": "2016-10-14T08:15:00Z",
                "v": null,
                "x": "Shutdown, RFC 3453"
            }
        ]
    }
]
```
