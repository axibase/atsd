# Series Query: Rate with Aggregation

## Description

Aggregation function is applied to values returned by the rate function.

### Data

```ls
| datetime                 | value         |
|--------------------------|---------------|
| 2016-02-16T12:11:13.000Z | 6021313083414 |
| 2016-02-16T12:11:28.000Z | 6021315128131 |
| 2016-02-16T12:11:43.000Z | 6021316614529 |
| 2016-02-16T12:11:58.000Z | 6021317932602 |
| 2016-02-16T12:35:12.000Z | 1591585       | + reset +
| 2016-02-16T12:35:27.000Z | 2065410       |
| 2016-02-16T12:35:43.000Z | 3380806       |
| 2016-02-16T12:35:58.000Z | 7144214       |
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
    "startDate": "2016-02-16T12:11:00Z",
    "endDate":   "2016-02-16T12:36:00Z",
    "entity": "nurswgvml007",
    "metric": "net_tx_bytes",
    "rate": { "counter": true },
    "aggregate": {"type": "SUM", "period":  {"count": 1, "unit": "MINUTE"}}
  }
]
```

## Response

### Payload

```json
[{"entity":"nurswgvml007","metric":"net_tx_bytes","tags":{"name":"eth1"},"type":"HISTORY",
"aggregate":{"type":"SUM","period":{"count":1,"unit":"MINUTE","align":"CALENDAR"}},
"rate":{"period":{"count":0,"unit":"SECOND"},"counter":true},
"data":[
    {"d":"2016-02-16T12:11:00.000Z","v":4849188.0},
    {"d":"2016-02-16T12:35:00.000Z","v":5552629.0}
]}]
```

## Rate without Aggregation

```json
[
  {
    "startDate": "2016-02-16T12:11:00Z",
    "endDate":   "2016-02-16T12:36:00Z",
    "entity": "nurswgvml007",
    "metric": "net_tx_bytes",
    "rate": { "counter": true }
  }
]
```

### Response

```json
[{"entity":"nurswgvml007","metric":"net_tx_bytes","tags":{"name":"eth1"},"type":"HISTORY",
"aggregate":{"type":"DETAIL"},
"rate":{"period":{"count":0,"unit":"SECOND"},"counter":true},
"data":[
    {"d":"2016-02-16T12:11:28.000Z","v":2044717.0},
    {"d":"2016-02-16T12:11:43.000Z","v":1486398.0},
    {"d":"2016-02-16T12:11:58.000Z","v":1318073.0},
    {"d":"2016-02-16T12:35:27.000Z","v":473825.0},
    {"d":"2016-02-16T12:35:43.000Z","v":1315396.0},
    {"d":"2016-02-16T12:35:58.000Z","v":3763408.0}
]}]
```
