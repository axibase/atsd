# Entity Views

## Overview

Entity Views provide a way to construct customized tabular presentations for subsets of entities that typically share similar attributes. The enabled entity views are listed under the [Entities] tab drop-down in the top menu.

## Access Controls

The view can be accessed by users with a 'read' permission for the entity group to which the view is linked.

## Settings

**Name** | **Description**
---|---
Name | View name displayed in the [Entities] tab drop-down.
Enabled | Enabled or disabled status. Disabled entity views are not visible in the [Entities] tab drop-down.
Entity Group | Entity Group which members are included in the view.
Entity Expression | A additional condition that entity group members must satisfy in order to be included in the view. The syntax is the same as supported by expression-based entity groups.
Dynamic Filter | The default [dynamic filter](#dynamic-filters) applied to entities on initial page load.
Split Table by Tag | Group entities by entity tag value into separate tables.
Display in Left Menu | If enabled, the view is accessible under its own tab in the left menu.
Display Index | Applies if entity view is displayed in the top menu. Specifies relative position of the tab. The tabs are sorted by index in ascending order.
Multi-Entity Portal | [Portal](#portal) with time series charts for entities displayed in the view.
Menu Icon | Icon to be displayed with view at the left menu.

## Filters

The list of displayed entities is established as follows:

* The list of entities is initially set to the current members of the linked entity group.
* If Entity Expression is specified, the member entities are checked with this expression. Members that fail to satisfy this condition are discarded.
* If a Dynamic Filter is applied by the user, the entities are additionally checked again the selected filter. Entities that fail to satisfy the filter condition are hidden.
* If a Search text is specified, only entities with a column value containing the search keyword are displayed.

> While the Dynamic Filter can be toggled by the user, the Entity Group and Entity Expression (if specified) are enforced at all times.

## Search

The search is performed based on column values displayed in the table. An entity meets the search condition if one of the column values for the entity row contains the specified search keyword.

## Table

The table consists of multiple columns, one row per entity. Each cell displays a particular attribute such as entity tag value or property tag value for a given entity.

### Table Header

**Name** | **Description**
---|---
Type | Column type.
Header | Column name.
Value | Applicable to 'Entity Tag', 'Property Tag', 'Series Value' and 'Last Insert' [column types](#column-types). Contains entity tag name, [property search expression](../rule-engine/property-search.md) or metric name respectively.
Link | Specifies if the cell value should also be clickable as a link. See [Links](#links) options.
Link Label | Text value displayed for the link. If `icon-` is specified, the text is replaced with an [icon](http://getbootstrap.com/2.3.2/base-css.html#icons), such as `icon-search`. If Link is set to 'Entity Property', the text is resolved to the property expression value.
Link Template | Path to a page in the user interface with support for placeholders: `${entity}` and `${value}` (current cell value).
Formatting | A [function](#formatting) or an expression to round numbers and convert units.

### Column Types

**Name** | **Description**
---|---
Entity Tag | Name of the entity tag.
Property Tag | [Property search expression](../rule-engine/property-search.md) in the format of `type:{key-name=key-value}:tag-name`.
Series Value | Name of the metric for which the last value for this entity will be displayed.<br>If multiple series match the specified metric and entity, the value for first one will be displayed.
Name Column | Entity name with a link to the editor page for the entity.
Label Column | Entity label with a link to the editor page for the entity.
Portals Column | Link to the portals page.
Properties Column | Link to the properties page for the entity.
Last Insert | Last insert date for the specified metric with a link to the list of last insert dates for metrics of the given entity.<br>Value must be specified as `metric:[threshold]`, where the optional parameter `threshold` is the permissible lag.<br>If `lastInsertDate < now - threshold`, the cell is highlighted with orange background.
Enabled Column | Entity status.

### Links

**Name** | **Description**
---|---
Entity | Entity editor page.
Property | Portal with a property widget for the given entity and property type.
Chart | Portal with a time chart displaying the data for the specified metric and entity.
Entity Property | Portal with a property widget for another entity retrieved with the property expression.

### Formatting

The following functions are available in 'Formatting' section:

#### Text Functions 

* [upper](functions-text.md#upper)
* [lower](functions-text.md#lower)
* [truncate](functions-text.md#truncate)
* [coalesce](functions-text.md#coalesce)
* [keepAfter](functions-text.md#keepafter)
* [keepAfterLast](functions-text.md#keepafterlast)
* [keepBefore](functions-text.md#keepbefore)
* [keepBeforeLast](functions-text.md#keepbeforelast)
* [replace](functions-text.md#replace)
* [capFirst](functions-text.md#capfirst)
* [capitalize](functions-text.md#capitalize)
* [removeBeginning](functions-text.md#removebeginning)
* [removeEnding](functions-text.md#removeending)
* [urlencode](functions-text.md#urlencode)
* [jsonencode](functions-text.md#jsonencode)
* [htmlDecode](functions-text.md#htmldecode)
* [unquote](functions-text.md#unquote)
* [countMatches](functions-text.md#countmatches)
* [abbreviate](functions-text.md#abbreviate)
* [indexOf](functions-text.md#indexof)
* [locate](functions-text.md#locate)
* [trim](functions-text.md#trim)
* [length](functions-text.md#length)

#### Formatting Functions 

* [convert](functions-format.md#convert)
* [formatNumber](functions-format.md#formatnumber)
* [date_format](functions-format.md#date_format)
* [formatInterval](functions-format.md#formatinterval)
* [formatIntervalShort](functions-format.md#formatintervalshort)

#### Time Functions

* [elapsedTime](#elapsedtime)


## Dynamic Filters

**Name** | **Description**
---|---
Name | Filter name displayed in the drop-down.
Expression | A condition that entities must satisfy when the filter is selected in the drop-down. The expression may refer to `name` and `tags.{name}` columns defined in the entity view.

Filter expression examples:

```java
// name column
name like 'nur*'
```

```java
// entity tag column
upper(tags.name) LIKE '*SVL*'
```

```java
// entity tag column
lower(tags.app) LIKE '*hbase*'
```

```java
// property tag column
tags['configuration::codename'] = 'Santiago'
```

## Portal

If the Multi-Entity Portal is defined manually or the entity view contains at least one 'Series Value' column, the statistics for entities can be viewed on a portal accessible with the [View Portal] button. If no portal is selected, the default portal displays metrics for columns of type 'Series Value'.

The multi-entity portal is any portal that displays a metric for multiple entities using the `${entities}` placeholder.


```ls
[widget]
  type = chart
  [series]
    metric = docker.cpu.avg.usage.total.percent
    entities = ${entities}
```
