# Series Query: Defined Tags

## Description

Query detailed data for defined tags.

The query can return multiple series, including series with additional series tags, that contain the specified tag.

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
        "tags": {"file_system": "/dev/mapper/vg_nurswgvml007-lv_root",
                 "mount_point": "/"}
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
      },
      {
        "d": "2016-02-22T13:31:07.000Z",
        "v": 59.3047
      },
      {
        "d": "2016-02-22T13:31:22.000Z",
        "v": 59.3054
      },
      {
        "d": "2016-02-22T13:31:37.000Z",
        "v": 59.306
      },
      {
        "d": "2016-02-22T13:31:52.000Z",
        "v": 59.3063
      },
      {
        "d": "2016-02-22T13:32:07.000Z",
        "v": 59.3068
      },
      {
        "d": "2016-02-22T13:32:22.000Z",
        "v": 59.3074
      },
      {
        "d": "2016-02-22T13:32:37.000Z",
        "v": 59.3081
      },
      {
        "d": "2016-02-22T13:32:52.000Z",
        "v": 59.3084
      },
      {
        "d": "2016-02-22T13:33:07.000Z",
        "v": 59.3088
      },
      {
        "d": "2016-02-22T13:33:22.000Z",
        "v": 59.3096
      },
      {
        "d": "2016-02-22T13:33:37.000Z",
        "v": 59.3102
      },
      {
        "d": "2016-02-22T13:33:52.000Z",
        "v": 59.3106
      },
      {
        "d": "2016-02-22T13:34:07.000Z",
        "v": 59.3111
      },
      {
        "d": "2016-02-22T13:34:22.000Z",
        "v": 59.3117
      },
      {
        "d": "2016-02-22T13:34:37.000Z",
        "v": 59.3124
      },
      {
        "d": "2016-02-22T13:34:52.000Z",
        "v": 59.3128
      }
    ]
  }
]
```
