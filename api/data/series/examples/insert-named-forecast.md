# Insert Named Forecast

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
        "forecastName": "arima",
        "data": [
            {
                "t": 1462427361327,
                "v": 46
            }
        ]
    }
]
```