## Overview

The Data API lets you insert and retrieve series, properties, messages, and alerts from the Axibase Time Series Database.

## Categories

* [Series](series#data-api-series-methods)
  - [insert](series/insert.md)
  - [query](series/query.md)
  - [csv insert](series/csv-insert.md)
  - [url query](series/url-query.md)
* [Properties](properties#data-api-properties-methods)
  - [insert](properties/insert.md)
  - [query](properties/query.md)
  - [url query](properties/url-query.md)
  - [type query](properties/type-query.md)
  - [delete](properties/delete.md)
* [Messages](messages#data-api-messages-methods)
  - [insert](messages/insert.md)
  - [webhook](messages/webhook.md)
  - [query](messages/query.md)
  - [delete](messages/delete.md)  
  - [statistics](messages/stats-query.md)
* [Alerts](alerts#data-api-alerts-methods)
  - [query](alerts/query.md)
  - [update](alerts/update.md)
  - [delete](alerts/delete.md)
  - [history query](alerts/history-query.md)
* [Extended](ext#data-api-extended-methods)
  - [command insert](ext/command.md)
  - [csv upload](ext/csv-upload.md)
  - [nmon upload](ext/nmon-upload.md)

## Request Methods

The API uses the `POST` method to read, write, and delete data except for [series url](series/url-query.md) and [property url](properties/url-query.md) queries.

## Request Headers

When submitting a payload with the `POST` method in JSON format, add the header `Content-Type: application/json`.

For correct Unicode handling, specify the charset `Content-Type: application/json;chartset=UTF-8`.

## URI Encoding

Request parameters and path segments, such as [`/api/v1/properties/{entity}/types`](../../api/meta/entity/property-types.md), should be [URL encoded](https://tools.ietf.org/html/rfc3986#section-2.1) to translate special characters, such as `: / ? # [ ] @`, into a percent format that can be transmitted safely as part of the request URI.

| **Input** | **Encoded Value** | **URI** |
|:---|:---|:---|
|`station/24`|`station%2F24`| /api/v1/properties/**station%2F24**/types |

Failure to encode URI components may result in 4xx and 5xx errors:

```json
Status Code: 500
{"error":"...HttpRequestMethodNotSupportedException: Request method 'GET' not supported"}
```

## Date/Time Formats

Supported date input formats:

* yyyy-MM-dd'T'HH:mm:ss[.SSS]'Z'
* yyyy-MM-dd'T'HH:mm:ss[.SSS]±hh:mm

Refer to [ISO 8601 date format examples](date-format.md).

* The minimum time that can be stored in the database is **1970-01-01T00:00:00.000Z**, or 0 millisecond from Epoch time.
* The maximum date that can be stored by the database is **2106-02-07T06:59:59.999Z**, or 4294969199999 milliseconds from Epoch time.
* The maximum date that can be specified in ISO format when querying data is **9999-12-31T23:59:59.999** UTC.

## Number Formatting

* The decimal separator is a period (`.`).
* No thousands separator.
* No digit grouping.
* Negative numbers use a negative sign (`-`) at the beginning of the number.
* Not-a-Number is the literal string `NaN` unless specified [otherwise](series/insert.md#fields).

## Syntax

* Entity name, metric name, property type, and key/tag names must consist of printable characters.
* Field names are case-insensitive and are converted to lower case when stored in the database.
* Field values are **case-sensitive** and are stored as submitted, except for entity name, metric name, and property type, which are converted to lower case.
* Values are stripped of starting and trailing line breaks (CR,LF symbols).

## Limits

The number of tags in the record cannot exceed the following limit:

| **Command** | **Maximum Tags** |
|:---|:---|
| series | 1024 series tags |
| property | 1024 keys and tags |
| message | 1024 message tags |

## Wildcards

When querying, wildcards `*` and `?` are supported in entity names and tag values.

The literal symbols `?` and `*` can be escaped with a single backslash.

## Response Codes

* `200` status code if the request is successful.
* `401` status code in case of an unknown resource.
* `403` status code in case of access denied error.
* `4xx` status code in case of other client errors.
* `5xx` status code in case of server error.

4xx or 5xx response codes are specific to each API method.

## Errors

Processing errors are returned in JSON format:

```json
{"error":"Empty first row"}
```

## Authentication

* User [authentication](../../administration/user-authentication.md) is required.
* All requests must be authenticated using BASIC AUTHENTICATION.
* The authentication method is **HTTP BASIC**.
* Session cookies can be used to execute multiple requests without repeating authentication.

## Authorization

* The user must have the [**API_DATA_READ**/**API_DATA_WRITE**](../../administration/user-authorization.md#api-roles) role.
* The user must have read/write [**entity permission**](../../administration/user-authorization.md#entity-permissions) for the entities specified in the request and/or returned in the results.

## Cross-Domain Requests

Cross-domain requests are allowed.

## Compression

* Clients may send compressed data by adding the HTTP header **Content-Encoding: gzip** to the request.

## Troubleshooting

* Review error logs on the **Admin:Server Logs** page if the payload is rejected.
* To validate JSON received from a client, launch the `netcat` utility in server mode, reconfigure the client to send data to the netcat port, and dump the incoming data to file:

```elm
nc -lk 0.0.0.0 20088 > json-in.log &

curl http://localhost:20088/api/v1/series/insert \
  -v -u {username}:{password} \
  -H "Content-Type: application/json" \
  -X POST \
  -d '[{"entity": "nurswgvml007", "metric": "mpstat.cpu_busy", "data": [{ "t": 1462427358127, "v": 22.0 }]}]'

cat json-in.log
```

## Examples

Each Data API method provides a set of examples containing sample request and response objects.

The response object illustrates all fields returned by the method.

Basic Java Examples:

* [Series Query](series/examples/DataApiSeriesQueryExample.java)
* [Series CSV Insert](series/examples/DataApiSeriesCsvInsertExample.java)
* [Properties Query](properties/examples/DataApiPropertiesQueryExample.java)
* [Message Query](messages/examples/DataApiMessagesQueryExample.java)
* [Command Insert](ext/examples/DataApiCommandInsertExample.java)
