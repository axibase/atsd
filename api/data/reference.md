# Data API Reference

## Series

| **Name** | **Method** | **Path** | **Content-Type** | **Description** |
|:---|:---|:---|:---|:---|
| [Insert](series/insert.md) | POST | `/api/v1/series/insert` | `application/json` | Insert a timestamped array of numbers for a given series identified by metric, entity, and series tags. |
| [CSV Insert](series/csv-insert.md) | POST | `api/v1/series/csv/{entity}` | `text/csv` | Insert series values for the specified entity and series tags in CSV format.|
| [Query](series/query.md) | POST | `/api/v1/series/query` | `application/json` | Retrieve series with timestamped values for specified filters.|
| [URL Query](series/url-query.md) | GET | `/api/v1/series/{format}/{entity}/{metric}` |  | Retrieve series values for the specified entity, metric, and optional series tags in CSV and JSON format. |
| [Delete](series/delete.md) | POST | `/api/v1/series/delete` | `application/json` | Delete series that match specified filters. |

## Properties

| **Name** | **Method** | **Path** | **Content-Type** | **Description** |
|:---|:---|:---|:---|:---|
| [Insert](properties/insert.md) | POST | `/api/v1/properties/insert` | `application/json` | Insert an array of properties. |
| [Query](properties/query.md) | POST | `/api/v1/properties/query` | `application/json` | Retrieve property records for specified filters. |
| [URL Query](properties/url-query.md) | GET | `/api/v1/properties/{entity}/types/{type}` |  | Retrieve property records for the specified entity and type. |
| [Type Query](properties/type-query.md) | GET | `/api/v1/properties/{entity}/types` |  | Retrieve an array of property types for the entity.  |
| [Delete](properties/delete.md) | POST | `/api/v1/properties/delete` | `application/json` | Delete property records that match specified filters. |

## Messages

| **Name** | **Method** | **Path** | **Content-Type** | **Description** |
|:---|:---|:---|:---|:---|
| [Insert](messages/insert.md) | POST | `/api/v1/messages/insert` | `application/json` | Insert an array of messages. |
| [Webhook](messages/webhook.md) | POST | `/api/v1/messages/webhook/*` | `application/json` | Convert the request into a message and store it. |
| [Query](messages/query.md) | POST | `/api/v1/messages/query` | `application/json` | Retrieve message records for the specified filters. |
| [Count](messages/count.md) | POST | `/api/v1/messages/stats/query` | `application/json` |  Calculate the number of messages per period.  |

## Alerts

| **Name** | **Method** | **Path** | **Content-Type** | **Description** |
|:---|:---|:---|:---|:---|
| [Query](alerts/query.md) | POST | `/api/v1/alerts/query` | `application/json` | Retrieve open alerts for specified filters. |
| [History Query](alerts/history-query.md) | POST | `/api/v1/alerts/history/query` | `application/json` | Retrieve a list of closed alerts matching specified fields. |
| [Update](alerts/update.md) | POST | `/api/v1/alerts/update` | `application/json` | Change acknowledgement status of the specified open alerts. |
| [Delete](alerts/delete.md) | POST | `/api/v1/alerts/delete` | `application/json` | Delete specified alerts by id from the memory store. |

## Extended

| **Name** | **Method** | **Path** | **Content-Type** | **Description** |
|:---|:---|:---|:---|:---|
| [Command](ext/command.md) | POST | `/api/v1/command` | `text/plain` | Insert data using commands in Network API via HTTP. |
| [CSV Upload](ext/csv-upload.md) | POST | `/api/v1/csv` | `multipart/*`<br>`text/csv`<br>`application/zip`<br>`application/gzip` | Upload CSV file or multiple CSV files for parsing into series, properties, or messages with the specified CSV parser. |
| [nmon Upload](ext/nmon-upload.md) | POST | `/api/v1/nmon` | `text/csv`<br>`text/plain` | Upload nmon file for parsing. |

## SQL

| **Name** | **Method** | **Path** | **Content-Type** | **Description** |
|:---|:---|:---|:---|:---|
| [SQL Query](../../sql/api.md) | POST | `/api/sql` | `text/plain` | Execute an SQL query and retrieve results in CSV or JSON format. |