# Value Functions

## Overview

Value functions provide access to metric values received in the **same** `series` command.

```ls
series e:entity-1 m:metric-1=3.0 m:metric-2=20.0 m:metric-3=91.5
```

In the example above, a `metric-1` window can access the remaining values in the command using `value('metric-2')` and `value('metric-3')` functions.

```javascript
value > 5 && value('metric-2') > 10
```

Compared to the [`db_last`](functions-series.md) function, the `value()` function retrieves metric values from the underlying command, without querying the database.

Related functions:

* [`db_last`](functions-series.md#db_last)
* [`db_statistic`](functions-series.md#db_statistic)

### `value`

```csharp
value(string metric [, number default_value]) number
```

Retrieves the value for the specified `metric` received in the same `series` command or parsed from the same row in the CSV file.

Example:

```javascript
value > 1.5 && value('temperature') > 50
```

```ls
series e:sensor01 m:pressure=3.5 m:temperature=80
```

If the default is specified and the requested metric is not present in the command, the function returns the default value without raising a processing error.

```javascript
value > 10 && value('pressure', 0.0) > 50
```

Assuming the rule is created for the `pressure` metric, the above condition resolves fields and evaluates to `true`.

```javascript
// returns true
3.5 > 1.5 && 80 > 50
```

If the value of the `pressure` metric is less than `50` the condition evaluates to `false`.

```ls
series e:sensor01 m:pressure=3.5 m:temperature=33
```

```javascript
// returns false
3.5 > 1.5 && 33 > 50
```