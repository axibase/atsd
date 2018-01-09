# Property Functions

## Overview

Property functions provide a set of convenience methods to retrieve and compare property keys and tags using [property search](property-search.md) syntax.

## Reference

* [property_values(string s)](#property_valuesstring-s)
* [property_values(string s, string e)](#property_valuesstring-s-string-e)
* [property](#property)
* [property_compare_except([string k])](#property_compare_exceptstring-k)
* [property_compare_except([string k], [string e])](#property_compare_exceptstring-c-string-e)

### `property_values(string s)`

```javascript
  property_values(string s) [string]
```

Returns a list of property tag values for the current entity given the property [search string](property-search.md) `s`.

The list is empty if the property or tag is not found.

Examples:

```javascript
  property_values('docker.container::image').contains('atsd/latest')
```

```javascript
  property_values('linux.disk:fstype=ext4:mount_point').contains('/')
```

### `property_values(string s, string e)`

```javascript
  property_values(string s, string e) [string]
```

Same as `property_values(string s)`, except for an explicitly specified entity `e`.

Examples:

```javascript
  property_values('nurswgvml007', 'docker.container::image').contains('atsd/latest')
```

```javascript
  property_values(entity_tags.image, 'docker.image.config::name').contains('atsd/latest')
```

### `property`

```javascript
  property(string s) string
```

Returns the first value in the list of strings returned by the `property_values(string s)` function. The function returns an empty string if no property records are found.

```javascript
  property('docker.container::image')
```

### `property_compare_except([string k])`

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

Returns true if property tags have changed except for the `name` tag and any tags that end with `time`.

### `property_compare_except([string c], [string e])`

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