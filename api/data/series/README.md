# Data API: Series Methods

| **Name** | **Method** | **Path** | **Content-Type** | **Description** |
|:---|:---|:---|:---|:---|
| [Insert](insert.md) | POST | `/api/v1/series/insert` | `application/json` | Insert a timestamped array of numbers for a given series identified by metric, entity, and series tags. |
| [Query](query.md) | POST | `/api/v1/series/query` | `application/json` | Retrieve series with timestamped values for specified filters.|
| [CSV Insert](csv-insert.md) | POST | `api/v1/series/csv/{entity}` | `text/csv` | Insert series values for the specified entity and series tags in CSV format.|
| [URL Query](url-query.md) | GET | `/api/v1/series/{format}/{entity}/{metric}` |  | Retrieve series values for the specified entity, metric, and optional series tags in CSV and JSON format. |
