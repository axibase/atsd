# List Entities by Min Insert Date

List entities with last insert date at or after 2016-05-18T22:13:40Z.

## Request

### URI

```elm
GET /api/v1/entities?minInsertDate=2016-05-18T22:13:40.000Z
```

## Response

```json
[
   {
      "name":"nurswgvml201",
      "enabled":true,
      "lastInsertDate": "2016-05-18T22:13:55.000Z"
   },
   {
      "name":"nurswgvml221",
      "enabled":true,
      "lastInsertDate": "2016-05-18T22:13:41.012Z"
   }
]
```
