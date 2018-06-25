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

Clients can send compressed payload by adding the **Content-Encoding: gzip** header to the request.

## Security

### Authentication

* User [authentication](../../administration/user-authentication.md) is required.
* All requests must be authenticated using `BASIC AUTHENTICATION`.
* Session cookies can be used to execute subsequent requests without re-sending `BASIC` authentication header

### Authorization

#### Data API Authorization

* The user must have the [**API_DATA_READ**/**API_DATA_WRITE**](../../administration/user-authorization.md#api-roles) role when making requests to `Data API` endpoints.
* The user must have read/write [**entity permission**](../../administration/user-authorization.md#entity-permissions) for the entities specified in the request and returned in the results.

#### Meta API Authorization

* The user must have the [**API_META_READ**/**API_META_WRITE**](../../administration/user-authorization.md#api-roles) role when making requests to `Meta API` endpoints.

### Cross-Domain Requests

Cross-domain requests are allowed.

## Schema and Syntax

### Dates

Supported date input patterns:

| Pattern | Example |
|---|---|
| `yyyy-MM-dd'T'HH:mm:ss[.SSS]'Z'` | `Z` denotes UTC time zone.<br>`2018-05-15T00:00:00Z`<br>`2018-05-15T00:00:00.002Z` |
| `yyyy-MM-dd'T'HH:mm:ss[.SSS]±hh[:]mm` | Offset from UTC time zone in hours and minutes.<br>`2018-05-15T00:00:00-05:00`<br>`2018-05-15T00:00:00-0500` |

Refer to [date format examples](date-format.md).

* The minimum time that can be stored in the database is `1970-01-01T00:00:00.000Z`, or 0 milliseconds from Unix time.
* The maximum date that can be stored by the database is `2106-02-07T06:59:59.999Z`, or 4294969199999 milliseconds from Unix time.
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

When querying, wildcards `*` and `?` are supported in entity names and tag values.

The literal symbols `?` and `*` can be escaped with a single backslash.

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

The endpoints listed below are accessible under the `/api/v1/` context path, for example `/api/v1/series/insert`.

### Series

| **Name** | **Method** / **Path** / **Description** |
|:---|:---|
| [Get](./series/get.md) | `GET` `/series/{format}/{entity}/{metric}` <br>  Retrieves series values for the specified entity, metric, and series tags in CSV and JSON format. |
| [Query](./series/query.md) | `POST` `/series/query` <br> Retrieves series values for the specified filters in JSON format. Supports advanced filtering and transformation options compare to [Get](./series/get.md) method.|
| [Insert](./series/insert.md) | `POST` `/series/insert`<br> Inserts a timestamped array of numbers for a given series identified by metric, entity, and series tags. |
| [CSV Insert](./series/csv-insert.md) | `POST` `/series/csv/{entity}` <br> Inserts series values for the specified entity and series tags in CSV format.|
|[Delete](./series/delete.md) | `POST` `/series/delete` <br> Deletes series for the specified entity, metric, and optional series tags. |

### Messages

| **Method** | **Path** / **Description** |
|:---|:---|
| `POST` | [`/messages/insert`](./messages/insert.md) <br>Inserts an array of messages.
| `POST` | [`/messages/webhook/`](./messages/webhook.md) <br>Creates message from an HTTP request with optional JSON payload and insert it.
| `POST` | [`/messages/query`](./messages/query.md)  <br>Retrieves message records for the specified filters. |
| - | [-](./messages/delete.md) <br>Executes administrative actions to delete message records. |
| `POST` | [`/messages/stats/query`](./messages/count.md) <br>Calculates the number of messages per period.  |

### Properties

| **Method** | **Path** / **Description** |
|:---|:---|
| `GET` | [`/properties/{entity}/types/{type}`](./properties/get.md) <br>Retrieves property records for the specified entity and type. |
| `POST` | [`/properties/query`](./properties/query.md) <br>Retrieves property records matching specified filters. |
| `GET` | [`/properties/{entity}/types`](./properties/list-types.md) <br>Retrieves an array of property types for the entity.  |
| `POST` | [`/properties/insert`](./properties/insert.md) <br>Inserts an array of properties. |
| `POST` | [`/properties/delete`](./properties/delete.md) <br>Deletes property records that match specified filters. |

### Extended

| **Method** | **Path** / **Description** |
|:---|:---|
| `POST` | [`/command`](./ext/command.md) <br>Inserts data using commands in Network API via HTTP. |
| `POST` | [`/csv`](./ext/csv-upload.md) <br>Accepts CSV file or multiple CSV files for parsing into series, properties, or messages with the specified CSV parser. |
| `POST` | [`/nmon`](./ext/nmon-upload.md) <br>Accepts nmon file for parsing. |

## Meta API Endpoints

The endpoints are accessed under context path `/api/v1/`, for example `/api/v1/version`.

### Metric

| **Method** | **Path** / **Description** |
|:---|:---|
| `GET` | [`/metrics/{metric}`](../meta/metric/get.md) <br> Retrieves properties and tags for the specified metric. |
| `GET` | [`/metrics`](../meta/metric/list.md) <br> Retrieves a list of metrics matching the specified filter conditions. |
| `PATCH` | [`/metrics/{metric}`](../meta/metric/update.md) <br> Updates fields and tags of the specified metric. |
| `PUT` | [`/metrics/{metric}`](../meta/metric/create-or-replace.md) <br> Creates a metric with specified fields and tags or replaces the fields and tags of an existing metric. |
| `DELETE` | [`/metrics/{metric}`](../meta/metric/delete.md) <br> Deletes the specified metric. |
| `GET` | [`/metrics/{metric}/series`](../meta/metric/series.md) <br> Returns a list of series for the metric. |
| `GET` | [`/metrics/{metric}/series/tags`](../meta/metric/series-tags.md) <br> Returns a list of unique series tag values for the metric. |

### Entity

| **Method** | **Path** / **Description** |
|:---|:---|
| `GET` | [`/entities/{entity}`](../meta/entity/get.md) <br> Retrieves information about the specified entity including its tags. |
| `GET` | [`/entities`](../meta/entity/list.md) <br> Retrieves a list of entities matching the specified filter conditions. |
| `PATCH` | [`/entities/{entity}`](../meta/entity/update.md) <br> Updates fields and tags of the specified entity.  |
| `PUT` | [`/entities/{entity}`](../meta/entity/create-or-replace.md) <br> Creates an entity with specified fields and tags or replaces the fields and tags of an existing entity.  |
| `DELETE` | [`/entities/{entity}`](../meta/entity/delete.md) <br> Deletes the specified entity and delete it as member from any entity groups that it belongs to.  |
| `GET` | [`/entities/{entity}/groups`](../meta/entity/entity-groups.md) <br> Retrieves a list of entity groups to which the specified entity belongs. |
| `GET` | [`/entities/{entity}/metrics`](../meta/entity/metrics.md) <br> Retrieves a list of metrics collected by the entity. |
| `GET` | [`/entities/{entity}/property-types`](../meta/entity/property-types.md) <br> Retrieves a list property types for the entity. |

### Entity Group

| **Method** | **Path** / **Description** |
|:---|:---|
| `GET` | [`/entity-groups/{group}`](../meta/entity-group/get.md) <br> Retrieves information about the specified entity group including its tags. |
| `GET` | [`/entity-groups`](../meta/entity-group/list.md) <br> Retrieves a list of entity groups. |
| `PATCH` | [`/entity-groups/{group}`](../meta/entity-group/update.md) <br> Updates fields and tags of the specified entity group.  |
| `PUT` | [`/entity-groups/{group}`](../meta/entity-group/create-or-replace.md) <br> Creates an entity group with specified fields and tags or replaces the fields and tags of an existing entity group.  |
| `DELETE` | [`/entity-groups/{group}`](../meta/entity-group/delete.md) <br> Deletes the specified entity group.  |
| `GET` | [`/entity-groups/{group}/entities`](../meta/entity-group/get-entities.md) <br> Retrieves a list of entities that are members of the specified entity group and are matching the specified filter conditions.  |
| `POST` | [`/entity-groups/{group}/entities/add`](../meta/entity-group/add-entities.md) <br> Adds entities as members to the specified entity group. |
| `POST` | [`/entity-groups/{group}/entities/set`](../meta/entity-group/set-entities.md) <br> Sets members of the entity group from the specified entity list. |
| `POST` | [`/entity-groups/{group}/entities/delete`](../meta/entity-group/delete-entities.md) <br> Removes specified entities from members of the specified entity group. |

### Miscellaneous

| **Method** | **Path** / **Description** |
|:---|:---|:---|
| `GET` | [`/version`](../meta/misc/version.md) <br> Returns database version including licensing details as well as a date object with local time and offset. |
| `GET` | [`/ping`](../meta/misc/ping.md) <br> Returns HTTP `200 OK` status code to check connectivity and authentication.|
| `GET` | [`/permissions`](../meta/misc/permissions.md) <br>  Returns roles and permissions for the current user. |
| `GET` | [`/search`](../meta/misc/search.md) <br> Search series by an expression. |