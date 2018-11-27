# Series Query: Match Records using Tag Expressions

## Description

The `tagExpression` is a boolean expression that provides a flexible filtering option compared to the `tags` object.

The `tagExpression` can refer to multiple tags in one condition, negate the condition, or modify the tag value for case-insensitive match.

## Examples

| **Expression** | **Description** |
|---|---|
| `tags.location = 'abc'` | Include series with `location` tag equal `abc`. |
| `tags.location IN ('abc', 'cde')` | Include series with `location` tag equal `abc` or `cde`. |
| `tags.location NOT IN ('abc', 'cde')` | Include series with `location` tag other than `abc` or `cde`. |
| `tags.location LIKE '*abc'` | Include series with `location` tag ending with `abc`. |
| `tags.location LIKE '*abc' OR tags.mode = 'desktop'` | Include series either with `location` tag ending with `abc` or `mode` tag equal to `desktop`. |
| `tags.location LIKE '*abc' AND tags.mode != 'mobile'` | Include series with `location` tag ending with `abc` AND `mode` tag not equal to `mobile`. |

> Note that string comparison is case-sensitive. Apply the `LOWER` function to match case-insensitive values if necessary.

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
        "tagExpression": "tags.file_system LIKE '/dev*'"
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
