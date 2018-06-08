# Overview

The Meta API lets you query and update metadata about metrics, entities, and entity groups in the Axibase Time Series Database.

## Request Methods

The API uses `GET`, `POST`, `PUT`, `PATCH`, and `DELETE` methods to read and write data.

## Request Headers

When submitting payload with `POST`, `PUT`, and `PATCH` methods in JSON format, add the header `Content-Type: application/json`.

For correct Unicode handling, specify the charset `Content-Type: application/json;charset=UTF-8`.

## URI Encoding

Requested parameter values and parameterized path segments such as [`/api/v1/metrics/{metric}`](metric/get.md#path-parameters) should be [URL encoded](https://tools.ietf.org/html/rfc3986#section-2.1) to translate special characters such as `: / ? # [ ] @` into a percent format that can be transmitted safely as part of the request URI.

| **Input** | **Encoded Value** | **URI** |
|:---|:---|:---|
|`jvm/memory(max)`|`jvm%2Fmemory%28max%29`| `/api/v1/metrics/jvm%2Fmemory%28max%29` |
|`name LIKE 'cpu*'`|`name%20LIKE%20%27cpu*%27`| `/api/v1/metrics?expression=name%20LIKE%20%27cpu*%27` |

Failure to encode URI components may result in HTTP `4xx` and `5xx` status codes:

```json
Status Code: 500
{"error":"...HttpRequestMethodNotSupportedException: Request method 'GET' not supported"}
```

## HTTP Status Codes

* `200 OK` status code if the request is successful.
* `401 Unauthorized` status code in case of an unknown resource.
* `403 Forbidden` status code in case of an access denied error.
* `4xx` status code in case of other client errors.
* `5xx` status code in case of server error.

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

* Review error logs on the **Settings > Diagnostics > Server Logs** page in case the payload is rejected.
* To eliminate authentication issues, submit the request using the built-in API client on the **Data > API Client** page.
* To validate JSON received from a client, launch the `netcat` utility in server mode, reconfigure the client to send data to `netcat` port, and dump the incoming data to file:

```bash
nc -lk localhost 20088 > json-in.log &
```

```bash
curl http://localhost:20088/api/v1/metrics/cpu-used-total \
  -v -u {username}:{password} \
  -H "Content-Type: application/json" \
  -X PATCH \
  -d '{ "label": "CPU Busy Average" }'
```

```bash
cat json-in.log
```
