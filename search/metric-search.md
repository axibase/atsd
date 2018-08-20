# Metric Search

## Overview

The metric search interface finds metrics by name or metric tag values.

## Syntax

Search text can consist of multiple keywords.

* Keywords containing a colon are treated as **tag** filters, for example `example-tag:example-value` finds metrics with tag `example-tag` set to `example-value`
* Reserved keywords `min-date` and `max-date` filter entities by [ISO format](../shared/date-format.md) **last insert date**.
* Remaining keywords match **metric names**.

```ls
name-filter [tag-name-1:tag-value-2] [tag-name-2:tag-value-2]
```

## Wildcards

Name patterns support the following wildcard symbols:

* `*` Matches any number of characters.
* `?` Matches any one character.

Wildcard `*` is automatically appended to the end of name patterns when performing searches, thereby matching any metrics which contain a name that **begins** with the specified text. See [Examples](#examples) for a demonstrative explanation.

Multiple keywords are evaluated as boolean `AND` conditions.

Metric names, tag names, and tag values are matched on a  **case-insensitive** basis.

## Examples

* Find metrics which begin with keyword `cpu`:

  ```ls
  cpu
  ```

  **Identical query**:

  ```ls
  cpu*
  ```

* Find metrics which contain keyword `cpu`:

  ```ls
  *cpu*
  ```

* Find metrics with tag `frequency` set to `Daily`:

  ```ls
  frequency:Daily
  ```

* Find metrics with any value for tag `frequency` and display `frequency` column:

  ```ls
  frequency:*
  ```

* Find metrics with non-empty value for tag `frequency`:

  ```ls
  frequency:
  ```

* Find metrics which begin with keyword `cpu` **and** contain tag `frequency` set to `Daily`:

  ```ls
  cpu frequency:Daily
  ```
