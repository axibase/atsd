# Series Query: Match Records using Tag Expression with Wildcard

## Description

The `tagExpression` provides a more flexible filtering option compared to the `tags` object. The `tagExpression` can refer to multiple tags in one condition, it can negate the condition, it can apply value transformation such as case-insensitive match.

## Examples

| **Expression** | **Description** |
|---|---|
| `tags.location = 'abc'` | Include series with 'location' tag equal 'abc'. |
| `tags.location LIKE '*abc'` | Include series with 'location' tag ending with 'abc'. |
| `tags.location LIKE '*abc' OR tags.mode = 'desktop'` | Include series either with 'location' tag ending with 'abc' or 'mode' tag equal to 'desktop'. |
| `tags.location LIKE '*abc' AND NOT tags.mode = 'mobile'` | Include series with 'location' tag ending with 'abc' AND 'mode' tag not equal to 'mobile'. |

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
        "taxExpression": "file_system LIKE '/dev*'"
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
