# Lookup Functions

## Overview

These functions retrieve collections and maps of strings from replacement tables, collections, and other entities.

Replacement tables are listed on the **Data > Replacement Tables** page.

Named collections are listed on the **Data > Named Collections** page.

## Reference

* [`entity_tag`](#entity_tag)
* [`entity_tags`](#entity_tags)
* [`entity_label`](#entity_label)
* [`getEntity`](#getentity)
* [`getEntities`](#getentities)
* [`getEntityCount`](#getentitycount)
* [`getEntityName`](#getentityname)
* [`collection`](#collection)
* [`lookup`](#lookup)
* [`replacementTable`](#replacementtable)
* [`property`](#property)

## `entity_tag`

```javascript
entity_tag(string e, string t) string
```

Returns value of tag `t` for entity `e`.

If the tag or the entity is not found, an empty string is returned.

## `entity_tags`

```javascript
entity_tags(string e [, boolean f]) map
```

Returns entity tags for entity `e` as a map.

If the entity is not found, the function returns an empty map.

If the optional `f` format parameter is set to `true`, the tag names in the map are converted to labels using the applicable entity tag templates which are listed on the **Settings > Tag Templates** page.

To exclude specific tags from the results, use the `excludeKeys()` function:

```javascript
excludeKeys(entity_tags(ent), ['image', 'java.home'])
```

Example:

```javascript
entity_tags('08ac68c080bc2829f9c924949c86f65d2140c3f1253f3510f8a4e2e4d5219e2b')
```

```txt
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

```txt
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

## `entity_label`

```javascript
entity_label(string e) string
```

Returns label for entity `e`.

If the entity is not found or the entity does not have a label, the input string `e` is returned.

## `getEntity`

```javascript
getEntity(string e[,boolean l]) object
```

Retrieves an entity object by name. If `l` set to `true` entity is searched by label if `e` is not found by name. By default `l` is `false`.

Access object [fields](entity-fields.md) using dot notation, for example `getEntity('nurswgvml007').label`.

The function returns `null` if the entity `e` is not found.

Example:

```javascript
/* Returns an interpolation mode of 'nurswgvml007' entity object */
getEntity('nurswgvml007').interpolate
```

## `getEntities`

```javascript
getEntities(string m, string s, string e, string p) [object]
```

Returns a list of entity **objects** with last insert date for metric `m` between `s` and `e` and matching the specified expression `p`.

Expression `p` can include entity [fields](../api/meta/entity/list.md#fields) (except `lastInsertDate`) and [window fields](window.md#window-fields). Refer to entity [fields](entity-fields.md) using dot notation.

Start date `s` and end date `e` are [ISO format](../shared/date-format.md) dates or a [calendar keyword](../shared/calendar.md#keywords).

To access the `n`-th element in the collection, use square brackets `[index]` or `get(index)` method, starting with `0` for the first element.

Examples:

```javascript
entities = getEntities('docker.activecontainers', 'now - 1 * HOUR', 'now', "tags.status != 'deleted'")
// entities[0].name
// date_format(entities.get(0).lastInsertTime, "yyyy-MM-dd HH:mm:ss", "UTC")
```

* Match using entity object field

```javascript
getEntities('df.inodes.used', '2018-01-13T18:08:04Z', '2018-02-13T18:08:04Z', "enabled=true")
```

* Match using wildcard

```javascript
getEntities('jvm_memory_used', 'now - 4*YEAR', 'now', "tags.alias LIKE '00*'")
```

* Match using window field

```javascript
getEntities('cpu_busy', 'yesterday', 'now', "interpolate = 'LINEAR' && tags.app = '" + entity.tags.app + "'")
```

## `getEntityCount`

```javascript
getEntityCount(string m, string s, string e, object p) integer
```

Returns a list of entity **objects** with last insert date for metric `m` between `s` and `e` and matching the specified expression `p`, for `integer` length. Identical to `getEntity(m,s,e,p).size()`.

## `getEntityName`

```javascript
getEntityName(string e) string
```

Returns normalized (lowercase) entity name for input string `e`. The function searches for entity by name `e` in a case-insensitive manner. If the entity is not found by name, the function attempts to find an entity by label `e` in a case-insensitive manner.

If the entity cannot be found, the function returns the original input string `e`.

## `collection`

```javascript
collection(string s) [string]
```

Retrieves a list of strings for the specified named collection `s`. Named collections are defined on the **Data > Named Collections** page.

If no collection is found, the function returns an empty list.

To access the `n`-th element in the collection, use square brackets `[index]` or the `get(index)` method (starting with `0` for the first element).

Examples:

```javascript
tags.location NOT IN collection('dc-locations')
```

```javascript
collection('dc-locations').contains(tags.location)
```

## `lookup`

```javascript
lookup(string s, string k[, boolean b]) string
```

Returns the value for key `k` from the replacement table `s`.

The function returns an empty string if the table is not found or if the table does not contain the specified key.

If the optional boolean `b` parameter is specified and is set to `true`, the function returns the original key `k` in case the table is not found or if the key is not found.

Example:

```javascript
/* Returns 'john.doe' if the 'on-call' table does not contain an entry for 'john.doe' */
lookup('on-call', 'john.doe', true)
```

## `replacementTable`

```javascript
replacementTable(string s) map
```

Retrieves the replacement table identified by name `s` as a key-value map.

If the table is not found, the function returns an empty map.

## `property`

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