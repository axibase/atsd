# Rule Functions

## Overview

These functions check windows created by other rules. Matching windows can contain data for series that differ from the series in the current window. Use these functions for correlation purposes.

Windows are matched using [grouping](grouping.md) tags, irrespective of tags present in the last command.
For example, if the window is grouped by entity and tags `t1` and `t2` and the expression checks for `tags.t3 NOT LIKE ""`, such an expression returns `false` even if `t3` is present in the last command because `t3` is not included in the grouping tags.

The current window is excluded from matching.

## Reference

* [rule_open](#rule_open)
* [rule_window](#rule_window)
* [rule_windows](#rule_windows)

## `rule_open`

```javascript
rule_open(string rule [, string entity [, string expression]]) boolean
```

Checks if there is at least one window with the `OPEN` or `REPEAT` [status](README.md#window-status) for the specified `rule`, `entity` and `expression` to match other windows.

Returns `true` if a matching window is found, `false` otherwise.

## `rule_window`

```javascript
rule_window(string rule [, string entity [, string expression]]) Window
```

Returns the **first** matching [`Window`](window-fields.md#base-fields) object for the specified `rule`, `entity` and `expression` to match other windows.

Returns `null` if no matching windows are found.

Window [fields](window-fields.md#base-fields) except `repeat_interval` can be accessed via the dot notation, for example `rule_window('jvm_derived').entity`. In addition, the matched window provides the `lastText` field which contains the last message text received by the window.

Notes:

* `entity` and `tags` are the same as in the last window command.
* If minimum interval is not set then `min_interval_expired = true`.
* `threshold`: the threshold value matched by the last command.

---

Applies the following match conditions

* Entity:
  * If the `entity` is not specified, the **current** entity in the window is used for matching.
  * If the `entity` is specified as `null` or empty string `''`, all entities are matched.

* Expression:
  * The `expression` can include the following fields and supports wildcards in field values:

    |**Name**|**Description**|
    |---|---|
    |message |The text value, which is equal to `message` field in case of `message` command.|
    |tags and `tags.{name}`/`tags['name']`|Command tags.|
    |status|Window [status](README.md#window-status).|
  * The `expression` can include window [fields](window.md#window-fields) as placeholders.

### `rule_open` Examples

```javascript
/* Evaluates to `true` if the average value of samples in the current window exceeds 10
and if the 'disk_used_check' rule is open for the same entity. */
avg() > 10 && rule_open('disk_used_check')

/* Match using Message Fields. */
rule_open('disk_used_check', 'nurswgvml007',
          'tags.source="' + source +'" AND tags.type="' + type +'" AND message="' + message +'"')
```

Assume the following windows have status `REPEAT` and the function is called from the rule `test_rule_open`:

```txt
+----------------+------------------------------+
| Entity         | nurswgvml007                 |
| Entity Label   | NURswgvml007                 |
| Metric         | message                      |
| Tags           | container-name = axibase     |
|                | container-status = UP        |
|                | host = 172.17.0.3            |
|                | port = 22                    |
| Rule           | jvm_derived                  |
| Rule Expression| true                         |
| Text Value     | Starting sql query execution.|
+----------------+------------------------------+
```

```txt
+----------------+------------------------------+
| Entity         | atsd                         |
| Entity Label   | ATSD                         |
| Metric         | message                      |
| Tags           | container-name = axibase2    |
|                | external-port = 43022        |
| Rule           | test_rule_open               |
| Rule Expression| true                         |
| Text Value     | Send 300 commands to ATSD.   |
+----------------+------------------------------+
```

* No optional parameters

```javascript
/* Returns 'false' because the entity in window of the referenced rule is different */
rule_open('jvm_derived')
```

* Entity is specified

```javascript
/* Returns 'true' */
rule_open('jvm_derived', 'nurswgvml007')

/* Returns 'true' */
rule_open('jvm_derived', '')

/* Returns 'true' */
rule_open('jvm_derived', null)
```

* Match with tags

```javascript
/* Returns 'true' */
rule_open('jvm_derived', 'nurswgvml007', "tags.container-status != ''")

/* Returns 'true' */
rule_open('jvm_derived', 'nurswgvml007', "tags.container-name LIKE 'axi*'")
```

* Match with message

```javascript
/* Returns 'true' */
rule_open('jvm_derived', 'nurswgvml007', "message != ''")

/* Returns 'false' */
rule_open('jvm_derived', 'nurswgvml007', "message NOT LIKE 'Starting*'")
```

* Match with message and tags

```javascript
/* Returns 'true' */
rule_open('jvm_derived', 'nurswgvml007', "message != '' AND tags.host='172.17.0.3'")

/* Returns 'true' */
rule_open('jvm_derived', 'nurswgvml007', "tags.port != '23' && message LIKE 'Starting*'")
```

### `rule_window` Examples

```javascript
/* Evaluates to `true` if the average value of samples in the current window exceeds 10
and if the first window for 'disk_used_check' rule in the same entity has any other status except 'OPEN'. */
avg() > 10 && rule_window('disk_used_check') != null && rule_window('disk_used_check').status != 'OPEN'

/* Match using Message Fields. */
rule_window('disk_used_check', 'nurswgvml007',
            'tags.source="' + source +'" AND tags.type="' + type +'" AND message="' + message +'"')

/* Match using wildcard. */
rule_window('jvm_derived', 'nurswgvml007', "tags.container-name LIKE 'axi*'").repeat_count

/* Used the same entity as in the current window. */
rule_window('slack-bot-cmd-confirm', entity,
            'tags.event.user!="' + tags.event.user + '" AND message="' + message + '" AND status!="CANCEL"')
```

## `rule_windows`

```javascript
rule_windows(string rule, string expression) [Window]
```

Returns the collection of [Window](window.md#window-fields) objects for the specified `rule`, `expression` and the same entity as in the current window.

The following match conditions apply:

* The `expression` can include the following fields and supports wildcards in field values:

    |**Name**|**Description**|
    |---|---|
    |message |The text value, which is equal to `message` field in case of `message` command.|
    |tags and `tags.{name}`/`tags['name']`|Command tags.|
    |status|Window [status](README.md#window-status).|

* The `expression` can include window [fields](window.md#window-fields) as placeholders.

To access the `n`-th window in the collection, use square brackets `[index]` or `get(index)` method, starting with `0` for the first element).

Access window [fields](window-fields.md#base-fields) except `repeat_interval` via dot notation, for example `rule_windows('jvm_derived', 'status="CANCEL"')[0].entity`. In addition, the matched windows provide the `lastText` field which contains the last message text received by the window.

Notes:

* `tags` are the same as in the last window command;
* if minimum interval is not set then `min_interval_expired = true`;
* `threshold`: the threshold matched by the last command.

Examples:

```javascript
/* Returns open windows of 'jvm_derived' rule
with the same value for 'tags.host' as at the current window. */
rule_windows('jvm_derived',"tags.host='" + tags.host + "'")

/* Match with tags, message and status.*/
rule_windows('slack-bot-cmd-confirm',
             'tags.event.user!="' + tags.event.user + '" AND message="' + message + '" AND status!="CANCEL"')

/* Access to window fields. */
rule_windows('jvm_derived',"tags.port='22'").lastText

/* Match using Message Fields. */
rule_windows('jvm_derived', 'tags.source="' + source +'" AND tags.type="' + type +'" AND message="' + message +'"')
```
