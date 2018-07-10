# List Metrics by Max Insert Date

List metrics with `lastInsertDate` less than 2016-05-19T08:13:40.000Z

## Request

### URI

```elm
GET /api/v1/metrics?maxInsertDate=2016-05-19T08:13:40.000Z
```

## Response

```json
[
   {
      "name":"meminfo.buffers",
      "enabled":true,
      "dataType":"FLOAT",
      "persistent":true,
      "retentionDays":0,
      "invalidAction":"NONE",
      "lastInsertDate":"2016-05-18T22:50:00.000Z",
      "versioned":false
   },
   {
      "name":"meminfo.cached",
      "enabled":true,
      "dataType":"FLOAT",
      "persistent":true,
      "retentionDays":0,
      "invalidAction":"NONE",
      "lastInsertDate":"2016-05-18T22:50:00.000Z",
      "versioned":false
   },
   {
      "name":"meminfo.cmafree",
      "enabled":true,
      "dataType":"FLOAT",
      "persistent":true,
      "retentionDays":0,
      "invalidAction":"NONE",
      "lastInsertDate":"2016-05-05T05:50:18.312Z",
      "versioned":false
   }
]
```
