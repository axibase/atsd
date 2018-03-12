# Condition

A condition is a boolean expression which is evaluated when data is received by or removed from the window. For example, the condition `value > 50` returns `true` if the last received value exceeds 50.

The condition consists of one or multiple boolean checks combined with [boolean operators](operators.md#boolean-operators) `AND` (`&&`), `OR` (`||`), and `NOT` (`!`).

The expression can include command fields, literal values, window/entity/metric fields, user-defined variables and [functions](functions.md).

When the condition evaluates to `true` for the first time, the [window](window.md) status will change to `OPEN` causing the execution of 'On Open' triggers. Once the condition becomes `false`, the window reassumes the `CANCEL` status triggering a corresponding set of 'On Cancel' triggers.

Note that [`Overrides`](overrides.md) take precedence over the condition.

## Fields

| **Field** | **Description** |
| :--- | :--- |
| `value` | Last data sample. |
| `tags.{tag_name}` | Value of command tag 'tag_name', for example, `tags.file_system`. <br>Also, `tags['tag_name']`.|
| `entity` | Entity name. |
| `entity.label` | Entity label. |
| `entity.{field_name}` | Entity [field](../api/meta/entity/list.md#fields) with the specified name, for example `entity.timeZone`. |
| `entity.tags.{tag_name}` | Entity tag value, for example, `entity.tags.location`. <br>Also, `entity.tags['tag_name']`. |
| `metric` | Metric name. |
| `metric.label` | Metric label. |
| `metric.{field_name}` | Metric [field](../api/meta/metric/list.md#fields) with the specified name, for example `metric.retentionDays`. |
| `metric.tags.{tag_name}` | Metric tag value, for example, `metric.tags.units`. <br>Also, `metric.tags['tag_name']`. |

Refer to [window fields](window.md#window-fields).

## Operators

Refer to [operators](operators.md).

## Collections

The collections (lists of items) can be created inline, using square brackets, for example `['a', 'b', 'c']` or `[1, 2, 3]`, or retrieved with [lookup](functions.md#lookup-functions) functions.

## Functions

Refer to [functions](functions.md).

Function names are **case-sensitive**.

## Variables

Custom expressions that return a value (number, string, boolean, object) can be declared as a [variable](variables.md) and included in the condition by name.

![](images/condition-variable.png)

## Examples

### Basic Threshold

The condition is `true` when the last value is greater than `75`.

```javascript
  value > 75
```

### Threshold Range

The condition is `true` when the last value is greater than `75` and smaller than `90`.

```javascript
  value > 75 && value < 90
```

### Last-N Average

For a count-based window with the length of 5 samples, the condition is `true` when average of values in the window is greater than `75`.

```javascript
  avg() > 75
```

The number of values in the window is less than `5` from the time the window is started and until it reaches the maximum capacity as new data arrives. For example, the `avg()` function will return the same result as `value` when the first sample arrives.

### Latest-N Average

For a time-based window with a duration of 5 minutes, the condition is `true` when the average of values with timestamps greater than the current time minus window duration exceeds `75`.

```javascript
  avg() > 75
```

The number of samples in the window can range from 0 (when the oldest value exits the window) to infinity.

### All Values Are Above Threshold

The condition is `true` when the all values in the window, both count- and time-based, exceed `50`.

```javascript
  min() > 50
```

### Equal Values

The condition is `true` when all values in the window are equal.

```javascript
  max() - min() = 0
```

### Equal Number

The condition is `true` when all values in the window are equal `50`.

```javascript
  max() - min() = 0 && avg() = 50
```

### Multiple metrics

If metrics were submitted with the same 'series' command, their last value can be accessed with the [`value(string n)`](functions-value.md) function.

```javascript
  value > 90 AND value('disk_used') < 1000000000
```

Alternatively, the metric's last value can be retrieved with the [`db_last`](functions-db.md#db_laststring-m) and [`db_statistic`](functions-db.md#db_statistic) functions.

```javascript
  value > 90 AND db_last('io_nodes_used_precent') < 80
```

### Schedule-based (Time condition)

The condition is `true` if the average exceeds `90` at any time or if the average exceeds `50` during the working hours (between `08:00:00` and `17:59:59`).

```javascript
  avg() > 90 || avg() > 50 && now.getHourOfDay() BETWEEN 8 AND 17
```
