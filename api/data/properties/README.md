# Data API: Properties Methods

| **Name** | **Method** | **Path** | **Content-Type** | **Description** |
|:---|:---|:---|:---|:---|
| [Insert](insert.md) | POST | `/api/v1/properties/insert` | `application/json` | Insert an array of properties. |
| [Query](query.md) | POST | `/api/v1/properties/query` | `application/json` | Retrieve property records matching specified filters. |
| [URL Query](url-query.md) | GET | `/api/v1/properties/{entity}/types/{type}` |  | Retrieve property records for the specified entity and type. |
| [Type Query](type-query.md) | GET | `/api/v1/properties/{entity}/types` |  | Retrieve an array of property types for the entity.  |
| [Delete](delete.md) | POST | `/api/v1/properties/delete` | `application/json` | Delete property records that match specified filters. |
