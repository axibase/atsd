# Web Query Functions

## Overview

The functions execute an HTTP request to an external web service and return the `response` object with the following fields:

**Field**    | **Type** | **Description**
-------------|----------|----------------
content      | string   | Response body text.
status       | int      | Status code, such as `200` or `401`.
headers      | map      | Response headers. Header values with the same name are separated by a comma.
duration     | long     | Time, in milliseconds, between initiating a request and downloading the response.

### `queryConfig`

```javascript
  queryConfig(string c, map p) response
```

Execute an HTTP request using an existing web notification `c` and passing it a map of parameters `p`.

* The web notification must be listed on the **Alerts > Web Notifications** page.
* The name of the web notification `c` is case-sensitive.
* The web notification must be enabled.

The parameter map `p` is used to substitute placeholders in the given web notification.

If content type in configuration `c` is `application/x-www-form-urlencoded`, the exposed parameters and placeholders
with corresponding name will be substituted by values from `p`.

If content type in configuration `c` is `application/json`, the placeholders with corresponding name will be substituted by values from `p`.

Entries with unknown names in `p` will be ignored;

Example:

```javascript
  queryConfig("slack-devops", ["text": "Alert"])
```

### `queryGet`

```javascript
  queryGet(string u, [map c]) response
```

Execute a `GET` request to the specified request URL `u`. 

The request URL must include the schema, optional user credentials, hostname, port, and path with query string.

The request configuration map `c` may contain the following request parameters:

* `headers` - a map of request headers keys and values, or a collection of header entries separated by `:`.
* `params` - a map of request parameters sent to the server. They will be appended to query string parameters.
* `ignoreSsl` - skip SSL certificate validation. Default is `true`.

Example:

```javascript
  queryGet("https://ipinfo.io/8.8.8.8/json")
  
  
  /*
      return basic geoinformation about the city by IP address, e.g.:
      {
          "city": "Research",
          "country": {
              "name": "Australia",
              "code": "AU"
          },
          "location": {
              "accuracy_radius": 1000,
              "latitude": -37.7,
              "longitude": 145.1833,
              "time_zone": "Australia/Melbourne"
          },
          "ip": "1.1.1.1"
      }
  */
  queryGet("https://geoip.nekudo.com/api/1.1.1.1/en/short").content
  
  
  /*
      return the information as a key-value map. The result should be equal to creating the map in Rule Engine syntax like:
      [
          "city" : "Research",
          "country.name" : "Australia",
          "country.code" : "AU",
          "location.accuracy_radius" : 1000,
          "location.latitude" : -37.7,
          "location.longitude" : 145.1833,
          "location.time_zone" : "Australia/Melbourne",
          "ip" : "1.1.1.1"
      ]
   */
  flattenJson(queryGet("https://geoip.nekudo.com/api/1.1.1.1/en/short").content)
  
  
  /*
        Print response values each on a separate line, e.g.:
            Research
            Australia
            AU
            1000
            -37.7
            145.1833
            Australia/Melbourne
            1.1.1.1
     */
  concatLines(flattenJson(queryGet("https://geoip.nekudo.com/api/1.1.1.1/en/short").content).values())
```

### `queryPost`

```javascript
  queryPost(string u, [map c]) response
```

Execute a `POST` request to the specified request URL `u`. 

The request URL must include the schema, optional user credentials, hostname, port, and path with query string.

The request configuration map `c` may contain the following request parameters:

* `contentType` - Content type of the request. Default contentType is `application/json`.
* `headers` - a map of request headers keys and values, or a collection of header entries separated by `:`.
* `content` - request body. Either `content` or `params` may be specified.
* `params` - a map of request parameters sent to the server. They will be pre-processed according to the `contentType`.
* `ignoreSsl` - skip SSL certificate validation. Default is `true`.

Example:

```javascript
  // Post a message to Rocket.Chat
  queryPost("https://chat.company.com/hooks/1A1AbbbAAAa1bAAAa/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", ['params': ['channel': '#devops', 'text': "hello world"]])
  // request body: {"channel":"#devops","text":"hello world"}
```

```javascript
  printObject(queryPost("https://chat.company.com/hooks/1A1AbbbAAAa1bAAAa/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", ["params": ["channel": "#devops", "text": "hello world"]]), "ascii")
```

```
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