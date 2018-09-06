# Filters

## Overview

Filters determine which commands are processed by the given rule.

Commands that satisfy all filters are added to the rule [windows](window.md) for further processing such as updating statistics and evaluating the alert [condition](condition.md).

| **Filter** | **Description** |
|---|---|
| Data Type | Accepts commands of the specified type: `series`, `property`, or `message`. |
| Metric Name | Accepts `series` commands with the specified metric name. |
| Type/Source | Accepts `message` commands with the specified type and source tags. |
| Type | Accepts `property` commands with the specified property type. |
| Entity Names | Accepts commands for the specified list of entity names or name patterns. |
| Entity Group | Accepts commands for entities that belong to one of selected groups. |
| Expression | Accepts commands for which the filter expression returns `true`. |
| Time Offset | Accepts commands with a timestamp that deviates by **less** than the specified interval from the current server time. |
| Out-of-order | Accepts commands with a timestamp that is equal or greater than the timestamp of the previous command. |

## Data Type Filter

The filter checks that the command is of the specified data type: `series`, `property`, or `message` and ignores commands if their type is different from what is specified in the filter. For example, a `series` filter ignores `message` and `property` commands.

![](./images/filter-dt-metric.png)

## Metric, Type, Source Filter

The filter is specific to each data type and accepts commands that match values in the respective fields.

* The **Metric** filter applies to `series` commands.
* The **Type** filter applies to `property` commands.
* The **Type** and **Source** filter applies to `message` commands.

![](./images/filter-type-source.png)

## Entity Names Filter

Specify one or more entity names or patterns to restrict a rule to specific entities. Separate multiple names or patterns with whitespace. Patterns support `*` wildcard characters.

![](./images/filter-entity.png)

For more flexible filtering, use the main [Expression](#filter-expression) filter described below, for example:

* Exclude entities using negation:

  ```javascript
  entity != 'abc'
  ```

* Include entities based on entity label:

  ```javascript
  entity.displayName NOT LIKE '*test*'
  ```

* Include entities based on entity tags:

  ```javascript
  entity.tags.location IN ('SVL', 'NUR')
  ```

## Entity Group Filter

The filter discards commands for entities that do not belong to one of the entity groups specified in the rule. The filter is applied only if the list of selected entity groups is not empty.

![](./images/filter-entity-group.png)

## Filter Expression

The filter matches commands for which the expression returns `true`.

The expression consists of one or multiple boolean checks joined with [boolean operators](operators.md#boolean-operators) `AND`, `OR`, and `NOT`.

The expression can include command fields listed below, literal values, and [functions](functions.md) except [statistical functions](functions-statistical.md).

| Base | Series | Message | Property |
|---|---|---|---|
| <ul><li>`entity`</li><li>`tags.{name}`</li><li>`entity.tags.{name}`</li><li>`entity.field`</li><li>`metric.tags.{name}`</li><li>`metric.field`</li></ul>| <ul><li>`metric`</li><li>`value`</li></ul>|<ul><li>`type`</li><li>`source`</li><li>`severity`</li><li>`message`</li></ul> | <ul><li>`type`</li><li>`keys`</li><li>`keys.{name}`</li><li>`properties`</li><li>`properties.{name}`</li></ul>|

```javascript
entity != 'nurswgvml007'
```

```javascript
entity.displayName NOT LIKE '*test*'
  && entity.tags.location = 'SVL'
```

Tag values can be accessed using dot notation `tags.{tag-name}` or square brackets `tags['tag-name']`.

```javascript
tags.location LIKE 'nur*' && tags.state = 'CA'
```

```javascript
type = 'activemq_service' AND keys.service = 'health'
```

```javascript
entity.tags.environment != 'test'
  && message NOT IN collection('linux-ignore-commands')
```

![](./images/filter-expression.png)

```javascript
tags.method = 'get' AND tags.site = 'OperationsManager2007WebConsole'
```

Use square brackets if the tag name contains special characters such as `-,+,=`.

```javascript
tags['mount-point'] NOT LIKE '*u113452*'
```

## Time Offset Filter

If set to a positive value, the filter discards commands with a timestamp that deviates by more than specified `grace` interval from the current server time. This filter can be used to ignore delayed and future data.

![](./images/filter-time.png)

Set count to `0` to disable the filter.

## Out-of-Order Filter

The filter discards commands timestamped **earlier** than the time of the most recent command in the given window.

![](./images/filter-out-of-order.png)

## Filter Log

To view the list of commands that matched the **Data Type** and **Metric/Type/Source** filters and the results of their evaluation by other filters, click **View Filter Log** located on the **Filters** tab.

![](./images/filter-log.png)

## Filter vs Condition

While the same checks can be performed in the filter expression and in the alert condition, performance increases if checks that refer to command fields are specified in the filter expression whereas checks that require the [window](window.md) object are specified in the alert condition. Discarding unnecessary commands early minimizes the number of windows maintained by the rule engine.

For example, `tags.mount_point = '/'` refers to the `tags` field which is present in the incoming command and therefore can be checked in the filter expression. As a result commands with other tag values (for example `mount_point` = `/dev`) are discarded early in the process without causing additional windows to be created.

[Statistical functions](functions-statistical.md), on the other hand, operate on values stored in the window and therefore cannot be used during the filtering stage. Since the window is not available at the filtering stage, the statistical functions shall return `zero` if included in a filter expression.
