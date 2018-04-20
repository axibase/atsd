# Web Query Functions

## Overview

The web query functions execute an HTTP request to an external web service and return the `WebRequestResult` response object for further processing.

### Response Object

**Field**    | **Type** | **Description**
-------------|----------|----------------
content      | string   | Response body text.
status       | int      | Status code, such as `200` or `401`.
headers      | map      | Response headers. Header values with the same name are separated by a comma.
duration     | long     | Time, in milliseconds, between initiating a request and downloading the response.
content      | string   | Response body text.
reasonPhrase | string   | Status line such as `OK`.
contentType  | string   | Response content type, such as `application/json`.

```
WebRequestResult(
  status=200,
  reasonPhrase=OK,
  contentType=application/json; charset=utf-8,
  content={
    "ip": "8.8.8.8",
    "country": "US",
    "org": "Example"
  },
  headers={
    Content-Type=application/json; charset=utf-8,
    Access-Control-Allow-Origin=*,
    Transfer-Encoding=chunked
  },
  duration=225
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

### `queryConfig`

```javascript
  queryConfig(string c, map p) response
```

Executes an HTTP request using a predefined [web notification](web-notifications.md), identified by name `c`.

The function returns a `WebRequestResult` response object.

* The web notification must exist and be listed on the **Alerts > Web Notifications** page.
* The web notification must be enabled.
* The name `c` is case-sensitive.

The map of parameters `p` is used to set parameters and replace placeholders defined in the web notification.

#### Content Type is `application/x-www-form-urlencoded`

The form-based web notification defines a set of parameters that can be edited in the rule editor.

The values for such parameters are retrieved from the input map `p`.

Unknown parameters in the map `p` are ignored.

![query config form](images/query-config-form.png)

```javascript
queryConfig("rc-hook", ["repository": "atsd-site", "channel": "devops"])
```

The payload sent to the target web service will be assembled as follows.

```ls
channel=devops&repository=atsd-site
```

#### Content Type is `application/json`

The JSON payload in the web notification includes placeholders using `${name}` syntax.

Such placeholders are substituted with corresponding parameter values from the input map `p`.

Unknown parameters in the map `p` are ignored.

![query config json](images/query-config-json.png)

```javascript
queryConfig("rc-hook", ["repository": "atsd-site", "channel": "devops"])
```

The JSON document sent to the target web service will be as follows.

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

Execute a `GET` request to the specified request URL `u`.

The function returns a `WebRequestResult` response object.

The request URL consists of schema (http/https), optional user credentials, hostname, port, and path with query string.

  ```ls
  scheme:[//[user:password@]host[:port]][/path][?query]
  ```

Sample URL:

  ```ls
  https://cuser:cpass@10.102.0.9:8443/service?load=true
  ```

The configuration object `c` may contain the following fields:

* `headers` - Map of request headers keys and values, or a collection of header entries separated by `:`.
* `params` - Map of request parameters appended to query string.
* `ignoreSsl` - Boolean field that controls SSL certificate validation. Default is `true`.

Sample query to download a JSON document from a trusted web service without passing any headers or parameters.

### `queryPost`

```javascript
  queryPost(string u, [map c]) response
```

Execute a `POST` request to the specified request URL `u`.

The function returns a `WebRequestResult` response object.

The request URL consists of schema (http/https), optional user credentials, hostname, port, and path with query string.

  ```ls
  scheme:[//[user:password@]host[:port]][/path][?query]
  ```

Sample URL:

  ```ls
  https://cuser:cpass@10.102.0.9:8443/service?load=true
  ```

The configuration object `c` may contain the following fields:

* `contentType` - Content type of the request. Default contentType is `application/json`.
* `content` - request body text. Either `content` or `params` may be specified.
* `headers` - Map of request headers keys and values, or a collection of header entries separated by `:`.
* `params` - Map of request parameters serialized to text payload depending on the `contentType`.
* `ignoreSsl` - Boolean field that controls SSL certificate validation. Default is `true`.

The `params` map is serialized as a JSON document if content type is `application/json`. Otherwise it is converted to URL-encoded form format.

`params` map:

```javascript
["repository": "atsd-site", "channel": "devops"]
```

**JSON content type:**

```javascript
  queryPost(_url, ["params": ["repository": "atsd-site", "channel": "devops"]])
```

Payload:

```json
{ "repository": "atsd-site", "channel": "devops" }
```

**Form content type:**

```javascript
  queryPost(_url, ["contentType": "application/x-www-form-urlencoded", "params": ["repository": "atsd-site", "channel": "devops"]])
```

Payload:

```ls
repository=atsd-site&channel=devops
```

#### Example: Webhook

Post message to an Incoming Webhook in [Rocket.Chat](https://rocket.chat/docs/administrator-guides/integrations/)

```javascript
  queryPost("https://chat.company.com/hooks/1A1AbbbAAAa1bAAAa/xox-token", ['params': ['channel': '#devops', 'text': "Hello from ATSD!"]])
  // request body is: {"channel":"#devops","text":"hello world"}
```

#### Example: GraphQL

Retrieve results of a GraphQL query into [GitHub API v4](https://developer.github.com/v4/query/)

```graphql

```

```javascript
  queryPost("https://api.github.com/graphql", [
    "headers": ["Authorization" : "bearer TOKEN"],
    "params": ["query": "{ user(login:\"octocat\") { name login websiteUrl bio company createdAt location organizations(first: 1) {nodes { name login location description websiteUrl url }}}}"]
  ])
```

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

### Result Processing Examples

Display text content.

```javascript
  queryGet("https://ipinfo.io/1.1.1.1/json").content
```

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

Convert the JSON response to a flat structure.

```javascript
  flattenJson(queryGet("https://ipinfo.io/1.1.1.1/json").content)
```

```json
  [
    "city" : "Melbourne",
    "location.latitude" : -37.7,
    "location.longitude" : 145.1833,
    "ip" : "1.1.1.1"
  ]
```

Display field values in the JSON response in a compact format.

```javascript
  concatLines(flattenJson(queryGet("https://ipinfo.io/1.1.1.1/json").content).values())
```

```ls
  Melbourne
  -37.7
  145.1833
  1.1.1.1
```