# Collection Functions

## Overview

These functions return information about the collection or checks for the presence of a specified element.

Create a collection by declaring the elements inline, enclosed in square brackets:

```javascript
['john.doe@example.org', 'mary.jones@example.org']
```

Alternatively, load a collection using the `collection()` function or another [lookup](functions-lookup.md) function.

```javascript
collection('oncall-emails')
```

## Reference

* [`collection`](#collection)
* [`IN`](#in)
* [`LIKE`](#like)
* [`likeAny`](#likeany)
* [`matchList`](#matchlist)
* [`matches`](#matches)
* [`contains`](#contains)
* [`size`](#size)
* [`isEmpty`](#isempty)
* [`replacementTable`](#replacementtable)
* [`excludeKeys`](#excludekeys)

## `collection`

```javascript
collection(string s) [string]
```

Returns an array of strings contained in collection `s`.

Named collections are listed on the **Data > Named Collections** page.

To access the size of the array, use the `.size()` method.

To access the `n`-th element in a collection, use square brackets like with the `[index]` or `get(index)` method. Index begins with `0` on the first element.

```javascript
author = (authors.size() == 0) ? 'n/a' : authors[0]
```

## `IN`

```javascript
string s IN (string a[, string b[...]]) boolean
```

Returns `true` if `s` is contained in the collection of strings enclosed in round brackets.

Examples:

```javascript
entity IN ('nurswgvml007', 'nurswgvml008')
```

```javascript
tags.location IN ('NUR', 'SVL')
```

## `LIKE`

```javascript
string s LIKE (string a[, string b[...]]) boolean
```

Returns `true` if `s` matches any pattern in the collection of strings enclosed in round brackets. The pattern supports `?` and `*` wildcards. The collection can contain string literals and variables.

Examples:

```javascript
entity LIKE ('nurswgvml*', 'nurswghbs*')
```

```javascript
tags.version LIKE ('1.2.*', '1.3.?')
```

```javascript
tags.location LIKE ('NUR*', entity.tags.location)
```

## `likeAny`

```javascript
likeAny(string s, [string] c) boolean
```

Returns `true` if string `s` matches any element in the string collection `c`.

Load collection `c` from a named collection or initialize collection `c` from an array of strings. The elements of the collection can include patterns with `?` and `*` wildcards.

Examples:

```javascript
likeAny(tags.request_ip, ['192.0.2.1', '192.0.2.2'])
```

```javascript
likeAny(tags.location, ['NUR', 'SVL*'])
```

```javascript
likeAny(tags.request_ip, collection('ip_white_list'))
```

## `matchList`

```javascript
matchList(string s, string c) boolean
```

Returns `true` if `s` is contained in collection `c`.

Collection `c` can include patterns with `?` and `*` wildcards.

Example:

```javascript
matchList(tags.request_ip, 'ip_white_list')
```

## `matches`

```javascript
matches(string p, [string] c) boolean
```

Returns `true` if one of the elements in collection `c` matches the specified pattern `p`.

The pattern supports `?` and `*` wildcards.

Example:

```javascript
matches('*atsd*', property_values('docker.container::image'))
```

## `contains`

```javascript
[string].contains(string s) boolean
```

Returns `true` if `s` is contained in the specified collection.

Example:

```javascript
collection('ip_white_list').contains(tags.request_ip)
```

## `size`

```javascript
[].size() integer
```

Returns the number of elements in the collection.

> Apply this function to any type of collection (string, number) as well as maps such as `entity.tags`.

Examples:

```javascript
collection('ip_white_list').size()
```

```javascript
entity.tags.size()
```

## `isEmpty`

```javascript
[].isEmpty() boolean
```

Returns `true` if the number of elements in the collection is zero.

> Apply this function to any type of collection (string, number) as well as maps such as `entity.tags`.

Example:

```javascript
collection('ip_white_list').isEmpty()
```

## `replacementTable`

```javascript
replacementTable(string s) map
```

Retrieves the replacement table identified by name `s` as a key-value map.

If the table is not found, the function returns an empty map.

```javascript
// .keySet() returns a collection of keys in the replacement table
replacementTable('oncall-emails').keySet()
```

```javascript
// .values() returns a collection of values in the replacement table
replacementTable('oncall-emails').values()
```

```javascript
// returns a random value in the replacement table
randomItem(replacementTable('oncall-emails').values())
```

```javascript
// returns a random key-value object from the replacement table
randomItem(replacementTable('oncall-emails'))
```

## `excludeKeys`

```javascript
excludeKeys([] m, [] c) map
```

Returns a copy of the input map `m` without the keys specified in collection `c`.

The keys in collection `c` can contain wildcards ? and * to remove multiple matching keys from the map.

Examples:

```javascript
excludeKeys(replacementTable('oncall-emails'),['jack.smith@example.org', 'mary.jones@example.org'])
```

```javascript
    /* Returns ["b1": "w1", "b2": "w2"] */
excludeKeys(["a1": "v1", "a2": "v2", "b1": "w1", "b2": "w2", "c1": "z1"], ['a*', 'c1'])
```
