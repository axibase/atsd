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

```csharp
collection(string name) [string]
```

Returns an array of strings contained in collection identified by `name`.

Named collections are listed on the **Data > Named Collections** page.

To access the size of the array, use the `.size()` method.

To access the `n`-th element in a collection, use square brackets like with the `[index]` or `get(index)` method. Index begins with `0` on the first element.

```javascript
author = (authors.size() == 0) ? 'n/a' : authors[0]
```

## `IN`

```csharp
string s IN (string a[, string b[...]]) bool
```

Returns `true` if string `s` equals one of the strings enclosed in round brackets and separated by comma.

Examples:

```javascript
// Returns true if entity is nurswgvml007
entity IN ('nurswgvml007', 'nurswgvml008')
```

```javascript
tags.location IN ('NUR', 'SVL')
```

## `LIKE`

```csharp
string s LIKE (string a[, string b[...]]) bool
```

Returns `true` if string `s` matches any pattern in the collection of strings enclosed in round brackets and separated by comma. The patterns support `?` and `*` wildcards. The collection can contain string literals and variables.

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

```csharp
likeAny(string s, [string] strcoll) bool
```

Returns `true` if string `s` matches any element in the string collection `strcoll`.

Load collection `strcoll` from a named collection or initialize collection `strcoll` from an array of strings. The elements of the collection can include patterns with `?` and `*` wildcards.

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

```csharp
matchList(string s, string name) bool
```

Returns `true` if `s` matches one of the elements in the collection identified by `name`.

The collection can include patterns with `?` and `*` wildcards.

Example:

```javascript
matchList(tags.request_ip, 'ip_white_list')
```

## `matches`

```csharp
matches(string pattern, [string] strcoll) bool
```

Returns `true` if one of the elements in collection `strcoll` matches the specified `pattern`.

The pattern supports `?` and `*` wildcards.

Example:

```javascript
matches('*atsd*', property_values('docker.container::image'))
```

## `contains`

```csharp
[string].contains(string s) bool
```

Returns `true` if string `s` is contained in the specified collection.

Example:

```javascript
collection('ip_white_list').contains(tags.request_ip)
```

## `size`

```csharp
[].size() int
```

Returns the number of elements in the collection.

> The function can be applied to a collection containing elements of any type (string, number) as well as maps such as `entity.tags`.

Examples:

```javascript
collection('ip_white_list').size()
```

```javascript
entity.tags.size()
```

## `isEmpty`

```csharp
[].isEmpty() bool
```

Returns `true` if the number of elements in the collection is zero.

> The function can be applied to a collection containing elements of any type (string, number) as well as maps such as `entity.tags`.

Example:

```javascript
collection('ip_white_list').isEmpty()
```

## `replacementTable`

```csharp
replacementTable(string name) map
```

Retrieves the replacement table identified by `name` as a key-value map.

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

```csharp
excludeKeys(map, [string] strcoll) map
```

Returns a copy of the input key-value `map` without the keys specified in collection `strcoll`.

The keys in `strcoll` can contain wildcards `?` and `*` to remove multiple matching keys from the map.

Examples:

```javascript
excludeKeys(replacementTable('oncall-emails'),['jack.smith@example.org', 'mary.jones@example.org'])
```

```javascript
/* Returns ["b1": "w1", "b2": "w2"] */
excludeKeys(["a1": "v1", "a2": "v2", "b1": "w1", "b2": "w2", "c1": "z1"], ['a*', 'c1'])
```
