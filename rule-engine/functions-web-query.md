# Web Query Functions

## Overview

The functions in this section perform an HTTP request to external web service 
and return the result in the object with following fields:

**Field**    | **Type** | **Description**
-------------|----------|----------------
content      | string   | Response body
headers      | map      | Map of HTTP headers. Header values with the same name are separated by a comma.
contentType  | string   | Value of Content-Type header
responseCode | int      | HTTP response code
reasonPhrase | string   | HTTP Reason Phrase
duration     | long     | Time in milliseconds between creating a request object and receiving a response object

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
Allowed configuration parameters: "url", "method", "contentType"

Example:

```javascript
  queryUrl(["url": "https://api.telegram.org/bot1234567/sendMessage", "method": "POST", "contentType": "json"], ["chat_id": 123456, "text": "Alert"])
```

### `queryUrl`

```javascript
  queryUrl(string u) response
```

Perform a GET request to URL `u` using a temporary custom configuration

Example:

```javascript
  queryUrl("https://api.telegram.org/bot1234567/getMe")
```