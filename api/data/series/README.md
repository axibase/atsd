# Data API: Series Methods

| **Name** | **Method** | **Path** | **Description** |
|:---|:---|:---|:---|
| [Get](get.md) | GET | `/api/v1/series/{format}/{entity}/{metric}` | Retrieve series values for the specified entity, metric, and series tags in CSV and JSON format. |
| [Query](query.md) | POST | `/api/v1/series/query` | Retrieve series values for the specified filters in JSON format. Supports advanced filtering and transformation options compared to [Get](get.md) method.|
| [Insert](insert.md) | POST | `/api/v1/series/insert` | Insert a timestamped array of numbers for a given series identified by metric, entity, and series tags. |
| [CSV Insert](csv-insert.md) | POST | `api/v1/series/csv/{entity}` | Insert series values for the specified entity and series tags in CSV format.|
| [Delete](delete.md) | POST | `/api/v1/series/delete` | Delete series for the specified entity, metric, and optional series tags. |
