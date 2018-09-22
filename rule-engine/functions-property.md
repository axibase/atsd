# Property Functions

## Overview

A set of convenience methods to retrieve and compare property keys and tags using [property search](property-search.md) syntax.

[Property](../schema.md#properties) is a collection of arbitrary key-value pairs describing a given entity, grouped by user-defined `type`.

Property record consists of:

* Type
* Keys
* Tags

## Reference

* [`property`](#property)
* [`property_values`](#property_values)
* [`property_compare`](#property_compare)
* [`property_compare_except`](#property_compare_except)
* [`property_map`](#property_map)
* [`property_maps`](#property_maps)
* [`getPropertyTypes`](#getpropertytypes)

## `property`

```csharp
property([string entity, ] string expression [, string date]) string
```

Returns tag value for the specified [property](../schema.md#properties) [search](property-search.md) `expression`. If the expression matches multiple records, the function returns tag value for the most recent record.

The basic `expression` contains property type and tag name, separate by two semi-colons.

```ls
{property_type}::{tag_name}
```

By default, the search is performed for the current entity that is initialized in the rule window. If the `entity` is specified explicitly as the first argument, the search is performed for the specified entity instead.

An optional start date `date` argument controls which property records to include. If specified, only property records received on or after the start date are included. The start date `date` can be an [ISO format](../shared/date-format.md) date or a [calendar keyword](../shared/calendar.md#keywords). If `date` is specified, the `entity` argument must also be specified.

Returns an empty string if no matching property records are found.

Examples:

```javascript
property('docker.container::image')
```

```javascript
/* Returns the most recent value if it received later than 2018-01-16T15:38:04.000Z,
otherwise returns an empty string */
property('nurswgvml007', 'docker.container::image', '2018-01-16T15:38:04.000Z')
```

## `property_values`

```csharp
property_values([string entity, ] string expression [, string date]) [string]
```

Returns a list of property tag values for the given entity for the specified [property](../schema.md#properties) [search](property-search.md) `expression`.

By default, the search is performed for the current entity that is initialized in the rule window. If the `entity` is specified explicitly as the first argument, the search is performed for the specified entity instead.

Optional start `date` argument controls which property records to include. If specified, only property records received on or after the start date are included. The start date `date` can be an [ISO format](../shared/date-format.md) date or a [calendar keyword](../shared/calendar.md#keywords). If `date` is specified, the entity `entity` argument must also be specified.

The function returns an empty list if the entity, property or tag is not found.

To access the `n`-th string in the collection, use square brackets `[index]` or `get(index)` method (starting with `0` for the first element).

Examples:

```javascript
property_values('docker.container::image')
```

```javascript
/* Returns the second value of the list */
property_values('docker.container::image')[1]
property_values('docker.container::image').get(1)
```

```javascript
property_values('linux.disk:fstype=ext4:mount_point').contains('/')
```

```javascript
property_values('nurswgvml007', 'docker.container::image')
```

```javascript
/* Returns property tag values received later than 2018-01-16T15:38:04.000Z */
property_values('nurswgvml007', 'docker.container::image', '2018-01-16T15:38:04.000Z')
```

```javascript
/* Returns property tag values received later than 00:00:00 of the current day */
property_values('nurswgvml007', 'docker.container::image', 'today')
```

## `property_compare`

```csharp
property_compare() map
```

Compares tags in the received `property` command with the previous (stored) command, and returns a map containing a list of changed keys and the value difference. The value difference is a string created using the `'old)value' -> 'new_value'` pattern.

:::tip Scope
The function is supported by rules with `property` data type.
:::

Current command tags:

```txt
{"state": "Running", "location": "NUR", "process_id": "730"}
```

Previous command tags:

```txt
{"state": "Stopped", "location": "NUR", "exit_code": "-1"}
```

`property_compare()` difference map:

```txt
{"state": "'Running -> Stopped'", "process_id": "'730' -> ''", "exit_code": "'' -> '-1'"}
```

The map includes keys that are present in one command and absent in the other command.
The map is empty if no differences among the commands are present.
The values are compared in **case-insensitive** manner.

## `property_compare_except`

```csharp
property_compare_except([string name]) map
```

The function compares property tags similar to the `property_compare()` function, while ignoring changes in tags which match one of the patterns in the argument list.

```java
NOT property_compare_except (['pid', '*time']).isEmpty()
```

The above example returns `true` if at least one property tag has changed except for the `pid` tag and any tags that end with `time`.

* `property_compare_except([string c], [string e])`

```javascript
property_compare_except([string name], [string prevVal]) map
```

Same as above, while ignoring changes in tags with **previous** values that match one of the `prevVal` patterns.

```java
NOT property_compare_except(['pid', '*time'], ['*Xloggc*']).isEmpty()
```

The above example returns `true` if at least one property tag has changed, except for the `pid` tag, any tags that end with `time`, and any tags with previous value containing `Xloggc`. The pattern `*Xloggc*` ignores changes such as:

```txt
{"args": "'-Xloggc:gc_100.log' -> '-Xloggc:gc_712.log'"}
```

## `property_map`

```csharp
property_map([string entity,] string expression [, string date]) map
```

Returns a map containing keys and tags for the specified [property](../schema.md#properties) [search](property-search.md) `expression`. The map is composed as follows: sorted keys (if present) are followed by matching sorted tags.

By default, the search is performed for the current entity that is initialized in the rule window. If `entity` is specified explicitly as the first argument, the search is performed for the specified entity instead.

Optional start `date` argument controls which property records to include. If specified, only property records received **on or after** the start date are included. The start `date` can be an [ISO format](../shared/date-format.md) date or a [calendar keyword](../shared/calendar.md#keywords). If `date` is specified, the `entity` argument must be specified as well.

Search `expression` can include only the property type (without key and tag parts). Omit the `{tag_name}` or specify a string to match tags with `*` used as a wildcard, in which case all keys and tags are returned.

Supported syntax options:

* `{property_type}`
* `{property_type}:[{key_name}={key_value}[,{key_name}={key_value}]]:`
* `{property_type}:[{key_name}={key_value}[,{key_name}={key_value}]]:*`
* `{property_type}:[{key_name}={key_value}[,{key_name}={key_value}]]:*abc*`

Returns an empty map if the entity, property or tag is not found.

Examples:

```javascript
/* Returns map with tags starting with 'cpu' in the 'configuration' type */
property_map('configuration::cpu*')
```

```javascript
/* Returns map of the 'configuration' type for the entity 'nurswgvml007' */
property_map('nurswgvml007','configuration::')
```

```javascript
/* Returns map if the most recent property record received later than 00:00:00 of the current day,
otherwise returns an empty map */
property_map('nurswgvml007','configuration::', 'today')
```

## `property_maps`

```csharp
property_maps([string entity,] string expression [, string date]) [map]
```

Returns a list of maps, each map containing keys and tags for the specified [property](../schema.md#properties) [search](property-search.md) `expression`. The maps are composed as follows: sorted keys (if present) are followed by matching sorted tags.

By default, the search is performed for the current entity that is initialized in the rule window. If the `entity` is specified explicitly as the first argument, the search is performed for the specified entity instead.

Optional start `date` argument controls which property records to include. If specified, only property records received on or after the start date are included. The start `date` can be an [ISO format](../shared/date-format.md) date or a [calendar keyword](../shared/calendar.md#keywords). If `date` is specified, the `entity` argument must be specified as well.

Search expression `s` can include only the property type without key-value pairs. Omit `<tag_name>` or specify a string to match tags with `*` used as a wildcard, in which case the function returns all keys and tags.

Supported syntax options:

* `{property_type}`
* `{property_type}:[{key_name}={key_value}[,{key_name}={key_value}]]:`
* `{property_type}:[{key_name}={key_value}[,{key_name}={key_value}]]:*`
* `{property_type}:[{key_name}={key_value}[,{key_name}={key_value}]]:*abc*`

Returns an empty list if the entity, property or tag is not found.

To access the `n`-th map in the list, use square brackets `[index]` or `get(index)` method, starting with `0` for the first element.

Examples:

```javascript
/* Returns list of maps with tags starting with 'cpu' in the 'configuration' type */
property_maps('configuration::cpu*')
```

```javascript
/* Returns value of the 'host' key for the first map in the collection */
property_maps('configuration::cpu*')[0].get('host')
property_maps('configuration::cpu*').get(0).get('host')
```

```javascript
/* Returns list of maps of the 'configuration' type for the entity 'nurswgvml007' */
property_maps('nurswgvml007','configuration::')
```

```javascript
/* Returns list of maps of property records received later than 00:00:00 of the previous day */
property_maps('nurswgvml007','configuration::', 'yesterday')
```

## `getPropertyTypes`

```csharp
getPropertyTypes(string entity [, string startDate[, string endDate]]) [string]
```

Returns a sorted set of [property](../schema.md#properties) types for the specified `entity`.

Optional start `startDate` and `endDate` arguments control the time range for selecting property records. The dates can be specified as an [ISO format](../shared/date-format.md) string or a [calendar keyword](../shared/calendar.md#keywords).

To access the `n`-th string in the collection, use square brackets `[index]` or `get(index)` method, starting with `0` for the first element.

Examples:

```javascript
/* Returns property types for entity nurswgvml007*/
getPropertyTypes('nurswgvml007')
```

```javascript
/* Returns the first property type for entity nurswgvml007*/
getPropertyTypes('nurswgvml007')[0]
getPropertyTypes('nurswgvml007').get(0)
```

```javascript
/* Returns property types received after 2018-01-23T13:30:04.000Z */
getPropertyTypes('nurswgvml007','2018-01-23T13:30:04.000Z')
```

```javascript
/* Returns property types received after 00:00:00 of the previous day and before 00:00:00 of the current day*/
getPropertyTypes('nurswgvml007','yesterday', 'today')
```
