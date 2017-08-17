# List Metrics by minInsertDate

List metrics with `lastInsertDate` equal or greater than 2016-05-18T22:13:40.000Z

## Request
### URI
```elm
GET https://atsd_host:8443/api/v1/metrics?minInsertDate=2016-05-18T22:13:40.000Z
```
## Response
```json
[
   {
      "name":"properties_pool_active_count",
      "enabled":true,
      "dataType":"FLOAT",
      "persistent":true,
      "timePrecision":"MILLISECONDS",
      "retentionDays":0,
      "invalidAction":"NONE",
      "lastInsertDate":"2016-05-18T22:50:00.000Z",
      "versioned":false
   },
   {
      "name":"properties_queue_size",
      "enabled":true,
      "dataType":"FLOAT",
      "persistent":true,
      "timePrecision":"MILLISECONDS",
      "retentionDays":0,
      "invalidAction":"NONE",
      "lastInsertDate":"2016-05-19T03:50:00.000Z",
      "versioned":false
   },
   {
      "name":"properties_rejected_count",
      "enabled":true,
      "dataType":"FLOAT",
      "persistent":true,
      "timePrecision":"MILLISECONDS",
      "retentionDays":0,
      "invalidAction":"NONE",
      "lastInsertDate":"2016-05-19T10:07:54.749Z",
      "versioned":false
   }
]
```
