# Operators

## Boolean Operators

| **Name** | **Description** |
| :--- | :--- |
| `OR` | Boolean OR, also `\|\|`. |
| `AND` | Boolean AND, also `&&`. |
| `NOT` | Boolean NOT, also `!`. |

Examples:

```javascript
  value > 90 && avg() > 50
```

```javascript
  tags.file_system LIKE '/opt/*' OR tags.file_system LIKE '/mnt/*'
```

```javascript
  tags.file_system NOT LIKE '/dev/*'
```

```javascript
  NOT tags.isEmpty()
```

## Ternary Operator

| **Name** | **Description** |
| :--- | :--- |
| `?` | Ternary conditional |

The ternary `?` operator simplifies `if/else` syntax. The operator chooses one of the two options based on the boolean expression. 

If the expression `expr` evaluates to `true`, the operator selects `value1` option. Otherwise, `value2` is chosen.

```javascript
   boolean expr ? value1 : value2
```

Examples:

```javascript
   tags.mount_point == '/' ? 90.0 : 75.0

  // The above example is equivalent to:
  if (tags.mount_point == '/') {
     return 90.0;
  } else {
     return 75.0;
  }
```

```javascript
   status >= 500 ? 'Server Error' : ((status >= 400) ? 'Client Error' : ((status >= 300) ? 'Redirect' : 'OK')))
```  

## Numeric Operators

| **Name** | **Description** |
| :--- | :--- |
| `+` | Plus. |
| `-` | Minus. |
| `*` | Multiply. |
| `/` | Divide. |
| `%` | Remainder. |
| `=` | Equal. Also `==`. |
| `!=` | Not equal. |
| `>` | Greater than. |
| `>=` | Greater than or equal. |
| `<` | Less than. |
| `<=` | Less than or equal. |
| `BETWEEN` | `n BETWEEN m AND p`.<br>The number `n` is between `m` and `p` (inclusive).<br>`m <= n <= p`.<br>Example: `avg() BETWEEN 10 and 20`. |
| `IN` | Returns `true` if the number is contained in the numeric [collection](functions-collection.md#in). |

Examples:

```javascript
  value*100 > 90
```

```javascript
  max() BETWEEN 80 and 100
```

```javascript
  value IN (0, 1, 12)
```

## Text Operators

| **Name** | **Description** |
| :--- | :--- |
| `=` | Also `==`. Equal. The comparison is case-**insensitive** ('a' = 'A' equals `true`).|
| `!=` | Not equal. The comparison is case-**insensitive** ('a' != 'A' equals `false`).|
| `BETWEEN` | Returns `true` if the left operand string is ordered between lower and upper strings on the right.<br>`a BETWEEN b AND c`.<br>String `a` is ordered between `b` and `c` (inclusive) using lexicographical comparison.<br>The comparison is case-**sensitive**.<br>Example: `timeStr BETWEEN '18:00' AND '18:04'`.|
| `LIKE` | Returns `true` if the left operand string matches the pattern on the right. The pattern may include regular characters and  wildcards `?` and `*`.<br>The operator also accepts a [collection of patterns](functions-collection.md#like) in round brackets.|
| `IN` | Returns `true` if the left operand string is contained in the string [collection](functions-collection.md#in) specified in parenthesis on the right. |

Examples:

```javascript
  entity = 'nurswgvml007'
```

```javascript
  entity IN ('nurswgvml007', 'nurswgvml010')
```

```javascript
  entity LIKE '*007'
```		

```javascript
  tags.location LIKE ('NUR*', entity.tags.location)
```		
