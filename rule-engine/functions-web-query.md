# Web Query Functions

## Overview

The functions execute an HTTP request to an external web service and return the `response` object with the following fields:

**Field**    | **Type** | **Description**
-------------|----------|----------------
content      | string   | Response body text.
status       | int      | Status code, such as `200` or `401`.
headers      | map      | Response headers. Header values with the same name are separated by a comma.
duration     | long     | Time, in milliseconds, between initiating a request and downloading the response.

### `webNotify`

```javascript
  webNotify(string c, map p) response
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
  webNotify("slack-devops", ["text": "Alert"])
```

### `queryUrl`

```javascript
  queryUrl(map c, map p) response
```

Execute an HTTP request to the specified URL and return the `response` object.

The request configuration map `c` may contain the following request parameters:

* `url` (**required**) - Request URL including the schema, optional credentials, hostname, port, and path with query string.
* `contentType` - Content type of the request. Default contentType is `application/json`.
* `method` - HTTP request method. Default method is `POST`.

The parameter map `p` contains optional request parameters sent to the server.

Example:

```javascript
  queryUrl(["url": "https://ipinfo.io/8.8.8.8/json", "method": "GET"], [])
```

### `queryUrl`

```javascript
  queryUrl(string u) response
```

Execute a `GET` request to the specified request URL `u`. 

The request URL must include the schema, optional user credentials, hostname, port, and path with query string.

Example:

```javascript
  queryUrl("https://ipinfo.io/8.8.8.8/json")
  
  
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
  queryUrl("https://geoip.nekudo.com/api/1.1.1.1/en/short").content
  
  
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
  flattenJson(queryUrl("https://geoip.nekudo.com/api/1.1.1.1/en/short").content)
  
  
  /*
        Print response values each in a separate line, e.g.:
            Research
            Australia
            AU
            1000
            -37.7
            145.1833
            Australia/Melbourne
            1.1.1.1
     */
  concatLines(flattenJson(queryUrl("https://geoip.nekudo.com/api/1.1.1.1/en/short").content).values())
```
