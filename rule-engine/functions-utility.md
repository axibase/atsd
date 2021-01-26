# Utility Functions

## Reference

* [`agent_to_host`](#agent_to_host)
* [`ifEmpty`](#ifempty)
* [`toBoolean`](#toboolean)
* [`toNumber`](#tonumber)
* [`toLong`](#tolong)
* [`trim_zero`](#trim_zero)
* [`check_range`](#check_range)
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
* [`sendTcpMessage`](#sendtcpmessage)
* [`sendTcpMessageReply`](#sendtcpmessagereply)
* [`lock`](#lock)
* [`unlock`](#unlock)

## `agent_to_host`

```csharp
agent_to_host(string a) string
```

Extracts hostname from the ITM agent name, typically consisting of optional instance, hostname, and [ITM product code](http://www-01.ibm.com/support/docview.wss?uid=swg21265222).

Examples:

```javascript
/*
  Primary:HOST_01:NT   ->   HOST_01
  HOST_02:LZ           ->   HOST_02
*/
agent_to_host(entity)
```

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
toBoolean(string | number obj) bool
```

Converts a string or number `obj` to boolean value. The function returns `true` if `obj` is the string `true`, `yes`, `on` (**case-insensitive**), or equal to the number `1`. Otherwise, the functions returns `false`. Refer to the value table below for additional examples:

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
toNumber(object a [, number defaultValue]) double
```

Converts an input object, typically a string, to a decimal number.

If the input cannot be parsed into a number, the function returns `Double.NaN` or the default value, if specified.

Value table:

Input | Type | Result
----|---|---
`null` | - | `NaN`
`""` | string | `NaN`
`" "` | string | `NaN`
`"hello"` | string | `NaN`
`"null"` | string | `NaN`
`"0"` | string | `0.0`
`"1"` | string | `1.0`
`"1.0"` | string | `1.0`
`[]` | array | `NaN`
`0` | number | `0.0`
`1` | number | `1.0`

## `toLong`

```csharp
toLong(object a [, long defaultValue]) long
```

Converts an input object to a long integer number.

## `trim_zero`

```csharp
trim_zero(object a) string
```

Formats the input number to a decimal representation without an exponent field and by stripping trailing zeros from fractional numbers.

## `check_range`

```csharp
check_range(object in, number min, number max, number default) double
```

The function converts the input argument `in` to a number and checks if it satisfies the minimum and maximum constraints. The constraints are inclusive. If one of the constraints is violated, the function raises an error.

If `in` is not a valid number, the value `default` is returned.

Example:

```javascript
check_range(in, 0, 100, 25)
```

Input `in` | Type | Result
---:|---|---:
`null` | - | `25`
`""` | string | `25`
`NaN` | number | `25`
`8` | number | `8`
`"8"` | string | `8`
`0` | number | `0`
`50` | number | `50`
`100` | number | `100`
`-10` | number | Error
`200` | number | Error

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

Retrieves an ordered map of time series samples from the current window. Each sample object in the map contains two fields: `key` which stores command time as a [`DateTime`](./object-datetime.md#datetime-object) object, and `value` which contains the numeric value.

The samples are sorted by command time in ascending order, with the oldest sample placed at the beginning of the map.

An optional `limit` argument can be specified to return a subset of samples:

* If `limit` is positive, the function returns the first `N` samples.
* If `limit` is negative, the function returns the last `N` samples.

To retrieve sample times and values separately, use [`timestamps`](#timestamps) and [`values`](#values) functions respectively.

Window samples:

| `key` | `value` |
|:---|---:|
| `2018-09-18T13:43:36Z[Etc/UTC]` | 10.0 |
| `2018-09-18T13:44:06Z[Etc/UTC]` | 40.0 |
| `2018-09-18T13:44:36Z[Etc/UTC]` | 50.0 |
| `2018-09-18T13:45:06Z[Etc/UTC]` | 85.0 |
| `2018-09-18T13:45:32Z[Etc/UTC]` | 90.0 |

Expression examples:

```bash
${addTable(samples(2), 'markdown')}
```

```markdown
| **key** | **value**  |
|:---|:--- |
| `2018-09-18T13:43:36Z[Etc/UTC]` | 10.0 |
| `2018-09-18T13:44:06Z[Etc/UTC]` | 40.0 |
```

```bash
${addTable(samples(-1), 'csv')}
```

```txt
key,value
2018-09-18T13:45:32Z[Etc/UTC],90
```

```javascript
@foreach{item: samples(-2)}
    - @{date_format(item.key, "yyyy-MM-dd HH:mm:ss")} = @{item.value}
@end{}
```

```txt
- 2018-09-18 13:45:06 = 85.0
- 2018-09-18 13:45:32 = 90.0
```

> Refer to [Control Flow](./control-flow.md#iteration) overview for more information about the `@foreach` template.

## `values`

```java
values([int limit]) [number]
```

Retrieves a list of numeric sample values in the current window. The list is sorted by command time in the ascending order. Values are floating-point numbers (`double`).

An optional `limit` argument can be specified to return a subset of values:

* If `limit` is positive, the function returns values in the first `N` samples.
* If `limit` is negative, the function returns values in the last `N` samples.

## `timestamps`

```java
timestamps([int limit]) [long]
```

Retrieves a list of sample command times in the current window. Each time  is a [`DateTime`](./object-datetime.md#datetime-object) object. The list is sorted by command time in the ascending order.

An optional `limit` argument can be specified to return a subset of times:

* If `limit` is positive, the function returns sample times in the first `N` samples.
* If `limit` is negative, the function returns sample times in the last `N` samples.

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

## `sendTcpMessage`

```csharp
sendTcpMessage(string host, int port, string message) int
```

The function sends the specified message to a remote server, identified with the hostname and port, via the TCP protocol. The response status code is an integer:

Status | Description
---|---
`0` | Connection established successfully.
`1` | Connection Error
`2` | No Route To Host
`3` | Unknown Host
`4` | Socket Timeout
`5` | Other Error

```sh
${sendTcpMessage('example.org', 9001, "hello world")}
```

```sh
${sendTcpMessage('example.org', 9001, entity + ' alert')}
```

## `sendTcpMessageReply`

```csharp
sendTcpMessageReply(string host, int port, string message [, timeout]) TcpReply
```

The function sends the specified message to a remote server, identified with the hostname and port, via the TCP protocol. After the message is sent, the function awaits a response from the server, for up to `30` seconds. The default timeout can be customized using the optional `timeout` argument specified in seconds.  

The function returns a `TcpReply` object containing the following fields:

* `status` - Response status integer.
* `response` - Response text received from the remote server.
* `execTime` - Execution time in milliseconds.

Status | Description
---|---
`0` | Connection established successfully.
`1` | Connection Error
`2` | No Route To Host
`3` | Unknown Host
`4` | Socket Timeout
`5` | Other Error

```sh
${sendTcpMessageRepy('example.org', 9001, order + '
')}
```

```txt
TcpReply(status=4, response=Order 123 received OK, execTime=250)
```

## `sendUdpMessage`

Same as `sendTcpMessage` function using UDP as the protocol.

## `sendUdpMessageReply`

Same as `sendTcpMessageReply` function using UDP as the protocol.

## `lock`

```csharp
lock(string key, long interval_millis) boolean
```

Create a named lock on the server for the specified duration of time in milliseconds. If an action triggered by another rule attempts to acquire the same lock within the lock interval, the function returns `false`.

The function can be used to ensure that some action is executed only once.

Example:

```javascript
/*
Send TCP message (cmd) to the target server
and ensure that the SAME command is not sent to the server
within 15 seconds.
*/
@if{lock(cmd, 15000)}
${sendTcpMessageReply('example.org', 9092, cmd)}
@end{}
```

The `atsd.log` records lock acquisition attempts with relevant rule details.

```txt
2019-07-03T08:10:21.742Z;INFO;sendNotificationsExecutor-2;com.axibase.tsd.service.el.ElFunctionsServiceImpl;Lock 'call-01' acquired by rule 'call_order', window {"metric":"property","entity":"nur","tags":{}}: locked until 2019-07-03T08:10:36.742Z
2019-07-03T08:10:21.806Z;INFO;sendNotificationsExecutor-18;com.axibase.tsd.service.el.ElFunctionsServiceImpl;Lock 'call-01' not acquired by rule 'call_order', window {"metric":"property","entity":"nur","tags":{}}: locked until 2019-07-03T08:10:36.742Z
```

To prevent the action from executing twice on the same day, enable Alert Logging and invoke the `last_open()` function:

```javascript
@if{!lock(cmd, 15000) || date_format(last_open().open_time, 'yyyy-MM-dd') != date_format(now, 'yyyy-MM-dd')}
${cancelAction()}
@end{}
# execute action or send notification
```

## `unlock`

```csharp
unlock(string key) boolean
```

The function releases a previously acquired lock. The result is `true` if an active lock is found for the specified key and the lock is released.

```javascript
@if{unlock(entity)}
Actions for `${entity}` were unlocked.
@end{}
```