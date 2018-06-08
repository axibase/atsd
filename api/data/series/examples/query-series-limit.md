# Series Query: Multiple Queries with Limit

## Description

The `seriesLimit` parameter limits the number of series returned by the server.

This parameter is typically used to prevent the client/server from processing too many series.

The order of series in the response is undefined .

## Data

```ls
| entity       | tags.file_system                    | tags.mount_point |
|--------------|-------------------------------------|------------------|
| nurswgvml006 | /dev/mapper/vg_nurswgvml006-lv_root | /                |
| nurswgvml006 | /dev/sdc1                           | /media/datadrive |
| nurswgvml007 | /dev/mapper/vg_nurswgvml007-lv_root | /                |
| nurswgvml009 | /dev/mapper/vg_nurswgvml009-lv_root | /                |
| nurswgvml009 | /dev/sdb1                           | /opt             |
| nurswgvml010 | /dev/sda1                           | /                |
| nurswgvml010 | /dev/sdb1                           | /app             |
| nurswgvml011 | /dev/sda1                           | /                |
| nurswgvml502 | /dev/sda1                           | /                |
```

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[{
    "startDate": "2016-08-13T13:30:00Z",
    "endDate":   "2016-08-13T13:30:30Z",
    "entity": "*",
    "metric": "disk_used_percent",
    "seriesLimit": 3,
    "limit": 2
}]
```

## Response

### Payload

```json
[
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
        "d": "2016-08-13T13:30:00.000Z",
        "v": 69.6069
      },
      {
        "d": "2016-08-13T13:30:15.000Z",
        "v": 69.6116
      }
    ]
  },
  {
    "entity": "nurswgvml006",
    "metric": "disk_used_percent",
    "tags": {
      "file_system": "/dev/mapper/vg_nurswgvml006-lv_root",
      "mount_point": "/"
    },
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-08-13T13:30:13.000Z",
        "v": 43.0614
      },
      {
        "d": "2016-08-13T13:30:28.000Z",
        "v": 43.0614
      }
    ]
  },
  {
    "entity": "nurswgvml006",
    "metric": "disk_used_percent",
    "tags": {
      "file_system": "/dev/sdc1",
      "mount_point": "/media/datadrive"
    },
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-08-13T13:30:13.000Z",
        "v": 75.5934
      },
      {
        "d": "2016-08-13T13:30:28.000Z",
        "v": 75.5942
      }
    ]
  }
]
```
