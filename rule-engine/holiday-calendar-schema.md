# Holiday Calendar Schema

```json
{
  "$id": "https://example.com/calendar.json",
  "type": "array",
  "definitions": {},
  "$schema": "https://json-schema.org/draft-07/schema#",
  "items": {
    "$id": "https://example.com/calendar.json/items",
    "type": "object",
    "properties": {
      "date": {
        "$id": "https://example.com/calendar.json/items/properties/date",
        "type": "string",
        "title": "Date in ISO8601 format",
        "examples": [
          "2018-01-01"
        ]
      },
      "description": {
        "$id": "https://example.com/calendar.json/items/properties/description",
        "type": "string",
        "title": "Exceptional Day Description",
        "examples": [
          "New Year's Day"
        ]
      },
      "type": {
        "$id": "https://example.com/calendar.json/items/properties/type",
        "type": "string",
        "title": "Exceptional Day Type: Holiday or Workday",
        "examples": [
          "Holiday"
        ]
      }
    }
  }
}
```
