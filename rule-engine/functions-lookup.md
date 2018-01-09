# Lookup Functions

## Overview

The functions retrieve collections and maps of strings from replacement tables, collections, and other entities.

The replacement tables are listed on the **Data > Replacement Tables** page.

The named collections are listed on the **Data > Named Collections** page.

## Reference

* [entity_tag](#entity_tag)
* [entity_tags](#entity_tags)
* [collection](#collection)
* [lookup](#lookup)
* [replacementTable](#replacementtable)

### `entity_tag`

```javascript
  entity_tag(string e, string t) string
```

Returns value of tag `t` for entity `e`.

### `entity_tags`

```javascript
  entity_tags(string e) map
```
Returns entity tags as a map for entity `e`.

### `collection`

```javascript
  collection(string s) [string]
```

Retrieves an array of strings for the specified named collection `s`. If the collection is not found, an empty array is returned.

### `lookup`

```javascript
  lookup(string s, string k) string
```

Returns the value for key `k` from the replacement table `s`. The function returns `null` if the table is not found or if it doesn't contain the specified key.

### `replacementTable`

```javascript
  replacementTable(string s) map
```

Retrieves the replacement table identified by name `s` as a key-value map.

