# Webhook

## Overview

**Webhook** [notifications](../web-notifications.md) send a pre-defined payload containing all alert window fields to an external HTTP service. The subscribed service is responsible for parsing, handling, and reacting to the received event.

## Method

The payload is sent using the `POST` method.

## Content Types

You can choose to send the payload as a `JSON` document or HTML form parameters.

* `application/json`
* `application/x-www-form-urlencoded`

## Headers

The request will include standard HTTP headers: Content-Length, Content-Type, User-Agent, Host, Connection, Accept-Encoding.

## Message Signature

The message payload can be signed with the `SHA1` algorithm by filling out the `Secret` field, in which case outgoing requests will include a special header `x-axi-signature`.

This header contains the lower-cased `HMAC-SHA1` hex digest of the payload.

```
x-axi-signature: sha1=232c3cd1dedf9f5a5ac42bf63275b8b686ae53b6
```

When using the `application/x-www-form-urlencoded` content type, the message is prepared for signing by sorting request parameters by name, URL-encoding both parameter names and values, and then concatenating the sorted list of `name=value` pairs into a string using the ampersand `&` character as a separator.

Request headers are not included in the signed message content.

## Payload

The JSON payload includes all available alert fields as well as entity and metric metadata.

## Response

The response status code and response content is recorded in `atsd.log` if the `Log Response` setting is enabled.

## Testing

Click the `Test` button in the web notification form to send a sample request to the specified endpoint.

In order to test the actual payload, create a sample rule, and enable notifications on the `Web Notifications` tab.

You can use online resources such as `https://webhook.site` for troubleshooting.

## Examples

### Sample Headers

```
| Header Name      | Header Value                                  |
|------------------|-----------------------------------------------|
| accept-encoding  | gzip,deflate                                  |
| user-agent       | Apache-HttpClient/4.5.3 (Java/1.8.0_152)      |
| connection       | Keep-Alive                                    |
| host             | webhook.site                                  |
| content-type     | application/json; charset=UTF-8               |
| content-length   | 2183                                          |
| x-axi-signature  | sha1=c72af6519f478731d52fa0f197921e7b9de25932 |
```

### Sample Payload

```json
{
  "alert_duration": "00:00:00:00",
  "alert_duration_interval": "",
  "alert_message": "",
  "alert_open_datetime": "2017-12-01T13:30:28Z",
  "alert_open_time": "2017-12-01 13:30:28 GMT",
  "alert_type": "OPEN",
  "count": 1,
  "entity": "3a9ba2b3ae95531ae819877fa325fa36cedee6271eea0e089c7430f923b24e1a",
  "entity.enabled": true,
  "entity.id": 62494,
  "entity.label": "db-test-db2-10.5.0.5",
  "entity.name": "3a9ba2b3ae95531ae819877fa325fa36cedee6271eea0e089c7430f923b24e1a",
  "entity.tags": {
    "image-name": "db2express-c",
    "image": "sha256:7aa154d9b73c5587cc92c5abe92e935d8695ce7d1d2f5c128c7a0a26b6e9f176",
    "image-tags": "latest",
    "image-repository": "ibmcom",
    "hostname": "3a9ba2b3ae95",
    "ip-address": "172.17.0.12",
    "docker-type": "container",
    "name": "db-test-db2-10.5.0.5",
    "env.license": "accept",
    "env.path": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    "env.notvisible": "\"in users profile\"",
    "env.db2inst1_password": "********",
    "docker-host": "nurswghbs001",
    "image-repotags": "ibmcom/db2express-c:latest",
    "status": "running"
  },
  "event_datetime": "2017-12-01T13:30:22Z",
  "event_time": "2017-12-01 13:30:22 GMT",
  "expression": "value != 0 && entity.tags.status != 'exited' && entity.tags.status != 'deleted'",
  "message": "",
  "metric": "docker.tcp-connect-status",
  "metric.dataType": "FLOAT",
  "metric.enabled": true,
  "metric.id": 39418,
  "metric.interpolate": "LINEAR",
  "metric.invalidValueAction": "NONE",
  "metric.name": "docker.tcp-connect-status",
  "metric.persistent": true,
  "metric.seriesRetentionDays": 0,
  "metric.tags": {
    "category": "network"
  },
  "metric.timePrecision": "MILLISECONDS",
  "metric.versioning": false,
  "min_interval_expired": "",
  "open_value": 1,
  "properties": "",
  "received_datetime": "2017-12-01T13:30:28Z",
  "received_time": "2017-12-01 13:30:28.73 GMT",
  "repeat_count": 0,
  "repeat_interval": "",
  "rule": "docker-tcp-check_clone",
  "rule_expression": "value != 0 && entity.tags.status != 'exited' && entity.tags.status != 'deleted'",
  "rule_filter": "",
  "rule_name": "docker-tcp-check_clone",
  "schedule": "",
  "severity": "warning",
  "status": "OPEN",
  "tags": {
    "container-name": "db-test-db2-10.5.0.5",
    "external-port": "48002",
    "host": "172.17.0.12",
    "port": "50000"    
  },
  "value": 1,
  "window": "length(1)",
  "window_first_datetime": "2017-12-01T13:30:22Z",
  "window_first_time": "2017-12-01 13:30:22 GMT"
}
```
