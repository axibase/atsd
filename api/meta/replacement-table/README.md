# Meta API: Replacement Tables Methods

| **Name** | **Method** | **Path** | **Accept** | **Content-Type** | **Description** |
|:---|:---|:---|:---|:---|:----|
| [Get](get.md) | GET | `/api/v1/replacement-tables/csv/{name}` | | `text/csv` | Retrieve replacement table keys and values in CSV format and metadata in Link header. |
| [Get](get.md) | GET | `/api/v1/replacement-tables/json/{name}` | | `application/json` | Retrieve replacement table keys, values, and metadata in JSON format. |
| [List](list.md) | GET | `/api/v1/replacement-tables/csv` | | `text/csv` | Retrieve a list of replacement table names in CSV format. |
| [List](list.md) | GET | `/api/v1/replacement-tables/json` | | `application/json` | Retrieve a list of replacement table names in JSON format. |
| [Update](update.md) | PATCH | `/api/v1/replacement-tables/csv/{name}` | `text/csv` | | Update values for existing keys or create new records from CSV file. |
| [Update](update.md) | PATCH | `/api/v1/replacement-tables/json/{name}` | `application/json` | |  Update replacement table and metadata from JSON document. |
| [Create or Replace](create-or-replace.md) | PUT | `/api/v1/replacement-tables/csv/{name}` | `text/csv` | | Create a replacement table with specified records or replace if exists. |
| [Create or Replace](create-or-replace.md) | PUT | `/api/v1/replacement-tables/json/{name}` | `application/json` | | Create a replacement table with specified records and metadata, or replace if exists. |
| [Delete](delete.md) | DELETE | `/api/v1/replacement-tables/{name}` | | |  Delete the specified replacement table. |
