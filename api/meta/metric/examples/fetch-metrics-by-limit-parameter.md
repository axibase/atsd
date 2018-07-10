# Fetch Metrics by Limit Parameter

Fetch first three metrics, ordered by name.

## Request

### URI

```elm
GET /api/v1/metrics?limit=3
```

## Response

```json
[
   {
      "name":"api_command_malformed_per_second",
      "enabled":true,
      "dataType":"FLOAT",
      "persistent":true,
      "retentionDays":0,
      "invalidAction":"NONE",
      "lastInsertTime":1463129522969,
      "versioned":false
   },
   {
      "name":"temperature",
      "enabled":true,
      "dataType":"FLOAT",
      "description":"Celsius",
      "persistent":true,
      "retentionDays":2,
      "minValue":21.0,
      "maxValue":125.0,
      "invalidAction":"RAISE_ERROR",
      "lastInsertTime":1462427358127,
      "filter":"filter",
      "versioned":false
   },
   {
      "name":"df.disk_size",
      "enabled":true,
      "dataType":"FLOAT",
      "persistent":true,
      "retentionDays":0,
      "invalidAction":"NONE",
      "lastInsertTime":1463129525000,
      "versioned":false
   }
]
```
