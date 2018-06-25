# Data API: Messages Methods

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [Insert](./insert.md) | `POST` `/messages/insert` <br>Inserts an array of messages.|
| [Webhook](./webhook.md) | `POST` \| `GET` `/messages/webhook/*` <br>Creates message from an HTTP request with optional JSON payload and insert it.|
| [Query](./query.md) | `POST` `/messages/query` <br>Retrieves message records for the specified filters.|
| [Delete](./delete.md) | `-` `-` `-` <br>Executes administrative actions to delete message records. |
| [Count](./count.md) | `POST` `/messages/stats/query` <br>Calculates the number of messages per period.|