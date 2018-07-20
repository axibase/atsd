# Holiday Calendar Schema

```json
{
  "$id": "https://example.com/calendar.json",
  "type": "object",
  "definitions": {},
  "$schema": "http://json-schema.org/draft-07/schema#",
  "properties": {
    "country": {
      "$id": "/properties/country",
      "type": "string",
      "title": "ISO 3166-1 Alpha-3 Country Code",
      "default": "",
      "examples": [
        "USA"
      ]
    },
    "data": {
      "$id": "/properties/data",
      "type": "array",
      "items": {
        "$id": "/properties/data/items",
        "type": "object",
        "properties": {
          "date": {
            "$id": "/properties/data/items/properties/date",
            "type": "string",
            "title": "ISO 8601 Date Representation: yyyy-MM-dd",
            "default": "",
            "examples": [
              "2018-01-01"
            ]
          },
          "description": {
            "$id": "/properties/data/items/properties/description",
            "type": "string",
            "title": "Exceptional Date Description",
            "default": "",
            "examples": [
              "New Years Day"
            ]
          },
          "type": {
            "$id": "/properties/data/items/properties/type",
            "type": "string",
            "title": "Exceptional Date Type: Holiday or Workday",
            "default": "",
            "examples": [
              "Holiday"
            ]
          }
        }
      }
    }
  }
}
```
