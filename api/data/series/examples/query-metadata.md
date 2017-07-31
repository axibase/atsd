# Series Query: Add Metadata

## Description

The `addMeta` parameter instructs the server to include entity and metric metadata, namely their fields and tags, in the response object.

This provides a convenient method for retrieving both series data and descriptive information about the metric and the entities, without executing a separate request to Meta API `get` methods.

The list of returned fields corresponds to entity [get](../../../../api/meta/entity/get.md) and metric [get](../../../../api/meta/metric/get.md) methods.

Meta API user role is not required to access this metadata.

## Request

### URI

```elm
POST https://atsd_host:8443/api/v1/series/query
```

### Payload

```json
[{
    "startDate": "2016-11-28T08:30:00Z",
    "endDate":   "2016-11-28T08:31:00Z",
    "entity": "*",
    "metric": "cpu_busy",
    "seriesLimit": 2,
    "limit": 2,
    "addMeta": true
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
    "meta": {
      "metric": {"name":"cpu_busy","enabled":true,"dataType":"FLOAT","label":"CPU Busy %","persistent":true,"tags":{"source":"iostat","table":"System"},"timePrecision":"MILLISECONDS","retentionDays":0,"minValue":0.0,"maxValue":100.0,"invalidAction":"TRANSFORM","versioned":false,"interpolate":"LINEAR","timeZone":"US/Eastern"},
      "entity": {"name":"nurswgvml007","enabled":true,"timeZone":"PST","tags":{"alias":"007","app":"ATSD","environment":"prod","ip":"10.102.0.6","loc_area":"dc1","loc_code":"nur,nur","os":"Linux"},"interpolate":"LINEAR","label":"NURswgvml007"}
    },
    "data": [
      {
        "d": "2016-11-28T08:30:33.000Z",
        "v": 12
      },
      {
        "d": "2016-11-28T08:30:49.000Z",
        "v": 2.02
      }
    ]
  },
  {
    "entity": "nurswgvml006",
    "metric": "cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "meta": {
      "metric": {"name":"cpu_busy","enabled":true,"dataType":"FLOAT","label":"CPU Busy %","persistent":true,"tags":{"source":"iostat","table":"System"},"timePrecision":"MILLISECONDS","retentionDays":0,"minValue":0.0,"maxValue":100.0,"invalidAction":"TRANSFORM","versioned":false,"interpolate":"LINEAR","timeZone":"US/Eastern"},
      "entity": {"name":"nurswgvml006","enabled":true,"timeZone":"America/Bahia_Banderas","tags":{"app":"Hadoop/HBASE","environment":"prod","ip":"10.102.0.5","loc_area":"dc1","os":"Linux"},"label":"NURSWGVML006"}
    },
    "data": [
      {
        "d": "2016-11-28T08:30:29.000Z",
        "v": 98.99
      },
      {
        "d": "2016-11-28T08:30:45.000Z",
        "v": 68.42
      }
    ]
  }
]
```
