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

Converts an input string or number `a` to boolean value. The function returns `true` if input `a` is the string `true`, `yes`, `on` (**case-insensitive**), or equal to the number `1`. Otherwise, the functions returns `false`. Refer to the value table below for additional examples:

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

Converts input object `a` to floating-point number. If `a` is `null` or an empty string, the function returns `0.0`.
If `a` cannot be parsed as a number, and neither of the aforementioned criteria are met, the function returns `Double.NaN`.

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

Prints input object `obj` as a two-column table in the specified `format`.

Supported formats:

* `markdown`
* `ascii`
* `property`
* `csv`
* `html`

The first column contains field names, the second column contains the corresponding field values.

Object `o` can be an `Entity` or `Window` object. Retrieve such objects using the applicable function:

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

Retrieves a map ordered by ascending datetime of included samples. Each sample is an object with two fields: command time and a numeric value. Time is a [`DateTime`](./object-datetime.md#datetime-object) object.

Returns a variable number of samples based on the value of the `limit` argument:

* Zero or omitted: All samples.
* Positive: Up to the specified number of samples from **start**, earliest samples first.
* Negative: Up to the specified number of samples from **end**, latest samples first.

If the number specified exceeds window length, the function returns all window samples.

To retrieve sample timestamps and values separately, use [`timestamps`](#timestamps) and [`values`](#values) functions.

Example:

* Window samples:

    | **`datetime`** | **`value`**  |
    |:---|:--- |
    | `2018-09-18T13:43:36Z[Etc/UTC]` | 164292.0 |
    | `2018-09-18T13:44:06Z[Etc/UTC]` | 164292.0 |
    | `2018-09-18T13:44:36Z[Etc/UTC]` | 164308.0 |
    | `2018-09-18T13:45:06Z[Etc/UTC]` | 164308.0 |
    | `2018-09-18T13:45:32Z[Etc/UTC]` | 1177004.0 |

* Expression:

    ```javascript
    samples()

    ${addTable(samples(), 'markdown')}

    samples(3)

    ${addTable(samples(3), 'markdown')}

    samples(-1)

    ${addTable(samples(-1), 'markdown')}

    samples(-2)_formatted
    @foreach{item: samples(-2)}
        (@{date_format(item.key, "yyyy-MM-dd HH:mm:ss")}, @{item.value}),
    @end{}
    ```

    See [Control Flow Documentation](./control-flow.md#iteration) for more information about the `@foreach` template.

* Result:

    `samples()`

    | **key** | **value**  |
    |:---|:--- |
    | `2018-09-18T13:43:36Z[Etc/UTC]` | 164292.0 |
    | `2018-09-18T13:44:06Z[Etc/UTC]` | 164292.0 |
    | `2018-09-18T13:44:36Z[Etc/UTC]` | 164308.0 |
    | `2018-09-18T13:45:06Z[Etc/UTC]` | 164308.0 |
    | `2018-09-18T13:45:32Z[Etc/UTC]` | 1177004.0 |

    `samples(3)`

    | **key** | **value**  |
    |:---|:--- |
    | `2018-09-18T13:43:36Z[Etc/UTC]` | 164292.0 |
    | `2018-09-18T13:44:06Z[Etc/UTC]` | 164292.0 |
    | `2018-09-18T13:44:36Z[Etc/UTC]` | 164308.0 |

    `samples(-1)`

    | **key** | **value**  |
    |:---|:--- |
    | `2018-09-18T13:45:32Z[Etc/UTC]` | 1177004.0 |

    ```ls
    samples(-2)_formatted
    (2018-09-18 13:45:06, 164308.0),
    (2018-09-18 13:45:32, 1177004.0),
    ```

## `values`

```java
values([int limit]) [number]
```

Retrieves a list of numeric sample values. The list is ordered by ascending command time of the sample. Values are floating-point numbers (`double`).

Returns a variable number of samples based on the value of the `limit` argument:

* Zero or omitted: All samples.
* Positive: Up to the specified number of samples from **start**, earliest samples first.
* Negative: Up to the specified number of samples from **end**, latest samples first.

If the number specified exceeds window length, the function returns all window samples.

Complete samples map is available via [`samples`](#samples) function.

Example:

* Window samples:

    | **`datetime`** | **`value`**  |
    |:---|:--- |
    | `2018-09-18T13:43:36Z[Etc/UTC]` | 164292.0 |
    | `2018-09-18T13:44:06Z[Etc/UTC]` | 164292.0 |
    | `2018-09-18T13:44:36Z[Etc/UTC]` | 164308.0 |
    | `2018-09-18T13:45:06Z[Etc/UTC]` | 164308.0 |
    | `2018-09-18T13:45:32Z[Etc/UTC]` | 1177004.0 |

* Expression:

    ```javascript
    values()

    ${addTable(values(), 'markdown')}

    values(3)

    ${addTable(values(3), 'markdown')}

    values(-1)

    ${addTable(values(-1), 'markdown')}
    ```

* Result:

    `values()`

    | **Value**  |
    |:--- |
    | 164292.0 |
    | 164292.0 |
    | 164308.0 |
    | 164308.0 |
    | 1177004.0 |

    `values(3)`

    | **Value**  |
    |:--- |
    | 164292.0 |
    | 164292.0 |
    | 164308.0 |

    `values(-1)`

    | **Value**  |
    |:--- |
    | 1177004.0 |

## `timestamps`

```java
timestamps([int limit]) [long]
```

Retrieves an array of [`DateTime`](./object-datetime.md#datetime-object) objects of the samples in the current window.

Returns a variable number of samples based on the value of the `limit` argument:

* Zero or omitted: All samples.
* Positive: Up to the specified number of samples from **start**, earliest samples first.
* Negative: Up to the specified number of samples from **end**, latest samples first.

If the number specified exceeds window length, the function returns all window samples.

Complete samples map is available via [`samples`](#samples) function.

Example:

* Window samples:

    | **`datetime`** | **`value`**  |
    |:---|:--- |
    | `2018-09-18T13:43:36Z[Etc/UTC]` | 164292.0 |
    | `2018-09-18T13:44:06Z[Etc/UTC]` | 164292.0 |
    | `2018-09-18T13:44:36Z[Etc/UTC]` | 164308.0 |
    | `2018-09-18T13:45:06Z[Etc/UTC]` | 164308.0 |
    | `2018-09-18T13:45:32Z[Etc/UTC]` | 1177004.0 |

* Expression:

    ```javascript
    timestamps()

    ${addTable(timestamps(), 'markdown')}

    timestamps(3)

    ${addTable(timestamps(3), 'markdown')}

    timestamps(-1)

    ${addTable(timestamps(-1), 'markdown')}

    timestamps(-2)_formatted
    @foreach{item: timestamps(-2)}
        (@{date_format(item, "yyyy-MM-dd HH:mm:ss")}),
    @end{}
    ```
    See [Iteration](./control-flow.md#iteration) for more information about `@foreach`.

* Result:

    `timestamps()`

    | **Value**  |
    |:--- |
    | `2018-09-18T13:43:36Z[Etc/UTC]` |
    | `2018-09-18T13:44:06Z[Etc/UTC]` |
    | `2018-09-18T13:44:36Z[Etc/UTC]` |
    | `2018-09-18T13:45:06Z[Etc/UTC]` |
    | `2018-09-18T13:45:32Z[Etc/UTC]` |

    `timestamps(3)`

    | **Value**  |
    |:--- |
    | `2018-09-18T13:43:36Z[Etc/UTC]` |
    | `2018-09-18T13:44:06Z[Etc/UTC]` |
    | `2018-09-18T13:44:36Z[Etc/UTC]` |

    `timestamps(-1)`

    | **Value**  |
    |:--- |
    | `2018-09-18T13:45:32Z[Etc/UTC]` |

    ```ls
    timestamps(-2)_formatted
    (2018-09-18 13:45:06),
    (2018-09-18 13:45:32),
    ```

## `getURLHost`

```csharp
getURLHost(string url) string
```

Retrieves **host** from the URL specified by the string `url`. If `url` is `null`, empty or invalid, an exception is thrown.

Example:

```javascript
/* Returns "example.org" */
getURLHost('https://example.org/en/products?type=database&status=1')
```

## `getURLPort`

```csharp
getURLPort(string url) int
```

Retrieves **port** from the URL specified by the string `url`. If `url` is `null`, empty or invalid, an exception is thrown.

If `url` contains no port, the function returns the default value for the protocol, for example port `443` for `HTTPS` and port `80` for `HTTP`.

Example:

```javascript
/* Returns 443 */
getURLPort('https://example.org/en/products?type=database&status=1')
```

## `getURLProtocol`

```csharp
getURLProtocol(string url) string
```

Retrieves **protocol** from the URL specified by the string `url`. If `url` is `null`, empty or invalid, an exception is thrown.

Example:

```javascript
/* Returns "https" */
getURLProtocol('https://example.org/en/products?type=database&status=1')
```

## `getURLPath`

```csharp
getURLPath(string url) string
```

Retrieves **path** from the URL specified by the string `url`. If `url` is `null`, empty or invalid, an exception is thrown.

Example:

```javascript
/* Returns "/en/products" */
getURLPath('https://example.org/en/products?type=database&status=1')
```

## `getURLQuery`

```csharp
getURLQuery(string url) string
```

Retrieves **query string** from the URL specified by the string `url`. If `url` is `null`, empty or invalid, an exception is thrown.

Example:

```javascript
/* Returns "type=database&status=1" */
getURLQuery('https://example.org/en/products?type=database&status=1')
```

## `getURLUserInfo`

```csharp
getURLUserInfo(string url) string
```

Retrieves the user credential portion of the `username:password` key-value pair from the URL string specified by the string `url`. If `url` is `null`, empty or invalid, an exception is thrown.

Example:

```javascript
/* Returns null */
getURLUserInfo('https://example.org/en/products?type=database&status=1')

/* Returns "john.doe:secret" */
getURLUserInfo('https://john.doe:secret@example.org/en/products?type=database&status=1')
```