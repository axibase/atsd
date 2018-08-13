# Series Insert In ISO Format

## Description

Insert data for an entity, metric (no tags) with sample times specified in [ISO format](../../../../shared/date-format.md#supported-formats).

Millisecond precision is optional.

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
      { "d": "2016-06-05T05:49:18.127Z", "v": 17.7 },
      { "d": "2016-06-05T05:49:25.127Z", "v": 14.0 }
    ]
}]
```