# List Entities by Max Insert Date

## Description

List entities with last insert date before 2016-05-19T08:13:40.000Z.

## Request

### URI

```elm
GET /api/v1/entities?maxInsertDate=2016-05-19T08:13:40.000Z
```

## Response

```json
[
   {
      "name":"nurswgvml017",
      "enabled":true,
      "lastInsertDate": "2016-05-19T08:11:23.000Z"
   },
   {
      "name":"nurswgvml01",
      "enabled":true,
      "lastInsertDate": "2016-05-19T08:12:00.000Z"
   }
]
```
