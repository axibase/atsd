# Series Query: Interval Window

## Description

Specify interval without `endDate` to query data for a sliding window ending with current time.

If an interval is specified and `endDate` is not, `endDate` is set to current server time.

This would be equivalent to setting `endDate` to `now`.

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
    {
        "interval": {"count": 1, "unit": "MINUTE"},
        "entity": "nurswgvml007",
        "metric": "mpstat.cpu_busy"
    }
]
```

## Response

### Payload

```json
[{"entity":"nurswgvml007","metric":"cpu_busy","tags":{},"type":"HISTORY",
    "aggregate":{"type":"DETAIL"},
"data":[
    {"d":"2016-06-28T11:07:06.000Z","v":69.7},
    {"d":"2016-06-28T11:07:22.000Z","v":32.65},
    {"d":"2016-06-28T11:07:38.000Z","v":12.12},
    {"d":"2016-06-28T11:07:55.000Z","v":31.31}
]}]
```
