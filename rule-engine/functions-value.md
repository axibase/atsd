# Value Functions

## Overview

### `value`

```java
  value(string m) number
```
Retrieves value for the specified metric `m` received in the same `series` command or parsed from the same row in the CSV file.

Example:

```java
  value > 1.5 && value('temperature') > 50
```

```ls
series e:sensor01 m:pressure=3.5 m:temperature=80
```

Assuming the rule was created for the `pressure` metric, the condition will resolve and evaluate to `true` for the above series command.

```ls
3.5 > 1.5 && 80 > 50
```

Compared to the [`db_last`](functions-db.md) function, which queries the database, the `value()` function returns metric values set in the command, even if they're not yet stored in the database.
