# List Entities for Last Insert Date Range

List entities with `lastInsertDate` within the specified range. To exclude entities without `lastInsertDate`, set `minInsertDate` to `1970-01-01T00:00:00Z`.

## Request

### URI

```elm
GET /api/v1/entities?minInsertDate=1970-01-01T00:00:00Z&maxInsertDate=1980-01-01T00:00:00Z&limit=3
```

## Response

```json
[{
   "name": "bahamas",
   "enabled": true,
   "lastInsertDate": "1976-01-01T00:00:00.000Z"
}, {
   "name": "barbados",
   "enabled": true,
   "lastInsertDate": "1976-01-01T00:00:00.000Z"
}, {
   "name": "gabon",
   "enabled": true,
   "lastInsertDate": "1979-01-01T00:00:00.000Z"
}]
```
