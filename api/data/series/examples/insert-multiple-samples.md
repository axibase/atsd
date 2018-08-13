# Insert Multiple Samples

Insert multiple samples for the given series in [ISO format](../../../../shared/date-format.md#supported-formats).

## Request

### URI

```elm
POST /api/v1/series/insert
```

### Payload

```json
[{
    "entity": "nurswgvml007",
    "metric": "mpstat.cpu_busy",
    "data": [
      { "d": "2016-06-07T16:00:00.000Z", "v": 17.7 },
      { "d": "2016-06-07T16:00:15.000Z", "v": 17.8 }
    ]
}]
```
