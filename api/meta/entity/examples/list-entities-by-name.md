# List Entities by Name

## Description

List all entities whose name includes `car`.

Expression: `name LIKE '*car*'`

## Request

### URI

```elm
/api/v1/entities?limit=10&expression=name%20LIKE%20%27*car*%27
```

### Payload

```json
[
   {
      "name":"car",
      "enabled":true,
      "lastInsertDate": "2016-05-19T08:13:40.000Z"
   },
   {
      "name":"sport-car",
      "enabled":true,
      "lastInsertDate": "2016-05-19T08:13:45.000Z"
   },
   {
      "name":"card",
      "enabled":true,
      "lastInsertDate": "2016-05-19T08:13:40.000Z"
   }
]
```
