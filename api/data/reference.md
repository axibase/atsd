# Data API Reference

## Series

| **Name** | **Method** / **Path** | **Description** |
|:---|:---|:---|
| [Get](series/get.md) | `GET`<br>`/api/v1/series/{format}/{entity}/{metric}` | Retrieve series values for the specified entity, metric, and series tags in CSV and JSON format. |
| [Query](series/query.md) | `POST`<br>`/api/v1/series/query` | Retrieve series values for the specified filters in JSON format. Supports advanced filtering and transformation options compared to [Get](series/get.md) method. |
| [Insert](series/insert.md) | `POST`<br>`/api/v1/series/insert` | Insert a timestamped array of numbers for a given series identified by metric, entity, and series tags. |
| [CSV Insert](series/csv-insert.md) | `POST`<br>`api/v1/series/csv/{entity}` | Insert series values for the specified entity and series tags in CSV format.|
| [Delete](series/delete.md) | `POST`<br>`/api/v1/series/delete` | Delete series that match specified filters. |

## Properties

| **Name** | **Method** / **Path** | **Description** |
|:---|:---|:---|
| [Get](properties/get.md) | `GET`<br>`/api/v1/properties/{entity}/types/{type}` |  Retrieve property records for the specified entity and type. |
| [Query](properties/query.md) | `POST`<br>`/api/v1/properties/query` | Retrieve property records matching specified filters. |
| [List Types](properties/list-types.md) | `GET`<br>`/api/v1/properties/{entity}/types` | Retrieve an array of property types for the entity.  |
| [Insert](properties/insert.md) | `POST`<br>`/api/v1/properties/insert` | Insert an array of properties. |
| [Delete](properties/delete.md) | `POST`<br>`/api/v1/properties/delete` | Delete property records that match specified filters. |

## Messages

| **Name** | **Method** / **Path** | **Description** |
|:---|:---|:---|
| [Insert](messages/insert.md) | `POST`<br>`/api/v1/messages/insert` | Insert an array of messages. |
| [Webhook](messages/webhook.md) | `POST`<br>`/api/v1/messages/webhook/*` | Convert the request into a message and store it. |
| [Query](messages/query.md) | `POST`<br>`/api/v1/messages/query` | Retrieve message records for the specified filters. |
| [Count](messages/count.md) | `POST`<br>`/api/v1/messages/stats/query` | Calculate the number of messages per period.  |

## Alerts

| **Name** | **Method** / **Path** | **Description** |
|:---|:---|:---|
| [Query](alerts/query.md) | `POST`<br>`/api/v1/alerts/query` | Retrieve a list of open alerts matching specified filters. |
| [History Query](alerts/history-query.md) | `POST`<br>`/api/v1/alerts/history/query` | Retrieve a list of closed alerts matching specified fields. |
| [Update](alerts/update.md) | `POST`<br>`/api/v1/alerts/update` | Change acknowledgement status of the specified open alerts. |
| [Delete](alerts/delete.md) | `POST`<br>`/api/v1/alerts/delete` | Delete specified alerts by id from the memory store. |

## Extended

| **Name** | **Method** / **Path** | **Description** |
|:---|:---|:---|
| [Command](ext/command.md) | `POST`<br>`/api/v1/command` | Insert data using commands in Network API via HTTP. |
| [CSV Upload](ext/csv-upload.md) | `POST`<br>`/api/v1/csv` | Upload CSV file or multiple CSV files for parsing into series, properties, or messages with the specified CSV parser. |
| [nmon Upload](ext/nmon-upload.md) | `POST`<br>`/api/v1/nmon` | Upload nmon file for parsing. |

## SQL

| **Name** | **Method** / **Path** | **Description** |
|:---|:---|:---|
| [SQL Query](../../sql/api.md) | `POST`<br>`/api/sql` | Execute an SQL query and retrieve results in CSV or JSON format. |