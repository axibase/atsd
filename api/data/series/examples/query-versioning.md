# Series Query: Versioned Metric

## Description

Query last values and value history for versioned metrics.

The `data[]` object in the response contains multiple samples for the same timestamp if the value has a history of changes.

The samples are sorted by sample time, and value change time in ascending order.

The version object contains value change date, source, and status. For example: `"version":{"d":"2015-08-13T14:32:42.251Z","source":"form/manual","status":"OK"}`.

## Detailed Data (No Versioning)

```ls
| datetime                 | value |
|--------------------------|-------|
| 2015-08-13T06:00:00.000Z | 55.0  |
| 2015-08-13T06:05:00.000Z | 31.0  |
| 2015-08-13T07:00:00.000Z | 45.0  |
| 2015-08-13T07:05:00.000Z | 21.0  |
| 2015-08-13T08:00:00.000Z | 45.0  |
| 2015-08-13T08:05:00.000Z | 21.0  |
| 2015-08-13T09:00:00.000Z | 25.0  |
| 2015-08-13T09:05:00.000Z | 11.0  |
| 2015-08-13T09:30:00.000Z | 12.4  |
| 2015-08-13T09:40:00.000Z | 6.2   |
| 2015-08-13T09:50:00.000Z | NaN   |
| 2015-08-13T10:00:00.000Z | 14.0  |
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
    "startDate": "2015-08-13T00:00:00Z",
    "endDate": "2015-08-14T00:00:00Z",
    "entity": "e-vers",
    "metric": "m-vers",
    "versioned": true
  }
]
```

## Response

### Payload

```json
[{"entity":"e-vers","metric":"m-vers","tags":{},"type":"HISTORY",
"aggregate":{"type":"DETAIL"},
"data":[
    {"d":"2015-08-13T06:00:00.000Z","v":55.0,"version":{"d":"2015-08-13T14:32:42.251Z","source":"form/manual","status":"OK"}},
    {"d":"2015-08-13T06:05:00.000Z","v":31.0,"version":{"d":"2015-08-13T14:32:42.257Z","source":"device","status":"Error"}},
    {"d":"2015-08-13T07:00:00.000Z","v":45.0,"version":{"d":"2015-08-13T14:31:27.320Z"}},
    {"d":"2015-08-13T07:05:00.000Z","v":21.0,"version":{"d":"2015-08-13T14:31:27.320Z"}},
    {"d":"2015-08-13T08:00:00.000Z","v":45.0,"version":{"d":"2015-08-13T14:28:25.319Z"}},
    {"d":"2015-08-13T08:00:00.000Z","v":45.0,"version":{"d":"2015-08-13T14:28:51.244Z"}},
    {"d":"2015-08-13T08:05:00.000Z","v":21.0,"version":{"d":"2015-08-13T14:28:25.319Z"}},
    {"d":"2015-08-13T08:05:00.000Z","v":21.0,"version":{"d":"2015-08-13T14:28:51.244Z"}},
    {"d":"2015-08-13T09:00:00.000Z","v":25.0,"version":{"d":"2015-08-13T14:15:30.731Z","source":"etl:export"}},
    {"d":"2015-08-13T09:05:00.000Z","v":11.0,"version":{"d":"2015-08-13T14:15:30.731Z","source":"etl:export"}},
    {"d":"2015-08-13T09:30:00.000Z","v":12.4,"version":{"d":"2015-08-13T13:41:43.920Z","source":"api:192.0.2.14"}},
    {"d":"2015-08-13T09:40:00.000Z","v":6.2,"version":{"d":"2015-08-13T13:42:16.489Z","source":"api:192.0.2.14"}},
    {"d":"2015-08-13T09:50:00.000Z","v":-999.0,"version":{"d":"2015-08-13T13:42:36.597Z","source":"api:192.0.2.14","status":"Invalid"}},
    {"d":"2015-08-13T09:50:00.000Z","v":"NaN","version":{"d":"2015-08-13T13:43:27.530Z","source":"user:axibase","status":"Delete boot sample"}},
    {"d":"2015-08-13T10:00:00.000Z","v":0.0,"version":{"d":"2015-08-13T13:40:57.578Z","source":"api:192.0.2.14","status":"Invalid"}},
    {"d":"2015-08-13T10:00:00.000Z","v":14.0,"version":{"d":"2015-08-13T13:44:00.398Z","source":"user:axibase","status":"Manual revision"}}
]}]
```
