# Rule Functions

## Overview

The `rule` functions provide a way to check the status of windows created by other rules. The matching windows may contain data for series that are different from the series in the current window. The functions can be used for correlation purposes.

The following match conditions are applied:

* If the entity argument `e` is not specified, the same entity is used for matching regardless of grouping tags and message.
* If the entity argument `e` is specified as null or empty string, any entity is matched.
* The expression `p` can be built using tags, message, wildcards and [window fields](window.md#window-fields).

The windows are matched using their [grouping](grouping.md) tags, irrespective of tags present in the last command. 
For example, if the window is grouped by entity and tags `t1` and `t2` and the expression checks for `tags.t3 NOT LIKE ""`, such expression will return `false` even if `t3` is present in the last command because `t3` is not included in the grouping tags.

> Open window means a window with status `OPEN` or `REPEAT`.

Current window is excluded from matching.

## Reference

* [rule_open](#rule_open)
* [rule_window](#rule_window)
* [rule_windows](#rule_windows)

## `rule_open`

```javascript
  rule_open(string r[, string e[, string p]]) boolean
```

Checks if there is at least one window with the 'OPEN' or 'REPEAT' status for the specified rule `r`, entity `e` and expression `p`.

The function returns `true` if a matching window is found, `false` otherwise.

Examples:

The following expression will evaluate to `true` if the average value of samples in the current window exceeds 10 and if rule 'disk_used_check' is open for the same entity.

```javascript
  avg() > 10 && rule_open('disk_used_check')
```

Assume that there is the following windows with status 'REPEAT' and function is called from the rule 'test_rule_open':

```
+----------------+------------------------------+
| Entity         | nurswgvml007                 |
| Entity Label   | NURswgvml007                 |
| Metric	       | message                      |
| Tags	         | container-name = axibase     | 
|                | container-status = UP        |
|                | host = 172.17.0.3            |
|                | port = 22                    |
| Rule	         | jvm_derived                  |
| Rule Expression| true                         |
| Text Value	   | Starting sql query execution.|
+----------------+------------------------------+
```
```
+----------------+------------------------------+
| Entity         | atsd                         |
| Entity Label   | ATSD                         |
| Metric	       | message                      |
| Tags	         | container-name = axibase2    |
|                | external-port = 43022        |
| Rule	         | test_rule_open               |
| Rule Expression| true                         |
| Text Value	   | Send 300 commands to ATSD.   |
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

## `rule_window`

```javascript
  rule_window(string r[, string e[, string p]]) object
```

Returns the first matching window in `OPEN` or `REPEAT` status for the specified rule `r`, entity `e` and expression `p` to match other windows.

The function returns `null` if no matching windows are found.

Example:

```javascript
  avg() > 10 && rule_window('disk_used_check') != null && rule_window('disk_used_check').status != 'CANCEL'
```

The above expression will evaluate to `true` if the average value of samples in the current window exceeds 10 and if the first window for rule 'disk_used_check' for the same entity has any other status except `CANCEL`.


## `rule_windows`

```javascript
  rule_windows(string r, string p) [object]
```

Returns the collection of windows in `OPEN` or `REPEAT` status for the specified rule `r`, expression `p` and the same entity as in the current window.

Example:

```javascript
  /* 
  Returns open windows of 'jvm_derived' rule 
  with the same value for 'tags.host' as at the current window. 
  */
  rule_windows('jvm_derived',"tags.host='" + tags.host + "'")
```
