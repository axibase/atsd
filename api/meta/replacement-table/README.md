# Meta API: Replacement Tables Methods

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [Get](get.md) | `GET` `/replacement-tables/csv/{name}` <br>Retrieves replacement table keys and values in CSV format and metadata in `Link` header. |
| [Get](get.md) | `GET` `/replacement-tables/json/{name}`<br>Retrieves replacement table keys, values, and metadata in JSON format. |
| [List](list.md) | `GET` `/replacement-tables/csv` <br>Retrieves list of replacement table names in CSV format. |
| [List](list.md) | `GET` `/replacement-tables/json` <br> Retrieves list of replacement table names in JSON format. |
| [Update](update.md) | `PATCH` `/replacement-tables/csv/{name}`<br>Updates values for existing keys or create new records from CSV file. |
| [Update](update.md) | `PATCH` `/replacement-tables/json/{name}` <br>Updates replacement table and metadata from JSON document. |
| [Create or Replace](create-or-replace.md) | `PUT` `/replacement-tables/csv/{name}` <br>Creates a replacement table with specified records or replace if exists. |
| [Create or Replace](create-or-replace.md) | `PUT` `/replacement-tables/json/{name}` <br>Creates a replacement table with specified records and metadata, or replace if table already exists. |
| [Delete](delete.md) | `DELETE` `/replacement-tables/{name}` <br>Deletes specified replacement table. |