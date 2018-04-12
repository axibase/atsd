# Web Query Functions

## Overview

The functions in this section perform an HTTP request to external web service 
and return the result in the object with following fields:

**Field**    | **Type** | **Description**
-------------|----------|----------------
content      | string   | Response body
headers      | map      | Map of HTTP headers. Header values with the same name are separated by a comma.
status       | int      | HTTP response code
duration     | long     | Time in milliseconds between creating a request object and receiving response

### `webNotify`

```javascript
  webNotify(string c, map p) response
```

Perform a request using an existing web configuration `c` passing to it the parameters `p`

Example:

```javascript
  webNotify("Telegram", ["text": "Alert"])
```

### `queryUrl`

```javascript
  queryUrl(map c, map p) response
```

Perform a request using a temporary custom configuration 
built using web configuration parameters `c`. 
Request body is built from request parameters `p` according to provided content type.
Allowed configuration parameters: "url", "method", "contentType".
Default method is `POST`.
Default contentType is `application/json`

Example:

```javascript
  queryUrl(["url": "https://ipinfo.io/8.8.8.8/json", "method": "GET"], [])
```

### `queryUrl`

```javascript
  queryUrl(string u) response
```

Perform a GET request to URL `u` using a temporary custom configuration

Example:

```javascript
  queryUrl("https://ipinfo.io/8.8.8.8/json")
```