# Property Functions

## Overview

Property functions provide a set of convenience methods to retrieve and compare property keys and tags using [property search](property-search.md) syntax.

## Reference

* [property](#property)
* [property_values](#property_values)
* [property_compare_except](#property_compare_except)
* [property_map](#property_map)
* [property_maps](#property_maps)
* [getPropertyTypes](#getpropertytypes)

### `property`

```javascript
  property([string e, ]string s[, string d]) string
```

Returns the first value in the list of strings returned by the `property_values(string s)` function. 

By the default, the search is performed for the current entity that is initialized in the rule window. If the entity `e` is specified explicitly as the first argument, the search is performed for the specified entity instead.

An optional start date `d` argument controls which property records to include. If specified, only property records received on or after the start date are included. The start date `d` can be an `iso` date or a [calendar keyword](../shared/calendar.md#keywords). If `d` is specified, the entity `e` argument must also be specified.

The function returns an empty string if no matching roperty records are found.

Examples:

```javascript
  property('docker.container::image')
  
  /* Returns the most recent value if it received later than 2018-01-16T15:38:04.000Z, otherwise returns an empty string */
  property('nurswgvml007', 'docker.container::image', '2018-01-16T15:38:04.000Z')
```

### `property_values`

```javascript
  property_values([string e, ]string s[, string d]) [string]
```

Returns a list of property tag values for the given entity for the specified [property search](property-search.md) expression `s`.

By the default, the search is performed for the current entity that is initialized in the rule window. If the entity `e` is specified explicitly as the first argument, the search is performed for the specified entity instead.

An optional start date `d` argument controls which property records to include. If specified, only property records received on or after the start date are included. The start date `d` can be an `iso` date or a [calendar keyword](../shared/calendar.md#keywords). If `d` is specified, the entity `e` argument must also be specified.

The function returns an empty list if the entity, property or tag is not found.

To access the n-th element in the collection, use square brackets `[index]` or `get(index)` method (starting with 0 for the first element).

Examples:

```javascript
  property_values('docker.container::image')
  
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
  
  /* Returns property tag values received later than 00:00:00 of the current day */
  property_values('nurswgvml007', 'docker.container::image', 'today')
```

### `property_compare_except`

* `property_compare_except([string k])`

  ```javascript
    property_compare_except([string k]) map
  ```

  Compares previous and current property tags and returns a difference map containing a list of changed tag values.

  Sample difference map:

  ```javascript
    {inputarguments_19='-Xloggc:/home/axibase/axibase-collector/logs/gc_29286.log' -> '-Xloggc:/home/axibase/axibase-collector/logs/gc_13091.log'}
  ```

  The map includes tags that are not present in new property tags and tags that were deleted.
  If the difference map is empty, this means that no changes were identified.
  This comparison is case-insensitive.

  ```java
    NOT property_compare_except (['name', '*time']).isEmpty()
  ```

  Returns `true` if property tags have changed except for the `name` tag and any tags that end with `time`.

* `property_compare_except([string c], [string e])`

  ```javascript
    property_compare_except([string c], [string e]) map
  ```

  Same as `property_compare_except(keys)` with a list `e` of previous values that are excluded from the difference map.

  ```java
    NOT property_compare_except(['name', '*time'], ['*Xloggc*']).isEmpty()
  ```

  Returns true if property tags have changed, except for the `name` tag, any tags that end with `time`, and any previous tags with value containing `Xloggc`. The pattern `*Xloggc*` would ignore changes such as:

  ``` java
    {inputarguments_19='-Xloggc:/home/axibase/axibase-collector/logs/gc_29286.log'-> '-Xloggc:/home/axibase/axibase-collector/logs/gc_13091.log'}
  ```

### `property_map`

```javascript
  property_map([string e,] string s[, string d]) map
```

Returns a map containing keys and tags for the specified [property search](property-search.md) expression `s`. The map is composed as follows: sorted keys (if present) are followed by matching sorted tags.

By the default, the search is performed for the current entity that is initialized in the rule window. If the entity `e` is specified explicitly as the first argument, the search is performed for the specified entity instead.

An optional start date `d` argument controls which property records to include. If specified, only property records received on or after the start date are included. The start date `d` can be an `iso` date or a [calendar keyword](../shared/calendar.md#keywords). If `d` is specified, the entity `e` argument must also be specified.

The search expression `s` can include only the property type (without key and tag parts), omit the `<tag_name>` or specify a string to match tags with `*` used as a wildcard, in which case all keys and tags will be returned.

Supported syntax options:

* `<property_type>`
* `<property_type>:[<key>=<value>[,<key>=<value>]]:`
* `<property_type>:[<key>=<value>[,<key>=<value>]]:*`
* `<property_type>:[<key>=<value>[,<key>=<value>]]:*abc*`

The function returns an empty map if the entity, property or tag is not found.

Examples:

```javascript
  /* Returns map with tags starting with 'cpu' in the 'configuration' type */
  property_map('configuration::cpu*')
  
  /* Returns map of the 'configuration' type for the entity 'nurswgvml007' */
  property_map('nurswgvml007','configuration::')
  
  /* Returns map if the most recent propery record received later than 00:00:00 of the current day, otherwise returns an empty map */
  property_map('nurswgvml007','configuration::', 'today')
```

### `property_maps`

```javascript
  property_maps([string e,] string s[, string d]) [map]
```

Returns a list of maps, each map containing keys and tags for the specified [property search](property-search.md) expression `s`. The maps are composed as follows: sorted keys (if present) are followed by matching sorted tags.

By the default, the search is performed for the current entity that is initialized in the rule window. If the entity `e` is specified explicitly as the first argument, the search is performed for the specified entity instead.

An optional start date `d` argument controls which property records to include. If specified, only property records received on or after the start date are included. The start date `d` can be an `iso` date or a [calendar keyword](../shared/calendar.md#keywords). If `d` is specified, the entity `e` argument must also be specified.

The search expression `s` can include only the property type (without key and tag parts), omit the `<tag_name>` or specify a string to match tags with `*` used as a wildcard, in which case all keys and tags will be returned.

Supported syntax options:

* `<property_type>`
* `<property_type>:[<key>=<value>[,<key>=<value>]]:`
* `<property_type>:[<key>=<value>[,<key>=<value>]]:*`
* `<property_type>:[<key>=<value>[,<key>=<value>]]:*abc*`

The function returns an empty list if the entity, property or tag is not found.

To access the n-th element in the collection, use square brackets `[index]` or `get(index)` method (starting with 0 for the first element).

Examples:

```javascript
  /* Returns list of maps with tags starting with 'cpu' in the 'configuration' type */
  property_maps('configuration::cpu*')
  
  /* Returns value of the 'host' key for the first map in the collection */
  property_maps('configuration::cpu*')[0].get('host')
  property_maps('configuration::cpu*').get(0).get('host')
  
  /* Returns list of maps of the 'configuration' type for the entity 'nurswgvml007' */
  property_maps('nurswgvml007','configuration::')
  
  /* Returns list of maps of propery records received later than 00:00:00 of the previous day */
  property_maps('nurswgvml007','configuration::', 'yesterday')
```

### `getPropertyTypes`

```javascript
  getPropertyTypes(string e[, string s[, string e]]) [string]
```

Returns a sorted set of property types for the specified entity `e`.

Optional start date `s` and end date `e` arguments control the time range for selecting property records. The dates `s` and `e` can be an `iso` date or a [calendar keyword](../shared/calendar.md#keywords).

To access the n-th element in the collection, use square brackets `[index]` or `get(index)` method (starting with 0 for the first element).

Examples:

```javascript
  /* Returns property types for entity nurswgvml007*/
  getPropertyTypes('nurswgvml007')
  
  /* Returns the first property type for entity nurswgvml007*/
  getPropertyTypes('nurswgvml007')[0]
  getPropertyTypes('nurswgvml007').get(0)
  
  /* Returns property types received after 2018-01-23T13:30:04.000Z */
  getPropertyTypes('nurswgvml007','2018-01-23T13:30:04.000Z')
  
  /* Returns property types received after 00:00:00 of the previous day and before 00:00:00 of the current day*/
  getPropertyTypes('nurswgvml007','yesterday', 'today')
```