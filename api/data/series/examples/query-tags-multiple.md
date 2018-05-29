# Series Query: Multiple Tags

## Description

Query detailed data for an array of tag values for a given tag.

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
        "metric": "disk_used_percent",
        "tags": {
            "mount_point": ["/", "/mnt/u113452"]
        }
    }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "metric": "disk_used_percent",
    "tags": {
      "file_system": "//u113452.nurswgstr003/backup",
      "mount_point": "/mnt/u113452"
    },
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-02-22T13:34:22.000Z",
        "v": 33.4837
      },
      {
        "d": "2016-02-22T13:34:37.000Z",
        "v": 33.4837
      },
      {
        "d": "2016-02-22T13:34:52.000Z",
        "v": 33.4837
      }
    ]
  },
  {
    "entity": "nurswgvml007",
    "metric": "disk_used_percent",
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
