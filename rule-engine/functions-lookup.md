# Lookup Functions

## Overview

The functions retrieve records from replacement tables and collections.

The replacement tables are listed on the **Data > Replacement Tables** page.

The named collections are listed on the **Data > Named Collections** page.

## Reference

* [collection](#collection)
* [lookup](#lookup)
* [replacementTable](#replacementtable)

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
