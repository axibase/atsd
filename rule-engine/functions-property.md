# Property Functions

## Overview

A set of convenience methods to retrieve and compare property keys and tags using [property search](property-search.md) syntax.

## Reference

* [`property`](#property)
* [`property_values`](#property_values)
* [`property_compare_except`](#property_compare_except)
* [`property_map`](#property_map)
* [`property_maps`](#property_maps)
* [`getPropertyTypes`](#getpropertytypes)

## `property`

```csharp
property([string entity, ] string expr [, string date]) string
```

Returns the first value in the list of strings returned by the `property_values(expr)` function.

By default, the search is performed for the current entity that is initialized in the rule window. If the entity `entity` is specified explicitly as the first argument, the search is performed for the specified entity instead.

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
property_values([string entity, ] string expr [, string date]) [string]
```

Returns a list of property tag values for the given entity for the specified [property search](property-search.md) expression `expr`.

By default, the search is performed for the current entity that is initialized in the rule window. If the entity `entity` is specified explicitly as the first argument, the search is performed for the specified entity instead.

Optional start date `date` argument controls which property records to include. If specified, only property records received on or after the start date are included. The start date `date` can be an [ISO format](../shared/date-format.md) date or a [calendar keyword](../shared/calendar.md#keywords). If `date` is specified, the entity `entity` argument must also be specified.

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

## `property_compare_except`

* `property_compare_except([string key])`

```csharp
property_compare_except([string key]) map
```

Compares properties in the previous and the current `property` command, ignoring changes in the optional list of key names, and returns a map containing a list of changed keys. The function is supported by rules with `property` data type.

Sample difference map:

```txt
{args='-Xloggc:/home/axibase/gc_100.log' -> '-Xloggc:/home/axibase/gc_712.log'}
```

The map includes keys that are present in one command and absent in the other command.
The map is empty if no differences among the commands are present.
The values are compared in **case-insensitive** manner.

```java
NOT property_compare_except (['pid', '*time']).isEmpty()
```

  Returns `true` if property tags have changed except for the `pid` tag and any tags that end with `time`.

* `property_compare_except([string c], [string e])`

```javascript
property_compare_except([string key], [string previousValue]) map
```

  Same as `property_compare_except([string key])` with a list of previous values that are excluded from the difference map.

```java
NOT property_compare_except(['pid', '*time'], ['*Xloggc*']).isEmpty()
```

Returns `true` if property tags have changed, except for the `pid` tag, any tags that end with `time`, and any previous tags with value containing `Xloggc`. The pattern `*Xloggc*` ignores changes such as:

```txt
{args='-Xloggc:/home/axibase/gc_100.log' -> '-Xloggc:/home/axibase/gc_712.log'}
```

## `property_map`

```csharp
property_map([string entity,] string expression [, string date]) map
```

Returns a map containing keys and tags for the specified [property search](property-search.md) `expression`. The map is composed as follows: sorted keys (if present) are followed by matching sorted tags.

By default, the search is performed for the current entity that is initialized in the rule window. If `entity` is specified explicitly as the first argument, the search is performed for the specified entity instead.

Optional start `date` argument controls which property records to include. If specified, only property records received **on or after** the start date are included. The start `date` can be an [ISO format](../shared/date-format.md) date or a [calendar keyword](../shared/calendar.md#keywords). If `date` is specified, the `entity` argument must be specified as well.

Search `expression` can include only the property type (without key and tag parts). Omit the `<tag_name>` or specify a string to match tags with `*` used as a wildcard, in which case all keys and tags are returned.

Supported syntax options:

* `<property_type>`
* `<property_type>:[<key>=<value>[,<key>=<value>]]:`
* `<property_type>:[<key>=<value>[,<key>=<value>]]:*`
* `<property_type>:[<key>=<value>[,<key>=<value>]]:*abc*`

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

Returns a list of maps, each map containing keys and tags for the specified [property search](property-search.md) `expression`. The maps are composed as follows: sorted keys (if present) are followed by matching sorted tags.

By default, the search is performed for the current entity that is initialized in the rule window. If the `entity` is specified explicitly as the first argument, the search is performed for the specified entity instead.

Optional start `date` argument controls which property records to include. If specified, only property records received on or after the start date are included. The start `date` can be an [ISO format](../shared/date-format.md) date or a [calendar keyword](../shared/calendar.md#keywords). If `date` is specified, the `entity` argument must be specified as well.

Search expression `s` can include only the property type without key-value pairs. Omit `<tag_name>` or specify a string to match tags with `*` used as a wildcard, in which case the function returns all keys and tags.

Supported syntax options:

* `<property_type>`
* `<property_type>:[<key>=<value>[,<key>=<value>]]:`
* `<property_type>:[<key>=<value>[,<key>=<value>]]:*`
* `<property_type>:[<key>=<value>[,<key>=<value>]]:*abc*`

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

Returns a sorted set of property types for the specified `entity`.

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
