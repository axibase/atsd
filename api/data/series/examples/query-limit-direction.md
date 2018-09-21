# Series Query: Apply Limit to Ordered Results

## Description

The `direction` parameter orders samples by time for the purpose of limiting the number of samples in each series returned to the client.

Samples for each series are always sorted by time in **ascending** order regardless of the direction.

With `limit` specified, `ASC` returns first `N` values ordered by time. `DESC` returns last `N` values ordered by time.

## Request

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[{
  "startDate": "1970-01-01T00:00:00Z",
  "endDate":   "now",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "limit": 2,
  "direction": "ASC"
}]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2013-06-17T07:29:04.000Z",
        "v": 0
      },
      {
        "d": "2013-06-17T07:29:20.000Z",
        "v": 5.050000190734863
      }
    ]
  }
]
```

## Request with descending order

Note that `DESC` direction is the default direction.

### URI

```elm
POST /api/v1/series/query
```

### Payload

```json
[{
  "startDate": "1970-01-01T00:00:00Z",
  "endDate":   "now",
  "entity": "nurswgvml007",
  "metric": "cpu_busy",
  "limit": 2,
  "direction": "DESC"
}]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2017-10-18T15:04:32.000Z",
        "v": 9.09
      },
      {
        "d": "2017-10-18T15:04:48.000Z",
        "v": 2.97
      }
    ]
  }
]
```
