# Series Query: Entity Expression with Entity Tags

## Description

Query data for series with entities whose entity tags match the specified expression.

Entity tags can be accessed with the `tags.{name}` syntax.

Entity object provides the following parameters that can be referenced in `entityExpression`:

|**Parameter**|**Description**|
|:---|:---|
|`name`|Entity id.|
|`id`|Entity id.|
|`tags.{name}`|Value of the entity tag `{name}`. If tag is not available for the given entity, the value is set to empty string ''|

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
        "entityExpression": "tags.app = 'ATSD'",
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
  }
]
```
