# Web Query Functions

## Overview

Web query functions execute an HTTP request to an external web service and return a [`WebRequestResult`](#response-object) response object for further processing.

## Reference

* [`queryConfig`](#queryconfig)
    * [Form](#content-type-is-form)
    * [JSON](#content-type-is-json)    
* [`queryGet`](#queryget)
* [`queryPost`](#querypost)
* [Request URL](#request-url)
* [Response Object](#response-object)
* [Examples](#examples)

### `queryConfig`

```javascript
  queryConfig(string n, [map p]) response
```

This function executes an HTTP request using a predefined [web notification](web-notifications.md), identified by name `n` (case-sensitive) and returns a `WebRequestResult` [response object](#response-object).

> The web notification `n` must be listed as `enabled` on the **Alerts > Web Notifications** page.

Parameters and placeholders defined in the web notification are replaced using the input map `p`.

Available parameters for built-in notification types are enumerated [here](params-map.md).

#### Content Type is Form

The form-based web notification defines parameters that can be modified in the rule editor.

The values for such parameters are retrieved from the input map `p`. Unknown parameters in map `p` are ignored.

![query config form](images/query-config-form.png)

```javascript
queryConfig("rc-hook", 
  ["channel": "devops", "repository": "atsd-site"]
)
```

The target URL will receive the following payload sent as `application/x-www-form-urlencoded`:

```ls
channel=devops&repository=atsd-site
```

#### Content Type is JSON

The JSON document defined in the web notification may include placeholders using `${name}` syntax.

Such placeholders are substituted with corresponding parameter values from the input map `p`. Unknown parameters in the map `p` are ignored.

![query config json](images/query-config-json.png)

```javascript
queryConfig("rc-hook", 
  ["channel": "devops", "repository": "atsd-site"]
)
```

The target URL will receive the following JSON payload sent as `application/json`:

```json
{
  "channel": "devops",
  "repository": "atsd-site"
}
```

### `queryGet`

```javascript
  queryGet(string u, [map c]) response
```

Execute a `GET` request to the specified [request URL](#request-url) `u` and return a `WebRequestResult` [response object](#response-object).

The configuration map `c` may contain the following fields:

* `headers` - Map of request headers keys and values.
* `params` - Map of request parameters appended to query string.
* `ignoreSsl` - Boolean field that controls SSL certificate validation. Default is `true`.

```javascript
  queryGet("https://ipinfo.io/1.1.1.1/json").content
```

### `queryPost`

```javascript
  queryPost(string u, [map c]) response
```

Execute a `POST` request to the specified [request URL](#request-url) `u` and return a `WebRequestResult` [response object](#response-object).

The configuration map `c` may contain the following fields:

* `contentType` - Content type of the request. Default is `application/json`.
* `content` - Request body text. 
* `headers` - Map of request headers keys and values.
* `params` - Map of request parameters.
* `ignoreSsl` - Boolean field that controls SSL certificate validation. Default is `true`.

The request payload can be specified using either `content` text or `params` map. 

The `params` map is serialized into a JSON document if content type is `application/json`. Otherwise it is converted to URL-encoded form format.

**JSON content type:**

```javascript
  queryPost(_url, 
    ["params": ["repository": "atsd-site", "channel": "devops"]]
  )
```

Payload:

```json
{ "repository": "atsd-site", "channel": "devops" }
```

**Form content type:**

```javascript
  queryPost(_url, [
     "contentType": "application/x-www-form-urlencoded", 
     "params": ["repository": "atsd-site", "channel": "devops"]
  ])
```

Payload:

```ls
repository=atsd-site&channel=devops
```

### Request URL

The request URL consists of schema (http/https), optional user credentials, hostname, port, and path with query string.

```ls
  scheme:[//[user:password@]host[:port]][/path][?query]
```

Examples:

```elm
  https://cuser:cpass@10.102.0.9:8443/service?load=true
```

```elm
  https://api.slack.com/sendMessage
```

### Response Object

**Field**    | **Type** | **Description**
-------------|----------|----------------
`content`      | string   | Response body text.
`status`       | integer  | Status code, such as `200` or `401`.
`headers`      | map      | Response headers. Header values with the same name are separated by a comma.
`duration`     | long     | Time, in milliseconds, between initiating a request and downloading the response.
`reasonPhrase` | string   | Status line such as `OK`.
`contentType`  | string   | Response content type, such as `application/json`.

```txt
WebRequestResult(
  content={
    "ip": "8.8.8.8",
    "country": "US",
    "org": "Example"
  },
  status=200,
  headers={
    Content-Type=application/json; charset=utf-8,
    Access-Control-Allow-Origin=*,
    Transfer-Encoding=chunked
  },
  duration=225,  
  reasonPhrase=OK,
  contentType=application/json; charset=utf-8
)
```

Response object can be introspected using the `printObject` function.

```javascript
printObject(queryPost({}))
```

```ls
+--------------+---------------------------------------------------------+
| Name         | Value                                                   |
+--------------+---------------------------------------------------------+
| class        | class                                                   |
|              |  com.axibase.tsd.model.notifications.WebRequestResult   |
| content      | {"success":true}                                        |
| contentType  | application/json                                        |
| duration     | 133                                                     |
| headers      | {Access-Control-Allow-Headers=Origin, X-Requested-With, |
|              |  Content-Type, Accept, Access-Control-Allow-Origin=*,   |
|              |  Cache-Control=no-store, Content-Type=application/json, |
|              |  Date=Wed, 18 Apr 2018 14:23:56 GMT, Pragma=no-cache,   |
|              |  Server=Caddy, Vary=Accept-Encoding,                    |
|              |  X-Instance-Id=gz6wtH9rkYaJpju99}                       |
| reasonPhrase | OK                                                      |
| status       | 200                                                     |
+--------------+---------------------------------------------------------+
```

### Examples

#### Send Request to a Webhook

Post message to an `Incoming Webhook` in [Rocket.Chat](https://rocket.chat/docs/administrator-guides/integrations/).

```javascript
  queryPost("https://chat_server:3000/hooks/1A1AbbbAAAa1bAAAa/xox-token", [  
      "params": ["channel": "#devops", "text": "Hello from ATSD!"]
  ])
```

Request payload:

```json
  {"channel":"#devops","text":"hello world"}
```

#### Post Message using REST API

Post message to Rocket.Chat group using [`sendMessage`](https://rocket.chat/docs/developer-guides/rest-api/chat/sendmessage/) REST API method.

```javascript
  queryPost("https://chat_server:3000/api/v1/chat.sendMessage", [
     "headers":[
        "X-Auth-Token": "botUserToken",
        "X-User-Id": "botUserId"
     ],
     "params": [
        "message": [ "rid": "GENERAL", "msg": "Hello, Rocket.Chat"]
     ]
  ])
```

Response `content`:

```json
{
  "message": {
    "rid": "GENERAL",
    "msg": "Hello, Rocket.Chat",
    "ts": "2018-04-24T11:31:45.728Z",
    "alias": "ATSD BOT",
    "u": {
      "_id": "userId",
      "username": "atsd_bot",
      "name": "ATSD BOT"
    },
    "unread": true,
    "mentions": [],
    "channels": [],
    "_updatedAt": "2018-04-24T11:31:45.731Z",
    "_id": "messageId"
  },
  "success": true
}
```

#### Execute a GraphQL Query

Retrieve results of a [GitHub GraphQL](https://developer.github.com/v4/query/) query.

```javascript
  queryPost("https://api.github.com/graphql", [
    "headers": ["Authorization" : "bearer TOKEN"],
    "params": [
      "query": "{ user(login:\"octocat\") { name login websiteUrl bio company createdAt location organizations(first: 1) {nodes { name login location description websiteUrl url }}}}"
    ]
  ])
```

Response `content`:

```json
{
  "data": {
    "user": {
      "name": "The Octocat",
      "login": "octocat",
      "websiteUrl": "http://www.github.com/blog",
      "bio": null,
      "company": "GitHub",
      "createdAt": "2011-01-25T18:44:36Z",
      "location": "San Francisco",
      "organizations": {
        "nodes": []
      }
    }
  }
}
```

#### Display Text Content

```javascript
  queryGet("https://ipinfo.io/1.1.1.1/json").content
```

Response `content`:

```json
  {
      "city": "Melbourne",
      "location": {
          "latitude": -37.7,
          "longitude": 145.1833
      },
      "ip": "1.1.1.1"
  }
```

#### Convert JSON response to a flat structure

```javascript
  flattenJson(queryGet("https://ipinfo.io/1.1.1.1/json").content)
```

```elm
  [
    "city" : "Melbourne",
    "location.latitude" : -37.7,
    "location.longitude" : 145.1833,
    "ip" : "1.1.1.1"
  ]
```

#### Display field values in the JSON response in a compact format

```javascript
  concatLines(flattenJson(queryGet("https://ipinfo.io/1.1.1.1/json").content).values())
```

```ls
  Melbourne
  -37.7
  145.1833
  1.1.1.1
```
