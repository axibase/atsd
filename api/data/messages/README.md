# Data API: Messages Methods

| **Name** | **Method** | **Path** | **Content-Type** | **Description** |
|:---|:---|:---|:---|:---|
| [Insert](insert.md) | POST | `/api/v1/messages/insert` | `application/json` | Insert an array of messages.
| [Webhook](webhook.md) | POST / GET | `/api/v1/messages/webhook/*` | `application/json` / none | Create message from an HTTP request with optional JSON payload and insert it.
| [Query](query.md) | POST | `/api/v1/messages/query` | `application/json` | Retrieve message records for the specified filters. |
| [Delete](delete.md) | - | - | - | Execute administrative actions to delete message records. |
| [Count](count.md) | POST | `/api/v1/messages/stats/query` | `application/json` |  Calculate the number of messages per period.  |
