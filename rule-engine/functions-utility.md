# Utility Functions

## Reference

* [ifEmpty](#ifempty)
* [getURLHost](#geturlhost)
* [getURLPort](#geturlport)
* [getURLProtocol](#geturlprotocol)
* [getURLPath](#geturlpath)
* [getURLQuery](#geturlquery)
* [getURLUserInfo](#geturluserinfo)

### `ifEmpty`

```javascript
  ifEmpty(object a, object b) object
```

The function returns `b` if `a` is `null` or an empty string.

Example:

  ```javascript
    /* Returns 2 */  
    ifEmpty(null, 2)
    
    /* Returns hello */  
    ifEmpty('hello', 'world')
  ```

### `getURLHost`

```javascript
  getURLHost(string u) string
```
Retrieves a host from URL string `u`. If the URL `u` is null, empty or invalid, exception is thrown.

### `getURLPort`

```javascript
  getURLPort(string u) string
```
Retrieves a port from URL string `u`. If the URL `u` is `null`, empty or invalid, exception is thrown.

If the the URL `u` doesn't contain port, returns the default value for the protocol, e.g. 443 for `https` and 80 for `http`.

### `getURLProtocol`

```javascript
  getURLProtocol(string u) string
```
Retrieves a protocol from URL string `u`. If the URL `u` is null, empty or invalid, exception is thrown.

### `getURLPath`

```javascript
  getURLPath(string u) string
```
Retrieves a path from URL string `u`. If the URL `u` is null, empty or invalid, exception is thrown.

### `getURLQuery`

```javascript
  getURLQuery(string u) string
```
Retrieves a query from URL string `u`. If the URL `u` is null, empty or invalid, exception is thrown.

### `getURLUserInfo`

```javascript
  getURLUserInfo(string u) string
```
Retrieves a `user:password` string from URL string `u`. If the URL `u` is null, empty or invalid, exception is thrown.