# Lookup Functions

## Overview

The functions retrieve collections and maps of strings from replacement tables, collections, and other entities.

The replacement tables are listed on the **Data > Replacement Tables** page.

The named collections are listed on the **Data > Named Collections** page.

## Reference

* [entity_tag](#entity_tag)
* [entity_tags](#entity_tags)
* [getEntity](#getentity)
* [collection](#collection)
* [lookup](#lookup)
* [replacementTable](#replacementtable)
* [property](#property)

### `entity_tag`

```javascript
  entity_tag(string e, string t) string
```

Returns value of tag `t` for entity `e`.

If the tag or the entity is not found, an empty string is returned.

### `entity_tags`

```javascript
  entity_tags(string e) map
```
Returns entity tags as a map for entity `e`.

If the entity is not found, an empty map is returned.

### `getEntity`

```javascript
  getEntity(string e) object
```

Retrieves an entity object by name. 

The object's [fields](../api/meta/entity/list.md#fields) can be accessed using the dot notation, for example `getEntity('nurswgvml007').label`.

The function returns `null` if the entity `e` is not found.

Example:

```javascript
  /* Returns a label of 'nurswgvml007' entity object */
  getEntity('nurswgvml007').label
```

### `collection`

```javascript
  collection(string s) [string]
```

Retrieves a list of strings for the specified named collection `s`. 

If the collection is not found, an empty list is returned.

### `lookup`

```javascript
  lookup(string s, string k[, boolean b]) string
```

Returns the value for key `k` from the replacement table `s`. 

The function returns an empty string if the table is not found or if it doesn't contain the specified key.

If the optional boolean `b` parameter is specified and is set to `true`, the function returns the original key `k` in case the table is not found or if the key is not found.

Example:

```javascript
  lookup('oncall', 'john', true)
  # returns 'john' if the oncall table doesn't contain an entry for 'john'
```

### `replacementTable`

```javascript
  replacementTable(string s) map
```

Retrieves the replacement table identified by name `s` as a key-value map.

If the table is not found, an empty map is returned.

### `property`

```javascript
  property(string s) string
```

Retrieves tag value for the entity in the current window given the [property search](property-search.md) expression `s`.

The function returns an empty string if the expression matches no properties.

Example:

```javascript
  property('docker.container::image')
```

Refer to [property functions](functions-property.md#property) for additional syntax options.

