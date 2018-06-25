# Data API: Series Methods

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [Get](./get.md) | `GET` `/series/{format}/{entity}/{metric}` <br>  Retrieves series values for the specified entity, metric, and series tags in CSV and JSON format. |
| [Query](./query.md) | `POST` `/series/query` <br> Retrieves series values for the specified filters in JSON format. Supports advanced filtering and transformation options compare to [Get](./get.md) method.|
| [Insert](./insert.md) | `POST` `/series/insert`<br> Inserts a timestamped array of numbers for a given series identified by metric, entity, and series tags. |
| [CSV Insert](./csv-insert.md) | `POST` `/series/csv/{entity}` <br> Inserts series values for the specified entity and series tags in CSV format.|
|[Delete](./delete.md) | `POST` `/series/delete` <br> Deletes series for the specified entity, metric, and optional series tags. |