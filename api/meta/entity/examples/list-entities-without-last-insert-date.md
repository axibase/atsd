# List Entities without Last Insert Date

List entities without `lastInsertDate`. This can occur when the data collected by the entity was subsequently deleted, for example when all metrics collected by this entity were deleted, or when old data was pruned according to retention day or series retention day parameters.

To retrieve entities without `lastInsertDate`, set `maxInsertDate` to `1970-01-01T00:00:00Z` or earlier.

## Request

### URI

```elm
GET /api/v1/entities?maxInsertDate=1970-01-01T00:00:00Z&limit=3
```

## Response

```json
[{
   "name": "/a",
   "enabled": true,
   "createdDate": "2017-10-03T07:09:54.551Z"
}, {
   "name": "0492bac05f420f0c966737ed98c7b032580a63c8cf2d74aed864361ac5927295",
   "enabled": true,
   "label": "0492bac0 [bridge]"
}, {
   "name": "12364bc005b2",
   "enabled": true
}]
```
