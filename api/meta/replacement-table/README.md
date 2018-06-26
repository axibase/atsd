# Meta API: Replacement Tables Methods

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [get CSV](./get.md) | `GET` `/replacement-tables/csv/{name}` <br>Retrieves replacement table keys and values in CSV format and metadata in `Link` header. |
| [get JSON](./get.md) | `GET` `/replacement-tables/json/{name}`<br>Retrieves replacement table keys, values, and metadata in JSON format. |
| [list CSV](./list.md) | `GET` `/replacement-tables/csv` <br>Retrieves list of replacement table names in CSV format. |
| [list JSON](./list.md) | `GET` `/replacement-tables/json` <br> Retrieves list of replacement table names in JSON format. |
| [update CSV](./update.md) | `PATCH` `/replacement-tables/csv/{name}`<br>Updates values for existing keys or create new records from CSV file. |
| [update JSON](./update.md) | `PATCH` `/replacement-tables/json/{name}` <br>Updates replacement table and metadata from JSON document. |
| [create or replace CSV](./create-or-replace.md) | `PUT` `/replacement-tables/csv/{name}` <br>Creates a replacement table with specified records or replace if exists. |
| [create or replace JSON](./create-or-replace.md) | `PUT` `/replacement-tables/json/{name}` <br>Creates a replacement table with specified records and metadata, or replace if table already exists. |
| [delete](./delete.md) | `DELETE` `/replacement-tables/{name}` <br>Deletes specified replacement table. |