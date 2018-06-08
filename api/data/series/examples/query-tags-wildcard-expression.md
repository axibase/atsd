# Series Query: Match Tags with Wildcard

## Description

Query data for series that have the specified tag `file_system` that starts with `/dev`.

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[
    {
        "startDate": "2016-02-22T13:30:00Z",
        "endDate":   "2016-02-22T13:35:00Z",
        "entity": "nurswgvml007",
        "metric": "df.disk_used_percent",
        "tags": {"file_system": "/dev*"}
    }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "metric": "df.disk_used_percent",
    "tags": {
      "file_system": "/dev/mapper/vg_nurswgvml007-lv_root",
      "mount_point": "/"
    },
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-02-22T13:30:07.000Z",
        "v": 59.3024
      },
      {
        "d": "2016-02-22T13:30:22.000Z",
        "v": 59.3032
      },
      {
        "d": "2016-02-22T13:30:37.000Z",
        "v": 59.3037
      },
      {
        "d": "2016-02-22T13:30:52.000Z",
        "v": 59.3042
      }
    ]
  }
]
```
