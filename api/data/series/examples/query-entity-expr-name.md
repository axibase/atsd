# Series Query: Filter Series with Entity Expression

## Description

Query data for series with entities whose names match the specified expression.

Entity object provides the following parameters that can be referenced in `entityExpression`:

|**Parameter**|**Description**|
|:---|:---|
|`name`|Entity id.|
|`id`|Entity id.|
|`tags.{name}`|Value of the entity tag `{name}`. If tag is not available for the given entity, the value is set to empty string `''`|

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
        "endDate":   "2016-02-22T13:31:00Z",
        "entityExpression": "name LIKE '*urswgvml0*'",
        "metric": "mpstat.cpu_busy"
    }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "metric": "mpstat.cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-02-22T13:30:08.000Z",
        "v": 4
      },
      {
        "d": "2016-02-22T13:30:24.000Z",
        "v": 3.03
      },
      {
        "d": "2016-02-22T13:30:40.000Z",
        "v": 6.06
      },
      {
        "d": "2016-02-22T13:30:56.000Z",
        "v": 4
      }
    ]
  },
  {
    "entity": "nurswgvml006",
    "metric": "mpstat.cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-02-22T13:30:11.000Z",
        "v": 2
      },
      {
        "d": "2016-02-22T13:30:27.000Z",
        "v": 2.97
      },
      {
        "d": "2016-02-22T13:30:43.000Z",
        "v": 7.07
      },
      {
        "d": "2016-02-22T13:30:59.000Z",
        "v": 55.79
      }
    ]
  },
  {
    "entity": "nurswgvml010",
    "metric": "mpstat.cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-02-22T13:30:01.000Z",
        "v": 36.45
      },
      {
        "d": "2016-02-22T13:30:17.000Z",
        "v": 13.13
      },
      {
        "d": "2016-02-22T13:30:33.000Z",
        "v": 1.26
      },
      {
        "d": "2016-02-22T13:30:49.000Z",
        "v": 0.25
      }
    ]
  },
  {
    "entity": "nurswgvml011",
    "metric": "mpstat.cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-02-22T13:30:06.000Z",
        "v": 1.98
      },
      {
        "d": "2016-02-22T13:30:22.000Z",
        "v": 1
      },
      {
        "d": "2016-02-22T13:30:38.000Z",
        "v": 2.97
      },
      {
        "d": "2016-02-22T13:30:54.000Z",
        "v": 47.47
      }
    ]
  }
]
```
