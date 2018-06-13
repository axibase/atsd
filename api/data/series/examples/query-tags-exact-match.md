# Series Query: Exact Match

## Description

`exactMatch` can exclude series with tags not specified in the request.

## Match Example

Assuming series A,B,C, and D have the following series tags:

```ls
| series | metric | entity | tag-1 | tag-2 |
|--------|--------|--------|-------|-------|
| A      | m-1    | e-1    | val-1 | val-2 |
| B      | m-1    | e-1    | val-1 |       |
| C      | m-1    | e-1    |       | val-2 |
| D      | m-1    | e-1    |       |       |
```

The table below illustrates which records are returned (the `result` column) for the corresponding `exactMatch` and `key` parameters on the left.

```ls
| exactMatch | requested tags | result  |
|------------|----------------|---------|
| true       |                | D       | - no tags specified in the request, series with additional tags are ignored because exactMatch=true
| false      |                | A;B;C;D | - no tags specified in the request, series with additional tags returned because exactMatch=false
| true       | tag-1=val-1    | B       | - A and B match the requested series tag-1, but A is ignored because exactMatch=true and A has an additional series tag-2
| false      | tag-1=val-1    | A;B     | - A and B match the requested series tag-1, and A is included because exactMatch=false and A's additional series tag-2 is allowed
| true       | tag-2=*        | C       | - A and C match the requested series tag-2, but A is ignored because exactMatch=true and A has an additional series tag-1
| false      | tag-2=*        | A;C     | - A and C match the requested series tag-2, and A is included because exactMatch=false and A's additional series tag-1 is allowed
```

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
        "metric": "m-1",
        "entity": "e-1",
        "tags": {
            "tag-1": "val-1"
        },
        "exactMatch": true
    }
]
```

## Response

### Payload

```json
[
  {
    "entity": "e-1",
    "metric": "m-1",
    "tags": {
      "tag-1": "val-1"
    },
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2016-02-22T13:34:00.000Z",
        "v": 16.0
      }
    ]
  }
]
```
