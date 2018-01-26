# Utility Functions

## Reference

* [ifEmpty](#ifempty)
* [getURLHost](#geturlhost)
* [getURLPort](#geturlport)
* [getURLProtocol](#geturlprotocol)
* [getURLPath](#geturlpath)
* [getURLQuery](#geturlquery)
* [getURLUserInfo](#geturluserinfo)
* [executeSqlQuery](#executesqlquery)

### `ifEmpty`

```javascript
  ifEmpty(object a, object b) object
```

The function returns `b` if `a` is `null` or an empty string.

Examples:

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
Retrieves the **host** part from URL string `u`. If the URL `u` is null, empty or invalid, exception is thrown.

Example:

  ```javascript
    /* Returns "axibase.com" */  
    getURLHost('https://axibase.com/en/products?type=database&status=1')
  ```

### `getURLPort`

```javascript
  getURLPort(string u) integer
```
Retrieves the **port** part from URL string `u`. If the URL `u` is `null`, empty or invalid, exception is thrown.

If the the URL `u` doesn't contain port, returns the default value for the protocol, for example port 443 for `https` and port 80 for `http`.

Example:

  ```javascript
    /* Returns 443 */  
    getURLPort('https://axibase.com/en/products?type=database&status=1')
  ```

### `getURLProtocol`

```javascript
  getURLProtocol(string u) string
```
Retrieves the **protocol** part from URL string `u`. If the URL `u` is null, empty or invalid, exception is thrown.

Example:

  ```javascript
    /* Returns "https" */  
    getURLProtocol('https://axibase.com/en/products?type=database&status=1')
  ```

### `getURLPath`

```javascript
  getURLPath(string u) string
```
Retrieves the **path** part from URL string `u`. If the URL `u` is null, empty or invalid, exception is thrown.

Example:

  ```javascript
    /* Returns "/en/products" */  
    getURLPath('https://axibase.com/en/products?type=database&status=1')
  ```
  
### `getURLQuery`

```javascript
  getURLQuery(string u) string
```
Retrieves the **query string** part from URL string `u`. If the URL `u` is null, empty or invalid, exception is thrown.

Example:

  ```javascript
    /* Returns "type=database&status=1" */  
    getURLQuery('https://axibase.com/en/products?type=database&status=1')
  ```
  
### `getURLUserInfo`

```javascript
  getURLUserInfo(string u) string
```
Retrieves the `user:password` part from URL string `u`. If the URL `u` is null, empty or invalid, exception is thrown.

Example:

  ```javascript
    /* Returns null */  
    getURLUserInfo('https://axibase.com/en/products?type=database&status=1')
    
    /* Returns "atsd_user:atsd_password" */  
    getURLUserInfo('https://atsd_user:atsd_password@axibase.com/en/products?type=database&status=1')
  ```
  
### `executeSqlQuery`

```javascript
  executeSqlQuery(string q) collection[collection[string]]
```
Returns the result of SQL query `q` to ATSD. The first row contains headers. 

Example:

```javascript
executeSqlQuery('SELECT datetime, value FROM http.sessions WHERE datetime > current_hour LIMIT 2')
```

The following result is returned:

```css
[[datetime, value], [2018-01-25T19:00:12.346Z, 1], [2018-01-25T19:00:27.347Z, 1]]
``` 