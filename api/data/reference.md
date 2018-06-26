# Data API Reference

## Series

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [Get](./series/get.md) | `GET` `/series/{format}/{entity}/{metric}` <br>  Retrieves series values for the specified entity, metric, and series tags in CSV and JSON format. |
| [Query](./series/query.md) | `POST` `/series/query` <br> Retrieves series values for the specified filters in JSON format. Supports advanced filtering and transformation options compare to [Get](./series/get.md) method.|
| [Insert](./series/insert.md) | `POST` `/series/insert`<br> Inserts a timestamped array of numbers for a given series identified by metric, entity, and series tags. |
| [CSV Insert](./series/csv-insert.md) | `POST` `/series/csv/{entity}` <br> Inserts series values for the specified entity and series tags in CSV format.|
|[Delete](./series/delete.md) | `POST` `/series/delete` <br> Deletes series for the specified entity, metric, and optional series tags. |

## Messages

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [Insert](./messages/insert.md) | `POST` `/messages/insert` <br>Inserts an array of messages.|
| [Webhook](./messages/webhook.md) | `POST` \| `GET` `/messages/webhook/*` <br>Creates message from an HTTP request with optional JSON payload and insert it.|
| [Query](./messages/query.md) | `POST` `/messages/query` <br>Retrieves message records for the specified filters.|
| [Delete](./messages/delete.md) | `-` `-` `-` <br>Executes administrative actions to delete message records. |
| [Count](./messages/count.md) | `POST` `/messages/stats/query` <br>Calculates the number of messages per period.|

## Properties

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [Get](./properties/get.md) | `GET` `/properties/{entity}/types/{type}` <br>Retrieves property records for the specified entity and type. |
| [Query](./properties/query.md) | `POST` `/properties/query` <br>Retrieves property records matching specified filters.|
| [List Types](./properties/list-types.md) | `GET` `/properties/{entity}/types` <br>Retrieves an array of property types for the entity. |
| [Insert](./properties/insert.md) | `POST` `/properties/insert` <br>Inserts an array of properties. |
| [Delete](./properties/delete.md) |`POST` `/properties/delete` <br>Deletes property records that match specified filters. |

## Alerts

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [Query](./alerts/query.md) | `POST` `/alerts/query` <br>Retrieves open alerts for specified filters. |
| [History Query](./alerts/history-query.md) | `POST` `/alerts/history/query` <br>Retrieves closed alerts for specified filters. |
| [Update](./alerts/update.md) | `POST` `/alerts/update` <br>Changes acknowledgement status of the specified open alerts. |
| [Delete](./alerts/delete.md) | `POST` `/alerts/delete` <br>Deletes specified alerts by id from the memory store. |

## SQL

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [SQL Query](../../sql/api.md) | `POST` `/api/sql` <br>Executes an SQL query and retrieves results in CSV or JSON format. |

## Extended

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [Command](./ext/command.md) | `POST` `/command` <br>Inserts data using commands in Network API via HTTP.|
| [CSV Upload](./ext/csv-upload.md) | `POST` `/csv` <br>Accepts CSV file or multiple CSV files for parsing into series, properties, or messages with the specified CSV parser.|
| [`nmon` Upload](./ext/nmon-upload.md) | `POST` `/nmon` <br>Accepts nmon file for parsing.|