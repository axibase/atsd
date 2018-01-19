# Collection Functions

## Overview

The collection functions return information about the collection or check it for the presence of the specified element.

The collection can be created by declaring its elements inline, enclosed in square brackets:


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
* [likeAny](#likeany)
* [matchList](#matchlist)
* [matches](#matches)
* [excludeKeys](#excludekeys)

### `collection`

```javascript
  collection(string s) [string]
```

Returns an array of strings loaded for the specified named collection `s`.

The named collections are listed on the **Data > Named Collections** page.

To check the size of the collection, use the `.size()` method.

To access the n-th element, use square brackets and index starting with `0` for the first element.

  ```java
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

### `likeAny`

```javascript
  likeAny(string s, [string] c) boolean
```

Returns `true` if `s` is contained in the string collection `c`.

The collection `c` can be specified inline as an array of strings or reference a named collection. The collection may include expressions with wildcards.

Examples:

  ```javascript
    likeAny(tags.request_ip, ['10.50.102.1', '10.50.102.2'])
  ```

  ```javascript
    likeAny(tags.request_ip, collection('ip_white_list'))
  ```

### `matchList`

```javascript
  matchList(string s, string c) boolean
```

Returns `true` if `s` is contained in the named collection identified by name `c`.

The collection `c` may include expressions with wildcards.

Example:

  ```javascript
    matchList(tags.request_ip, 'ip_white_list')
  ```

### `matches`

```javascript
  matches(string p, [string] c) boolean
```

Returns `true` if one of the collection `c` elements matches (satisfies) the specified pattern `p`.

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
  excludeKeys([] m, [] c) boolean
```

Returns a copy of the input map `m` without the keys specified in collection `c`.

Example:

  ```javascript
    excludeKeys(replacementTable('oncall-emails'),['a@a.org', 'b@b.org'])
  ```
