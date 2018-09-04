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
* [`samples`](#samples)
* [`values`](#values)
* [`timestamps`](#timestamps)

## `ifEmpty`

```csharp
ifEmpty(object a, object b) object
```

Returns `b` if `a` is either `null` or an empty string.

Examples:

```javascript
/* Returns 2 */
ifEmpty(null, 2)

/* Returns hello */
ifEmpty('hello', 'world')
```

## `toBoolean`

```csharp
toBoolean(object a) bool
```

Converts the input string or number `a` to a boolean value. `true` is returned by the function if the input `a` is a string `true`, `yes`, `on`, `1` (case-**IN**sensitive) or if `a` is equal to the number `1`.

Value table:

Input | Type | Result
----|---|---
`yes` | string | `true`
`YES` | string | `true`
`on` | string | `true`
`1` | string | `true`
`1` | number | `true`
`no` | string | `false`
`NO` | string | `false`
`hello` | string | `false`
`0` | string | `false`
`0` | number | `false`
`3` | number | `false`

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

```csharp
toNumber(object a) double
```

Converts the input object `a` to floating-point number. If `a` is `null` or an empty string, the function returns `0.0`.
If `a` cannot be parsed as a number, the function returns `Double.NaN`.

Value table:

Input | Type | Result
----|---|---
`null` | - | `0.0`
`""` | string | `0.0`
`" "` | string | `0.0`
`"hello"` | string | `NaN`
`"null"` | string | `NaN`
`"0"` | string | `0.0`
`"1"` | string | `1.0`
`"1.0"` | string | `1.0`
`[]` | array | `NaN`
`0` | number | `0.0`
`1` | number | `1.0`

## `printObject`

```csharp
printObject(object obj, string format) string
```

Prints the input object `obj` as a two-column table in the specified `format`.

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

Returns an empty string if `ojb` is `null`.

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

## `samples`

```java
samples([int limit]) map
```

Retrieves the map of the samples:

```javascript
{ date: value }
```

Where `date` is an ISO datetime in the UTC timezone.

Limit can be:

1. Zero or omitted: return all samples.

2. Positive: return up to the specified number of samples from **start** (earliest samples first).

3. Negative: return up to the specified number of samples from **end** (latest samples first).

The map can be divided using [`values`](#values) and [`timestamps`](#timestamps) functions.

Example:

```javascript
samples(-3) = ${samples(-3)}
samples(3) = ${samples(3)}
samples() =${samples()}
```

For window with `count = 5` produces:

```javascript
samples(-3) = [(2018-09-04T07:34:17Z[Etc/UTC],0.44), (2018-09-04T07:34:02Z[Etc/UTC],0.29), (2018-09-04T07:33:47Z[Etc/UTC],0.38)]

samples(3) = [(2018-09-04T07:33:17Z[Etc/UTC],0.29), (2018-09-04T07:33:32Z[Etc/UTC],0.22), (2018-09-04T07:33:47Z[Etc/UTC],0.38)]

samples() =[(2018-09-04T07:33:17Z[Etc/UTC],0.29), (2018-09-04T07:33:32Z[Etc/UTC],0.22), (2018-09-04T07:33:47Z[Etc/UTC],0.38), (2018-09-04T07:34:02Z[Etc/UTC],0.29), (2018-09-04T07:34:17Z[Etc/UTC],0.44)]
```

## `values`

```java
values([int limit]) [number]
```

Retrieves values of samples in the window.

Limit can be:

1. Zero or omitted: return all values.

2. Positive: return up to the specified number of values from **start** (earliest values first).

3. Negative: return up to the specified number of values from **end** (latest values first).

The whole samples map is available via [`samples`](#samples) function.

Example:

```javascript
values(-3) = ${values(-3)}
values(3) = ${values(3)}
values() =${values()}
```

For window with `count = 5` produces:

```javascript
values(-3) = ${values(-3)}
values(3) = ${values(3)}
values() =${values()}
```

## `timestamps`

```java
timestamps([int limit]) [long]
```

Retrieves the ISO datetimes in the UTC timezone of the samples in the window.

Limit can be:

1. Zero or omitted: return all timestamps.

2. Positive: return up to the specified number of timestamps from **start** (earliest timestamps first).

3. Negative: return up to the specified number of timestamps from **end** (latest timestamps first).

The whole samples map is available via [`samples`](#samples) function.

Example:

```javascript
timestamps(-3) = ${timestamps(-3)}
timestamps(3) = ${timestamps(3)}
timestamps() =${timestamps()}
```

For window with `count = 5` produces:

```javascript
timestamps(-3) = [2018-09-04T07:32:32Z[Etc/UTC], 2018-09-04T07:32:17Z[Etc/UTC], 2018-09-04T07:32:02Z[Etc/UTC]]

timestamps(3) = [2018-09-04T07:31:32Z[Etc/UTC], 2018-09-04T07:31:47Z[Etc/UTC], 2018-09-04T07:32:02Z[Etc/UTC]]

timestamps() =[2018-09-04T07:31:32Z[Etc/UTC], 2018-09-04T07:31:47Z[Etc/UTC], 2018-09-04T07:32:02Z[Etc/UTC], 2018-09-04T07:32:17Z[Etc/UTC], 2018-09-04T07:32:32Z[Etc/UTC]]
```

## `getURLHost`

```csharp
getURLHost(string url) string
```

Retrieves the **host** from URL specified in string `url`. If `url` is `null`, empty or invalid, an exception is thrown.

Example:

```javascript
/* Returns "example.org" */
getURLHost('https://example.org/en/products?type=database&status=1')
```

## `getURLPort`

```csharp
getURLPort(string url) int
```

Retrieves the **port** from URL string `url`. If `url` is `null`, empty or invalid, an exception is thrown.

If `url` does not contain a port, the function returns the default value for the protocol, for example port 443 for `https` and port 80 for `http`.

Example:

```javascript
/* Returns 443 */
getURLPort('https://example.org/en/products?type=database&status=1')
```

## `getURLProtocol`

```csharp
getURLProtocol(string url) string
```

Retrieves the **protocol** from URL string `url`. If `url` is `null`, empty or invalid, exception is thrown.

Example:

```javascript
/* Returns "https" */
getURLProtocol('https://example.org/en/products?type=database&status=1')
```

## `getURLPath`

```csharp
getURLPath(string url) string
```

Retrieves the **path** from URL string `url`. If `url` is `null`, empty or invalid, an exception is thrown.

Example:

```javascript
/* Returns "/en/products" */
getURLPath('https://example.org/en/products?type=database&status=1')
```

## `getURLQuery`

```csharp
getURLQuery(string url) string
```

Retrieves the **query string** from URL string `url`. If `url` is `null`, empty or invalid, an exception is thrown.

Example:

```javascript
/* Returns "type=database&status=1" */
getURLQuery('https://example.org/en/products?type=database&status=1')
```

## `getURLUserInfo`

```csharp
getURLUserInfo(string url) string
```

Retrieves the user credential part `username:password` from URL string `url`. If `url` is `null`, empty or invalid, an exception is thrown.

Example:

```javascript
/* Returns null */
getURLUserInfo('https://example.org/en/products?type=database&status=1')

/* Returns "john.doe:secret" */
getURLUserInfo('https://john.doe:secret@example.org/en/products?type=database&status=1')
```
