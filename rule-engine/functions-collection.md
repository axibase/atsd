# Collection Functions

## Overview

The collection functions return information about the collection or check it for the presence of a specified element.

A collection can be created by declaring its elements inline, enclosed in square brackets:


```javascript
  ['a@example.org', 'b@example.org']
```

Alternatively, it can be loaded using the `collection()` or another [lookup](functions-lookup.md) function.


```javascript
  collection('oncall-emails')
```

## Reference

* [collection](#collection)
* [IN](#in)
* [LIKE](#like)
* [likeAny](#likeany)
* [matchList](#matchlist)
* [matches](#matches)
* [contains](#contains)
* [size](#size)
* [isEmpty](#isempty)
* [excludeKeys](#excludekeys)

### `collection`

```javascript
  collection(string s) [string]
```

Returns an array of strings contained in the named collection `s`.

The named collections are listed on the **Data > Named Collections** page.

To access the size of the array, use the `.size()` method.

To access the n-th element in the collection, use square brackets as in `[index]` or the `get(index)` method. The index starts with `0` for the first element.

  ```javascript
    author = (authors.size() == 0) ? 'n/a' : authors[0]
  ```

### `IN`

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
  
### `LIKE`

```javascript
  string s LIKE (string a[, string b[...]]) boolean
```

Returns `true` if `s` matches any pattern in the collection of strings enclosed in round brackets. The pattern supports `?` and `*` wildcards.

Examples:

  ```javascript
    entity LIKE ('nurswgvml*', 'nurswghbs*')
  ```

  ```javascript
    tags.version LIKE ('1.2.*', '1.3.?')
  ``` 

### `likeAny`

```javascript
  likeAny(string s, [string] c) boolean
```

Returns `true` if string `s` matches any element in the string collection `c`.

The collection `c` can be initialized by referencing a named collection by name or it can be specified inline as an array of strings. The collection may include patterns with `?` and `*` wildcards.

Examples:

  ```javascript
    likeAny(tags.request_ip, ['10.50.102.1', '10.50.102.2'])
  ```

  ```javascript
    likeAny(tags.location, ['NUR', 'SVL*'])
  ```
  
  ```javascript
    likeAny(tags.request_ip, collection('ip_white_list'))
  ```  

### `matchList`

```javascript
  matchList(string s, string c) boolean
```

Returns `true` if `s` is contained in the collection named `c`.

The collection `c` may include patterns with `?` and `*` wildcards.

Example:

  ```javascript
    matchList(tags.request_ip, 'ip_white_list')
  ```

### `matches`

```javascript
  matches(string p, [string] c) boolean
```

Returns `true` if one of the elements in collection `c` matches (satisfies) the specified pattern `p`.

The pattern supports `?` and `*` wildcards.

Example:

  ```javascript
    matches('*atsd*', property_values('docker.container::image'))
  ```  

### `contains`

```javascript
  [string].contains(string s) boolean
```

Returns `true` if `s` is contained in the collection.

Example:

  ```javascript
    collection('ip_white_list').contains(tags.request_ip)
  ```

### `size`

```javascript
  [].size() integer
```

Returns the number of elements in the collection.

> This function can be applied to collections of any type (string, number) as well as to maps such as `entity.tags`.

Examples:

  ```javascript
    collection('ip_white_list').size()
  ```  

  ```javascript
    entity.tags.size()
  ```    

### `isEmpty`

```javascript
  [].isEmpty() boolean
```

Returns `true` if the number of elements in the collection is zero.

> This function can be applied to collections of any type (string, number) as well as to maps such as `entity.tags`.

Example:

  ```javascript
    collection('ip_white_list').isEmpty()
  ```  

### `excludeKeys`

```javascript
  excludeKeys([] m, [] c) map
```

Returns a copy of the input map `m` without the keys specified in collection `c`.

The keys in collection `c` may contain wildcards ? and * to remove multiple matching keys from the map.

Examples:

  ```javascript
    excludeKeys(replacementTable('oncall-emails'),['a@a.org', 'b@b.org'])
    
    /* Returns ["b1": "w1", "b2": "w2"] */
    excludeKeys(["a1": "v1", "a2": "v2", "b1": "w1", "b2": "w2", "c1": "z1"], ['a*', 'c1'])
  ```
