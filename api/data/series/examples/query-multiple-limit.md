# Series Query: Multiple Queries with Limit

## Description

The `limit` parameter applies to each series separately.

Samples for each series are sorted by time in descending order.

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
    "endDate": "2016-02-22T13:31:00Z",
    "entity": "nurswgvml006",
    "metric": "cpu_busy",
    "limit": 1,
    "requestId": "q1"
  },
  {
    "startDate": "2016-02-22T13:30:00Z",
    "endDate": "2016-02-22T13:31:00Z",
    "entity": "nurswgvml007",
    "metric": "disk_used_percent",
    "tags": {},
    "limit": 1,
    "requestId": "q2"
  }
]
```

## Response

### Payload

```json
[
  {
    "requestId": "q2",
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
        "d": "2016-02-22T13:30:52.000Z",
        "v": 59.3042
      }
    ]
  },
  {
    "requestId": "q2",
    "entity": "nurswgvml007",
    "metric": "disk_used_percent",
    "tags": {
      "file_system": "//u113452.nurstr003/backup",
      "mount_point": "/mnt/u113452"
    },
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-02-22T13:30:52.000Z",
        "v": 33.4837
      }
    ]
  },
  {
    "requestId": "q1",
    "entity": "nurswgvml006",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-02-22T13:30:59.000Z",
        "v": 55.79
      }
    ]
  }
]
```
