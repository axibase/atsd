# Overview

The Rest API lets you insert and retrieve series, properties, messages, and alerts from the Axibase Time Series Database as well as to manipulate metadata about the metrics and entities.

## Requests

### Request Methods

The API endpoints implement `GET` and `POST` methods to **read** data from the database and `POST`, `PUT`, `PATCH`, and `DELETE` methods to **write** data into the database.

### API Content Path

The API context path is `/api/v1/` and should include the current API version (`v1`).

Sample API endpoints:

```elm
/api/v1/series/query
/api/v1/series/insert
/api/v1/series/delete
```

### Request Headers

When submitting a payload in JSON format, add the `Content-Type: application/json;charset=UTF-8` header.

### URI Encoding

Request parameters and path segments, such as [`/api/v1/properties/{entity}/types`](../../api/meta/entity/property-types.md), should be [URL encoded](https://tools.ietf.org/html/rfc3986#section-2.1) to translate special characters, such as `: / ? # [ ] @`, into a percent format that can be transmitted safely as part of the request URI.

| **Input** | **Encoded Value** | **URI** |
|:---|:---|:---|
|`jvm/memory(max)`|`jvm%2Fmemory%28max%29`| `/api/v1/metrics/jvm%2Fmemory%28max%29` |
|`station/24`|`station%2F24`| `/api/v1/properties/station%2F24/types` |

Failure to encode URI components may result in 4xx and 5xx errors:

```json
Status Code: 500
{"error":"...HttpRequestMethodNotSupportedException: Request method 'GET' not supported"}
```

### Compression

Clients may send compressed payload by adding the **Content-Encoding: gzip** header to the request.

## Security

### Authentication

* User [authentication](../../administration/user-authentication.md) is required.
* All requests must be authenticated using `BASIC AUTHENTICATION`.
* Session cookies can be used to execute subsequent requests without re-sending `BASIC` authentication header

### Authorization

#### Data API Authorization

* The user must have the [**API_DATA_READ**/**API_DATA_WRITE**](../../administration/user-authorization.md#api-roles) role when making requests to `Data API` endpoints.
* The user must have read/write [**entity permission**](../../administration/user-authorization.md#entity-permissions) for the entities specified in the request and/or returned in the results.

#### Meta API Authorization

* The user must have the [**API_META_READ**/**API_META_WRITE**](../../administration/user-authorization.md#api-roles) role when making requests to `Meta API` endpoints.

### Cross-Domain Requests

Cross-domain requests are allowed.

## Schema and Syntax

### Dates

Supported date input patterns:

| Pattern | Example |
|---|---|
| `yyyy-MM-dd'T'HH:mm:ss[.SSS]'Z'` | `2018-05-15T00:00:00.002Z` |
| `yyyy-MM-dd'T'HH:mm:ss[.SSS]±hh:mm` | `2018-05-15T00:00:00-05:00` |

Refer to [date format examples](date-format.md).

* The minimum time that can be stored in the database is **1970-01-01T00:00:00.000Z**, or 0 milliseconds from Epoch time.
* The maximum date that can be stored by the database is **2106-02-07T06:59:59.999Z**, or 4294969199999 milliseconds from Epoch time.
* The maximum date that can be specified in ISO format when querying data is **9999-12-31T23:59:59.999** UTC.

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

### Response Codes

* `200` status code if the request is successful.
* `401` status code in case of an unknown resource.
* `403` status code in case of an access denied error.
* `4xx` status code in case of other client errors.
* `5xx` status code in case of server error.

`4xx` or `5xx` response codes are specific to each API method.

### Errors

Processing errors are returned in JSON format:

```json
{"error":"Empty first row"}
```

Authentication and authorization error codes are listed in the [Administation](../../administration/user-authentication.md#authentication-and-authorization-errors) guide.

## Troubleshooting

* Review error logs on the **Settings > Server Logs** page if the payload is rejected.
* To eliminate authentication issues, submit the request using the built-in API client on the **Data > API Client** page.
* To validate JSON received from a client, launch the `netcat` utility in server mode, reconfigure the client to send data to the netcat port, and dump the incoming data to file:

```bash
nc -lk 0.0.0.0 20088 > json-in.log &
```

```bash
curl http://localhost:20088/api/v1/series/insert \
  -v -u {username}:{password} \
  -H "Content-Type: application/json" \
  -X POST \
  -d '[{"entity": "nurswgvml007", "metric": "mpstat.cpu_busy", "data": [{ "t": 1462427358127, "v": 22.0 }]}]'
```

```bash
cat json-in.log
```

Each API method in this guide provides links to examples containing sample request and response objects.
