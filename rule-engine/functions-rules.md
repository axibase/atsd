# Rule Functions

## Overview

The rule functions provide a way to check the status of windows created by other rules. The matching windows may contain data for series that are different from the series in the current window. The functions can be used for correlation purposes.

If the current rule and the referenced rules have different grouping settings, the following match conditions are applied:

| Current Rule | Referenced Rule | rule_open() Result |
|---|---|---|
| No tags | No tags | `true` if there is an open window by the referenced rule with the same entity. Tags are ignored. |
| No tags | Has tags | `true` if there is an open window by the referenced rule with the same entity. Tags are ignored. |
| Has tags | No tags | `true` if there is an open window by the referenced rule with the same entity. Tags are ignored. |
| Has tags | Has tags | `true` if there is an open window by the referenced rule with the same entity **and common tags with the same values**. |

> Open window means a window with status `OPEN` or `REPEAT`.

## `rule_open`

```java
  rule_open(string r) boolean
```
Checks if there is at least one window with the 'OPEN' or 'REPEAT' status for the specified rule `r` and the same entity and tags as defined in the current window.

> The function returns `false` if a matching window is not found.

Example:

```java
  avg() > 10 && rule_open('disk_used_check')
```

The above expression will evaluate to `true` if the average value of samples in the current window exceeds 10 and if rule 'disk_used_check' is open for the same entity and tags as defined in this window.

## `rule_window`

```java
  rule_window(string r) EventWindow
```
Returns the first matching window for the specified rule `r` and the same entity and tags as defined in the current window.

Example:

```java
  avg() > 10 && rule_window('disk_used_check') != null && rule_window('disk_used_check').status != 'CANCEL'
```

> The function returns `null` if a matching window is not found.

The above expression will evaluate to `true` if the average value of samples in the current window exceeds 10 and if the first window for rule 'disk_used_check' and the same entity and tags as defined in this window has any other status except `CANCEL`.
