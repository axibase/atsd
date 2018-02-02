## Overview

The Meta API lets you query and update metadata about metrics, entities, and entity groups in the Axibase Time Series Database.

## Categories

* [Metric](metric)
    - [get](metric/get.md)
    - [list](metric/list.md)
    - [update](metric/update.md)
    - [create or replace](metric/create-or-replace.md)
    - [delete](metric/delete.md)
    - [series](metric/series.md)
    - [series tags](metric/series-tags.md)
* [Entity](entity)
    - [get](entity/get.md)
    - [list](entity/list.md)
    - [update](entity/update.md)
    - [create or replace](entity/create-or-replace.md)
    - [delete](entity/delete.md)
    - [entity groups](entity/entity-groups.md)
    - [metrics](entity/metrics.md)
    - [property types](entity/property-types.md)
* [Entity group](entity-group)
    - [get](entity-group/get.md)
    - [list](entity-group/list.md)
    - [update](entity-group/update.md)
    - [create or replace](entity-group/create-or-replace.md)
    - [delete](entity-group/delete.md)
    - [get entities](entity-group/get-entities.md)
    - [add entities](entity-group/add-entities.md)
    - [set entities](entity-group/set-entities.md)
    - [delete entities](entity-group/delete-entities.md)
* [Misc](misc)
    - [search](misc/search.md)
    - [ping](misc/ping.md)
    - [version](misc/version.md)

## Request Methods

The API uses `GET`, `POST`, `PUT`, `PATCH`, and `DELETE` methods to read and write data.

## Request Headers

When submitting payload with `POST`, `PUT`, and `PATCH` methods in JSON format, add the header `Content-Type: application/json`.

For correct Unicode handling, specify the chartset `Content-Type: application/json;chartset=UTF-8`.

## URI Encoding

Requested parameter values and parameterized path segments such as [`/api/v1/metrics/{metric}`](metric/get.md#path-parameters) should be [URL encoded](https://tools.ietf.org/html/rfc3986#section-2.1) to translate special characters such as `: / ? # [ ] @` into a percent format that can be transmitted safely as part of the request URI.

| **Input** | **Encoded Value** | **URI** |
|:---|:---|:---|
|`jvm/memory(max)`|`jvm%2Fmemory%28max%29`| /api/v1/metrics/**jvm%2Fmemory%28max%29** |
|`name LIKE 'cpu*'`|`name%20LIKE%20%27cpu*%27`| /api/v1/metrics?**expression=name%20LIKE%20%27cpu*%27** |

Failure to encode URI components may result in 4xx and 5xx errors:

```json
Status Code: 500
{"error":"...HttpRequestMethodNotSupportedException: Request method 'GET' not supported"}
```

## Response Codes

* `200` status code if the request is successful.
* `401` status code in case of an unknown resource.
* `403` status code in case of access denied error.
* `4xx` status code in case of other client errors.
* `5xx` status code in case of server error.

4xx or 5xx response codes are specific to each API methods.

## Errors

Processing errors are returned in JSON format:

```json
{"error":"Empty first row"}
```

## Authentication

* User [authentication](../../administration/user-authentication.md) is required.
* All requests must be authenticated using BASIC AUTHENTICATION.
* The authentication method is **HTTP BASIC**.
* The client may enable session cookies to execute multiple requests without re-sending BASIC authentication header.

## Authorization

* User must have [**API_META_READ**/**API_META_WRITE**](../../administration/user-authorization.md#api-roles) role.

## Cross-domain Requests

Cross-domain requests are allowed.

## Compression

* Clients may send compressed data by adding the HTTP header **Content-Encoding: gzip** to the request.

## Troubleshooting

* Review error logs on the **Admin:Server Logs** page in case the payload is rejected
* To validate JSON received from a client, launch the `netcat` utility in server mode, reconfigure the client to send data to netcat port, and dump the incoming data to file:

```elm
nc -lk localhost 20088 > json-in.log &

curl http://localhost:20088/api/v1/metrics/cpu-used-total \
  -v -u {username}:{password} \
  -H "Content-Type: application/json" \
  -X PATCH \
  -d '{ "label": "CPU Busy Average" }'

cat json-in.log
```
