# Series Query: Not a Number

## Description

If the series value at a given time is Not-A-Number (`NaN`), the value field contains `null` in the response.

## Data

```ls
series d:2017-09-01T09:00:00Z e:entity-nan m:metric-nan=10.4
series d:2017-09-01T09:15:00Z e:entity-nan m:metric-nan=NaN x:metric-nan=Invalid
series d:2017-09-01T09:30:00Z e:entity-nan m:metric-nan=16.3
```

## Request

### URI

```elm
POST https://atsd_host:8443/api/v1/series/query
```

### Payload

```json
[{
    "startDate": "2017-09-01T09:00:00Z",
    "endDate": "2017-09-01T10:00:00Z",
    "entity": "entity-nan",
    "metric": "metric-nan"
}]
```

## Response

### Payload

```json
[
  {
    "entity": "entity-nan",
    "metric": "metric-nan",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {
        "d": "2017-09-01T09:00:00.000Z",
        "v": 10.4
      },
      {
        "d": "2017-09-01T09:15:00.000Z",
        "v": null,
        "x": "Invalid"
      },
      {
        "d": "2017-09-01T09:30:00.000Z",
        "v": 16.3
      }
    ]
  }
]
```
