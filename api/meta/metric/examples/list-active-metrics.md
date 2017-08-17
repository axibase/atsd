# List Active Metrics 

## Request
### URI
```elm
GET https://atsd_host:8443/api/v1/metrics?active=true&timeFormat=iso
```

## Response
```json
[
   {
      "name":"meminfo.active(file)",
      "enabled":true,
      "dataType":"FLOAT",
      "persistent":true,
      "timePrecision":"MILLISECONDS",
      "retentionDays":0,
      "invalidAction":"NONE",
      "lastInsertTime":"2016-05-19T09:18:49.000Z",
      "versioned":false
   },
   {
      "name":"meminfo.anonhugepages",
      "enabled":true,
      "dataType":"FLOAT",
      "persistent":true,
      "timePrecision":"MILLISECONDS",
      "retentionDays":0,
      "invalidAction":"NONE",
      "lastInsertTime":"2016-05-19T09:18:49.000Z",
      "versioned":false
   },
   {
      "name":"meminfo.anonpages",
      "enabled":true,
      "dataType":"FLOAT",
      "persistent":true,
      "timePrecision":"MILLISECONDS",
      "retentionDays":0,
      "invalidAction":"NONE",
      "lastInsertTime":"2016-05-19T09:18:49.000Z",
      "versioned":false
   }
]
```
