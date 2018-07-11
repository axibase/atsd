# REST API

The REST API allows you to insert and retrieve data from the database using HTTP requests.

## Requests

### Request Methods

To **read** data from the database, use `GET` and `POST` methods.

To **write** data into the database, use `POST`, `PUT`, `PATCH`, and `DELETE` methods.

### API Content Path

The API context path is `/api/v1/` and must include the current `v1` API version.

Sample API endpoints:

```elm
/api/v1/series/query
/api/v1/series/insert
/api/v1/series/delete
```

### Request Headers

When submitting a payload in JSON format, add the `Content-Type: application/json;charset=UTF-8` header.

### URI Encoding

Request parameters and path segments, such as [`/api/v1/properties/{entity}/types`](../meta/entity/property-types.md), must be [URL encoded](https://tools.ietf.org/html/rfc3986#section-2.1) to translate special characters, such as `: / ? # [ ] @`, into a percent format that can be transmitted safely as part of the request URI.

| **Input** | **Encoded Value** | **URI** |
|:---|:---|:---|
|`jvm/memory(max)`|`jvm%2Fmemory%28max%29`| `/api/v1/metrics/jvm%2Fmemory%28max%29` |
|`station/24`|`station%2F24`| `/api/v1/properties/station%2F24/types` |

Failure to properly encode URI components results in HTTP `4xx` and `5xx` errors.

```json
{"error":"...HttpRequestMethodNotSupportedException: Request method 'GET' not supported"}
```

### Compression

Clients can send compressed payload by adding the `Content-Encoding: gzip` header to the request.

## Security

### Authentication

* User [authentication](../../administration/user-authentication.md) is required.
* All requests must be authenticated using `BASIC AUTHENTICATION`.
* Session cookies can be used to execute subsequent requests without re-sending `BASIC` authentication header

### Authorization

#### Data API Authorization

* The user must have the [`API_DATA_READ`/`API_DATA_WRITE`](../../administration/user-authorization.md#api-roles) role when making requests to **Data API** endpoints.
* The user must have read/write [**entity permission**](../../administration/user-authorization.md#entity-permissions) for the entities specified in the request and returned in the results.

#### Meta API Authorization

* The user must have the [`API_META_READ`/`API_META_WRITE`](../../administration/user-authorization.md#api-roles) role when making requests to **Meta API** endpoints.

### Cross-Domain Requests

Cross-domain requests are allowed.

## Schema and Syntax

### Dates

Supported date input patterns:

| Pattern | Example |
|---|---|
| `yyyy-MM-dd'T'HH:mm:ss[.S]'Z'` | `Z` denotes UTC time zone.<br>`2018-05-15T00:00:00Z`<br>`2018-05-15T00:00:00.002Z` |
| `yyyy-MM-dd'T'HH:mm:ss[.S]±hh[:]mm` | Offset from UTC time zone in hours and minutes.<br>`2018-05-15T00:00:00-05:00`<br>`2018-05-15T00:00:00-0500` |

Refer to [date format](date-format.md) rules and examples.

* The minimum time that can be stored in the database is `1970-01-01T00:00:00.000Z`, or `0` milliseconds from Unix time.
* The maximum date that can be stored by the database is `2106-02-07T06:59:59.999Z`, or `4294969199999` milliseconds from Unix time.
* The maximum year that can be specified in ISO format when `querying` data is `9999` and the maximum date is `9999-12-31T23:59:59.999` UTC.

### Numbers

* The decimal separator is a period (`.`).
* No thousands separator is allowed.
* No digit grouping is allowed.
* Negative numbers must start with a negative sign (`-`).
* Not-a-Number is the literal string `NaN` unless specified [otherwise](series/insert.md#fields).

### Strings

* Entity name, metric name, property type, and key/tag names must consist of printable characters.
* Field **names** are case-insensitive and are converted to lowercase when stored in the database.
* Field **values** are **case-sensitive** and are stored as submitted, except for entity name, metric name, and property type, which are converted to lowercase.
* Values are stripped of starting and trailing line breaks (CR,LF symbols).

### Wildcards

Wildcard characters asterisk (`*`) and question mark (`?`) are supported in entity name and tag value filters.

The literal symbols `*` and `?` can be escaped with a single backslash.

### Limits

The number of tags in the inserted record cannot exceed the following limit:

| **Command** | **Maximum Tags** |
|:---|:---|
| series | 1024 series tags |
| property | 1024 keys and tags |
| message | 1024 message tags |

## Responses

### HTTP Status Codes

* `200 OK` status code if the request is successful.
* `401 Unauthorized` status code in case of an unknown resource.
* `403 Forbidden` status code in case of an access denied error.
* `4xx` status code in case of other client errors.
* `5xx` status code in case of server error.

### Errors

Processing errors are returned in JSON format:

```json
{"error":"Empty first row"}
```

Authentication and authorization error codes are listed in the [Administration](../../administration/user-authentication.md#authentication-and-authorization-errors) guide.

## Troubleshooting

* Review error logs on the **Settings > Diagnostics > Server Logs** page if the payload is rejected.
* To eliminate authentication issues, submit the request using the built-in API client on the **Data > API Client** page.
* To validate JSON received from a client, launch the `netcat` utility in server mode, reconfigure the client to send data to the `netcat` port, and dump the incoming data to file:

```bash
nc -lk 0.0.0.0 20088 > json-in.log &
```

```bash
curl http://localhost:20088/api/v1/series/insert \
  -v -u {username}:{password} \
  -H "Content-Type: application/json" \
  -d '[{"entity": "nurswgvml007", "metric": "mpstat.cpu_busy", "data": [{ "t": 1462427358127, "v": 22.0 }]}]'
```

```bash
cat json-in.log
```

Each API method below provides examples containing sample request and response objects.

## Data API Endpoints

The endpoints listed below are accessible under the `/api/v1/` context path, for example `/api/v1/series/insert`, except [SQL](#sql).

### Series

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [get](./series/get.md) | `GET` `/series/{format}/{entity}/{metric}` <br>  Retrieves series values for the specified entity, metric, and series tags in CSV and JSON format. |
| [query](./series/query.md) | `POST` `/series/query` <br> Retrieves series values for the specified filters in JSON format. Supports advanced filtering and transformation options compare to [get](./series/get.md) method.|
| [insert](./series/insert.md) | `POST` `/series/insert`<br> Inserts a timestamped array of numbers for a given series identified by metric, entity, and series tags. |
| [insert CSV](./series/csv-insert.md) | `POST` `/series/csv/{entity}` <br> Inserts series values for the specified entity and series tags in CSV format.|
| [delete](./series/delete.md) | `POST` `/series/delete` <br> Deletes series for the specified entity, metric, and optional series tags. |

### Messages

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [insert](./messages/insert.md) | `POST` `/messages/insert` <br>Inserts an array of messages.|
| [webhook](./messages/webhook.md) | `POST` \| `GET` `/messages/webhook/*` <br>Creates message from an HTTP request with optional JSON payload and insert it.|
| [query](./messages/query.md) | `POST` `/messages/query` <br>Retrieves message records for the specified filters.|
| [delete](./messages/delete.md) | `-` `-` `-` <br>Executes administrative actions to delete message records. |
| [count](./messages/count.md) | `POST` `/messages/stats/query` <br>Calculates the number of messages per period.|

### Properties

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [get](./properties/get.md) | `GET` `/properties/{entity}/types/{type}` <br>Retrieves property records for the specified entity and type. |
| [query](./properties/query.md) | `POST` `/properties/query` <br>Retrieves property records matching specified filters.|
| [get types](./properties/list-types.md) | `GET` `/properties/{entity}/types` <br>Retrieves an array of property types for the entity. |
| [insert](./properties/insert.md) | `POST` `/properties/insert` <br>Inserts an array of properties. |
| [delete](./properties/delete.md) |`POST` `/properties/delete` <br>Deletes property records that match specified filters. |

### Alerts

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [query](./alerts/query.md) | `POST` `/alerts/query` <br>Retrieves open alerts for specified filters. |
| [history query](./alerts/history-query.md) | `POST` `/alerts/history/query` <br>Retrieves closed alerts for specified filters. |
| [update](./alerts/update.md) | `POST` `/alerts/update` <br>Changes acknowledgement status of the specified open alerts. |
| [delete](./alerts/delete.md) | `POST` `/alerts/delete` <br>Deletes specified alerts by id from the memory store. |

### SQL

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [SQL query](../../sql/api.md) | `POST` `/api/sql` <br>Executes an SQL query and retrieves results in CSV or JSON format. |
| [SQL meta query](../../sql/api-meta.md)| `POST` `/api/sql/meta` <br>Retrieves SQL query result metadata in JSON format without executing the query. |

### Extended

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [command](./ext/command.md) | `POST` `/command` <br>Inserts data using commands in Network API via HTTP.|
| [upload CSV](./ext/csv-upload.md) | `POST` `/csv` <br>Accepts CSV file or multiple CSV files for parsing into series, properties, or messages with the specified CSV parser.|
| [upload `nmon`](./ext/nmon-upload.md) | `POST` `/nmon` <br>Accepts nmon file for parsing.|

## Meta API Endpoints

The endpoints are accessed under context path `/api/v1/`, for example `/api/v1/version`.

### Metric

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [get](../meta/metric/get.md) | `GET` `/metrics/{metric}`<br> Retrieves properties and tags for the specified metric. |
| [list](../meta/metric/list.md) | `GET` `/metrics` <br> Retrieves a list of metrics matching the specified filter conditions.|
| [update](../meta/metric/update.md) | `PATCH` `/metrics/{metric}` <br> Updates fields and tags of the specified metric.|
| [create or replace](../meta/metric/create-or-replace.md) | `PUT` `/metrics/{metric}`<br> Creates a metric with specified fields and tags or replaces the fields and tags of an existing metric.|
| [delete](../meta/metric/delete.md) | `DELETE` `/metrics/{metric}` <br> Deletes the specified metric.|
| [series](../meta/metric/series.md) | `GET` `/metrics/{metric}/series` <br> Returns a list of series for the metric. |
| [series tags](../meta/metric/series-tags.md) | `GET` `/metrics/{metric}/series/tags` <br> Returns a list of unique series tag values for the metric.|

### Entity

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [get](../meta/entity/get.md) | `GET` `/entities/{entity}` <br> Retrieves information about the specified entity including its tags. |
| [list](../meta/entity/list.md) | `GET` `/entities` <br> Retrieves a list of entities matching the specified filter conditions.|
| [update](../meta/entity/update.md) | `PATCH` `/entities/{entity}` <br> Updates fields and tags of the specified entity.|
| [create or replace](../meta/entity/create-or-replace.md) | `PUT` `entities/{entity}` <br> Creates an entity with specified fields and tags or replaces the fields and tags of an existing entity.|
| [delete](../meta/entity/delete.md) | `DELETE` `/entities/{entity}` <br> Deletes the specified entity and delete it as member from any entity groups that it belongs to.|
| [entity groups](../meta/entity/entity-groups.md) | `GET` `/entities/{entity}/groups` <br> Retrieves a list of entity groups to which the specified entity belongs. |
| [metrics](../meta/entity/metrics.md) | `GET` `/entities/{entity}/metrics` <br> Retrieves a list of metrics collected by the entity.|
| [property types](../meta/entity/property-types.md) | `GET` `/entities/{entity}/property-types` <br> Retrieves a list property types for the entity.|

### Entity Group

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [get](../meta/entity-group/get.md) | `GET` `/entity-groups/{group}`<br> Retrieves information about the specified entity group including its tags.|
| [list](../meta/entity-group/list.md) | `GET` `/entity-groups` <br> Retrieves a list of entity groups.|
| [update](../meta/entity-group/update.md) | `PATCH` `/entity-groups/{group}` <br> Updates fields and tags of the specified entity group.|
| [create or replace](../meta/entity-group/create-or-replace.md) | `PUT` `/entity-groups/{group}`<br> Creates an entity group with specified fields and tags or replaces the fields and tags of an existing entity group.|
| [delete](../meta/entity-group/delete.md) | `DELETE` `/entity-groups/{group}` <br> Deletes the specified entity group.|
| [get entities](../meta/entity-group/get-entities.md) | `GET` `/entity-groups/{group}/entities`<br> Retrieves a list of entities that are members of the specified entity group and are matching the specified filter conditions. |
| [add entities](../meta/entity-group/add-entities.md) | `POST` `/entity-groups/{group}/entities/add`<br> Adds entities as members to the specified entity group.|
| [set entities](../meta/entity-group/set-entities.md) | `POST` `/entity-groups/{group}/entities/set`<br> Sets members of the entity group from the specified entity list.|
| [delete entities](../meta/entity-group/delete-entities.md) | `POST` `/entity-groups/{group}/entities/delete`<br> Removes specified entities from members of the specified entity group. |

### Replacement Tables

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [get CSV](../meta/replacement-table/get.md) | `GET` `/replacement-tables/csv/{name}` <br>Retrieves replacement table keys and values in CSV format and metadata in `Link` header. |
| [get JSON](../meta/replacement-table/get.md) | `GET` `/replacement-tables/json/{name}`<br>Retrieves replacement table keys, values, and metadata in JSON format. |
| [list CSV](../meta/replacement-table/list.md) | `GET` `/replacement-tables/csv` <br>Retrieves list of replacement table names in CSV format. |
| [list JSON](../meta/replacement-table/list.md) | `GET` `/replacement-tables/json` <br> Retrieves list of replacement table names in JSON format. |
| [update CSV](../meta/replacement-table/update.md) | `PATCH` `/replacement-tables/csv/{name}`<br>Updates values for existing keys or create new records from CSV file. |
| [update JSON](../meta/replacement-table/update.md) | `PATCH` `/replacement-tables/json/{name}` <br>Updates replacement table and metadata from JSON document. |
| [create or replace CSV](../meta/replacement-table/create-or-replace.md) | `PUT` `/replacement-tables/csv/{name}` <br>Creates a replacement table with specified records or replace if exists. |
| [create or replace JSON](../meta/replacement-table/create-or-replace.md) | `PUT` `/replacement-tables/json/{name}` <br>Creates a replacement table with specified records and metadata, or replace if table already exists. |
| [delete](../meta/replacement-table/delete.md) | `DELETE` `/replacement-tables/{name}` <br>Deletes specified replacement table. |

### Miscellaneous

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [version](../meta/misc/version.md) | `GET` `/version`<br> Returns database version including licensing details as well as a date object with local time and offset. |
| [ping](../meta/misc/ping.md) | `GET` `/ping` <br> Returns HTTP `200 OK` status code to check connectivity and authentication.|
| [permissions](../meta/misc/permissions.md)| `GET` `/permissions` <br>  Returns roles and permissions for the current user.|
| [series search](../meta/misc/search.md) | `GET` `/search` <br> Search series by an expression.|