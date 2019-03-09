# Series Query: Versioned Metric - Filter Status

## Description

Filter versions with the `version_status` field.

Supported parameters:

* `value`
* `version_status`
* `version_source`
* `version_time`

## Versioned Data (No Filter)

```json
[
    {"d":"2018-08-13T06:00:00.000Z","v":55.0,"version":{"d":"2018-08-13T14:32:42.251Z","source":"form/manual","status":"OK"}},
    {"d":"2018-08-13T06:05:00.000Z","v":31.0,"version":{"d":"2018-08-13T14:32:42.257Z","source":"device","status":"Error"}},
    {"d":"2018-08-13T07:00:00.000Z","v":45.0,"version":{"d":"2018-08-13T14:31:27.320Z"}},
    {"d":"2018-08-13T07:05:00.000Z","v":21.0,"version":{"d":"2018-08-13T14:31:27.320Z"}},
    {"d":"2018-08-13T08:00:00.000Z","v":45.0,"version":{"d":"2018-08-13T14:28:25.319Z"}},
    {"d":"2018-08-13T08:00:00.000Z","v":45.0,"version":{"d":"2018-08-13T14:28:51.244Z"}},
    {"d":"2018-08-13T08:05:00.000Z","v":21.0,"version":{"d":"2018-08-13T14:28:25.319Z"}},
    {"d":"2018-08-13T08:05:00.000Z","v":21.0,"version":{"d":"2018-08-13T14:28:51.244Z"}},
    {"d":"2018-08-13T09:00:00.000Z","v":25.0,"version":{"d":"2018-08-13T14:15:30.731Z","source":"etl:export"}},
    {"d":"2018-08-13T09:05:00.000Z","v":11.0,"version":{"d":"2018-08-13T14:15:30.731Z","source":"etl:export"}},
    {"d":"2018-08-13T09:30:00.000Z","v":12.4,"version":{"d":"2018-08-13T13:41:43.920Z","source":"api:192.0.2.14"}},
    {"d":"2018-08-13T09:40:00.000Z","v":6.2,"version":{"d":"2018-08-13T13:42:16.489Z","source":"api:192.0.2.14"}},
    {"d":"2018-08-13T09:50:00.000Z","v":-999.0,"version":{"d":"2018-08-13T13:42:36.597Z","source":"api:192.0.2.14","status":"Invalid"}},
    {"d":"2018-08-13T09:50:00.000Z","v":"NaN","version":{"d":"2018-08-13T13:43:27.530Z","source":"user:axibase","status":"Delete boot sample"}},
    {"d":"2018-08-13T10:00:00.000Z","v":0.0,"version":{"d":"2018-08-13T13:40:57.578Z","source":"api:192.0.2.14","status":"Invalid"}},
    {"d":"2018-08-13T10:00:00.000Z","v":14.0,"version":{"d":"2018-08-13T13:44:00.398Z","source":"user:axibase","status":"Manual revision"}}
]
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
    "startDate": "2018-08-13T00:00:00Z",
    "endDate": "2018-08-14T00:00:00Z",
    "entity": "e-vers",
    "metric": "m-vers",
    "versioned": true,
    "versionFilter": "version_status != '' && version_status != 'OK'"
  }
]
```

## Response

### Payload

```json
[{"entity":"e-vers","metric":"m-vers","tags":{},"type":"HISTORY",
"aggregate":{"type":"DETAIL"},
"data":[
    {"d":"2018-08-13T06:05:00.000Z","v":31.0,"version":{"d":"2018-08-13T14:32:42.257Z","source":"device","status":"Error"}},
    {"d":"2018-08-13T09:50:00.000Z","v":-999.0,"version":{"d":"2018-08-13T13:42:36.597Z","source":"api:192.0.2.14","status":"Invalid"}},
    {"d":"2018-08-13T09:50:00.000Z","v":"NaN","version":{"d":"2018-08-13T13:43:27.530Z","source":"user:axibase","status":"Delete boot sample"}},
    {"d":"2018-08-13T10:00:00.000Z","v":0.0,"version":{"d":"2018-08-13T13:40:57.578Z","source":"api:192.0.2.14","status":"Invalid"}},
    {"d":"2018-08-13T10:00:00.000Z","v":14.0,"version":{"d":"2018-08-13T13:44:00.398Z","source":"user:axibase","status":"Manual revision"}}]}]
```
