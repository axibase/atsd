# Filters

## Overview

Filters determine which commands should be processed by the rule. Commands that satisfy all filters are allocated to the rule [windows](window.md) for further processing such as adding data and evaluating the alert condition.

### Built-in Filters

| **Name** | **Description** |
| --- | --- |
| Data Type | Checks that the command is of the specified type: `series`, `property`, `message`. |
| Metric | Checks that metric is equal to the metric name specified in the rule. |

![](images/filter-dt-metric.png)

### User-Defined Filters

| **Name** | **Description** |
| --- | --- |
| Expression | Accepts commands for which the filter expression  returns `true`. |
| Entity | Accepts commands only for entities selected in the rule. |
| Entity Group | Accepts commands for entities that belong only to one of entity groups selected in the rule. |
| Time | Accepts commands with timestamp that deviates by less than the specified interval from the current server time. |

## Data Type Filter

The filter ignores commands if their data type is different from what is specified in the rule.
For example, a `series` rule ignores `message` and `property` commands.

## Metric Filter

To match the rule, the incoming series command must have the same metric name as the one specified in the Rule Editor. This filter applies to `series` commands.

## Filter Expression

The filter matches commands for which the filter expression returns `true`.

The expression may consists of one or multiple boolean checks joined with [boolean operators](operators.md#boolean-operators) `AND`, `OR`, and `NOT`.

```javascript
entity != 'nurswgvml007'
```

```javascript
entity LIKE 'nurswgvml*' AND entity IN ('nurswgvml007', 'nurswgvml006')
```

The expression may reference command [fields](window.md#window-fields) as well as apply various [functions](functions.md):

Base fields:

* entity
* tags.{tag-name}
* entity.tags.{tag-name}
* entity.field
* metric.tags.{tag-name}
* metric.field

`series` command fields:

* metric
* value

`message` command fields:

* type
* source
* severity
* message

`property` command fields:

* type
* keys
* properties

![](images/filter-expression.png)

```javascript
tags.method = 'get' AND tags.site = 'OperationsManager2007WebConsole' 	
```

```javascript
tags.mount_point NOT LIKE '*u113452*'
```

```javascript
tags.mount_point = '/'
```

```javascript
type = 'activemq_service' and keys.service = 'health'
```

```javascript
tags.type != 'security' && message NOT IN collection('linux-ignore-commands')
```

## Entity Filter

The filter discards commands for an entity not equal to one of entities specified in the rule. The filter is applied only if the list of selected entities is not empty.

![](images/filter-entity.png)

As a more flexible alternative, the entity condition can be encoded in the filter expression:

```javascript
entity != 'nurswgvml007'
```

```javascript
entity LIKE 'mib*'
```

```javascript
entity.tags.location = 'SVL'
```

## Entity Group Filter

The filter discards commands for entities that do not belong to one of entity groups specified in the rule. The filter is applied only if the list of selected entity groups is not empty.

![](images/filter-entity-group.png)

## Time Filter

If set to a positive value, the filter discards commands with a timestamp that deviates by more than specified 'grace' interval from the current server time. The filter is commonly used to ignore historical data.

![](images/filter-time.png)

## Filter vs Condition

While the same condition such as `tags.mount_point = '/'` can be evaluated both in the filter expression and the alert condition, it is recommended that the checks that refer to command fields are specified in the filter expression whereas checks that require the [window](window.md) object are specified in the alert condition. This will minimize the number of windows maintained by the rule engine.

For example, `tags.mount_point = '/'` refers to the `tags` field which is present in the incoming command and therefore can be checked in the filter expression. As a result commands with other tag values (e.g. mount_point = /dev) will be discarded early in the process without causing extra windows to be created.

The `avg()` function, on the other hand, operates on an array of values stored in the window object and should therefore be used in the alert condition, because the window object is not available at the filtering stage.
