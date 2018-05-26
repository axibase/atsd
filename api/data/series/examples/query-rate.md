# Series Query: Rate

## Description

Compute the rate of change (first derivative) by dividing the change in value by the change in time (milliseconds).

If a [period](../../../../api/data/series/period.md) is specified, the `rate` function returns change per period duration. The rate is computed for each sample, except 1st.

### Data

```ls
| datetime                 | value         |
|--------------------------|---------------|
| 2016-06-27T14:10:06.000Z | 2416571149884 | no rate return
| 2016-06-27T14:10:21.000Z | 2416575751447 | rate at 14:10:21
| 2016-06-27T14:10:36.000Z | 2416579173021 |
| 2016-06-27T14:10:51.000Z | 2416581490451 |
```

Rate at 14:10:21:

```ls
(2416575751447 - 2416571149884)/(2016-06-27T14:10:21.000Z - 2016-06-27T14:10:06.000Z) =
  = 4601563 / 15000 milliseconds = 306.77 per millisecond
  Return 306.77 * (1*SECOND / 1*MILLISECOND) = 306770
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
    "startDate": "2016-06-27T14:10:00Z",
    "endDate":   "2016-06-27T14:11:00Z",
    "entity": "nurswgvml007",
    "metric": "net_tx_bytes",
    "rate": {
        "period": {"count": 1, "unit": "SECOND"}
    }
  }
]
```

## Response

### Payload

```json
[{"entity":"nurswgvml007","metric":"net_tx_bytes",
    "tags":{"name":"eth1"},"type":"HISTORY",
    "aggregate":{"type":"DETAIL"},
    "rate":{"period":{"count":1,"unit":"SECOND"},"counter":true},
"data":[
    {"d":"2016-06-27T14:10:21.000Z","v":306770.86666666664},
    {"d":"2016-06-27T14:10:36.000Z","v":228104.93333333332},
    {"d":"2016-06-27T14:10:51.000Z","v":154495.33333333334}
]}]
```

## Request - No Period

If the period is not specified, the `rate` function returns delta between consecutive samples.

If the interval between samples is equidistant, no period would be equivalent to period == interval, or  `{"count": 15, "unit": "SECOND"}` in the example below.

```json
[
  {
    "startDate": "2016-06-27T14:10:00Z",
    "endDate":   "2016-06-27T14:11:00Z",
    "entity": "nurswgvml007",
    "metric": "net_tx_bytes",
    "rate": { }
  }
]
```

### Response

```json
[{"entity":"nurswgvml007","metric":"net_tx_bytes",
    "tags":{"name":"eth1"},"type":"HISTORY",
    "aggregate":{"type":"DETAIL"},
    "rate":{"period":{"count":1,"unit":"SECOND"},"counter":true},
"data":[
    {"d":"2016-06-27T14:10:21.000Z","v":4601563.0},
    {"d":"2016-06-27T14:10:36.000Z","v":3421574.0},
    {"d":"2016-06-27T14:10:51.000Z","v":2317430.0}
]}]
```

## Example - Counter Off

With counter mode OFF, the rate returns delta between consecutive samples regardless if the change was positive or negative.

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

### Request

```json
[
  {
    "startDate": "2016-02-16T12:11:00Z",
    "endDate":   "2016-02-16T12:36:00Z",
    "entity": "nurswgvml007",
    "metric": "net_tx_bytes",
    "rate": { "counter": false }
  }
]
```

### Response

```json
[{"entity":"nurswgvml007","metric":"net_tx_bytes","tags":{"name":"eth1"},"type":"HISTORY",
"aggregate":{"type":"DETAIL"},
"rate":{"period":{"count":0,"unit":"SECOND"},"counter":false},
"data":[
    {"d":"2016-02-16T12:11:28.000Z","v":2044717.0},
    {"d":"2016-02-16T12:11:43.000Z","v":1486398.0},
    {"d":"2016-02-16T12:11:58.000Z","v":1318073.0},
    {"d":"2016-02-16T12:35:12.000Z","v":-6.021316341017E12},
    {"d":"2016-02-16T12:35:27.000Z","v":473825.0},
    {"d":"2016-02-16T12:35:43.000Z","v":1315396.0},
    {"d":"2016-02-16T12:35:58.000Z","v":3763408.0}
]}]
```

## Example - Counter On

With counter mode ON, the `rate` function ignores negative changes between consecutive samples.

In the example below, the sample at 2016-02-16T12:35:12.000Z was ignored.

The default behavior counter is ON.

### Request

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
"rate":{"period":{"count":0,"unit":"SECOND"},"counter":false},
"data":[
    {"d":"2016-02-16T12:11:28.000Z","v":2044717.0},
    {"d":"2016-02-16T12:11:43.000Z","v":1486398.0},
    {"d":"2016-02-16T12:11:58.000Z","v":1318073.0},
    {"d":"2016-02-16T12:35:27.000Z","v":473825.0},
    {"d":"2016-02-16T12:35:43.000Z","v":1315396.0},
    {"d":"2016-02-16T12:35:58.000Z","v":3763408.0}
]}]
```
