# Expressions

Expression is a condition which is entered in the Rule [editor](editor.md) and is evaluated each time a command is
received by or removed from the window. For example, the expression **`value > 50`** returns `TRUE` if the newly received value is greater than 50.

If the expression evaluates to `TRUE`, the window status changes to `OPEN` and creates an alert, followed by
the execution of triggers such as a system command and email notification. Once
the expression returns `FALSE`, the alert is closed and another set of
triggers is invoked.

The expression consists of one or multiple conditions combined with `OR` (`||`) and `AND` (`&&`) operators.

The condition can reference fields, apply [functions](functions.md) to them, and compare them with operators. Function names are case-sensitive.

> Exceptions specified in the Thresholds table take precedence over the expression.

## Fields

| **Field** | **Description** |
| :--- | :--- |
| `value` | Last data sample. |
| `tags.tag_name` | Value of command tag 'tag_name', for example, `tags.file_system`. <br>Also, `tags['tag_name']`.|
| `entity` | Entity name. |
| `entity.tags.tag_name` | Entity tag value, for example, `entity.tags.location`. <br>Also, `entity.tags['tag_name']`. |
| `metric` | Metric name. |
| `metric.tags.tag_name` | Metric tag value, for example, `metric.tags.units`. <br>Also, `metric.tags['tag_name']`. |
| `property(search)` | Property key/tag value based on property search syntax. Refer to [property functions](functions.md#property-functions). |

## Boolean Operators

| **Name** | **Description** |
| :--- | :--- |
| `OR` | Boolean OR, also `\|\|`. |
| `AND` | Boolean AND, also `&&`. |
| `NOT` | Boolean NOT, also `!`. |

## Numeric Operators

| **Name** | **Description** |
| :--- | :--- |
| `=` | Equal.
| `!=` | Not equal.
| `>` | Greater than.
| `>=` | Greater than or equal.
| `<` | Less than.
| `<=` | Less than or equal.

## Text Operators

| **Name** | **Description** |
| :--- | :--- |
| `=` | Equal. |
| `!=` | Not equal. |

> Note: `=` and `!=` operators are case-insensitive.

## Functions

Refer to [functions](functions.md).

## Examples

| **Type** | **Window** | **Example** | **Description** |
| --- | --- | --- | --- |
| threshold | none | `value > 75` | Raise an alert if last metric value exceeds threshold. |
| range | none | `value > 50 AND value <= 75` | Raise an alert if value is outside of specified range. |
| statistical-count | count(10) | `avg() > 75` | Raise an alert if average value of the last 10 samples exceeds threshold. |
| statistical-time | time('15 min') | `avg() > 75` | Raise an alert if average value for the last 15 minutes exceeds threshold. |
| statistical-ungrouped | time('15 min') | `avg() > 75` | Raise an alert if 15-minute average values for all entities in the group exceeds threshold. |
