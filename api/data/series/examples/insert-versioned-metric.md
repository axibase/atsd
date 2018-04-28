# Insert Versioned Metric
## Request
### URI
```elm
POST https://atsd_hostname:8443/api/v1/series/insert
```
### Payload
```json
[
    {
        "entity": "e-vers",
        "metric": "mpstat.cpu_busy",
        "data": [
            {
                "t": 1447834771665,
                "v": 33,
                "version": {
                    "status": "provisional",
                    "source": "t540p"
                }
            }
        ]
    }
]
```

|Name | Description|
|---|---|
|status | Status describing value change event.|
|source | Source that generated value change event.|

