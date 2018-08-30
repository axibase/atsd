# Value Functions

## Overview

Value functions provide a convenient way to get values of metrics received in the same `series` command.

```ls
series e:ent1 m:metric1=0 m:metric2=20 m:metric3=90
```

In the example above, a window created for `metric1` metric can access the remaining values in the command using `value('metric2')` and `value('metric3')` functions.

Compared to the [`db_last`](functions-series.md) function, the `value()` function retrieves metric values from the incoming command, even if they are not yet stored in the database.

Related functions:

* [`db_last`](functions-series.md#db_last)
* [`db_statistic`](functions-series.md#db_statistic)

## `value`

```csharp
value(string metric) number
```

Retrieves the value for the specified `metric` received in the same `series` command or parsed from the same row in the CSV file.

Example:

```javascript
value > 1.5 && value('temperature') > 50
```

```ls
series e:sensor01 m:pressure=3.5 m:temperature=80
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