# Series Query: Entity Expression with Properties

## Description

Query data for entities with specified properties.

Properties can be accessed with the property [functions](../../filter-entity.md#supported-functions), for example, [`property_values`](../../../../configuration/functions-entity-groups-expression.md#property_values).

## Request

### URI

```elm
POST https://atsd_hostname:8443/api/v1/series/query
```

### Payload

```json
[
  {
    "startDate": "2016-02-22T13:30:00Z",
    "endDate": "2016-02-22T13:31:00Z",
    "entityExpression": "name LIKE 'nurswgvml00*' && property_values('disk:mount_point=/sda1:fs_type').contains('ext4')",
    "metric": "mpstat.cpu_busy"
  }
]
```

## Response

### Payload

```json
[
  {
    "entity": "nurswgvml007",
    "metric": "mpstat.cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
        {"d":"2016-02-22T13:30:08.000Z","v":4},
        {"d":"2016-02-22T13:30:24.000Z","v":3.03},
        {"d":"2016-02-22T13:30:40.000Z","v":6.06},
        {"d":"2016-02-22T13:30:56.000Z","v":4}
    ]
  },
  {
    "entity": "nurswgvml006",
    "metric": "mpstat.cpu_busy",
    "tags": {},
    "type": "HISTORY",
    "aggregate": {
      "type": "DETAIL"
    },
    "data": [
      {"d":"2016-02-22T13:30:11.000Z","v":2},
      {"d":"2016-02-22T13:30:27.000Z","v":2.97},
      {"d":"2016-02-22T13:30:43.000Z","v":7.07},
      {"d":"2016-02-22T13:30:59.000Z","v":55.79}
    ]
  }
]
```
