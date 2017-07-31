# Metric Search

## Overview

The metric search interface can find metrics by name or specific metric tag values.

## Syntax

A keyword without a colon is considered a metric name filter, a keyword containing a colon is treated as a tag name.

```ls
name-filter [tag-name-1:tag-value-2] [tag-name-2:tag-value-2]
```

The `*` wildcard is automatically appended to the `name-filter`, thereby including all metrics **starting** with the specified name.

If the search expression contains a tag name, such tags are displayed in the results table.


## Wildcards

* `*` matches any number of characters.
* `?` matches any one characher.

## Examples

* Find metrics starting with 'cpu'

```ls
cpu
```

* Find metrics starting with 'cpu' (wildcard alternative)

```ls
cpu*
```

* Find metrics containing 'cpu'

```ls
*cpu*
```

* Find metrics with the tag 'hello' set to 'World'


```ls
hello:World
```

* Find metrics with any value for the tag 'hello'


```ls
hello:*
```

* Find metrics starting with 'cpu' and the tag 'unit' set to 'percent'


```ls
cpu hello:* unit:percent
```
