# Utility Functions

## Reference

* [`ifEmpty`](#ifempty)
* [`toBoolean`](#toboolean)
* [`toNumber`](#tonumber)
* [`getURLHost`](#geturlhost)
* [`getURLPort`](#geturlport)
* [`getURLProtocol`](#geturlprotocol)
* [`getURLPath`](#geturlpath)
* [`getURLQuery`](#geturlquery)
* [`getURLUserInfo`](#geturluserinfo)
* [`printObject`](#printobject)

## `ifEmpty`

```javascript
  ifEmpty(object a, object b) object
```

The function returns `b` if `a` is either `null` or an empty string.

Examples:

```javascript
    /* Returns 2 */
    ifEmpty(null, 2)

    /* Returns hello */
    ifEmpty('hello', 'world')
```

## `toBoolean`

```javascript
  toBoolean(object a) boolean
```

Converts the input string or number `a` to a boolean value. `true` is returned by the function if the input `a` is a string "true", "yes", "on", "1" (case-**IN**sensitive) or if `a` is equal to the number `1`.

Value table:

Input | Type | boolean
----|---|---
yes | string | `true`
YES | string | `true`
on | string | `true`
1 | string | `true`
1 | number | `true`
no | string | `false`
NO | string | `false`
hello | string | `false`
0 | string | `false`
0 | number | `false`
3 | number | `false`

Examples:

```javascript
  // Returns false
  toBoolean('hello')
  toBoolean(0)
  toBoolean('off')
```

```javascript
  // Returns true
  toBoolean('YES')
  toBoolean(1)
  toBoolean('On')
```

## `toNumber`

```javascript
  toNumber(object a) number
```

Converts input object to number. If `a` is null or blank string, function returns `0`.
If `a` is number, function returns `a` without modification.
If `a` is not a string or cannot be parsed as number, function returns `Double.NaN`.
Otherwise, function returns the most appropriate numeric type for `a`.

Value table:

Input | Result
----|---
null | 0
"" | 0
" " | 0
"not a number" | NaN
[] | NaN
0 | 0
1 | 1
"0" | 0
"1" | 1
"1L" | 1 (Long)
"1.0" | 1.0 (Float)
"1.0f" | 1.0 (Float)
"1.0d" | 1.0 (Double)

## `printObject`

```javascript
  printObject(object o, string f) string
```

The function prints the input object `o` as a two-column table in the specified format `f`.

Supported formats:

* `markdown`
* `ascii`
* `property`
* `csv`
* `html`

The first column in the table contains field names, whereas the second column contains corresponding field values.

Object `o` can be an `Entity` or a `Window` object which can be retrieved as follows:

* [`getEntity`](functions-lookup.md#getentity)
* [`rule_window`](functions-rules.md#rule_window)
* [`rule_windows`](functions-rules.md#rule_windows)

An empty string is returned if the object `o` is `null`.

Examples:

```javascript
  printObject(getEntity('atsd'), 'ascii')
```

```ls
+--------------------------+------------------------------------+
| Name                     | Value                              |
+--------------------------+------------------------------------+
| created                  | 1516996501692                      |
| enabled                  | true                               |
| id                       | 1                                  |
| interpolate              | LINEAR                             |
| label                    | ATSD                               |
| name                     | atsd                               |
| portalConfigs            | []                                 |
| portalConfigsEnabled     | []                                 |
| tags                     | {container=axibase/atsd:latest}    |
| timeZone                 | null                               |
...
```

```javascript
  printObject(rule_window('jvm_derived'), 'csv')
```

```ls
Name,Value
empty,false
lastText,null
status,OPEN
windowStatus,OPEN
...
```

```javascript
  printObject(rule_windows('jvm_derived', "tags != ''").get(1), 'markdown')
```

```ls
| **Name** | **Value**  |
|:---|:--- |
| empty | false |
| lastText | Send 300 commands to ATSD. |
| status | REPEAT |
| windowStatus | REPEAT |
...
```

## `getURLHost`

```javascript
  getURLHost(string u) string
```

Retrieves the **host** from URL string `u`. If the URL `u` is null, empty or invalid, an exception is thrown.

Example:

```javascript
    /* Returns "example.org" */
    getURLHost('https://example.org/en/products?type=database&status=1')
```

## `getURLPort`

```javascript
  getURLPort(string u) integer
```

Retrieves the **port** from URL string `u`. If the URL `u` is `null`, empty or invalid, an exception is thrown.

If the URL `u` does not contain a port, the function returns the default value for the protocol, for example port 443 for `https` and port 80 for `http`.

Example:

```javascript
    /* Returns 443 */
    getURLPort('https://example.org/en/products?type=database&status=1')
```

## `getURLProtocol`

```javascript
  getURLProtocol(string u) string
```

Retrieves the **protocol** from URL string `u`. If the URL `u` is null, empty or invalid, exception is thrown.

Example:

```javascript
    /* Returns "https" */
    getURLProtocol('https://example.org/en/products?type=database&status=1')
```

## `getURLPath`

```javascript
  getURLPath(string u) string
```

Retrieves the **path** from URL string `u`. If the URL `u` is null, empty or invalid, an exception is thrown.

Example:

```javascript
    /* Returns "/en/products" */
    getURLPath('https://example.org/en/products?type=database&status=1')
```

## `getURLQuery`

```javascript
  getURLQuery(string u) string
```

Retrieves the **query string** from URL string `u`. If the URL `u` is null, empty or invalid, an exception is thrown.

Example:

```javascript
    /* Returns "type=database&status=1" */
    getURLQuery('https://example.org/en/products?type=database&status=1')
```

## `getURLUserInfo`

```javascript
  getURLUserInfo(string u) string
```

Retrieves the `user:password` from URL string `u`. If the URL `u` is null, empty or invalid, an exception is thrown.

Example:

```javascript
    /* Returns null */
    getURLUserInfo('https://example.org/en/products?type=database&status=1')

    /* Returns "atsd_user:atsd_password" */
    getURLUserInfo('https://atsd_user:atsd_password@example.org/en/products?type=database&status=1')
```
