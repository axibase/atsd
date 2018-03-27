# Rule Functions

## Overview

The `rule` functions provide a way to check windows created by other rules. The matching windows may contain data for series that are different from the series in the current window. These functions may be used for correlation purposes.

Windows are matched using their [grouping](grouping.md) tags, irrespective of tags present in the last command. 
For example, if the window is grouped by entity and tags `t1` and `t2` and the expression checks for `tags.t3 NOT LIKE ""`, such an expression will return `false` even if `t3` is present in the last command because `t3` is not included in the grouping tags.

The current window is excluded from matching.

## Reference

* [rule_open](#rule_open)
* [rule_window](#rule_window)
* [rule_windows](#rule_windows)

## `rule_open`

```javascript
  rule_open(string r[, string e[, string p]]) boolean
```

Checks if there is at least one window with the 'OPEN' or 'REPEAT' [status](README.md#window-status) for the specified rule `r`, entity `e` and expression `p` to match other windows.

The function returns `true` if a matching window is found, `false` otherwise.

## `rule_window`

```javascript
  rule_window(string r[, string e[, string p]]) object
```

Returns the first matching window for the specified rule `r`, entity `e` and expression `p` to match other windows.

The function returns `null` if no matching windows are found.

The following window fields can be accessed via the dot notation, for example `rule_window('jvm_derived').entity`:

 * [base fields](window.md#base-fields), excluding `repeat_interval`
 * `lastText`

> Note: 
> * `entity` and `tags` are the same as in the last window command;
> * if minimum interval is not set then `min_interval_expired = true`;
> * `threshold` - the threshold matched by the last command.

---

The following match conditions are applied:

* Entity:
  * If the entity argument `e` is not specified, the **current** entity in the window is used for matching.
  * If the entity argument `e` is specified as `null` or empty string `''`, all entities are matched.

* Expression:
  * The expression `p` can include the following fields and supports wildcards in field values:
   
    |**Name**|**Description**|
    |---|---|
    |message |The text value, which is equal to 'message' field in case of message command.|
    |tags and tags.{name}/tags['name']|Command tags.|
    |status|Window [status](README.md#window-status).|
  * The expression `p` can include window [fields](window.md#window-fields) as placeholders.  

### `rule_open` Examples 

```javascript
  /*
  Evaluates to `true` if the average value of samples in the current window exceeds 10 
  and if the 'disk_used_check' rule is open for the same entity.
  */
  avg() > 10 && rule_open('disk_used_check')

  /*
  Match using Message Fields.
  */
  rule_open('disk_used_check', 'nurswgvml007', 'tags.source="' + source +'" AND tags.type="' + type +'" AND message="' + message +'"')
```

Assume the following windows have status 'REPEAT' and the function is called from the rule 'test_rule_open':

```
+----------------+------------------------------+
| Entity         | nurswgvml007                 |
| Entity Label   | NURswgvml007                 |
| Metric	 | message                      |
| Tags	         | container-name = axibase     | 
|                | container-status = UP        |
|                | host = 172.17.0.3            |
|                | port = 22                    |
| Rule	         | jvm_derived                  |
| Rule Expression| true                         |
| Text Value	 | Starting sql query execution.|
+----------------+------------------------------+
```
```
+----------------+------------------------------+
| Entity         | atsd                         |
| Entity Label   | ATSD                         |
| Metric	 | message                      |
| Tags	         | container-name = axibase2    |
|                | external-port = 43022        |
| Rule	         | test_rule_open               |
| Rule Expression| true                         |
| Text Value	 | Send 300 commands to ATSD.   |
+----------------+------------------------------+
```

* No optional parameters

```javascript
  /* 
  Returns 'false' because the entity in window of the referenced rule is different 
  */
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
  /*
  Evaluates to `true` if the average value of samples in the current window exceeds 10 
  and if the first window for 'disk_used_check' rule in the same entity has any other status except 'OPEN'.
  */
  avg() > 10 && rule_window('disk_used_check') != null && rule_window('disk_used_check').status != 'OPEN'

  /*
  Match using Message Fields.
  */
  rule_window('disk_used_check', 'nurswgvml007', 'tags.source="' + source +'" AND tags.type="' + type +'" AND message="' + message +'"')

  /*
  Match using wildcard.
  */
  rule_window('jvm_derived', 'nurswgvml007', "tags.container-name LIKE 'axi*'").repeat_count

  /*
  Used the same entity as in the current window.
  */
  rule_window('slack-bot-cmd-confirm', entity, 'tags.event.user!="' + tags.event.user + '" AND message="' + message + '" AND status!="CANCEL"')
  ```

## `rule_windows`

```javascript
  rule_windows(string r, string p) [object]
```

Returns the collection of windows for the specified rule `r`, expression `p` and the same entity as in the current window.

The following match conditions are applied:

* The expression `p` can include the following fields and supports wildcards in field values:
   
    |**Name**|**Description**|
    |---|---|
    |message |The text value, which is equal to 'message' field in case of message command.|
    |tags and tags.{name}/tags['name']|Command tags.|
    |status|Window [status](README.md#window-status).|
    
* The expression `p` can include window [fields](window.md#window-fields) as placeholders.  
 
To access the n-th element in the collection, use square brackets `[index]` or `get(index)` method (starting with 0 for the first element).

The following window fields can be accessed via the dot notation, for example `rule_windows('jvm_derived', 'status="CANCEL"')[0].entity`:

 * [base fields](window.md#base-fields), excluding `repeat_interval`
 * `lastText`

> Note: 
> * `tags` are the same as in the last window command;
> * if minimum interval is not set then `min_interval_expired = true`;
> * `threshold` - the threshold matched by the last command.

Examples:

```javascript
  /* 
  Returns open windows of 'jvm_derived' rule 
  with the same value for 'tags.host' as at the current window. 
  */
  rule_windows('jvm_derived',"tags.host='" + tags.host + "'")

  /*
  Match with tags, message and status.
  */
  rule_windows('slack-bot-cmd-confirm', 'tags.event.user!="' + tags.event.user + '" AND message="' + message + '" AND status!="CANCEL"')

  /*
  Access to window fields.
  */
  rule_windows('jvm_derived',"tags.port='22'").lastText

  /*
  Match using Message Fields.
  */
  rule_windows('jvm_derived', 'tags.source="' + source +'" AND tags.type="' + type +'" AND message="' + message +'"')
```
