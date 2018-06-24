# Data API: Properties Methods

| **Name** | **Method** | **Path** | **Content-Type** | **Description** |
|:---|:---|:---|:---|:---|
| [Get](get.md) | GET | `/api/v1/properties/{entity}/types/{type}` |  | Retrieve property records for the specified entity and type. |
| [Query](query.md) | POST | `/api/v1/properties/query` | `application/json` | Retrieve property records matching specified filters. |
| [List Types](list-types.md) | GET | `/api/v1/properties/{entity}/types` |  | Retrieve an array of property types for the entity.  |
| [Insert](insert.md) | POST | `/api/v1/properties/insert` | `application/json` | Insert an array of properties. |
| [Delete](delete.md) | POST | `/api/v1/properties/delete` | `application/json` | Delete property records that match specified filters. |
