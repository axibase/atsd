# Meta API: Replacement Tables Methods

| **Name** | **Method** | **Path** | **Accept** | **Content-Type** | **Description** |
|:---|:---|:---|:---|:---|:----|
| [Get](get.md) | GET | `/api/v1/replacement-tables/{format}/{name}` | |  | Retrieve replacement table keys, values, and metadata. |
| [List](list.md) | GET | `/api/v1/replacement-tables/{format}` | | | Retrieve a list of replacement table names. |
| [Update](update.md) | PATCH | `/api/v1/replacement-tables/{format}/{name}` | | `application/json` |  Update values for existing keys or create new records. |
| [Create or Replace](create-or-replace.md) | PUT | `/api/v1/replacement-tables/{format}/{name}` | | `application/json` |  Create a replacement table or replace if exists. |
| [Delete](delete.md) | DELETE | `/api/v1/replacement-tables/{name}` | | |  Delete the specified replacement table. |
| 