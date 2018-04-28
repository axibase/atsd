# Insert Forecast

## Request
### URI

```elm
POST https://atsd_hostname:8443/api/v1/series/insert
```
### Payload

```json
[
    {
        "entity": "nurswgvml007",
        "metric": "mpstat.cpu_busy",
        "type": "FORECAST",
        "data": [
            {
                "t": 1462427358127,
                "v": 52
            }
        ]
    }
]
```