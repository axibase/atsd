# Lookup Functions

## Overview

The functions retrieve collections and maps of strings from replacement tables, collections, and other entities.

The replacement tables are listed on the **Data > Replacement Tables** page.

The named collections are listed on the **Data > Named Collections** page.

## Reference

* [entity_tag](#entity_tag)
* [entity_tags](#entity_tags)
* [getEntity](#getentity)
* [getEntityName](#getentityname)
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
  entity_tags(string e [, boolean f]) map
```
Returns entity tags for entity `e` as a map.

If the entity is not found, an empty map is returned.

If the optional `f` format parameter is set to `true`, the tag names in the map are converted to labels using applicable entity tag templates which are listed on **Settings > Tag Templates** page.

To exclude specific tags from the results, use the `excludeKeys()` function:

```javascript
excludeKeys(entity_tags(ent), ['image', 'java.home'])
```

Example:

```javascript
entity_tags('08ac68c080bc2829f9c924949c86f65d2140c3f1253f3510f8a4e2e4d5219e2b')
```

```
+-------------------------+----------------------------------------------+
| Name                    | Value                                        |
+-------------------------+----------------------------------------------+
| hostname                | 08ac68c080bc                                 |
| image-name              | jmeter                                       |
| image-repotags          | axibase/jmeter:latest                        |
| image-tags              | latest                                       |
| ip-address              | 172.17.0.18                                  |
...
```

```javascript
entity_tags('08ac68c080bc2829f9c924949c86f65d2140c3f1253f3510f8a4e2e4d5219e2b', true)
```

```
+-------------------------+----------------------------------------------+
| Name                    | Value                                        |
+-------------------------+----------------------------------------------+
| IP Address              | 172.17.0.18                                  |
| Hostname                | 08ac68c080bc                                 |
| Image Name              | jmeter                                       |
| Image Tags              | latest                                       |
| Image Repo Tags         | axibase/jmeter:latest                        |
...
```

### `getEntity`

```javascript
  getEntity(string e[,boolean l]) object
```
Retrieves an entity object by name. If `l` set to `true` entity will be searched by label if it is not found by name. By default `l` is false.

The object's [fields](../api/meta/entity/list.md#fields) can be accessed using the dot notation, for example `getEntity('nurswgvml007').label`.

The function returns `null` if the entity `e` is not found.

Example:

```javascript
  /* Returns an interpolation mode of 'nurswgvml007' entity object */
  getEntity('nurswgvml007').interpolate
```

### `getEntityName`

```javascript
  getEntityName(string e) string
```
Returns normalized (lower-cased) entity name for the input string `e`. The function searches for entity by name `e` in case-insensitive manner. If the entity is not found by name, the function attempts to find an entity by label `e` in case-insensitive manner. 

If the entity cannot be found, the original input string `e` is returned.

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

