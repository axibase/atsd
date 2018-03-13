# Value Functions

## Overview

### `value`

```java
  value(string m) number
```
Retrieves the value for the specified metric `m` received in the same `series` command or parsed from the same row in the CSV file.

Example:

```javascript
  value > 1.5 && value('temperature') > 50
```

```ls
series e:sensor01 m:pressure=3.5 m:temperature=80
```

Assuming the rule was created for the `pressure` metric, the above condition will resolve and evaluate to `true`. 

```javascript
3.5 > 1.5 && 80 > 50
// returns true
```

If the value of the `pressure` metric were less than `50` the condition would evaluate to `false`.

```
series e:sensor01 m:pressure=3.5 m:temperature=33
```

```javascript
3.5 > 1.5 && 33 > 50
// returns false
```

Compared to the [`db_last`](functions-db.md) function, the `value()` function retrieves metric values from the incoming command, even if they're not yet stored in the database.
